import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:inea_scents_client/models/index.dart';
import 'package:inea_scents_client/providers/index.dart';
import 'package:inea_scents_client/screens/booking_screen.dart';
import 'package:inea_scents_client/src/providers/core_providers.dart';
import 'package:inea_scents_client/widgets/index.dart';

import 'helpers/fake_api.dart';

/// P5 navigation + IA proofs: `?date=` threading (Q16/Q-B), wishlist
/// retirement (Q15/Q-A), and tab inventory.
Package _navPackage() => const Package(
      id: 7,
      name: 'Unified Celebration Bar',
      price: 4499,
      paxOptions: [50, 70, 100, 150],
      paxPrices: {50: 4499.0, 70: 6399.0, 100: 8799.0, 150: 13119.0},
    );

void main() {
  group('ux_nav date param', () {
    test('formats YYYY-MM-DD with zero padding', () {
      expect(formatDateParam(DateTime(2026, 3, 5)), '2026-03-05');
      expect(formatDateParam(DateTime(2030, 11, 15)), '2030-11-15');
    });

    test('honors well-formed future dates only', () {
      final now = DateTime(2026, 9, 12);
      expect(
        tryParseDateParam('2030-01-15', now: now),
        DateTime(2030, 1, 15),
      );
      expect(tryParseDateParam('2020-01-01', now: now), isNull);
      expect(tryParseDateParam('not-a-date', now: now), isNull);
      expect(tryParseDateParam('2026-13-01', now: now), isNull);
      expect(tryParseDateParam(null, now: now), isNull);
      expect(tryParseDateParam('', now: now), isNull);
    });
  });

  group('ux_nav card push carries pax and date', () {
    testWidgets('tap forwards ?pax= and ?date=', (WidgetTester tester) async {
      String? pushed;
      final router = GoRouter(
        initialLocation: '/',
        routes: [
          GoRoute(
            path: '/',
            builder: (context, state) => Scaffold(
              body: SizedBox(
                width: 300,
                height: 620,
                child: SingleChildScrollView(
                  child: PackageCard(
                    package: _navPackage(),
                    optionPax: 70,
                    initialDate: DateTime(2030, 1, 15),
                  ),
                ),
              ),
            ),
          ),
          GoRoute(
            path: '/package-details/:id',
            builder: (context, state) {
              final query = state.queryParameters.entries
                  .map((e) => '${e.key}=${e.value}')
                  .join('&');
              pushed = '${state.matchedLocation}?$query';
              return const SizedBox();
            },
          ),
        ],
      );
      addTearDown(router.dispose);
      await tester.pumpWidget(MaterialApp.router(routerConfig: router));
      await tester.pumpAndSettle();

      expect(find.text('70 PAX'), findsOneWidget);
      await tester.ensureVisible(find.text('70 PAX'));
      await tester.pumpAndSettle();
      await tester.tap(find.byType(PackageCard));
      await tester.pumpAndSettle();

      expect(pushed, '/package-details/7?pax=70&date=2030-01-15');
    });
  });

  group('ux_nav booking honors carried date', () {
    testWidgets('valid ?date= seeds the flow default',
        (WidgetTester tester) async {
      final container = ProviderContainer(
        overrides: [
          packageDetailsProvider(7).overrideWith((ref) => _navPackage()),
          apiClientProvider.overrideWithValue(
            buildFakeRestClient(FakeApiBackend()),
          ),
        ],
      );
      addTearDown(container.dispose);
      await tester.pumpWidget(
        UncontrolledProviderScope(
          container: container,
          child: MaterialApp(
            home: BookingScreen(
              packageId: 7,
              initialDate: DateTime(2030, 1, 15),
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();

      expect(
        container.read(bookingFlowProvider).selectedDate,
        DateTime(2030, 1, 15),
      );
    });

    testWidgets('past ?date= falls back to the default',
        (WidgetTester tester) async {
      final container = ProviderContainer(
        overrides: [
          packageDetailsProvider(7).overrideWith((ref) => _navPackage()),
          apiClientProvider.overrideWithValue(
            buildFakeRestClient(FakeApiBackend()),
          ),
        ],
      );
      addTearDown(container.dispose);
      await tester.pumpWidget(
        UncontrolledProviderScope(
          container: container,
          child: MaterialApp(
            home: BookingScreen(
              packageId: 7,
              initialDate: DateTime(2020, 1, 1),
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();

      final selected = container.read(bookingFlowProvider).selectedDate;
      expect(selected, isNotNull);
      final today = DateTime.now();
      expect(
        DateTime(selected!.year, selected.month, selected.day).isBefore(
          DateTime(today.year, today.month, today.day),
        ),
        isFalse,
      );
    });
  });

  group('ux_nav tabs without wishlist', () {
    testWidgets('five tabs render, no wishlist anywhere',
        (WidgetTester tester) async {
      tester.view.physicalSize = const Size(375, 667);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);

      await tester.pumpWidget(
        const MaterialApp(home: Scaffold(bottomNavigationBar: BottomNavBar())),
      );
      await tester.pumpAndSettle();

      for (final label in ['HOME', 'PACKAGES', 'BOOKINGS', 'CALENDAR', 'PROFILE']) {
        expect(find.text(label), findsOneWidget);
      }
      expect(find.textContaining('WISHLIST'), findsNothing);
      expect(find.textContaining('Wishlist'), findsNothing);
    });
  });
}
