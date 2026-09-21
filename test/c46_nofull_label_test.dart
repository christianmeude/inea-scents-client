import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:inea_scents_client/config/theme.dart';
import 'package:inea_scents_client/src/providers/core_providers.dart';
import 'package:inea_scents_client/widgets/index.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'helpers/fake_api.dart';

// C46: disabled/booked dates render without a `Full` label and stay legible
// (body-color + strike, >=4.5 vs grid surface both modes).
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

/// Effective grid surface per mode: chipBg at 50% over the card fill.
Color _gridSurface(bool isDark) {
  if (isDark) {
    return _over(
      CardSurfaces.nightBorder.withValues(alpha: 0.5),
      CardSurfaces.nightSurface,
    );
  }
  return _over(
    CardSurfaces.cream.withValues(alpha: 0.5),
    Colors.white,
  );
}

DateTime _targetMonth() {
  final now = DateTime.now();
  return DateTime(now.year, now.month + 1, 1);
}

void main() {
  group('c46 disabled-date ratios (UI bar 4.5)', () {
    test('body vs grid surface hits UI bar both modes', () {
      const bodyLight = Color(0xFF765867);
      const bodyDark = Color(0xFFC4ACAC);
      expect(_ratio(bodyLight, _gridSurface(false)), greaterThanOrEqualTo(4.5));
      expect(_ratio(bodyDark, _gridSurface(true)), greaterThanOrEqualTo(4.5));
    });
  });

  for (final theme in [AppTheme.lightTheme, AppTheme.darkTheme]) {
    final mode = theme.brightness == Brightness.dark ? 'dark' : 'light';
    testWidgets('c46 no Full label, disabled day still legible ($mode)', (
      tester,
    ) async {
      SharedPreferences.setMockInitialValues({'first_launch': false});
      final month = _targetMonth();
      final backend = FakeApiBackend()
        ..bookedDate = DateTime(month.year, month.month, 10);
      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            apiClientProvider.overrideWithValue(
              buildFakeRestClient(backend),
            ),
          ],
          child: MaterialApp(
            theme: theme,
            home: Scaffold(
              body: SingleChildScrollView(
                child: IneaCalendar(
                  selectedDate: DateTime(month.year, month.month, 11),
                  onDateSelected: (_) {},
                ),
              ),
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();

      // Booked/disabled cells never carry the `Full` caption.
      expect(find.text('Full', findRichText: true), findsNothing);

      // The booked day number is still rendered (disabled but legible).
      final disabledCells = find.byWidgetPredicate(
        (w) =>
            w is Text &&
            w.data == '10' &&
            w.style?.decoration == TextDecoration.lineThrough,
      );
      expect(disabledCells, findsOneWidget);

      // Disabled day text resolves to body color at >=4.5 vs the grid.
      final disabled = tester.widget<Text>(disabledCells);
      final ctx = tester.element(disabledCells);
      expect(disabled.style?.color, equals(CardSurfaces.body(ctx)));
      expect(
        _ratio(disabled.style!.color!, _gridSurface(mode == 'dark')),
        greaterThanOrEqualTo(4.5),
      );
      expect(tester.takeException(), isNull);
    });
  }
}
