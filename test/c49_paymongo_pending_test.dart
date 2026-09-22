import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:inea_scents_client/models/index.dart';
import 'package:inea_scents_client/providers/index.dart';
import 'package:inea_scents_client/src/providers/core_providers.dart';

import 'helpers/fake_api.dart';

// C49: PayMongo success must flip the Booking off pending via the
// webhook/poll path or the manual reconcile (`checkStatusImmediate`).
// Statuses use backend wire case (`Pending`/`Confirmed`) on purpose.

ProviderContainer _container(FakeApiBackend backend) => ProviderContainer(
  overrides: [apiClientProvider.overrideWithValue(buildFakeRestClient(backend))],
);

Future<void> _submitOnline(ProviderContainer container) async {
  final notifier = container.read(bookingFlowProvider.notifier);
  notifier
    ..setSelectedPackage(
      Package(id: 1, name: 'Test', price: 4500.0, paxOptions: [50]),
    )
    ..setSelectedDate(DateTime(2026, 9, 30))
    ..setSelectedTime('2:00 PM - 5:00 PM')
    ..setSelectedPax(50)
    ..setCustomerName('Maria Clara')
    ..setCustomerEmail('maria@example.com')
    ..setVenueAddress('The Peninsula Manila')
    ..setPaymentMethod('online');
  await notifier.submitBooking();
}

void main() {
  test(
    'poll timeout while still pending does not force cancellation',
    () async {
      final backend = FakeApiBackend()
        ..bookingStatusAfterCreate = 'Pending'
        ..nextBookingStatus = 'Confirmed'
        ..pollAttemptsToResolve = 999999;
      final container = _container(backend);
      addTearDown(container.dispose);

      await _submitOnline(container);
      expect(
        container.read(bookingFlowProvider).checkoutStatus,
        BookingCheckoutStatus.awaitingPayment,
      );

      // First poll runs inline; the timer chain + timeout elapse behind it.
      unawaited(
        container.read(bookingFlowProvider.notifier).startPolling(
          interval: const Duration(milliseconds: 10),
          maxDuration: const Duration(milliseconds: 40),
        ),
      );
      await Future<void>.delayed(const Duration(milliseconds: 400));

      // Still pending server-side, so the client must keep waiting for the
      // late PayMongo success instead of fabricating a cancellation.
      expect(
        container.read(bookingFlowProvider).checkoutStatus,
        BookingCheckoutStatus.awaitingPayment,
      );
      expect(container.read(bookingFlowProvider).booking?.status, 'Pending');
    },
  );

  test(
    'poll timeout with the booking missing never forces cancellation',
    () async {
      final backend = FakeApiBackend()..bookingsOverride = [];
      final container = _container(backend);
      addTearDown(container.dispose);

      await _submitOnline(container);
      unawaited(
        container.read(bookingFlowProvider.notifier).startPolling(
          interval: const Duration(milliseconds: 10),
          maxDuration: const Duration(milliseconds: 40),
        ),
      );
      await Future<void>.delayed(const Duration(milliseconds: 400));

      expect(
        container.read(bookingFlowProvider).checkoutStatus,
        BookingCheckoutStatus.awaitingPayment,
      );
    },
  );

  test(
    'late PayMongo success flips the pending booking via recheck',
    () async {
      final backend = FakeApiBackend()
        ..bookingStatusAfterCreate = 'Pending'
        ..nextBookingStatus = 'Confirmed'
        ..pollAttemptsToResolve = 999999;
      final container = _container(backend);
      addTearDown(container.dispose);

      await _submitOnline(container);
      final notifier = container.read(bookingFlowProvider.notifier);
      unawaited(
        notifier.startPolling(
          interval: const Duration(milliseconds: 10),
          maxDuration: const Duration(milliseconds: 40),
        ),
      );
      await Future<void>.delayed(const Duration(milliseconds: 400));
      expect(
        container.read(bookingFlowProvider).checkoutStatus,
        BookingCheckoutStatus.awaitingPayment,
      );

      // The PayMongo `link.payment.paid` webhook lands late server-side.
      backend.pollAttemptsToResolve = 0;
      await notifier.checkStatusImmediate();

      expect(
        container.read(bookingFlowProvider).checkoutStatus,
        BookingCheckoutStatus.confirmed,
      );
      expect(
        container.read(bookingFlowProvider).booking?.status,
        'Confirmed',
      );
      final fresh = await container.read(bookingsProvider.future);
      expect(fresh.first.status, 'Confirmed');
    },
  );
}
