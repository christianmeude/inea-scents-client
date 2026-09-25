import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:inea_scents_client/providers/index.dart';
import 'package:inea_scents_client/screens/home_screen.dart';
import 'package:inea_scents_client/widgets/index.dart';

/// C91: Home two-column body on tablet/desktop (≥768), stacked on mobile.
/// No catalog grid. How-it-works strip present (DRAFT copy, owner gate).
GoRouter _homeRouter() {
  return GoRouter(
    initialLocation: '/',
    routes: [
      GoRoute(
        path: '/',
        builder: (context, state) => const HomeScreen(),
      ),
      GoRoute(
        path: '/calendar',
        builder: (context, state) => const SizedBox(),
      ),
      GoRoute(
        path: '/packages',
        builder: (context, state) => const SizedBox(),
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

Future<void> _pumpAtSize(
  WidgetTester tester,
  GoRouter router,
  Size size,
) async {
  tester.view.physicalSize = size;
  tester.view.devicePixelRatio = 1.0;
  addTearDown(() {
    tester.view.resetPhysicalSize();
    tester.view.resetDevicePixelRatio();
  });
  await tester.pumpWidget(_harness(router));
  await tester.pumpAndSettle();
}

void main() {
  group('c91 home two-column', () {
    testWidgets('mobile (390) stacks, keeps concierge stack + strip',
        (WidgetTester tester) async {
      final router = _homeRouter();
      addTearDown(router.dispose);
      await _pumpAtSize(tester, router, const Size(390, 844));

      expect(find.byKey(const Key('home_stacked')), findsOneWidget);
      expect(find.byKey(const Key('home_two_col')), findsNothing);
      expect(find.byKey(const Key('home_next_step_card')), findsOneWidget);
      expect(find.byType(UpcomingBookingSection), findsOneWidget);
      expect(find.byKey(const Key('home_offering_teaser')), findsOneWidget);
      expect(find.byKey(const Key('home_how_it_works')), findsOneWidget);
      expect(find.text('How it works'), findsOneWidget);
      expect(find.text('Browse'), findsOneWidget);
      expect(find.text('Schedule'), findsOneWidget);
      expect(find.text('Pay'), findsNothing);
      // No catalog grid returns to Home.
      expect(find.byType(PackageCard), findsNothing);
      expect(find.byType(GridView), findsNothing);
    });

    testWidgets('wide (1280) renders two columns + strip', (
      WidgetTester tester,
    ) async {
      final router = _homeRouter();
      addTearDown(router.dispose);
      await _pumpAtSize(tester, router, const Size(1280, 800));

      expect(find.byKey(const Key('home_two_col')), findsOneWidget);
      expect(find.byKey(const Key('home_stacked')), findsNothing);
      expect(find.byKey(const Key('home_next_step_card')), findsOneWidget);
      expect(find.byType(UpcomingBookingSection), findsOneWidget);
      expect(find.byKey(const Key('home_offering_teaser')), findsOneWidget);
      expect(find.byKey(const Key('home_how_it_works')), findsOneWidget);
      expect(find.byType(PackageCard), findsNothing);
      expect(find.byType(GridView), findsNothing);
    });
  });
}
