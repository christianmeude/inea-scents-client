import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:inea_scents_client/config/theme.dart';
import 'package:inea_scents_client/providers/index.dart';
import 'package:inea_scents_client/screens/login_screen.dart';
import 'package:inea_scents_client/screens/profile_screen.dart';
import 'package:inea_scents_client/screens/register_screen.dart';
import 'package:inea_scents_client/src/providers/core_providers.dart';
import 'package:inea_scents_client/widgets/index.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'helpers/fake_api.dart';

/// C23: native-feel mobile shell — login button states, Profile-only theme
/// toggle, and stateful tabs that keep per-tab stacks.
void main() {
  setUpAll(() {
    GoogleFonts.config.allowRuntimeFetching = false;
  });

  ProviderScope c23Scope({required Widget child}) => ProviderScope(
    overrides: [
      apiClientProvider.overrideWithValue(buildFakeRestClient(FakeApiBackend())),
    ],
    child: MaterialApp(theme: AppTheme.lightTheme, home: child),
  );

  group('c23 login primary keeps plum + 20px loading', () {
    testWidgets('LOG IN: 44px, plum disabled fill, centered text', (
      WidgetTester tester,
    ) async {
      tester.view.physicalSize = const Size(360, 800);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);

      await tester.pumpWidget(c23Scope(child: const LoginScreen()));
      await tester.pumpAndSettle();

      expect(find.text('LOG IN'), findsOneWidget);
      final button = tester.widget<ElevatedButton>(
        find.widgetWithText(ElevatedButton, 'LOG IN'),
      );
      const plum = Color(0xFF6A4053);
      final style = button.style!;
      expect(style.backgroundColor!.resolve({}), plum);
      // C23: loading keeps the plum fill, never the grey disabled wash.
      expect(style.backgroundColor!.resolve({WidgetState.disabled}), plum);
      expect(
        style.foregroundColor!.resolve({WidgetState.disabled}),
        // C31: cream label token on plum (was white; same AA legibility).
        AppTheme.onPrimaryButton,
      );
      // 44px touch target inside the 44–48px band.
      final sized = tester.widget<SizedBox>(
        find.ancestor(
          of: find.widgetWithText(ElevatedButton, 'LOG IN'),
          matching: find.byType(SizedBox),
        ),
      );
      expect(sized.height, 44);
      // Centered, never clipped at 360px.
      expect(
        find.ancestor(
          of: find.text('LOG IN'),
          matching: find.byType(FittedBox),
        ),
        findsOneWidget,
      );
      expect(tester.takeException(), isNull);
    });

    testWidgets('LOG IN loading shows a 20px cream spinner on plum', (
      WidgetTester tester,
    ) async {
      tester.view.physicalSize = const Size(360, 800);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);

      await tester.pumpWidget(c23Scope(child: const LoginScreen()));
      await tester.pumpAndSettle();

      await tester.enterText(find.byType(CustomTextField).first, 'a@b.co');
      await tester.enterText(find.byType(CustomTextField).last, 'secret123');
      await tester.tap(find.widgetWithText(ElevatedButton, 'LOG IN'));
      await tester.pump();

      final spinner = find.byType(CircularProgressIndicator);
      expect(spinner, findsOneWidget);
      expect(
        tester.widget<CircularProgressIndicator>(spinner).strokeWidth,
        2.5,
      );
      // 20px box, not the old squished 16px.
      expect(tester.getSize(spinner), const Size(20, 20));

      await tester.pumpAndSettle();
      expect(tester.takeException(), isNull);
    });

    testWidgets('REGISTER primary has the same plum loading treatment', (
      WidgetTester tester,
    ) async {
      tester.view.physicalSize = const Size(360, 800);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);

      await tester.pumpWidget(c23Scope(child: const RegisterScreen()));
      await tester.pumpAndSettle();

      final button = tester.widget<ElevatedButton>(
        find.widgetWithText(ElevatedButton, 'REGISTER'),
      );
      const plum = Color(0xFF6A4053);
      expect(
        button.style!.backgroundColor!.resolve({WidgetState.disabled}),
        plum,
      );
      expect(
        find.ancestor(
          of: find.text('REGISTER'),
          matching: find.byType(FittedBox),
        ),
        findsOneWidget,
      );
      expect(tester.takeException(), isNull);
    });
  });

  group('c23 Profile-only theme toggle persists', () {
    testWidgets('Dark theme tile flips provider + persists, no overflow', (
      WidgetTester tester,
    ) async {
      SharedPreferences.setMockInitialValues({});
      tester.view.physicalSize = const Size(360, 800);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);

      await tester.pumpWidget(c23Scope(child: const ProfileScreen()));
      await tester.pumpAndSettle();

      // Single toggle, Profile-only surface.
      expect(find.text('Dark theme'), findsOneWidget);
      expect(find.byType(Switch), findsOneWidget);

      await tester.tap(find.byType(Switch));
      await tester.pumpAndSettle();

      final container = ProviderScope.containerOf(
        tester.element(find.byType(ProfileScreen)),
      );
      expect(container.read(themeModeProvider), ThemeMode.dark);
      final prefs = await SharedPreferences.getInstance();
      expect(prefs.getString('inea-theme'), 'dark');

      // C9 still holds: no page scroll, muted footer logo intact.
      // C29: scaffold form fields own horizontal editables — vertical only.
      expect(find.byType(SingleChildScrollView), findsNothing);
      expect(
        find.byWidgetPredicate(
          (w) => w is Scrollable && w.axis == Axis.vertical,
        ),
        findsNothing,
      );
      expect(find.byType(AppLogo), findsOneWidget);
      expect(tester.takeException(), isNull);
    });
  });

  group('c23 stateful tabs keep per-tab stacks', () {
    testWidgets('switching tabs preserves typed state, no reset', (
      WidgetTester tester,
    ) async {
      tester.view.physicalSize = const Size(375, 667);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);

      final router = GoRouter(
        initialLocation: '/tab-a',
        routes: [
          StatefulShellRoute.indexedStack(
            builder: (context, state, shell) => ResponsiveAppShell(
              navigationShell: shell,
              child: const SizedBox.shrink(),
            ),
            branches: [
              StatefulShellBranch(
                routes: [
                  GoRoute(
                    path: '/tab-a',
                    builder: (context, state) => const _StatefulTab(),
                  ),
                ],
              ),
              StatefulShellBranch(
                routes: [
                  GoRoute(
                    path: '/tab-b',
                    builder: (context, state) => const Text('Tab B'),
                  ),
                ],
              ),
              StatefulShellBranch(
                routes: [
                  GoRoute(
                    path: '/tab-c',
                    builder: (context, state) => const Text('Tab C'),
                  ),
                ],
              ),
              StatefulShellBranch(
                routes: [
                  GoRoute(
                    path: '/tab-d',
                    builder: (context, state) => const Text('Tab D'),
                  ),
                ],
              ),
              StatefulShellBranch(
                routes: [
                  GoRoute(
                    path: '/tab-e',
                    builder: (context, state) => const Text('Tab E'),
                  ),
                ],
              ),
            ],
          ),
        ],
      );
      addTearDown(router.dispose);

      await tester.pumpWidget(
        MaterialApp.router(theme: AppTheme.lightTheme, routerConfig: router),
      );
      await tester.pumpAndSettle();

      // Bottom bar drives the shell; safe-area keeps it off the chin.
      expect(find.byType(BottomNavBar), findsOneWidget);
      expect(
        find.descendant(
          of: find.byType(BottomNavBar),
          matching: find.byType(SafeArea),
        ),
        findsOneWidget,
      );

      await tester.enterText(find.byType(TextField), 'keep me');
      await tester.pumpAndSettle();

      await tester.tap(find.text('PACKAGES'));
      await tester.pumpAndSettle();
      expect(find.text('Tab B'), findsOneWidget);

      await tester.tap(find.text('HOME'));
      await tester.pumpAndSettle();
      // Tab A's stack (and typed text) survived the round trip.
      expect(find.widgetWithText(TextField, 'keep me'), findsOneWidget);
      expect(tester.takeException(), isNull);
    });
  });
}

class _StatefulTab extends StatefulWidget {
  const _StatefulTab();

  @override
  State<_StatefulTab> createState() => _StatefulTabState();
}

class _StatefulTabState extends State<_StatefulTab> {
  final controller = TextEditingController();

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => TextField(controller: controller);
}
