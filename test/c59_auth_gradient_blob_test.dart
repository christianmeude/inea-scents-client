import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:inea_scents_client/config/theme.dart';
import 'package:inea_scents_client/screens/forgot_password_screen.dart';
import 'package:inea_scents_client/screens/login_screen.dart';
import 'package:inea_scents_client/screens/register_screen.dart';
import 'package:inea_scents_client/src/providers/core_providers.dart';
import 'package:inea_scents_client/widgets/auth_background.dart';

import 'helpers/fake_api.dart';

/// C59: auth light-mode gradient (NEW variant, not the pre-C45 restore) +
/// mobile blob reposition.
///
/// Budgets (C32-C36 precedent): light text/UI pairs hold >= 5.7 on every
/// gradient stop even under worst-case full blob coverage; button token and
/// dark mesh stay AAA (>= 7). Blob geometry scales down below 640px so no
/// mobile-width render overflows.
double _lum(Color c) {
  double f(int ch) {
    final v = ch / 255.0;
    return v <= 0.03928 ? v / 12.92 : math.pow((v + 0.055) / 1.055, 2.4).toDouble();
  }

  final r = (c.r * 255.0).round().clamp(0, 255);
  final g = (c.g * 255.0).round().clamp(0, 255);
  final b = (c.b * 255.0).round().clamp(0, 255);
  return 0.2126 * f(r) + 0.7152 * f(g) + 0.0722 * f(b);
}

double _ratio(Color a, Color b) {
  final l1 = _lum(a);
  final l2 = _lum(b);
  final hi = l1 > l2 ? l1 : l2;
  final lo = l1 > l2 ? l2 : l1;
  return (hi + 0.05) / (lo + 0.05);
}

/// Alpha-composite [fg] over opaque [bg].
Color _over(Color fg, Color bg) {
  final a = fg.a;
  int ch(double f, double b) =>
      ((f * a + b * (1 - a)) * 255).round().clamp(0, 255);
  return Color.fromARGB(
    255,
    ch(fg.r, bg.r),
    ch(fg.g, bg.g),
    ch(fg.b, bg.b),
  );
}

const _plum = Color(0xFF6A4053);

