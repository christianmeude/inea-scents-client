import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:inea_scents_client/config/theme.dart';
import 'package:inea_scents_client/models/index.dart';
import 'package:inea_scents_client/widgets/index.dart';

/// C18 pay-once: Payment Method is picked exactly once, at the payment
/// step. The schedule-step details panel carries no picker; the payment
/// panel does.
Package _payOncePackage() => const Package(
  id: 7,
  name: 'Unified Celebration Bar',
  price: 4499,
  paxOptions: [50, 70, 100, 150],
  paxPrices: {50: 4499.0, 70: 6399.0, 100: 8799.0, 150: 13119.0},
);

void main() {
  group('c18 pay-once', () {
    testWidgets('schedule details panel carries no payment picker', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(
        MaterialApp(
          theme: AppTheme.lightTheme,
          home: Scaffold(
            body: SingleChildScrollView(
              child: ReservationDetailsPanel(
                package: _payOncePackage(),
                selectedPax: 70,
                onChangePax: () {},
                selectedTime: '14:00:00',
                onTimeSelected: (_) {},
              ),
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text('Payment Method'), findsNothing);
      expect(find.text('Online'), findsNothing);
      expect(find.text('Cash'), findsNothing);
      expect(tester.takeException(), isNull);
    });

    testWidgets('payment panel picks method once and notifies', (
      WidgetTester tester,
    ) async {
      var picked = '';
      await tester.pumpWidget(
        MaterialApp(
          theme: AppTheme.lightTheme,
          home: Scaffold(
            body: SingleChildScrollView(
              child: DesktopPaymentPanel(
                package: _payOncePackage(),
                selectedPax: 70,
                paymentMethod: 'online',
                onPaymentMethodSelected: (m) => picked = m,
              ),
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text('Online'), findsOneWidget);
      expect(find.text('Cash'), findsOneWidget);
      await tester.tap(find.text('Cash'));
      await tester.pumpAndSettle();
      expect(picked, equals('cash'));
      expect(tester.takeException(), isNull);
    });
  });
}
