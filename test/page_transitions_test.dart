import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:inea_scents_client/config/theme.dart';

void main() {
  setUpAll(() {
    GoogleFonts.config.allowRuntimeFetching = false;
  });

  group('PageTransitionsTheme & CrossFadePageTransitionsBuilder Tests', () {
    test(
      'AppTheme.lightTheme and darkTheme inject CrossFadePageTransitionsBuilder for desktop platforms',
      () {
        final lightTheme = AppTheme.lightTheme;
        final darkTheme = AppTheme.darkTheme;

        final desktopPlatforms = [
          TargetPlatform.windows,
          TargetPlatform.macOS,
          TargetPlatform.linux,
          TargetPlatform.fuchsia,
        ];

        for (final platform in desktopPlatforms) {
          final lightBuilder =
              lightTheme.pageTransitionsTheme.builders[platform];
          expect(
            lightBuilder,
            isA<CrossFadePageTransitionsBuilder>(),
            reason:
                'Expected lightTheme to use CrossFadePageTransitionsBuilder for $platform',
          );

          final darkBuilder = darkTheme.pageTransitionsTheme.builders[platform];
          expect(
            darkBuilder,
            isA<CrossFadePageTransitionsBuilder>(),
            reason:
                'Expected darkTheme to use CrossFadePageTransitionsBuilder for $platform',
          );
        }

        // Verify mobile platforms retain standard mobile builders
        expect(
          lightTheme.pageTransitionsTheme.builders[TargetPlatform.iOS],
          isA<CupertinoPageTransitionsBuilder>(),
        );
        expect(
          lightTheme.pageTransitionsTheme.builders[TargetPlatform.android],
          isA<ZoomPageTransitionsBuilder>(),
        );
      },
    );

    testWidgets(
      'CrossFadePageTransitionsBuilder builds FadeTransition widgets',
      (WidgetTester tester) async {
        const builder = CrossFadePageTransitionsBuilder();

        await tester.pumpWidget(
          MaterialApp(
            home: Builder(
              builder: (context) {
                final animationController = AnimationController(
                  vsync: const TestVSync(),
                  duration: const Duration(milliseconds: 300),
                );
                final secondaryController = AnimationController(
                  vsync: const TestVSync(),
                  duration: const Duration(milliseconds: 300),
                );

                final transitionWidget = builder.buildTransitions<void>(
                  MaterialPageRoute(builder: (_) => const Text('Target Route')),
                  context,
                  animationController,
                  secondaryController,
                  const Text('Transition Child Content'),
                );

                return transitionWidget;
              },
            ),
          ),
        );

        // Verify FadeTransition exists in the transition widget tree
        expect(find.byType(FadeTransition), findsWidgets);
        expect(find.text('Transition Child Content'), findsOneWidget);
      },
    );

    testWidgets(
      'Desktop navigation executes cross-fade transition on route push and pop (Windows)',
      (WidgetTester tester) async {
        final key = GlobalKey<NavigatorState>();

        await tester.pumpWidget(
          MaterialApp(
            navigatorKey: key,
            theme: AppTheme.lightTheme.copyWith(
              platform: TargetPlatform.windows, // Simulate Windows desktop
            ),
            home: const Scaffold(body: Text('Page 1 Content')),
          ),
        );

        expect(find.text('Page 1 Content'), findsOneWidget);

        // Push Page 2
        key.currentState!.push(
          MaterialPageRoute<void>(
            builder: (_) => const Scaffold(body: Text('Page 2 Content')),
          ),
        );

        // Halfway through push transition
        await tester.pump(const Duration(milliseconds: 150));
        expect(find.byType(FadeTransition), findsWidgets);

        // Complete transition
        await tester.pumpAndSettle();
        expect(find.text('Page 2 Content'), findsOneWidget);

        // Pop back to Page 1
        key.currentState!.pop();
        await tester.pump(const Duration(milliseconds: 150));
        expect(find.byType(FadeTransition), findsWidgets);

        await tester.pumpAndSettle();
        expect(find.text('Page 1 Content'), findsOneWidget);
      },
    );

    testWidgets(
      'Desktop navigation executes cross-fade transition on macOS in Dark Theme',
      (WidgetTester tester) async {
        final key = GlobalKey<NavigatorState>();

        await tester.pumpWidget(
          MaterialApp(
            navigatorKey: key,
            theme: AppTheme.darkTheme.copyWith(
              platform: TargetPlatform.macOS, // Simulate macOS desktop
            ),
            home: const Scaffold(body: Text('Dark Page 1')),
          ),
        );

        expect(find.text('Dark Page 1'), findsOneWidget);

        key.currentState!.push(
          MaterialPageRoute<void>(
            builder: (_) => const Scaffold(body: Text('Dark Page 2')),
          ),
        );

        await tester.pump(const Duration(milliseconds: 150));
        expect(find.byType(FadeTransition), findsWidgets);

        await tester.pumpAndSettle();
        expect(find.text('Dark Page 2'), findsOneWidget);
      },
    );

    testWidgets(
      'Desktop navigation executes cross-fade transition on Linux and Fuchsia platforms',
      (WidgetTester tester) async {
        for (final platform in [TargetPlatform.linux, TargetPlatform.fuchsia]) {
          final key = GlobalKey<NavigatorState>();

          await tester.pumpWidget(
            MaterialApp(
              navigatorKey: key,
              theme: AppTheme.lightTheme.copyWith(platform: platform),
              home: Scaffold(body: Text('$platform Page 1')),
            ),
          );

          expect(find.text('$platform Page 1'), findsOneWidget);

          key.currentState!.push(
            MaterialPageRoute<void>(
              builder: (_) => Scaffold(body: Text('$platform Page 2')),
            ),
          );

          await tester.pump(const Duration(milliseconds: 150));
          expect(find.byType(FadeTransition), findsWidgets);

          await tester.pumpAndSettle();
          expect(find.text('$platform Page 2'), findsOneWidget);
        }
      },
    );

    testWidgets(
      'Mid-transition cancellation and reverse animation completes cleanly',
      (WidgetTester tester) async {
        final key = GlobalKey<NavigatorState>();

        await tester.pumpWidget(
          MaterialApp(
            navigatorKey: key,
            theme: AppTheme.lightTheme.copyWith(
              platform: TargetPlatform.windows,
            ),
            home: const Scaffold(body: Text('Base Page')),
          ),
        );

        // Start push
        key.currentState!.push(
          MaterialPageRoute<void>(
            builder: (_) => const Scaffold(body: Text('Temporary Page')),
          ),
        );

        // Advance 100ms into 300ms transition
        await tester.pump(const Duration(milliseconds: 100));
        expect(find.byType(FadeTransition), findsWidgets);

        // Pop while animation is in flight
        key.currentState!.pop();
        await tester.pump(const Duration(milliseconds: 50));
        expect(find.byType(FadeTransition), findsWidgets);

        await tester.pumpAndSettle();
        expect(find.text('Base Page'), findsOneWidget);
        expect(find.text('Temporary Page'), findsNothing);
      },
    );
  });
}
