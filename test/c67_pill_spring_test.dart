import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:inea_scents_client/models/index.dart';
import 'package:inea_scents_client/providers/index.dart';
import 'package:inea_scents_client/src/providers/core_providers.dart';
import 'package:inea_scents_client/widgets/index.dart';

import 'helpers/fake_api.dart';

// C67: payment pill spring — minimize↔expand animates (scale + slide from
// bottom-right), result auto-expand intact, reduced-motion instant.
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

Widget _overlayHarness(
  ProviderContainer container,
  Widget child, {
  bool disableAnimations = false,
}) {
  return UncontrolledProviderScope(
    container: container,
    child: MaterialApp(
      home: MediaQuery(
        data: MediaQueryData(disableAnimations: disableAnimations),
        child: Scaffold(
          body: Stack(
            children: [
              Positioned.fill(child: child),
              const ProcessingPaymentOverlay(),
            ],
          ),
        ),
      ),
    ),
  );
}

void main() {
  setUpAll(() {
    GoogleFonts.config.allowRuntimeFetching = false;
  });

  testWidgets('minimize animates pill spring entrance', (
    WidgetTester tester,
  ) async {
    final backend = FakeApiBackend()..pollAttemptsToResolve = 999999;
    final container = _container(backend);
    addTearDown(container.dispose);
    await _submitOnline(tester, container);

    await tester.pumpWidget(_overlayHarness(container, const Text('Page A')));
    await tester.pump(const Duration(milliseconds: 600));
    expect(find.byKey(const Key('processing_modal')), findsOneWidget);

    await tester.tap(find.byKey(const Key('processing_minimize')));
    await tester.pump();
    // Entrance-only swap: pill mounts immediately with spring running.
    expect(find.byKey(const Key('processing_pill')), findsOneWidget);
    expect(find.byKey(const Key('processing_modal')), findsNothing);
    expect(find.byType(TweenAnimationBuilder<double>), findsOneWidget);

    await tester.pump(const Duration(milliseconds: 600));
    expect(find.byKey(const Key('processing_pill')), findsOneWidget);
  });

  testWidgets('expand animates modal spring entrance', (
    WidgetTester tester,
  ) async {
    final backend = FakeApiBackend()..pollAttemptsToResolve = 999999;
    final container = _container(backend);
    addTearDown(container.dispose);
    await _submitOnline(tester, container);

    await tester.pumpWidget(_overlayHarness(container, const Text('Page A')));
    await tester.pump(const Duration(milliseconds: 600));
    await tester.tap(find.byKey(const Key('processing_minimize')));
    await tester.pump(const Duration(milliseconds: 600));
    expect(find.byKey(const Key('processing_pill')), findsOneWidget);

    await tester.tap(find.byKey(const Key('processing_pill')));
    await tester.pump();
    expect(find.byKey(const Key('processing_modal')), findsOneWidget);
    expect(find.byKey(const Key('processing_pill')), findsNothing);
    expect(find.byType(TweenAnimationBuilder<double>), findsOneWidget);

    await tester.pump(const Duration(milliseconds: 600));
    expect(find.byKey(const Key('processing_modal')), findsOneWidget);
  });

  testWidgets('auto-expand on result intact with spring', (
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
    await tester.pump(const Duration(milliseconds: 600));
    await tester.tap(find.byKey(const Key('processing_minimize')));
    await tester.pump(const Duration(milliseconds: 600));
    expect(find.byKey(const Key('processing_pill')), findsOneWidget);

    backend.pollAttemptsToResolve = 0;
    await _recheck(tester, container);
    await tester.pump(const Duration(milliseconds: 600));
    expect(container.read(paymentOverlayMinimizedProvider), isFalse);
    expect(find.byKey(const Key('processing_pill')), findsNothing);
    expect(find.byKey(const Key('processing_modal')), findsOneWidget);
    expect(find.text('Payment confirmed'), findsOneWidget);
  });

  testWidgets('reduced-motion renders instantly, no spring', (
    WidgetTester tester,
  ) async {
    final backend = FakeApiBackend()..pollAttemptsToResolve = 999999;
    final container = _container(backend);
    addTearDown(container.dispose);
    await _submitOnline(tester, container);

    await tester.pumpWidget(
      _overlayHarness(
        container,
        const Text('Page A'),
        disableAnimations: true,
      ),
    );
    await tester.pump();
    expect(find.byKey(const Key('processing_modal')), findsOneWidget);
    expect(find.byType(TweenAnimationBuilder<double>), findsNothing);

    await tester.tap(find.byKey(const Key('processing_minimize')));
    await tester.pump();
    expect(find.byKey(const Key('processing_pill')), findsOneWidget);
    expect(find.byType(TweenAnimationBuilder<double>), findsNothing);

    await tester.tap(find.byKey(const Key('processing_pill')));
    await tester.pump();
    expect(find.byKey(const Key('processing_modal')), findsOneWidget);
    expect(find.byType(TweenAnimationBuilder<double>), findsNothing);
  });
}
