import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:inea_scents_client/models/index.dart';
import 'package:inea_scents_client/providers/index.dart';
import 'package:inea_scents_client/screens/packages_screen.dart';
import 'package:inea_scents_client/src/providers/core_providers.dart';
import 'package:inea_scents_client/widgets/index.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'helpers/fake_api.dart';

/// P4 UX booking-flow proofs: API-driven pax options (REQ-1 shape),
/// per-pax pricing (Q5 regression), Online/Cash-only payment (Q14-B),
/// and notifier-owned state (Q8).
Package _fourOptionPackage() => const Package(
      id: 7,
      name: 'Unified Celebration Bar',
      price: 4499,
      paxOptions: [50, 70, 100, 150],
      paxPrices: {50: 4499.0, 70: 6399.0, 100: 8799.0, 150: 13119.0},
    );

void main() {
  group('ux_booking options model', () {
    test('four API options sort by pax with PAX titles', () {
      final options = _fourOptionPackage().options;
      expect(options.map((o) => o.pax).toList(), [50, 70, 100, 150]);
      expect(options.map((o) => o.title).toList(), [
        '50 PAX',
        '70 PAX',
        '100 PAX',
        '150 PAX',
      ]);
    });

    test('each pax has its own price (Q5 regression)', () {
      final pkg = _fourOptionPackage();
      expect(pkg.priceForPax(50), 4499.0);
      expect(pkg.priceForPax(70), 6399.0);
      expect(pkg.priceForPax(100), 8799.0);
      expect(pkg.priceForPax(150), 13119.0);
    });

    test('empty option map degrades to no options, never silent pricing', () {
      const bare = Package(id: 8, price: 4500.0);
      expect(bare.options, isEmpty);
      expect(bare.hasOptions, isFalse);
      // Scalar fallback only when the map has no entry for the pax.
      expect(bare.priceForPax(70), 4500.0);
    });
  });

  group('ux_booking packages screen', () {
    testWidgets('one tiered package renders four PAX cards with prices',
        (WidgetTester tester) async {
      SharedPreferences.setMockInitialValues({'first_launch': false});
      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            packagesProvider.overrideWith((ref) async => [_fourOptionPackage()]),
          ],
          child: const MaterialApp(home: PackagesScreen()),
        ),
      );
      await tester.pumpAndSettle();

      for (final label in ['50 PAX', '70 PAX', '100 PAX', '150 PAX']) {
        expect(find.text(label), findsOneWidget);
      }
      for (final price in [
        'Php. 4499.00',
        'Php. 6399.00',
        'Php. 8799.00',
        'Php. 13119.00',
      ]) {
        expect(find.text(price), findsOneWidget);
      }
      // Glossary terms only: no Guests, no Tier in the UI.
      expect(find.textContaining('Guest'), findsNothing);
      expect(find.textContaining('Tier'), findsNothing);
    });
  });

  group('ux_booking payment methods', () {
    testWidgets('Online default shows explainer, no card capture, no retired methods',
        (WidgetTester tester) async {
      tester.view.physicalSize = const Size(1200, 1000);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: DesktopPaymentPanel(
              package: _fourOptionPackage(),
              paymentMethod: 'online',
              onPaymentMethodSelected: (_) {},
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text('Online'), findsOneWidget);
      expect(find.text('Cash'), findsOneWidget);
      expect(find.text('Bank Transfer'), findsNothing);
      expect(
        find.byKey(const Key('online_checkout_explainer')),
        findsOneWidget,
      );
      expect(find.text('Card Number'), findsNothing);
    });

    testWidgets('Cash shows offline instructions with admin confirmation',
        (WidgetTester tester) async {
      tester.view.physicalSize = const Size(1200, 1000);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: DesktopPaymentPanel(
              package: _fourOptionPackage(),
              paymentMethod: 'cash',
              onPaymentMethodSelected: (_) {},
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text('2. Offline Payment Instructions'), findsOneWidget);
      expect(find.textContaining('confirm your booking'), findsOneWidget);
    });
  });

  group('ux_booking notifier-owned state', () {
    test('selections live in the notifier with null defaults', () {
      final container = ProviderContainer(
        overrides: [
          apiClientProvider.overrideWithValue(
            buildFakeRestClient(FakeApiBackend()),
          ),
        ],
      );
      addTearDown(container.dispose);

      final initial = container.read(bookingFlowProvider);
      expect(initial.selectedDate, isNull);
      expect(initial.selectedPax, isNull);
      expect(initial.selectedTime, isNull);
      expect(initial.paymentMethod, isNull);

      final notifier = container.read(bookingFlowProvider.notifier)
        ..setSelectedPackage(_fourOptionPackage())
        ..setSelectedDate(DateTime.utc(2026, 10, 3))
        ..setSelectedTime('14:00:00')
        ..setSelectedPax(70)
        ..setPaymentMethod('cash');

      final state = container.read(bookingFlowProvider);
      expect(state.selectedPax, 70);
      expect(state.selectedTime, '14:00:00');
      expect(state.paymentMethod, 'cash');
      expect(notifier.canProceedFromSchedule(), isTrue);
      expect(state.selectedPackage!.priceForPax(state.selectedPax), 6399.0);
    });
  });
}

