import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:inea_scents_client/models/index.dart';
import 'package:inea_scents_client/providers/index.dart';
import 'package:inea_scents_client/screens/home_screen.dart';
import 'package:inea_scents_client/widgets/index.dart';

/// C1 Home concierge recomposition proofs: the next-step card renders with
/// its Check-date CTA, the CTA routes calendar-first, and loading shows the
/// unified skeleton grid (no raw spinner divergence with Packages).
Package _cardPackage() => const Package(
      id: 7,
      name: 'Unified Celebration Bar',
      price: 4499,
      paxOptions: [50, 70, 100, 150],
      paxPrices: {50: 4499.0, 70: 6399.0, 100: 8799.0, 150: 13119.0},
    );

GoRouter _homeRouter(String? Function(String location) onPush) {
  return GoRouter(
    initialLocation: '/',
    routes: [
      GoRoute(
        path: '/',
        builder: (context, state) => const HomeScreen(),
      ),
      GoRoute(
        path: '/calendar',
        builder: (context, state) {
          onPush(state.matchedLocation);
          return const SizedBox();
        },
      ),
    ],
  );
}

void main() {
  group('c1 next-step card', () {
    testWidgets('renders above the packages grid with Check-date CTA', (
      WidgetTester tester,
    ) async {
      final router = _homeRouter((_) => null);
      addTearDown(router.dispose);
      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            packagesProvider.overrideWith((ref) async => [_cardPackage()]),
          ],
          child: MaterialApp.router(routerConfig: router),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.byKey(const Key('home_next_step_card')), findsOneWidget);
      expect(find.text('Your next step'), findsOneWidget);
      expect(find.byKey(const Key('home_check_date_cta')), findsOneWidget);
      expect(find.text('Check date'), findsOneWidget);
      // Packages grid still renders below the card.
      expect(find.text('Our Packages'), findsOneWidget);
      expect(find.byType(PackageCard), findsOneWidget);
    });

    testWidgets('Check-date CTA pushes /calendar (date-first flow)', (
      WidgetTester tester,
    ) async {
      String? pushed;
      final router = _homeRouter((location) {
        pushed = location;
        return null;
      });
      addTearDown(router.dispose);
      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            packagesProvider.overrideWith((ref) async => [_cardPackage()]),
          ],
          child: MaterialApp.router(routerConfig: router),
        ),
      );
      await tester.pumpAndSettle();

      await tester.ensureVisible(find.text('Check date'));
      await tester.pumpAndSettle();
      await tester.tap(find.byKey(const Key('home_check_date_cta')));
      await tester.pumpAndSettle();

      expect(pushed, '/calendar');
    });

    testWidgets('loading shows skeleton grid, never a raw spinner', (
      WidgetTester tester,
    ) async {
      final pending = Completer<List<Package>>();
      final router = _homeRouter((_) => null);
      addTearDown(router.dispose);
      await tester.pumpWidget(
        ProviderScope(
          overrides: [packagesProvider.overrideWith((ref) => pending.future)],
          child: MaterialApp.router(routerConfig: router),
        ),
      );
      // Single frames only: shimmer animates forever, settle would hang.
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 100));

      expect(find.byType(SkeletonPackageCard), findsNWidgets(4));
      expect(find.byType(CircularProgressIndicator), findsNothing);

      pending.complete([_cardPackage()]);
      await tester.pumpAndSettle();
      expect(find.byType(PackageCard), findsOneWidget);
    });
  });
}