void main() {
  setUpAll(() {
    GoogleFonts.config.allowRuntimeFetching = false;
  });

  group('c59 light gradient contrast (WCAG math)', () {
    test('plum copy holds >= 5.7 on every bare gradient stop', () {
      for (final stop in AuthBackground.lightStops) {
        expect(
          _ratio(_plum, stop),
          greaterThanOrEqualTo(5.7),
          reason: 'stop $stop falls below light text budget',
        );
      }
    });

    test('plum copy holds >= 5.7 under full blob coverage on deepest stop', () {
      final deepest = AuthBackground.lightStops.last;
      for (final blob in AuthBackground.lightBlobs) {
        final surface = _over(blob, deepest);
        expect(
          _ratio(_plum, surface),
          greaterThanOrEqualTo(5.7),
          reason: 'blob $blob over $deepest falls below budget',
        );
        expect(
          _ratio(_plum, surface),
          greaterThanOrEqualTo(4.5),
          reason: 'blob $blob over $deepest fails UI 4.5:1',
        );
      }
    });

    test('button token + dark mesh untouched (AAA >= 7)', () {
      expect(
        _ratio(
          AppTheme.primaryButtonBackground,
          AppTheme.onPrimaryButton,
        ),
        greaterThanOrEqualTo(7.0),
      );
      expect(
        _ratio(const Color(0xFFFDF4F5), AuthBackground.darkBase),
        greaterThanOrEqualTo(7.0),
      );
    });
  });

  group('c59 blob scale seam', () {
    test('360px shrinks blobs, 768/1280 stay full-size', () {
      expect(AuthBackground.blobScaleForWidth(360), lessThan(1.0));
      expect(AuthBackground.blobScaleForWidth(360), greaterThanOrEqualTo(0.5));
      expect(AuthBackground.blobScaleForWidth(768), equals(1.0));
      expect(AuthBackground.blobScaleForWidth(1280), equals(1.0));
    });
  });

  group('c59 auth screens no overflow @360px + @1280px', () {
    ProviderScope scope({required ThemeData theme, required Widget child}) =>
        ProviderScope(
          overrides: [
            apiClientProvider.overrideWithValue(
              buildFakeRestClient(FakeApiBackend()),
            ),
          ],
          child: MaterialApp(theme: theme, home: child),
        );

    const screens = <String, Widget>{
      'login': LoginScreen(),
      'register': RegisterScreen(),
      'forgot': ForgotPasswordScreen(),
    };
    const copy = <String, String>{
      'login': 'LOG IN',
      'register': 'REGISTER',
      'forgot': 'EMAIL PASSWORD RESET LINK',
    };

    for (final width in [360.0, 1280.0]) {
      for (final theme in [AppTheme.lightTheme, AppTheme.darkTheme]) {
        final mode = theme.brightness == Brightness.dark ? 'dark' : 'light';
        for (final entry in screens.entries) {
          testWidgets(
            '${entry.key} $mode renders copy @${width.toInt()}px, no overflow',
            (WidgetTester tester) async {
              tester.view.physicalSize = Size(width, 800);
              tester.view.devicePixelRatio = 1.0;
              addTearDown(tester.view.resetPhysicalSize);
              addTearDown(tester.view.resetDevicePixelRatio);

              await tester.pumpWidget(
                scope(theme: theme, child: entry.value),
              );
              await tester.pumpAndSettle();

              expect(find.text(copy[entry.key]!), findsOneWidget);
              expect(tester.takeException(), isNull);
            },
          );
        }
      }
    }

    testWidgets('light mode paints the C59 gradient backdrop', (
      WidgetTester tester,
    ) async {
      tester.view.physicalSize = const Size(360, 800);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);

      await tester.pumpWidget(
        scope(theme: AppTheme.lightTheme, child: const LoginScreen()),
      );
      await tester.pumpAndSettle();

      final containers = tester
          .widgetList<AnimatedContainer>(find.byType(AnimatedContainer))
          .where((c) {
            final d = c.decoration;
            return d is BoxDecoration && d.gradient is LinearGradient;
          });
      expect(containers, isNotEmpty);
      expect(tester.takeException(), isNull);
    });
  });

  group('c59 narrow inward bounds + dark geometry freeze', () {
    testWidgets('light narrow anchors stay within [0,1]-ish bounds (no outward spill)',
        (WidgetTester tester) async {
      tester.view.physicalSize = const Size(360, 800);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);

      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: AuthBackground(isDark: false, child: SizedBox()),
          ),
        ),
      );
      await tester.pumpAndSettle();

      const sw = 360.0;
      final blobs = tester
          .widgetList<Positioned>(find.byType(Positioned))
          .where((p) => (p.left == null) != (p.right == null))
          .toList();
      expect(blobs, hasLength(8));
      for (final p in blobs) {
        if (p.left != null) {
          // [0,1]-ish: allow the pre-existing slight off-screen anchor
          // (-0.05) but never an outward spill like -0.15/-0.10.
          expect(p.left!, greaterThanOrEqualTo(-0.05 * sw - 1.0),
              reason: 'left $p spills outward past the viewport edge');
          expect(p.left!, lessThanOrEqualTo(sw));
        }
        if (p.right != null) {
          expect(p.right!, greaterThanOrEqualTo(-0.05 * sw - 1.0),
              reason: 'right $p spills outward past the viewport edge');
          expect(p.right!, lessThanOrEqualTo(sw));
        }
      }
      // The two C59 narrowRight overrides must be genuinely inward
      // (non-negative, never past the right edge).
      final rights =
          blobs.where((p) => p.right != null).map((p) => p.right!).toList();
      expect(rights.where((r) => r < 0).length, lessThanOrEqualTo(1),
          reason: 'only the untouched -0.05 anchor may sit off-screen');
      expect(tester.takeException(), isNull);
    });

    testWidgets('dark layout at 360px equals pre-C59 desktop geometry',
        (WidgetTester tester) async {
      tester.view.physicalSize = const Size(360, 800);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);

      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: AuthBackground(isDark: true, child: SizedBox()),
          ),
        ),
      );
      await tester.pumpAndSettle();

      const sw = 360.0;
      const sh = 800.0;
      // Pre-C59 desktop geometry: base fracs at full scale.
      const expectedTops = [-0.10, 0.10, 0.30, 0.65, -0.15, 0.20, 0.50, 0.75];
      const expectedLefts = [-0.05, 0.05, -0.10, -0.05];
      const expectedRights = [0.05, 0.20, -0.05, 0.05];
      const expectedSizes = [
        Size(300, 600),
        Size(600, 300),
        Size(800, 250),
        Size(500, 400),
        Size(800, 600),
        Size(500, 400),
        Size(300, 500),
        Size(600, 250),
      ];

      final blobs = tester
          .widgetList<Positioned>(find.byType(Positioned))
          .where((p) => (p.left == null) != (p.right == null))
          .toList();
      expect(blobs, hasLength(8));
      for (var i = 0; i < 8; i++) {
        expect(blobs[i].top, closeTo(sh * expectedTops[i], 1.0));
        if (i < 4) {
          expect(blobs[i].left, closeTo(sw * expectedLefts[i], 1.0));
        } else {
          expect(blobs[i].right,
              closeTo(sw * expectedRights[i - 4], 1.0));
        }
      }

      final blobFinder = find.byWidgetPredicate(
        (w) =>
            w is AnimatedContainer &&
            w.decoration is BoxDecoration &&
            (w.decoration as BoxDecoration).borderRadius != null,
      );
      expect(blobFinder, findsNWidgets(8));
      for (var i = 0; i < 8; i++) {
        // Full scale in dark mode: no blobScaleForWidth shrink at 360px
        // (360/768 would be ~0.5 if applied).
        final size = tester.getSize(blobFinder.at(i));
        expect(size.width, closeTo(expectedSizes[i].width, 1.0));
        expect(size.height, closeTo(expectedSizes[i].height, 1.0));
      }
      expect(tester.takeException(), isNull);
    });
  });
}
