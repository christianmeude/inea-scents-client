import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:inea_scents_client/config/theme.dart';
import 'package:inea_scents_client/widgets/index.dart';

/// C31: plum-fill + cream-text token pinned in both modes. Pumps light +
/// dark at 360/768/1280 widths and asserts the resolved button-label
/// colors stay legible (WCAG AA) with no dark-on-dark text.
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

void main() {
  group('c31 primary-button token', () {
    test('token resolves to plum fill with cream text', () {
      expect(AppTheme.primaryButtonBackground, equals(const Color(0xFF6A4053)));
      expect(AppTheme.onPrimaryButton, equals(const Color(0xFFFDF4F5)));
      expect(
        _ratio(
          AppTheme.primaryButtonBackground,
          AppTheme.onPrimaryButton,
        ),
        greaterThanOrEqualTo(4.5),
      );
    });

    test('CardSurfaces re-exports the same single source', () {
      expect(
        CardSurfaces.primaryButtonBackground,
        equals(AppTheme.primaryButtonBackground),
      );
      expect(CardSurfaces.onPrimaryButton, equals(AppTheme.onPrimaryButton));
      expect(CardSurfaces.plum, equals(AppTheme.primaryButtonBackground));
      expect(CardSurfaces.cream, equals(AppTheme.onPrimaryButton));
    });

    for (final theme in [AppTheme.lightTheme, AppTheme.darkTheme]) {
      final mode = theme.brightness == Brightness.dark ? 'dark' : 'light';
      test('ElevatedButton $mode resolves plum bg + cream fg', () {
        final style = theme.elevatedButtonTheme.style;
        expect(style, isNotNull);
        expect(
          style!.backgroundColor?.resolve({}),
          equals(AppTheme.primaryButtonBackground),
        );
        expect(
          style.foregroundColor?.resolve({}),
          equals(AppTheme.onPrimaryButton),
        );
      });

      test('FilledButton $mode resolves plum bg + cream fg', () {
        final style = theme.filledButtonTheme.style;
        expect(style, isNotNull);
        expect(
          style!.backgroundColor?.resolve({}),
          equals(AppTheme.primaryButtonBackground),
        );
        expect(
          style.foregroundColor?.resolve({}),
          equals(AppTheme.onPrimaryButton),
        );
      });
    }
  });

  group('c31 button labels at 360/768/1200', () {
    for (final width in [360.0, 768.0, 1200.0]) {
      for (final theme in [AppTheme.lightTheme, AppTheme.darkTheme]) {
        final mode = theme.brightness == Brightness.dark ? 'dark' : 'light';
        testWidgets('Elevated+Filled CTA legible $mode @ ${width.toInt()}px', (
          WidgetTester tester,
        ) async {
          tester.view.physicalSize = Size(width, 800);
          tester.view.devicePixelRatio = 1.0;
          addTearDown(tester.view.resetPhysicalSize);
          addTearDown(tester.view.resetDevicePixelRatio);

          await tester.pumpWidget(
            MaterialApp(
              theme: theme,
              home: Scaffold(
                body: Center(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      ElevatedButton(
                        onPressed: () {},
                        child: const Text('Confirm & Pay'),
                      ),
                      FilledButton(
                        onPressed: () {},
                        child: const Text('Check date'),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
          await tester.pumpAndSettle();

          expect(find.text('Confirm & Pay'), findsOneWidget);
          expect(find.text('Check date'), findsOneWidget);

          final elevatedStyle = theme.elevatedButtonTheme.style!;
          final filledStyle = theme.filledButtonTheme.style!;
          for (final style in [elevatedStyle, filledStyle]) {
            final bg = style.backgroundColor!.resolve({})!;
            final fg = style.foregroundColor!.resolve({})!;
            expect(bg, equals(AppTheme.primaryButtonBackground));
            expect(fg, equals(AppTheme.onPrimaryButton));
            expect(_ratio(bg, fg), greaterThanOrEqualTo(4.5));
          }
          expect(tester.takeException(), isNull);
        });
      }
    }

    testWidgets('NextStepCard CTA carries the token in dark mode', (
      WidgetTester tester,
    ) async {
      tester.view.physicalSize = const Size(360, 800);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);

      await tester.pumpWidget(
        MaterialApp(
          theme: AppTheme.darkTheme,
          home: const Scaffold(body: NextStepCard()),
        ),
      );
      await tester.pumpAndSettle();

      final cta = tester.widget<FilledButton>(
        find.byKey(const Key('home_check_date_cta')),
      );
      final bg = cta.style?.backgroundColor?.resolve({});
      final fg = cta.style?.foregroundColor?.resolve({});
      expect(bg, equals(AppTheme.primaryButtonBackground));
      expect(fg, equals(AppTheme.onPrimaryButton));
      expect(_ratio(bg!, fg!), greaterThanOrEqualTo(4.5));
      expect(tester.takeException(), isNull);
    });
  });
}
