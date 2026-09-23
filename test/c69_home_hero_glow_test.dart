import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:inea_scents_client/config/theme.dart';
import 'package:inea_scents_client/providers/index.dart';
import 'package:inea_scents_client/screens/home_screen.dart';
import 'package:inea_scents_client/widgets/home_hero_glow.dart';

/// C69: home hero ambient richness — C59 blob/gradient language on the
/// concierge hero (NextStepCard): slow plum/cream opacity drift, no layout
/// change, no overflow at 360px or desktop, static under reduced-motion.
/// Flutter built-ins only, single drift cycle so pumpAndSettle stays green.
GoRouter _router(
  void Function(String location) onPush, {
  bool disableAnimations = false,
}) {
  return GoRouter(
    initialLocation: '/',
    routes: [
      GoRoute(
        path: '/',
        builder: (context, state) => MediaQuery(
          data: MediaQueryData(disableAnimations: disableAnimations),
          child: const HomeScreen(),
        ),
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

Future<void> _pumpHome(
  WidgetTester tester, {
  void Function(String location)? onPush,
  bool disableAnimations = false,
  ThemeData? theme,
  Size size = const Size(360, 800),
}) async {
  tester.view.physicalSize = size;
  tester.view.devicePixelRatio = 1.0;
  addTearDown(tester.view.reset);
  final router = _router(
    onPush ?? (_) {},
    disableAnimations: disableAnimations,
  );
  addTearDown(router.dispose);
  await tester.pumpWidget(
    ProviderScope(
      overrides: [bookingsProvider.overrideWith((ref) async => [])],
      child: MaterialApp.router(
        theme: theme ?? AppTheme.lightTheme,
        routerConfig: router,
      ),
    ),
  );
}

Finder _glowOpacity() => find.descendant(
  of: find.byKey(const Key('home_hero_glow')),
  matching: find.byType(Opacity),
);

Finder _glowTweens() => find.descendant(
  of: find.byKey(const Key('home_hero_glow')),
  matching: find.byType(TweenAnimationBuilder<double>),
);

void main() {
  setUpAll(() {
    GoogleFonts.config.allowRuntimeFetching = false;
  });

  group('c69 drift math + tokens', () {
    test('opacityFor spans the drift range and clamps', () {
      expect(HomeHeroGlow.opacityFor(0.0), HomeHeroGlow.minOpacity);
      expect(HomeHeroGlow.opacityFor(1.0), HomeHeroGlow.maxOpacity);
      expect(HomeHeroGlow.opacityFor(-1.0), HomeHeroGlow.minOpacity);
      expect(HomeHeroGlow.opacityFor(2.0), HomeHeroGlow.maxOpacity);
      expect(HomeHeroGlow.minOpacity, lessThan(HomeHeroGlow.maxOpacity));
    });

    test('drift is slow (multi-second, single cycle)', () {
      expect(HomeHeroGlow.driftDuration.inSeconds, greaterThanOrEqualTo(4));
    });

    test('washes use plum/cream tokens only', () {
      bool sameRgb(Color a, Color b) => a.r == b.r && a.g == b.g && a.b == b.b;
      for (final dark in [false, true]) {
        expect(
          sameRgb(
            HomeHeroGlow.plumWash(dark),
            AppTheme.primaryButtonBackground,
          ),
          isTrue,
          reason: 'plum wash must be the plum token',
        );
        expect(
          sameRgb(HomeHeroGlow.creamWash(dark), AppTheme.onPrimaryButton),
          isTrue,
          reason: 'cream wash must be the cream token',
        );
      }
    });
  });

  group('c69 hero glow on Home', () {
    testWidgets('glow renders behind hero, CTA still routes /calendar', (
      WidgetTester tester,
    ) async {
      String? pushed;
      await _pumpHome(tester, onPush: (location) => pushed = location);
      await tester.pumpAndSettle();

      expect(find.byKey(const Key('home_hero_glow')), findsOneWidget);
      expect(find.byKey(const Key('home_next_step_card')), findsOneWidget);

      await tester.ensureVisible(find.text('Check date'));
      await tester.pumpAndSettle();
      await tester.tap(find.byKey(const Key('home_check_date_cta')));
      await tester.pumpAndSettle();
      expect(pushed, '/calendar');
      expect(tester.takeException(), isNull);
    });

    testWidgets('glow drifts slowly then rests at full warmth', (
      WidgetTester tester,
    ) async {
      await _pumpHome(tester);
      await tester.pump(const Duration(milliseconds: 60));

      // Mid-flight: drift running below full warmth.
      expect(_glowTweens(), findsOneWidget);
      expect(tester.widget<Opacity>(_glowOpacity()).opacity, lessThan(1.0));

      await tester.pumpAndSettle();
      expect(tester.widget<Opacity>(_glowOpacity()).opacity, 1.0);
      expect(tester.takeException(), isNull);
    });

    testWidgets('reduced-motion renders resting warmth, no animation', (
      WidgetTester tester,
    ) async {
      await _pumpHome(tester, disableAnimations: true);
      await tester.pumpAndSettle();

      expect(find.byKey(const Key('home_hero_glow')), findsOneWidget);
      expect(_glowTweens(), findsNothing);
      expect(
        find.descendant(
          of: find.byKey(const Key('home_hero_glow')),
          matching: find.byType(FadeTransition),
        ),
        findsNothing,
      );
      expect(
        find.descendant(
          of: find.byKey(const Key('home_hero_glow')),
          matching: find.byType(AnimatedOpacity),
        ),
        findsNothing,
      );
      expect(tester.widget<Opacity>(_glowOpacity()).opacity, 1.0);
      expect(tester.takeException(), isNull);
    });

    for (final width in [360.0, 1280.0]) {
      for (final theme in [AppTheme.lightTheme, AppTheme.darkTheme]) {
        final mode = theme.brightness == Brightness.dark ? 'dark' : 'light';
        testWidgets('home $mode no overflow @${width.toInt()}px', (
          WidgetTester tester,
        ) async {
          await _pumpHome(tester, theme: theme, size: Size(width, 800));
          await tester.pumpAndSettle();

          expect(find.byKey(const Key('home_hero_glow')), findsOneWidget);
          expect(find.byKey(const Key('home_next_step_card')), findsOneWidget);
          expect(tester.takeException(), isNull);
        });
      }
    }
  });
}
