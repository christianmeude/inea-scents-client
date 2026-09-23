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
}
