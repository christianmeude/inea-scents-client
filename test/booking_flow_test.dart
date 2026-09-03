import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:inea_scents_client/models/index.dart';
import 'package:inea_scents_client/providers/index.dart';
import 'package:inea_scents_client/src/providers/core_providers.dart';

import 'helpers/fake_api.dart';

void main() {
  test(
    'BookingFlowNotifier completes an online booking through the fake API',
    () async {
      final backend = FakeApiBackend();
      final container = ProviderContainer(
        overrides: [
          apiClientProvider.overrideWithValue(buildFakeRestClient(backend)),
        ],
      );
      addTearDown(container.dispose);

      final notifier = container.read(bookingFlowProvider.notifier);
      container.read(bookingFlowProvider.notifier)
        ..setSelectedPackage(
          Package(id: 1, name: 'Test', price: 4500.0, paxOptions: [50]),
        )
        ..setSelectedDate(DateTime(2026, 9, 30))
        ..setSelectedTime('2:00 PM - 5:00 PM')
        ..setSelectedPax(50)
        ..setCustomerName('Maria Clara')
        ..setCustomerEmail('maria@example.com')
        ..setCustomerPhone('+639171234567')
        ..setVenueAddress('The Peninsula Manila')
        ..setPaymentMethod('credit_card');

      final booking = await notifier.submitBooking();
      expect(booking, isNotNull);
      expect(
        container.read(bookingFlowProvider).checkoutStatus,
        BookingCheckoutStatus.awaitingPayment,
      );

      await notifier.startPolling();
      expect(
        container.read(bookingFlowProvider).checkoutStatus,
        BookingCheckoutStatus.confirmed,
      );
    },
  );

  test('offline payment goes straight to awaiting admin', () async {
    final backend = FakeApiBackend();
    final container = ProviderContainer(
      overrides: [
        apiClientProvider.overrideWithValue(buildFakeRestClient(backend)),
      ],
    );
    addTearDown(container.dispose);

    final notifier = container.read(bookingFlowProvider.notifier);
    container.read(bookingFlowProvider.notifier)
      ..setSelectedPackage(
        Package(id: 1, name: 'Test', price: 4500.0, paxOptions: [50]),
      )
      ..setSelectedDate(DateTime(2026, 9, 30))
      ..setSelectedTime('2:00 PM - 5:00 PM')
      ..setSelectedPax(50)
      ..setCustomerName('Maria Clara')
      ..setCustomerEmail('maria@example.com')
      ..setVenueAddress('The Peninsula Manila')
      ..setPaymentMethod('cash');

    final booking = await notifier.submitBooking();
    expect(booking, isNotNull);
    expect(
      container.read(bookingFlowProvider).checkoutStatus,
      BookingCheckoutStatus.awaitingAdmin,
    );
  });

  test('invalid email is rejected before any request', () async {
    final backend = FakeApiBackend();
    final container = ProviderContainer(
      overrides: [
        apiClientProvider.overrideWithValue(buildFakeRestClient(backend)),
      ],
    );
    addTearDown(container.dispose);

    final notifier = container.read(bookingFlowProvider.notifier);
    container.read(bookingFlowProvider.notifier)
      ..setSelectedPackage(
        Package(id: 1, name: 'Test', price: 4500.0, paxOptions: [50]),
      )
      ..setSelectedDate(DateTime(2026, 9, 30))
      ..setSelectedTime('2:00 PM - 5:00 PM')
      ..setSelectedPax(50)
      ..setCustomerName('Maria Clara')
      ..setCustomerEmail('not-an-email')
      ..setVenueAddress('The Peninsula Manila')
      ..setPaymentMethod('credit_card');

    final booking = await notifier.submitBooking();
    expect(booking, isNull);
    expect(
      container.read(bookingFlowProvider).errorMessage,
      'Please enter a valid email address',
    );
    expect(backend.bookingsEndpointCallCount, 0);
  });

  test(
    'polling resolves to cancelled when backend reports cancellation',
    () async {
      final backend = FakeApiBackend()..nextBookingStatus = 'cancelled';
      final container = ProviderContainer(
        overrides: [
          apiClientProvider.overrideWithValue(buildFakeRestClient(backend)),
        ],
      );
      addTearDown(container.dispose);

      final notifier = container.read(bookingFlowProvider.notifier);
      container.read(bookingFlowProvider.notifier)
        ..setSelectedPackage(
          Package(id: 1, name: 'Test', price: 4500.0, paxOptions: [50]),
        )
        ..setSelectedDate(DateTime(2026, 9, 30))
        ..setSelectedTime('2:00 PM - 5:00 PM')
        ..setSelectedPax(50)
        ..setCustomerName('Maria Clara')
        ..setCustomerEmail('maria@example.com')
        ..setVenueAddress('The Peninsula Manila')
        ..setPaymentMethod('credit_card');

      final booking = await notifier.submitBooking();
      expect(booking, isNotNull);
      await notifier.startPolling();
      expect(
        container.read(bookingFlowProvider).checkoutStatus,
        BookingCheckoutStatus.cancelled,
      );
    },
  );

  test(
    'polling stays on awaitingPayment while pending then confirms',
    () async {
      final backend = FakeApiBackend()..pollAttemptsToResolve = 1;
      final container = ProviderContainer(
        overrides: [
          apiClientProvider.overrideWithValue(buildFakeRestClient(backend)),
        ],
      );
      addTearDown(container.dispose);

      final notifier = container.read(bookingFlowProvider.notifier);
      container.read(bookingFlowProvider.notifier)
        ..setSelectedPackage(
          Package(id: 1, name: 'Test', price: 4500.0, paxOptions: [50]),
        )
        ..setSelectedDate(DateTime(2026, 9, 30))
        ..setSelectedTime('2:00 PM - 5:00 PM')
        ..setSelectedPax(50)
        ..setCustomerName('Maria Clara')
        ..setCustomerEmail('maria@example.com')
        ..setVenueAddress('The Peninsula Manila')
        ..setPaymentMethod('credit_card');

      await notifier.submitBooking();
      final polling = notifier.startPolling(
        interval: const Duration(milliseconds: 100),
      );
      await Future<void>.delayed(const Duration(milliseconds: 400));
      await polling;
      expect(backend.bookingsEndpointCallCount, 2);
      expect(
        container.read(bookingFlowProvider).checkoutStatus,
        BookingCheckoutStatus.confirmed,
      );
    },
  );
}
