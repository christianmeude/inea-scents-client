import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:inea_scents_client/providers/index.dart';
import 'package:inea_scents_client/screens/home_screen.dart';
import 'package:inea_scents_client/widgets/index.dart';

/// C16 Home concierge stack: Check-date CTA + UpcomingBookingSection +
/// one Offering teaser (→ /packages) + trust copy. No catalog grid.
GoRouter _homeRouter(void Function(String location) onPush) {
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
      GoRoute(
        path: '/packages',
        builder: (context, state) {
          onPush(state.matchedLocation);
          return const SizedBox();
        },
      ),
    ],
  );
}

Widget _harness(GoRouter router) {
  return ProviderScope(
    overrides: [bookingsProvider.overrideWith((ref) async => [])],
    child: MaterialApp.router(routerConfig: router),
  );
}

void main() {
  group('c16 home concierge stack', () {
    testWidgets('renders CTA + upcoming + teaser + trust, zero PackageCard', (
      WidgetTester tester,
    ) async {
      final router = _homeRouter((_) {});
      addTearDown(router.dispose);
      await tester.pumpWidget(_harness(router));
      await tester.pumpAndSettle();

      expect(find.byKey(const Key('home_next_step_card')), findsOneWidget);
      expect(find.byKey(const Key('home_check_date_cta')), findsOneWidget);
      expect(find.byType(UpcomingBookingSection), findsOneWidget);
      expect(find.byKey(const Key('home_offering_teaser')), findsOneWidget);
      expect(find.text('Explore our Offerings'), findsOneWidget);
      expect(find.byKey(const Key('home_trust_copy')), findsOneWidget);
      // No catalog grid remains on Home.
      expect(find.byType(PackageCard), findsNothing);
      expect(find.byType(GridView), findsNothing);
      expect(find.text('Our Packages'), findsNothing);
    });

    testWidgets('Check-date CTA pushes /calendar (date-first flow)', (
      WidgetTester tester,
    ) async {
      String? pushed;
      final router = _homeRouter((location) => pushed = location);
      addTearDown(router.dispose);
      await tester.pumpWidget(_harness(router));
      await tester.pumpAndSettle();

      await tester.ensureVisible(find.text('Check date'));
      await tester.pumpAndSettle();
      await tester.tap(find.byKey(const Key('home_check_date_cta')));
      await tester.pumpAndSettle();

      expect(pushed, '/calendar');
    });

    testWidgets('offering teaser pushes /packages', (
      WidgetTester tester,
    ) async {
      String? pushed;
      final router = _homeRouter((location) => pushed = location);
      addTearDown(router.dispose);
      await tester.pumpWidget(_harness(router));
      await tester.pumpAndSettle();

      await tester.ensureVisible(find.text('View Offerings'));
      await tester.pumpAndSettle();
      await tester.tap(find.byKey(const Key('home_view_offerings_cta')));
      await tester.pumpAndSettle();

      expect(pushed, '/packages');
    });
  });
}
