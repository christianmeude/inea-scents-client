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
        ..setPaymentMethod('online');

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
      ..setPaymentMethod('online');

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
        ..setPaymentMethod('online');

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
        ..setPaymentMethod('online');

      await notifier.submitBooking();
      final polling = notifier.startPolling(
        interval: const Duration(milliseconds: 100),
      );
      await Future<void>.delayed(const Duration(milliseconds: 400));
      await polling;
      // 2 polls + 1 refetch from bookingsProvider invalidation on resolve.
      expect(backend.bookingsEndpointCallCount, 3);
      expect(
        container.read(bookingFlowProvider).checkoutStatus,
        BookingCheckoutStatus.confirmed,
      );
    },
  );

  test(
    'resolving checkout invalidates bookingsProvider without manual refresh',
    () async {
      final backend = FakeApiBackend()..pollAttemptsToResolve = 1;
      final container = ProviderContainer(
        overrides: [
          apiClientProvider.overrideWithValue(buildFakeRestClient(backend)),
        ],
      );
      addTearDown(container.dispose);

      // Prime the cached list while the booking is still pending.
      final primed = await container.read(bookingsProvider.future);
      expect(primed.first.status, 'pending');

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
        ..setPaymentMethod('online');

      await notifier.submitBooking();
      await notifier.startPolling(interval: const Duration(milliseconds: 50));
      expect(
        container.read(bookingFlowProvider).checkoutStatus,
        BookingCheckoutStatus.confirmed,
      );

      // No manual refresh: the cached list must now serve the confirmed row.
      final fresh = await container.read(bookingsProvider.future);
      expect(fresh.first.status, 'confirmed');
    },
  );

  test(
    'ensureFreshForPackage resets a terminal flow for a new package',
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
        ..setPaymentMethod('online');

      await notifier.submitBooking();
      await notifier.startPolling();
      expect(
        container.read(bookingFlowProvider).checkoutStatus,
        BookingCheckoutStatus.confirmed,
      );

      // Entering another package booking form starts fresh at schedule step.
      notifier
        ..ensureFreshForPackage(2)
        ..goToStep(2);
      final state = container.read(bookingFlowProvider);
      expect(state.booking, isNull);
      expect(state.checkoutStatus, BookingCheckoutStatus.idle);
      expect(state.currentStep, 2);
    },
  );

  test(
    'ensureFreshForPackage resets a stale package when switching packages',
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
        ..setPaymentMethod('cash');

      await notifier.submitBooking();
      expect(
        container.read(bookingFlowProvider).checkoutStatus,
        BookingCheckoutStatus.awaitingAdmin,
      );

      // A different package form never inherits the old in-memory booking.
      notifier.ensureFreshForPackage(2);
      expect(container.read(bookingFlowProvider).booking, isNull);
      expect(
        container.read(bookingFlowProvider).checkoutStatus,
        BookingCheckoutStatus.idle,
      );
    },
  );

  test(
    'ensureFreshForPackage keeps an in-flight same-package flow alive',
    () async {
      final backend = FakeApiBackend()..pollAttemptsToResolve = 99;
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
        ..setPaymentMethod('online');

      await notifier.submitBooking();
      expect(
        container.read(bookingFlowProvider).checkoutStatus,
        BookingCheckoutStatus.awaitingPayment,
      );

      // Same-package re-entry mid-poll must not disturb polling liveness.
      notifier.ensureFreshForPackage(1);
      expect(
        container.read(bookingFlowProvider).checkoutStatus,
        BookingCheckoutStatus.awaitingPayment,
      );
      expect(container.read(bookingFlowProvider).booking, isNotNull);
    },
  );
}

