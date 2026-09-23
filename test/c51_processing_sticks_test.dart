import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:inea_scents_client/models/index.dart';
import 'package:inea_scents_client/providers/index.dart';
import 'package:inea_scents_client/screens/my_bookings_screen.dart';
import 'package:inea_scents_client/src/providers/core_providers.dart';
import 'package:inea_scents_client/widgets/index.dart';

import 'helpers/fake_api.dart';

// C51: minimizable payment modal + realtime bookings row.
// Processing state is provider-level (bookingFlowProvider), the minimized
// flag is provider-level (paymentOverlayMinimizedProvider), and the
// bookings row subscribes to the live flow booking — no refresh needed.
//
// NOTE: bodies run in testWidgets' FakeAsync zone, so real-async provider
// calls (submit/recheck over the fake Dio adapter) go through
// tester.runAsync — a bare await deadlocks the fake clock.
ProviderContainer _container(FakeApiBackend backend) => ProviderContainer(
  overrides: [apiClientProvider.overrideWithValue(buildFakeRestClient(backend))],
);

Future<void> _submitOnline(
  WidgetTester tester,
  ProviderContainer container,
) async {
  await tester.runAsync(() async {
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
  });
}

Future<void> _recheck(WidgetTester tester, ProviderContainer container) {
  return tester.runAsync(
    () => container.read(bookingFlowProvider.notifier).checkStatusImmediate(),
  );
}

Widget _overlayHarness(ProviderContainer container, Widget child) {
  return UncontrolledProviderScope(
    container: container,
    child: MaterialApp(
      home: Scaffold(
        body: Stack(
          children: [
            Positioned.fill(child: child),
            const ProcessingPaymentOverlay(),
          ],
        ),
      ),
    ),
  );
}

