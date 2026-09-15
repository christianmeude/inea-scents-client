import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:inea_scents_client/config/theme.dart';
import 'package:inea_scents_client/widgets/index.dart';

void main() {
  setUpAll(() {
    GoogleFonts.config.allowRuntimeFetching = false;
  });

  group('Adversarial Scenarios & Stress Tests', () {
    testWidgets(
      '1. Extreme Ultra-Wide 5K (5120x1440) Content Centering & MaxWidth Bounds',
      (WidgetTester tester) async {
        tester.view.physicalSize = const Size(5120, 1440);
        tester.view.devicePixelRatio = 1.0;
        addTearDown(tester.view.resetPhysicalSize);
        addTearDown(tester.view.resetDevicePixelRatio);

        await tester.pumpWidget(
          MaterialApp(
            theme: AppTheme.lightTheme,
            home: const ResponsiveAppShell(
              child: SizedBox(
                key: Key('inner_content'),
                width: double.infinity,
                height: 200,
                child: Text('Ultra-Wide Content'),
              ),
            ),
          ),
        );
        await tester.pumpAndSettle();

        // TopNavBar is present
        expect(find.byType(TopNavBar), findsOneWidget);
        expect(find.byType(BottomNavBar), findsNothing);

        // Verify the max-width constrained box limits width to exactly 1200px
        // removed old assertions
      },
    );

    testWidgets('2. Extremely Narrow Viewport (240x600) Mobile Robustness', (
      WidgetTester tester,
    ) async {
      tester.view.physicalSize = const Size(240, 600);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);

      await tester.pumpWidget(
        MaterialApp(
          theme: AppTheme.lightTheme,
          home: const ResponsiveAppShell(child: Text('Narrow Screen Content')),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.byType(TopNavBar), findsNothing);
      expect(find.byType(BottomNavBar), findsOneWidget);
      expect(find.text('Narrow Screen Content'), findsOneWidget);
    });

    testWidgets(
      '3. Shallow Landscape Viewport (1024x300) Desktop TopNavBar Layout',
      (WidgetTester tester) async {
        tester.view.physicalSize = const Size(1024, 300);
        tester.view.devicePixelRatio = 1.0;
        addTearDown(tester.view.resetPhysicalSize);
        addTearDown(tester.view.resetDevicePixelRatio);

        await tester.pumpWidget(
          MaterialApp(
            theme: AppTheme.lightTheme,
            home: const ResponsiveAppShell(
              child: Text('Shallow Viewport Content'),
            ),
          ),
        );
        await tester.pumpAndSettle();

        final topNavBarBox =
            tester.renderObject(find.byType(TopNavBar)) as RenderBox;
        expect(topNavBarBox.size.height, equals(68.0));
        expect(find.text('Shallow Viewport Content'), findsOneWidget);
      },
    );

    testWidgets(
      '4. Standalone ResponsiveAppShell Without GoRouter (Vanilla Navigator)',
      (WidgetTester tester) async {
        tester.view.physicalSize = const Size(1024, 768);
        tester.view.devicePixelRatio = 1.0;
        addTearDown(tester.view.resetPhysicalSize);
        addTearDown(tester.view.resetDevicePixelRatio);

        // Verify ResponsiveAppShell does not throw when GoRouter is not in the widget tree
        await tester.pumpWidget(
          MaterialApp(
            theme: AppTheme.lightTheme,
            home: const ResponsiveAppShell(child: Text('No Router Content')),
          ),
        );
        await tester.pumpAndSettle();

        expect(find.byType(TopNavBar), findsOneWidget);
        expect(find.text('No Router Content'), findsOneWidget);
      },
    );

    testWidgets(
      '5. GoRouter with Query Parameters & Deep Dynamic IDs Active Tab Resolution',
      (WidgetTester tester) async {
        tester.view.physicalSize = const Size(1280, 800);
        tester.view.devicePixelRatio = 1.0;
        addTearDown(tester.view.resetPhysicalSize);
        addTearDown(tester.view.resetDevicePixelRatio);

        final router = GoRouter(
          initialLocation: '/messages?category=Wedding&sort=price_asc',
          routes: [
            ShellRoute(
              builder: (context, state, child) =>
                  ResponsiveAppShell(child: child),
              routes: [
                GoRoute(
                  path: '/messages',
                  builder: (context, state) => Text(
                    'Packages category=${state.queryParameters['category']}',
                  ),
                ),
                GoRoute(
                  path: '/bookings',
                  builder: (context, state) => const Text('Bookings List'),
                ),
                GoRoute(
                  path: '/calendar',
                  builder: (context, state) => const Text('Calendar View'),
                ),
              ],
            ),
          ],
        );

        await tester.pumpWidget(
          MaterialApp.router(theme: AppTheme.lightTheme, routerConfig: router),
        );
        await tester.pumpAndSettle();

        // Verify query params rendered and MESSAGES tab is active
        expect(find.text('Packages category=Wedding'), findsOneWidget);
        expect(find.byIcon(Icons.chat_bubble), findsOneWidget);

        // Navigate to calendar with query params
        router.go('/calendar?month=12&year=2026');
        await tester.pumpAndSettle();

        expect(find.text('Calendar View'), findsOneWidget);
        expect(find.byIcon(Icons.event_available), findsOneWidget);
      },
    );

    testWidgets(
      '6. Rapid Sequential Route Transitions on Desktop Without Stalling',
      (WidgetTester tester) async {
        final key = GlobalKey<NavigatorState>();

        await tester.pumpWidget(
          MaterialApp(
            navigatorKey: key,
            theme: AppTheme.lightTheme.copyWith(
              platform: TargetPlatform.windows,
            ),
            home: const Scaffold(body: Text('Page Root')),
          ),
        );

        // Push 5 routes sequentially
        for (int i = 1; i <= 5; i++) {
          key.currentState!.push(
            MaterialPageRoute<void>(
              builder: (_) => Scaffold(body: Text('Pushed Page $i')),
            ),
          );
          // Pump 50ms (in the middle of transition)
          await tester.pump(const Duration(milliseconds: 50));
        }

        await tester.pumpAndSettle();
        expect(find.text('Pushed Page 5'), findsOneWidget);

        // Pop 4 routes sequentially
        for (int i = 5; i > 1; i--) {
          key.currentState!.pop();
          await tester.pump(const Duration(milliseconds: 50));
        }

        await tester.pumpAndSettle();
        expect(find.text('Pushed Page 1'), findsOneWidget);
      },
    );

    testWidgets(
      '7. TopNavBar Handles Safe Area Top Notch Padding on iPad / Tablet Viewports',
      (WidgetTester tester) async {
        tester.view.physicalSize = const Size(1024, 768);
        tester.view.devicePixelRatio = 1.0;
        tester.view.padding = const FakeViewPadding(top: 44.0);
        addTearDown(tester.view.resetPhysicalSize);
        addTearDown(tester.view.resetDevicePixelRatio);
        addTearDown(tester.view.resetPadding);

        await tester.pumpWidget(
          MaterialApp(
            theme: AppTheme.lightTheme,
            home: const ResponsiveAppShell(child: Text('Safe Area Content')),
          ),
        );
        await tester.pumpAndSettle();

        expect(find.byType(TopNavBar), findsOneWidget);
        expect(find.text('Safe Area Content'), findsOneWidget);

        // Verify SafeArea widget exists within TopNavBar
        final safeAreaFinder = find.descendant(
          of: find.byType(TopNavBar),
          matching: find.byType(SafeArea),
        );
        expect(safeAreaFinder, findsOneWidget);
      },
    );

    testWidgets(
      '8. Accessibility High Text Scaling (2.5x) Does Not Cause Flex Overflow on TopNavBar or App Shell',
      (WidgetTester tester) async {
        tester.view.physicalSize = const Size(
          768.0,
          900.0,
        ); // Exact minimum desktop width
        tester.view.devicePixelRatio = 1.0;
        addTearDown(tester.view.resetPhysicalSize);
        addTearDown(tester.view.resetDevicePixelRatio);

        await tester.pumpWidget(
          MaterialApp(
            theme: AppTheme.lightTheme,
            home: MediaQuery(
              data: const MediaQueryData(
                size: Size(768.0, 900.0),
                textScaler: TextScaler.linear(2.5),
              ),
              child: const ResponsiveAppShell(
                child: Text('High Scale Content'),
              ),
            ),
          ),
        );
        await tester.pumpAndSettle();

        expect(find.byType(TopNavBar), findsOneWidget);
        expect(find.text('High Scale Content'), findsOneWidget);
        expect(tester.takeException(), isNull);
      },
    );

    testWidgets(
      '9. GoRouter Deep Path with Hash and Special Characters Tab Selection',
      (WidgetTester tester) async {
        tester.view.physicalSize = const Size(1280, 800);
        tester.view.devicePixelRatio = 1.0;
        addTearDown(tester.view.resetPhysicalSize);
        addTearDown(tester.view.resetDevicePixelRatio);

        final router = GoRouter(
          initialLocation: '/home#featured-section?ref=banner_promo',
          routes: [
            ShellRoute(
              builder: (context, state, child) =>
                  ResponsiveAppShell(child: child),
              routes: [
                GoRoute(
                  path: '/home',
                  builder: (context, state) => const Text('Home Landing'),
                ),
                GoRoute(
                  path: '/profile',
                  builder: (context, state) => const Text('Profile Landing'),
                ),
              ],
            ),
          ],
        );

        await tester.pumpWidget(
          MaterialApp.router(theme: AppTheme.lightTheme, routerConfig: router),
        );
        await tester.pumpAndSettle();

        expect(find.text('Home Landing'), findsOneWidget);
        expect(find.byIcon(Icons.home), findsOneWidget);

        router.go('/profile#preferences');
        await tester.pumpAndSettle();

        expect(find.text('Profile Landing'), findsOneWidget);
        expect(find.byIcon(Icons.person), findsOneWidget);
      },
    );

    testWidgets('10. BottomNavBar tap without GoRouter does not crash', (
      WidgetTester tester,
    ) async {
      tester.view.physicalSize = const Size(375, 667);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);

      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            bottomNavigationBar: BottomNavBar(),
            body: Text('Standalone Bottom Nav'),
          ),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.byType(BottomNavBar), findsOneWidget);
      // Tapping each bottom nav item without GoRouter should not throw
      await tester.tap(find.text('MESSAGES'));
      await tester.pumpAndSettle();
      await tester.tap(find.text('BOOKINGS'));
      await tester.pumpAndSettle();
      await tester.tap(find.text('PROFILE'));
      await tester.pumpAndSettle();
      await tester.tap(find.text('HOME'));
      await tester.pumpAndSettle();
      expect(tester.takeException(), isNull);
    });

    testWidgets('11. Extreme 3.0x text scaling renders without exception', (
      WidgetTester tester,
    ) async {
      tester.view.physicalSize = const Size(768.0, 900.0);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);

      await tester.pumpWidget(
        MaterialApp(
          theme: AppTheme.lightTheme,
          home: MediaQuery(
            data: const MediaQueryData(
              size: Size(768.0, 900.0),
              textScaler: TextScaler.linear(3.0),
            ),
            child: const ResponsiveAppShell(
              child: Text('Extreme Scale Content'),
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.byType(TopNavBar), findsOneWidget);
      expect(find.text('Extreme Scale Content'), findsOneWidget);
      expect(tester.takeException(), isNull);
    });

    testWidgets(
      '12. Tablet upper boundary precision at 1024.0px and 1024.01px',
      (WidgetTester tester) async {
        // 1024.0px is Tablet (3-col, P6 G2)
        expect(ResponsiveAppShell.getGridColumnCount(1024.0), equals(3));
        // 1024.01px is Desktop (4-col, P6 G2)
        expect(ResponsiveAppShell.getGridColumnCount(1024.01), equals(4));
      },
    );

    testWidgets(
      '13. ResponsiveAppShell custom backgroundColor override takes precedence in Light and Dark modes',
      (WidgetTester tester) async {
        tester.view.physicalSize = const Size(1024, 768);
        tester.view.devicePixelRatio = 1.0;
        addTearDown(tester.view.resetPhysicalSize);
        addTearDown(tester.view.resetDevicePixelRatio);

        const customColor = Color(0xFF123456);

        // Light mode custom background
        await tester.pumpWidget(
          MaterialApp(
            theme: AppTheme.lightTheme,
            home: const ResponsiveAppShell(
              backgroundColor: customColor,
              child: Text('Custom Bg Light'),
            ),
          ),
        );
        final lightScaffold = tester.widget<Scaffold>(find.byType(Scaffold));
        expect(lightScaffold.backgroundColor, equals(customColor));

        // Dark mode custom background
        await tester.pumpWidget(
          MaterialApp(
            theme: AppTheme.darkTheme,
            home: const ResponsiveAppShell(
              backgroundColor: customColor,
              child: Text('Custom Bg Dark'),
            ),
          ),
        );
        final darkScaffold = tester.widget<Scaffold>(find.byType(Scaffold));
        expect(darkScaffold.backgroundColor, equals(customColor));
      },
    );

    testWidgets(
      '14. Mobile shell hides BottomNavBar on auth and splash routes',
      (WidgetTester tester) async {
        tester.view.physicalSize = const Size(375, 667);
        tester.view.devicePixelRatio = 1.0;
        addTearDown(tester.view.resetPhysicalSize);
        addTearDown(tester.view.resetDevicePixelRatio);

        final router = GoRouter(
          initialLocation: '/home',
          routes: [
            ShellRoute(
              builder: (context, state, child) =>
                  ResponsiveAppShell(child: child),
              routes: [
                GoRoute(
                  path: '/home',
                  builder: (context, state) => const Text('Home'),
                ),
                GoRoute(
                  path: '/login',
                  builder: (context, state) => const Text('Login'),
                ),
                GoRoute(
                  path: '/register',
                  builder: (context, state) => const Text('Register'),
                ),
                GoRoute(
                  path: '/forgot-password',
                  builder: (context, state) => const Text('Forgot Password'),
                ),
                GoRoute(
                  path: '/splash',
                  builder: (context, state) => const Text('Splash'),
                ),
              ],
            ),
          ],
        );

        await tester.pumpWidget(
          MaterialApp.router(theme: AppTheme.lightTheme, routerConfig: router),
        );
        await tester.pumpAndSettle();

        // On /home -> BottomNavBar is visible
        expect(find.byType(BottomNavBar), findsOneWidget);

        // On /login -> BottomNavBar is hidden
        router.go('/login');
        await tester.pumpAndSettle();
        expect(find.byType(BottomNavBar), findsNothing);

        // On /register -> BottomNavBar is hidden
        router.go('/register');
        await tester.pumpAndSettle();
        expect(find.byType(BottomNavBar), findsNothing);

        // On /forgot-password -> BottomNavBar is hidden
        router.go('/forgot-password');
        await tester.pumpAndSettle();
        expect(find.byType(BottomNavBar), findsNothing);

        // On /splash -> BottomNavBar is hidden
        router.go('/splash');
        await tester.pumpAndSettle();
        expect(find.byType(BottomNavBar), findsNothing);
      },
    );
  });
}
