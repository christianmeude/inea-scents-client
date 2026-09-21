import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:inea_scents_client/config/theme.dart';
import 'package:inea_scents_client/screens/profile_screen.dart';
import 'package:inea_scents_client/src/providers/core_providers.dart';
import 'package:inea_scents_client/widgets/index.dart';

import 'helpers/fake_api.dart';

/// C32: destructive profile tile (Logout) stays legible in both modes —
/// tile text/icons are UI components so they need >= 4.5:1 against the
/// tile surface at 360px. Pumps light + dark, reads the resolved Logout
/// colors, and asserts the WCAG ratio from the Color values.
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

Future<void> _pumpProfile(WidgetTester tester, ThemeData theme) async {
  tester.view.physicalSize = const Size(360, 800);
  tester.view.devicePixelRatio = 1.0;
  addTearDown(tester.view.resetPhysicalSize);
  addTearDown(tester.view.resetDevicePixelRatio);

  await tester.pumpWidget(
    ProviderScope(
      overrides: [
        apiClientProvider.overrideWithValue(
          buildFakeRestClient(FakeApiBackend()),
        ),
      ],
      child: MaterialApp(theme: theme, home: const ProfileScreen()),
    ),
  );
  await tester.pumpAndSettle();
}

void main() {
  setUpAll(() {
    GoogleFonts.config.allowRuntimeFetching = false;
  });

  group('c32 destructive tile contrast', () {
    testWidgets('light: Logout title+icon errorOnLight vs white >= 7 @ 360px',
        (WidgetTester tester) async {
      await _pumpProfile(tester, AppTheme.lightTheme);

      expect(find.text('Logout'), findsOneWidget);
      final title = tester.widget<Text>(find.text('Logout'));
      // C36: darker plum token (was 0xFF9A4F5D at 5.75; text bar is 7:1).
      final expected = AppTheme.errorOnLight;
      expect(title.style?.color, equals(expected));

      final icon = tester.widget<Icon>(find.byIcon(Icons.logout_rounded));
      expect(icon.color, equals(expected));

      final ctx = tester.element(find.byType(ProfileScreen));
      final surface = CardSurfaces.cardBg(ctx);
      expect(surface, equals(Colors.white));
      // C36: destructive text meets the 7:1 text bar.
      expect(_ratio(expected, surface), greaterThanOrEqualTo(7.0));
      expect(tester.takeException(), isNull);
    });

    testWidgets('dark: Logout title+icon 0xFFF0A6B0 vs night >= 4.5 @ 360px',
        (WidgetTester tester) async {
      await _pumpProfile(tester, AppTheme.darkTheme);

      expect(find.text('Logout'), findsOneWidget);
      final title = tester.widget<Text>(find.text('Logout'));
      const expected = Color(0xFFF0A6B0);
      expect(title.style?.color, equals(expected));

      final icon = tester.widget<Icon>(find.byIcon(Icons.logout_rounded));
      expect(icon.color, equals(expected));

      final ctx = tester.element(find.byType(ProfileScreen));
      final surface = CardSurfaces.cardBg(ctx);
      expect(surface, equals(const Color(0xFF1C1618)));
      expect(_ratio(expected, surface), greaterThanOrEqualTo(4.5));
      expect(tester.takeException(), isNull);
    });
  });
}
