import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:inea_scents_client/config/theme.dart';
import 'package:inea_scents_client/widgets/bottom_nav_bar.dart';

/// C34: unselected BottomNavBar tabs are non-text UI -> strict >=4.5:1
/// against the bar surface in BOTH modes.
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
  double ch(double f, double b) => f * a + b * (1 - a);
  return Color.fromRGBO(
    (ch(fg.r, bg.r) * 255).round().clamp(0, 255),
    (ch(fg.g, bg.g) * 255).round().clamp(0, 255),
    (ch(fg.b, bg.b) * 255).round().clamp(0, 255),
    1.0,
  );
}

/// Effective (opaque) bar surface per mode, matching bottom_nav_bar.dart:
/// translucent navBg composited over the scaffold background.
Color _barSurface(bool isDark) {
  if (isDark) {
    return _over(
      AppTheme.night.withValues(alpha: 0.88),
      AppTheme.night,
    );
  }
  return _over(
    AppTheme.secondary.withValues(alpha: 0.85),
    AppTheme.neutralBg,
  );
}

Future<BottomNavigationBar> _pumpBar(
  WidgetTester tester,
  ThemeData theme,
) async {
  tester.view.physicalSize = const Size(360, 800);
  tester.view.devicePixelRatio = 1.0;
  addTearDown(tester.view.resetPhysicalSize);
  addTearDown(tester.view.resetDevicePixelRatio);
  await tester.pumpWidget(
    MaterialApp(theme: theme, home: const Scaffold(body: BottomNavBar())),
  );
  await tester.pumpAndSettle();
  return tester.widget<BottomNavigationBar>(find.byType(BottomNavigationBar));
}

void main() {
  group('c34 bottom-nav unselected contrast (AAA non-text >=4.5)', () {
    testWidgets('light: night unselected vs bar surface', (tester) async {
      final bar = await _pumpBar(tester, AppTheme.lightTheme);
      expect(bar.unselectedItemColor, equals(AppTheme.night));
      final surface = _barSurface(false);
      final rendered = _over(bar.unselectedItemColor!, surface);
      expect(_ratio(rendered, surface), greaterThanOrEqualTo(4.5));
      expect(tester.takeException(), isNull);
    });

    testWidgets('dark: white/0.85 unselected vs bar surface', (tester) async {
      final bar = await _pumpBar(tester, AppTheme.darkTheme);
      expect(
        bar.unselectedItemColor,
        equals(Colors.white.withValues(alpha: 0.85)),
      );
      final surface = _barSurface(true);
      final rendered = _over(bar.unselectedItemColor!, surface);
      expect(_ratio(rendered, surface), greaterThanOrEqualTo(4.5));
      expect(tester.takeException(), isNull);
    });
  });
}