void main() {
  setUpAll(() {
    GoogleFonts.config.allowRuntimeFetching = false;
  });

  testWidgets('minimized pill survives navigation (provider-level flag)', (
    WidgetTester tester,
  ) async {
    tester.view.physicalSize = const Size(800, 1200);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);
    final backend = FakeApiBackend()..pollAttemptsToResolve = 999999;
    final container = _container(backend);
    addTearDown(container.dispose);
    await _submitOnline(tester, container);
    expect(
      container.read(bookingFlowProvider).checkoutStatus,
      BookingCheckoutStatus.awaitingPayment,
    );

    await tester.pumpWidget(_overlayHarness(container, const Text('Page A')));
    await tester.pump();
    expect(find.byKey(const Key('processing_modal')), findsOneWidget);

    await tester.tap(find.byKey(const Key('processing_minimize')));
    await tester.pump();
    expect(
      container.read(paymentOverlayMinimizedProvider),
      isTrue,
      reason: 'minimized flag lives in the provider, not the route',
    );
    expect(find.byKey(const Key('processing_pill')), findsOneWidget);
    expect(find.byKey(const Key('processing_modal')), findsNothing);

    // Navigate: same container, brand-new route content.
    await tester.pumpWidget(_overlayHarness(container, const Text('Page B')));
    await tester.pump();
    expect(find.text('Page B'), findsOneWidget);
    expect(find.byKey(const Key('processing_pill')), findsOneWidget);
    expect(find.byKey(const Key('processing_modal')), findsNothing);

    // Pill sits bottom-right.
    final center = tester.getCenter(find.byKey(const Key('processing_pill')));
    expect(center.dx, greaterThan(400));
    expect(center.dy, greaterThan(600));
  });

  testWidgets('no dismiss-X while processing; tap pill re-expands', (
    WidgetTester tester,
  ) async {
    final backend = FakeApiBackend()..pollAttemptsToResolve = 999999;
    final container = _container(backend);
    addTearDown(container.dispose);
    await _submitOnline(tester, container);

    await tester.pumpWidget(_overlayHarness(container, const Text('Page A')));
    await tester.pump();
    expect(find.byKey(const Key('processing_modal')), findsOneWidget);
    expect(find.byIcon(Icons.close), findsNothing);
    expect(find.text('Close'), findsNothing);
    expect(find.text('Dismiss'), findsNothing);
    expect(find.byKey(const Key('processing_minimize')), findsOneWidget);

    await tester.tap(find.byKey(const Key('processing_minimize')));
    await tester.pump();
    expect(find.byIcon(Icons.close), findsNothing);
    expect(find.text('Close'), findsNothing);

    await tester.tap(find.byKey(const Key('processing_pill')));
    await tester.pump();
    expect(find.byKey(const Key('processing_modal')), findsOneWidget);
  });

  testWidgets('minimized pill auto-expands on success result', (
    WidgetTester tester,
  ) async {
    final backend = FakeApiBackend()
      ..bookingStatusAfterCreate = 'Pending'
      ..nextBookingStatus = 'Confirmed'
      ..pollAttemptsToResolve = 999999;
    final container = _container(backend);
    addTearDown(container.dispose);
    await _submitOnline(tester, container);

    await tester.pumpWidget(_overlayHarness(container, const Text('Page A')));
    await tester.pump();
    await tester.tap(find.byKey(const Key('processing_minimize')));
    await tester.pump();
    expect(find.byKey(const Key('processing_pill')), findsOneWidget);

    // Late PayMongo success lands server-side; recheck resolves.
    backend.pollAttemptsToResolve = 0;
    await _recheck(tester, container);
    await tester.pump();
    expect(
      container.read(paymentOverlayMinimizedProvider),
      isFalse,
      reason: 'terminal status clears the minimized flag',
    );
    expect(find.byKey(const Key('processing_pill')), findsNothing);
    expect(find.byKey(const Key('processing_modal')), findsOneWidget);
    expect(find.text('Payment confirmed'), findsOneWidget);
  });

  testWidgets('minimized pill auto-expands on cancelled result', (
    WidgetTester tester,
  ) async {
    final backend = FakeApiBackend()
      ..bookingStatusAfterCreate = 'Pending'
      ..nextBookingStatus = 'Cancelled'
      ..pollAttemptsToResolve = 999999;
    final container = _container(backend);
    addTearDown(container.dispose);
    await _submitOnline(tester, container);

    await tester.pumpWidget(_overlayHarness(container, const Text('Page A')));
    await tester.pump();
    await tester.tap(find.byKey(const Key('processing_minimize')));
    await tester.pump();
    expect(find.byKey(const Key('processing_pill')), findsOneWidget);

    backend.pollAttemptsToResolve = 0;
    await _recheck(tester, container);
    await tester.pump();
    expect(find.byKey(const Key('processing_pill')), findsNothing);
    expect(find.byKey(const Key('processing_modal')), findsOneWidget);
    expect(find.text('Booking cancelled'), findsOneWidget);
  });

  testWidgets('bookings row shows live status with a stale list, no refresh', (
    WidgetTester tester,
  ) async {
    tester.view.physicalSize = const Size(390, 844);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);
    final backend = FakeApiBackend()
      ..bookingStatusAfterCreate = 'Pending'
      ..nextBookingStatus = 'Confirmed'
      ..pollAttemptsToResolve = 999999;
    final container = _container(backend);
    addTearDown(container.dispose);
    await _submitOnline(tester, container);

    await tester.pumpWidget(
      UncontrolledProviderScope(
        container: container,
        child: const MaterialApp(home: MyBookingsScreen()),
      ),
    );
    await tester.pumpAndSettle();
    expect(find.text('PENDING'), findsOneWidget);

    // Resolve the flow booking, then freeze the cached list on stale
    // pending rows — the row must still flip via its flow subscription.
    backend.pollAttemptsToResolve = 0;
    await _recheck(tester, container);
    expect(
      container.read(bookingFlowProvider).checkoutStatus,
      BookingCheckoutStatus.confirmed,
    );
    backend.bookingsOverride = [
      backend.bookingJson(status: 'Pending'),
    ];
    // Refetch under real async so no fake-clock Dio timer leaks past
    // teardown; the cached list lands stale-pending while the flow stays
    // confirmed.
    await tester.runAsync(() async {
      container.invalidate(bookingsProvider);
      await container.read(bookingsProvider.future);
    });
    await tester.pump();

    expect(find.text('CONFIRMED'), findsOneWidget);
    expect(find.text('PENDING'), findsNothing);
  });
}
