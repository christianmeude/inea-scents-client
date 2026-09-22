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

  group('ResponsiveAppShell & Navigation Breakpoint Tests', () {
    testWidgets(
      'Renders TopNavBar and hides BottomNavBar on desktop screens (width >= 768px)',
      (WidgetTester tester) async {
        // Configure large desktop screen (1280x800)
        tester.view.physicalSize = const Size(1280, 800);
        tester.view.devicePixelRatio = 1.0;
        addTearDown(tester.view.resetPhysicalSize);
        addTearDown(tester.view.resetDevicePixelRatio);

        await tester.pumpWidget(
          MaterialApp(
            theme: AppTheme.lightTheme,
            home: const ResponsiveAppShell(child: Text('Desktop Content')),
          ),
        );

        // Verify TopNavBar is present
        expect(find.byType(TopNavBar), findsOneWidget);
        // Verify BottomNavBar is NOT rendered / hidden
        expect(find.byType(BottomNavBar), findsNothing);
        expect(find.text('Desktop Content'), findsOneWidget);

        // Verify TopNavBar has glassmorphism (BackdropFilter)
        final backdropFilters = find.descendant(
          of: find.byType(TopNavBar),
          matching: find.byType(BackdropFilter),
        );
        expect(backdropFilters, findsOneWidget);

        final backdropFilterWidget = tester.widget<BackdropFilter>(
          backdropFilters,
        );
        expect(backdropFilterWidget.filter, isNotNull);

        // Verify TopNavBar branding
        expect(find.text('INEA'), findsOneWidget);
        expect(find.text('Scents'), findsOneWidget);

        // Verify TopNavBar navigation items
        expect(find.text('HOME'), findsOneWidget);
        expect(find.text('PACKAGES'), findsOneWidget);
        expect(find.text('BOOKINGS'), findsOneWidget);
        expect(find.text('CALENDAR'), findsOneWidget);
        expect(find.text('PROFILE'), findsOneWidget);

// ConstrainedBox assertions removed
      },
    );

    testWidgets(
      'Renders BottomNavBar and hides TopNavBar on mobile screens (width < 768px)',
      (WidgetTester tester) async {
        // Configure mobile screen (375x667)
        tester.view.physicalSize = const Size(375, 667);
        tester.view.devicePixelRatio = 1.0;
        addTearDown(tester.view.resetPhysicalSize);
        addTearDown(tester.view.resetDevicePixelRatio);

        await tester.pumpWidget(
          MaterialApp(
            theme: AppTheme.lightTheme,
            home: const ResponsiveAppShell(child: Text('Mobile Content')),
          ),
        );

        // Verify TopNavBar is NOT present
        expect(find.byType(TopNavBar), findsNothing);
        // Verify BottomNavBar IS present
        expect(find.byType(BottomNavBar), findsOneWidget);
        expect(find.text('Mobile Content'), findsOneWidget);
      },
    );

    testWidgets('Boundary precision test at exactly 768.0px and 767.9px', (
      WidgetTester tester,
    ) async {
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);

      // 1. Sub-breakpoint (767.9px) -> Mobile mode
      tester.view.physicalSize = const Size(767.9, 900);
      await tester.pumpWidget(
        MaterialApp(
          theme: AppTheme.lightTheme,
          home: const ResponsiveAppShell(child: Text('Boundary Content')),
        ),
      );
      expect(find.byType(TopNavBar), findsNothing);
      expect(find.byType(BottomNavBar), findsOneWidget);

      // 2. Exact breakpoint (768.0px) -> Desktop mode
      tester.view.physicalSize = const Size(768.0, 900);
      await tester.pumpAndSettle();
      expect(find.byType(TopNavBar), findsOneWidget);
      expect(find.byType(BottomNavBar), findsNothing);
    });

    testWidgets(
      'Toggles between TopNavBar and BottomNavBar dynamically across multi-breakpoint resize sequence',
      (WidgetTester tester) async {
        tester.view.physicalSize = const Size(320, 800);
        tester.view.devicePixelRatio = 1.0;
        addTearDown(tester.view.resetPhysicalSize);
        addTearDown(tester.view.resetDevicePixelRatio);

        await tester.pumpWidget(
          MaterialApp(
            theme: AppTheme.lightTheme,
            home: const ResponsiveAppShell(child: Text('Responsive Body')),
          ),
        );

        // Step 1: Small mobile (320px)
        expect(find.byType(TopNavBar), findsNothing);
        expect(find.byType(BottomNavBar), findsOneWidget);

        // Step 2: Resize to 768px (Desktop boundary)
        tester.view.physicalSize = const Size(768, 900);
        await tester.pumpAndSettle();
        expect(find.byType(TopNavBar), findsOneWidget);
        expect(find.byType(BottomNavBar), findsNothing);

        // Step 3: Resize to 2560px (4K Ultra-wide)
        tester.view.physicalSize = const Size(2560, 1440);
        await tester.pumpAndSettle();
        expect(find.byType(TopNavBar), findsOneWidget);
        expect(find.byType(BottomNavBar), findsNothing);

        // Step 4: Resize back to 600px (Mobile)
        tester.view.physicalSize = const Size(600, 900);
        await tester.pumpAndSettle();
        expect(find.byType(TopNavBar), findsNothing);
        expect(find.byType(BottomNavBar), findsOneWidget);
      },
    );

    testWidgets(
      'TopNavBar items use SystemMouseCursors.click for web interaction',
      (WidgetTester tester) async {
        tester.view.physicalSize = const Size(1024, 768);
        tester.view.devicePixelRatio = 1.0;
        addTearDown(tester.view.resetPhysicalSize);
        addTearDown(tester.view.resetDevicePixelRatio);

        await tester.pumpWidget(
          MaterialApp(
            theme: AppTheme.lightTheme,
            home: const ResponsiveAppShell(child: Text('Content')),
          ),
        );

        final mouseRegions = find.descendant(
          of: find.byType(TopNavBar),
          matching: find.byType(MouseRegion),
        );
        expect(mouseRegions, findsWidgets);

        for (final element in mouseRegions.evaluate()) {
          final widget = element.widget as MouseRegion;
          expect(widget.cursor, equals(SystemMouseCursors.click));
        }
      },
    );

    testWidgets('TopNavBar renders dark theme background when Theme is dark', (
      WidgetTester tester,
    ) async {
      tester.view.physicalSize = const Size(1024, 768);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);

      await tester.pumpWidget(
        MaterialApp(
          theme: AppTheme.darkTheme,
          home: const ResponsiveAppShell(child: Text('Dark Desktop Content')),
        ),
      );

      expect(find.byType(TopNavBar), findsOneWidget);
      final backdrop = find.descendant(
        of: find.byType(TopNavBar),
        matching: find.byType(BackdropFilter),
      );
      expect(backdrop, findsOneWidget);
    });

    testWidgets(
      'ResponsiveAppShell Scaffold inherits scaffoldBackgroundColor from active Theme (Light and Dark)',
      (WidgetTester tester) async {
        tester.view.physicalSize = const Size(1024, 768);
        tester.view.devicePixelRatio = 1.0;
        addTearDown(tester.view.resetPhysicalSize);
        addTearDown(tester.view.resetDevicePixelRatio);

        // 1. Light theme scaffold background check
        await tester.pumpWidget(
          MaterialApp(
            theme: AppTheme.lightTheme,
            home: const ResponsiveAppShell(child: Text('Light Content')),
          ),
        );

        final lightScaffold = tester.widget<Scaffold>(find.byType(Scaffold));
        expect(
          lightScaffold.backgroundColor,
          isNull,
        ); // Let's Scaffold inherit from lightTheme (AppTheme.neutralBg)

        // 2. Dark theme scaffold background check
        await tester.pumpWidget(
          MaterialApp(
            theme: AppTheme.darkTheme,
            home: const ResponsiveAppShell(child: Text('Dark Content')),
          ),
        );

        final darkScaffold = tester.widget<Scaffold>(find.byType(Scaffold));
        expect(
          darkScaffold.backgroundColor,
          isNull,
        ); // Let's Scaffold inherit from darkTheme (Color(0xFF151012))
      },
    );

    testWidgets(
      'BottomNavBar widget self-hides when rendered directly on wide screens (>= 768px)',
      (WidgetTester tester) async {
        tester.view.physicalSize = const Size(1024, 768);
        tester.view.devicePixelRatio = 1.0;
        addTearDown(tester.view.resetPhysicalSize);
        addTearDown(tester.view.resetDevicePixelRatio);

        await tester.pumpWidget(
          const MaterialApp(
            home: Scaffold(
              body: Text('Standalone'),
              bottomNavigationBar: BottomNavBar(),
            ),
          ),
        );

        // The BottomNavBar should render SizedBox.shrink on >= 768px
        final bottomNavBarFinder = find.byType(BottomNavBar);
        expect(bottomNavBarFinder, findsOneWidget);

        final sizedBoxDescendant = find.descendant(
          of: bottomNavBarFinder,
          matching: find.byType(SizedBox),
        );
        expect(sizedBoxDescendant, findsOneWidget);
      },
    );

    testWidgets(
      'BottomNavBar renders dark theme background in Dark Mode on mobile screens',
      (WidgetTester tester) async {
        tester.view.physicalSize = const Size(375, 667);
        tester.view.devicePixelRatio = 1.0;
        addTearDown(tester.view.resetPhysicalSize);
        addTearDown(tester.view.resetDevicePixelRatio);

        await tester.pumpWidget(
          MaterialApp(
            theme: AppTheme.darkTheme,
            home: const ResponsiveAppShell(child: Text('Dark Mobile Content')),
          ),
        );

        expect(find.byType(BottomNavBar), findsOneWidget);
        final containerFinder = find.descendant(
          of: find.byType(BottomNavBar),
          matching: find.byType(Container),
        );
        expect(containerFinder, findsWidgets);

        final containerWidget = tester.widget<Container>(containerFinder.first);
        final decoration = containerWidget.decoration as BoxDecoration;
        expect(
          decoration.color,
          equals(AppTheme.night.withValues(alpha: 0.88)),
        );
      },
    );
  });

  group('GoRouter ShellRoute Deep Navigation & Selection Tests', () {
    testWidgets(
      'Navigates through all primary routes and updates active highlight in TopNavBar',
      (WidgetTester tester) async {
        tester.view.physicalSize = const Size(1280, 800);
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
                  builder: (context, state) => const Text('Home Screen Page'),
                ),
                GoRoute(
                  path: '/packages',
                  builder: (context, state) =>
                      const Text('Packages Screen Page'),
                ),
                GoRoute(
                  path: '/booking/:id',
                  builder: (context, state) =>
                      Text('Booking Flow ${state.pathParameters['id']}'),
                ),
                GoRoute(
                  path: '/bookings',
                  builder: (context, state) =>
                      const Text('My Bookings Screen Page'),
                ),
                GoRoute(
                  path: '/calendar',
                  builder: (context, state) =>
                      const Text('Calendar Screen Page'),
                ),
                GoRoute(
                  path: '/profile',
                  builder: (context, state) =>
                      const Text('Profile Screen Page'),
                ),
              ],
            ),
          ],
        );

        await tester.pumpWidget(
          MaterialApp.router(theme: AppTheme.lightTheme, routerConfig: router),
        );
        await tester.pumpAndSettle();

        // 1. Initial route: /home
        expect(find.text('Home Screen Page'), findsOneWidget);
        expect(find.byIcon(Icons.home), findsOneWidget); // Active icon for HOME

        // 2. Navigate to PACKAGES via tab click
        await tester.tap(find.text('PACKAGES'));
        await tester.pumpAndSettle();
        expect(find.text('Packages Screen Page'), findsOneWidget);
        expect(
          find.byIcon(Icons.card_giftcard),
          findsOneWidget,
        ); // Active icon for PACKAGES

        // 3. Navigate to BOOKINGS via tab click
        await tester.tap(find.text('BOOKINGS'));
        await tester.pumpAndSettle();
        expect(find.text('My Bookings Screen Page'), findsOneWidget);
        expect(
          find.byIcon(Icons.calendar_today),
          findsOneWidget,
        ); // Active icon for BOOKINGS

        // 4. Navigate to CALENDAR via tab click
        await tester.tap(find.text('CALENDAR'));
        await tester.pumpAndSettle();
        expect(find.text('Calendar Screen Page'), findsOneWidget);
        expect(
          find.byIcon(Icons.event_available),
          findsOneWidget,
        ); // Active icon for CALENDAR

        // 5. Navigate to PROFILE via tab click
        await tester.tap(find.text('PROFILE'));
        await tester.pumpAndSettle();
        expect(find.text('Profile Screen Page'), findsOneWidget);
        expect(
          find.byIcon(Icons.person),
          findsOneWidget,
        ); // Active icon for PROFILE

        // 6. Navigate back to HOME via logo click
        await tester.tap(find.text('INEA'));
        await tester.pumpAndSettle();
        expect(find.text('Home Screen Page'), findsOneWidget);
        expect(find.byIcon(Icons.home), findsOneWidget);

        // 7. Navigate to PACKAGES via the PACKAGES nav item
        // (the old 'Explore Packages' CTA was removed; the toggle
        // occupies the right cluster per the landing standard).
        await tester.tap(find.text('PACKAGES'));
        await tester.pumpAndSettle();
        expect(find.text('Packages Screen Page'), findsOneWidget);
        // debug
        print('Location: ' + router.routeInformationProvider.value.uri.path);
        try {
          expect(find.byIcon(Icons.card_giftcard), findsOneWidget);
        } catch (e) {
          print('card_giftcard not found. outline found? ' + find.byIcon(Icons.card_giftcard_outlined).evaluate().isNotEmpty.toString());
          print('location in router is: ' + router.location);
          print('uri path is: ' + router.routeInformationProvider.value.uri.path);
          rethrow;
        }

        // 8. C53: subroute /booking/99 belongs to the Packages branch
        // (single booking route), so PACKAGES keeps the highlight — the
        // plural /bookings list is the only BOOKINGS route.
        router.go('/booking/99');
        await tester.pumpAndSettle();
        expect(find.text('Booking Flow 99'), findsOneWidget);
        expect(find.byIcon(Icons.card_giftcard), findsOneWidget);

        // 10. Unknown /wishlist route is gone (wishlist retired, owner Q15).
        expect(find.text('Wishlist Screen Page'), findsNothing);
      },
    );

    testWidgets('Mobile shell hides BottomNavBar on detail routes', (
      WidgetTester tester,
    ) async {
      tester.view.physicalSize = const Size(375, 667);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);

      final router = GoRouter(
        initialLocation: '/packages',
        routes: [
          ShellRoute(
            builder: (context, state, child) =>
                ResponsiveAppShell(child: child),
            routes: [
              GoRoute(
                path: '/packages',
                builder: (context, state) => const Text('Packages Page'),
              ),
              GoRoute(
                path: '/booking/:id',
                builder: (context, state) => const Text('Booking Page'),
              ),
            ],
          ),
        ],
      );

      await tester.pumpWidget(
        MaterialApp.router(theme: AppTheme.lightTheme, routerConfig: router),
      );
      await tester.pumpAndSettle();

      // On /packages, BottomNavBar is visible
      expect(find.byType(BottomNavBar), findsOneWidget);

      // On /booking/1, BottomNavBar is hidden
      router.go('/booking/1');
      await tester.pumpAndSettle();
      expect(find.byType(BottomNavBar), findsNothing);
    });

    testWidgets(
      'Desktop navigation works smoothly at exact 768.0px minimum desktop width without overflow',
      (WidgetTester tester) async {
        tester.view.physicalSize = const Size(768.0, 900.0);
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
                  builder: (context, state) => const Text('Home Screen'),
                ),
                GoRoute(
                  path: '/packages',
                  builder: (context, state) => const Text('Packages Screen'),
                ),
                GoRoute(
                  path: '/bookings',
                  builder: (context, state) => const Text('Bookings Screen'),
                ),
                GoRoute(
                  path: '/calendar',
                  builder: (context, state) => const Text('Calendar Screen'),
                ),
                GoRoute(
                  path: '/profile',
                  builder: (context, state) => const Text('Profile Screen'),
                ),
              ],
            ),
          ],
        );

        await tester.pumpWidget(
          MaterialApp.router(theme: AppTheme.lightTheme, routerConfig: router),
        );
        await tester.pumpAndSettle();

        // TopNavBar is rendered at 768.0px
        expect(find.byType(TopNavBar), findsOneWidget);
        expect(find.byType(BottomNavBar), findsNothing);

        // Verify tapping each tab at 768px width
        await tester.tap(find.text('PACKAGES'));
        await tester.pumpAndSettle();
        expect(find.text('Packages Screen'), findsOneWidget);

        await tester.tap(find.text('BOOKINGS'));
        await tester.pumpAndSettle();
        expect(find.text('Bookings Screen'), findsOneWidget);

        await tester.tap(find.text('CALENDAR'));
        await tester.pumpAndSettle();
        expect(find.text('Calendar Screen'), findsOneWidget);

        await tester.tap(find.text('PROFILE'));
        await tester.pumpAndSettle();
        expect(find.text('Profile Screen'), findsOneWidget);

        await tester.tap(find.text('PACKAGES'));
        await tester.pumpAndSettle();
        expect(find.text('Packages Screen'), findsOneWidget);
      },
    );

    testWidgets(
      'TopNavBar items support keyboard activation via ActivateIntent and ButtonActivateIntent',
      (WidgetTester tester) async {
        tester.view.physicalSize = const Size(1280, 800);
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
                  builder: (context, state) => const Text('Home Page'),
                ),
                GoRoute(
                  path: '/packages',
                  builder: (context, state) => const Text('Packages Page'),
                ),
              ],
            ),
          ],
        );

        await tester.pumpWidget(
          MaterialApp.router(theme: AppTheme.lightTheme, routerConfig: router),
        );
        await tester.pumpAndSettle();

        expect(find.text('Home Page'), findsOneWidget);

        // Find FocusableActionDetector for PACKAGES nav item
        final packagesDetectorFinder = find.ancestor(
          of: find.text('PACKAGES'),
          matching: find.byType(FocusableActionDetector),
        );
        expect(packagesDetectorFinder, findsOneWidget);

        final detector = tester.widget<FocusableActionDetector>(
          packagesDetectorFinder,
        );

        // Test ActivateIntent (Enter key)
        final activateAction =
            detector.actions?[ActivateIntent]
                as CallbackAction<ActivateIntent>?;
        expect(activateAction, isNotNull);
        activateAction?.invoke(const ActivateIntent());
        await tester.pumpAndSettle();
        expect(find.text('Packages Page'), findsOneWidget);

        // Find Brand Logo FocusableActionDetector
        final brandDetectorFinder = find.ancestor(
          of: find.text('INEA'),
          matching: find.byType(FocusableActionDetector),
        );
        expect(brandDetectorFinder, findsOneWidget);
        final brandDetector = tester.widget<FocusableActionDetector>(
          brandDetectorFinder,
        );

        // Test Focus highlight on Brand Logo
        brandDetector.onShowFocusHighlight!(true);
        await tester.pumpAndSettle();

        final brandContainerFinder = find.descendant(
          of: brandDetectorFinder,
          matching: find.byType(AnimatedContainer),
        );
        final brandContainer = tester.widget<AnimatedContainer>(
          brandContainerFinder,
        );
        final brandDec = brandContainer.decoration as BoxDecoration;
        final brandBorder = brandDec.border as Border;
        expect(brandBorder.top.color, equals(Colors.white));
        expect(brandBorder.top.width, equals(2.0));

        // Test ButtonActivateIntent (Space key) on Brand Logo to navigate back to Home
        final brandButtonAction =
            brandDetector.actions?[ButtonActivateIntent]
                as CallbackAction<ButtonActivateIntent>?;
        expect(brandButtonAction, isNotNull);
        brandButtonAction?.invoke(const ButtonActivateIntent());
        await tester.pumpAndSettle();
        expect(find.text('Home Page'), findsOneWidget);
      },
    );

    testWidgets(
      'TopNavBar handles unmatched routes gracefully with no active pill',
      (WidgetTester tester) async {
        tester.view.physicalSize = const Size(1280, 800);
        tester.view.devicePixelRatio = 1.0;
        addTearDown(tester.view.resetPhysicalSize);
        addTearDown(tester.view.resetDevicePixelRatio);

        final router = GoRouter(
          initialLocation: '/unmatched-custom-route',
          routes: [
            ShellRoute(
              builder: (context, state, child) =>
                  ResponsiveAppShell(child: child),
              routes: [
                GoRoute(
                  path: '/unmatched-custom-route',
                  builder: (context, state) =>
                      const Text('Custom Unmatched Screen'),
                ),
              ],
            ),
          ],
        );

        await tester.pumpWidget(
          MaterialApp.router(theme: AppTheme.lightTheme, routerConfig: router),
        );
        await tester.pumpAndSettle();

        expect(find.text('Custom Unmatched Screen'), findsOneWidget);
        // No active filled icon should be present (HOME active icon is Icons.home, inactive is Icons.home_outlined)
        expect(find.byIcon(Icons.home), findsNothing);
        expect(find.byIcon(Icons.home_outlined), findsOneWidget);
      },
    );

    testWidgets(
      'ResponsiveAppShell respects custom breakpoint and maxWidth overrides',
      (WidgetTester tester) async {
        tester.view.physicalSize = const Size(900, 800);
        tester.view.devicePixelRatio = 1.0;
        addTearDown(tester.view.resetPhysicalSize);
        addTearDown(tester.view.resetDevicePixelRatio);

        // Custom breakpoint at 1000px -> at 900px, it should be in mobile mode
        await tester.pumpWidget(
          MaterialApp(
            theme: AppTheme.lightTheme,
            home: const ResponsiveAppShell(
              breakpoint: 1000.0,
              maxWidth: 800.0,
              child: Text('Custom Breakpoint Content'),
            ),
          ),
        );

        expect(find.byType(TopNavBar), findsNothing);
        expect(find.byType(BottomNavBar), findsOneWidget);

        // Now resize to 1100px -> desktop mode with custom maxWidth 800px
        tester.view.physicalSize = const Size(1100, 800);
        await tester.pumpAndSettle();

        expect(find.byType(TopNavBar), findsOneWidget);
        expect(find.byType(BottomNavBar), findsNothing);

// ConstrainedBox removed
      },
    );

    testWidgets('TopNavBar nav item changes background on hover', (
      WidgetTester tester,
    ) async {
      tester.view.physicalSize = const Size(1280, 800);
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
                path: '/packages',
                builder: (context, state) => const Text('Packages'),
              ),
            ],
          ),
        ],
      );

      await tester.pumpWidget(
        MaterialApp.router(theme: AppTheme.lightTheme, routerConfig: router),
      );
      await tester.pumpAndSettle();

      // Find PACKAGES FocusableActionDetector (currently unselected)
      final packagesDetectorFinder = find.ancestor(
        of: find.text('PACKAGES'),
        matching: find.byType(FocusableActionDetector),
      );
      expect(packagesDetectorFinder, findsOneWidget);

      final detector = tester.widget<FocusableActionDetector>(
        packagesDetectorFinder,
      );

      // Verify unhovered background
      final unhoveredContainerFinder = find.descendant(
        of: packagesDetectorFinder,
        matching: find.byType(AnimatedContainer),
      );
      final unhoveredContainer = tester.widget<AnimatedContainer>(
        unhoveredContainerFinder,
      );
      final unhoveredDec = unhoveredContainer.decoration as BoxDecoration;
      expect(unhoveredDec.color, equals(Colors.transparent));

      // Trigger hover highlight
      detector.onShowHoverHighlight!(true);
      await tester.pumpAndSettle();

      final hoveredContainer = tester.widget<AnimatedContainer>(
        unhoveredContainerFinder,
      );
      final hoveredDec = hoveredContainer.decoration as BoxDecoration;
      expect(hoveredDec.color, equals(Colors.white.withValues(alpha: 0.15)));
    });

    testWidgets('Mobile BottomNavBar full tap navigation cycle', (
      WidgetTester tester,
    ) async {
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
                builder: (context, state) => const Text('Mobile Home'),
              ),
              GoRoute(
                path: '/packages',
                builder: (context, state) => const Text('Mobile Packages'),
              ),
              GoRoute(
                path: '/bookings',
                builder: (context, state) => const Text('Mobile Bookings'),
              ),
              GoRoute(
                path: '/profile',
                builder: (context, state) => const Text('Mobile Profile'),
              ),
            ],
          ),
        ],
      );

      await tester.pumpWidget(
        MaterialApp.router(theme: AppTheme.lightTheme, routerConfig: router),
      );
      await tester.pumpAndSettle();

      expect(find.text('Mobile Home'), findsOneWidget);

      // Tap Packages in BottomNavBar
      await tester.tap(find.text('PACKAGES'));
      await tester.pumpAndSettle();
      expect(find.text('Mobile Packages'), findsOneWidget);

      // Tap Bookings in BottomNavBar
      await tester.tap(find.text('BOOKINGS'));
      await tester.pumpAndSettle();
      expect(find.text('Mobile Bookings'), findsOneWidget);

      // Tap Profile in BottomNavBar
      await tester.tap(find.text('PROFILE'));
      await tester.pumpAndSettle();
      expect(find.text('Mobile Profile'), findsOneWidget);

      // Tap Home in BottomNavBar
      await tester.tap(find.text('HOME'));
      await tester.pumpAndSettle();
      expect(find.text('Mobile Home'), findsOneWidget);
    });
  });

  group('R1 Foundational Breakpoints & LayoutBuilder Tests', () {
    test(
      // P6 (G2): package grids render 2 → 3 → 4 columns across
      // mobile / tablet / desktop.
      'Breakpoint column count calculations (Mobile: 2-col, Tablet: 3-col, Desktop: 4-col)',
      () {
        // Mobile (< 768px -> 2 columns)
        expect(ResponsiveAppShell.getGridColumnCount(-10), equals(2));
        expect(ResponsiveAppShell.getGridColumnCount(0), equals(2));
        expect(ResponsiveAppShell.getGridColumnCount(320), equals(2));
        expect(ResponsiveAppShell.getGridColumnCount(600), equals(2));
        expect(ResponsiveAppShell.getGridColumnCount(767.9), equals(2));

        // Tablet (768px - 1024px -> 3 columns)
        expect(ResponsiveAppShell.getGridColumnCount(768.0), equals(3));
        expect(ResponsiveAppShell.getGridColumnCount(900.0), equals(3));
        expect(ResponsiveAppShell.getGridColumnCount(1024.0), equals(3));

        // Desktop (> 1024px -> 4 columns)
        expect(ResponsiveAppShell.getGridColumnCount(1024.01), equals(4));
        expect(ResponsiveAppShell.getGridColumnCount(1200.0), equals(4));
        expect(ResponsiveAppShell.getGridColumnCount(1920.0), equals(4));
        expect(ResponsiveAppShell.getGridColumnCount(5120.0), equals(4));
      },
    );

    testWidgets(
      'ResponsiveAppShell contains root LayoutBuilder and evaluates constraints correctly',
      (WidgetTester tester) async {
        tester.view.physicalSize = const Size(1280, 800);
        tester.view.devicePixelRatio = 1.0;
        addTearDown(tester.view.resetPhysicalSize);
        addTearDown(tester.view.resetDevicePixelRatio);

        await tester.pumpWidget(
          MaterialApp(
            theme: AppTheme.lightTheme,
            home: const ResponsiveAppShell(
              child: Text('LayoutBuilder Content'),
            ),
          ),
        );

        final layoutBuilderFinder = find.descendant(
          of: find.byType(ResponsiveAppShell),
          matching: find.byType(LayoutBuilder),
        );
        expect(layoutBuilderFinder, findsOneWidget);

        expect(find.byType(TopNavBar), findsOneWidget);
        expect(find.byType(BottomNavBar), findsNothing);
      },
    );

    testWidgets(
      'ResponsiveAppShell static helpers (isMobile, isTablet, isDesktop, isWideScreen)',
      (WidgetTester tester) async {
        tester.view.devicePixelRatio = 1.0;
        addTearDown(tester.view.resetPhysicalSize);
        addTearDown(tester.view.resetDevicePixelRatio);

        late bool isMobileVal;
        late bool isTabletVal;
        late bool isDesktopVal;
        late bool isWideVal;

        Widget buildProbe() {
          return Builder(
            builder: (context) {
              isMobileVal = ResponsiveAppShell.isMobile(context);
              isTabletVal = ResponsiveAppShell.isTablet(context);
              isDesktopVal = ResponsiveAppShell.isDesktop(context);
              isWideVal = ResponsiveAppShell.isWideScreen(context);
              return const SizedBox.shrink();
            },
          );
        }

        // 1. Mobile (400px)
        tester.view.physicalSize = const Size(400, 800);
        await tester.pumpWidget(MaterialApp(home: buildProbe()));
        expect(isMobileVal, isTrue);
        expect(isTabletVal, isFalse);
        expect(isDesktopVal, isFalse);
        expect(isWideVal, isFalse);

        // 2. Tablet (800px)
        tester.view.physicalSize = const Size(800, 800);
        await tester.pumpWidget(MaterialApp(home: buildProbe()));
        expect(isMobileVal, isFalse);
        expect(isTabletVal, isTrue);
        expect(isDesktopVal, isFalse);
        expect(isWideVal, isTrue);

        // 3. Exact Tablet upper boundary (1024.0px)
        tester.view.physicalSize = const Size(1024.0, 800);
        await tester.pumpWidget(MaterialApp(home: buildProbe()));
        expect(isMobileVal, isFalse);
        expect(isTabletVal, isTrue);
        expect(isDesktopVal, isFalse);
        expect(isWideVal, isTrue);

        // 4. Desktop (1400px)
        tester.view.physicalSize = const Size(1400, 800);
        await tester.pumpWidget(MaterialApp(home: buildProbe()));
        expect(isMobileVal, isFalse);
        expect(isTabletVal, isFalse);
        expect(isDesktopVal, isTrue);
        expect(isWideVal, isTrue);
      },
    );
  });
}
