import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:inea_scents_client/config/theme.dart';
import 'package:inea_scents_client/models/index.dart';
import 'package:inea_scents_client/widgets/index.dart';

/// C33: payment-method chip labels hit AAA UI bar (4.5:1), chip sublabels
/// hit AAA text bar (7:1) — both modes, both methods, both states.
/// Labels/sublabels resolve through [CardSurfaces.title]; method colors
/// survive only as border/tint state signals.
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

/// Mirrors `Color.withValues(alpha: a)` composited over an opaque bg.
Color _blend(Color fg, Color bg, double a) {
  int ch(double v) => (v * 255.0).round().clamp(0, 255);
  final r = ch(fg.r * a + bg.r * (1 - a));
  final g = ch(fg.g * a + bg.g * (1 - a));
  final b = ch(fg.b * a + bg.b * (1 - a));
  return Color.fromARGB(255, r, g, b);
}

const _plum = Color(0xFF6A4053); // desktop online method color
const _green = Color(0xFF16A34A); // cash method color
const _red = Color(0xFFEB001B); // mobile online method color
const _cardLight = Colors.white;
const _cardDark = Color(0xFF1C1618);
const _chipLight = Color(0xFFFDF4F5);
const _chipDark = Color(0xFF36222C);
const _titleLight = Color(0xFF633E50);
const _titleDark = Color(0xFFFDF4F5);

Color _desktopBg(Color method, bool dark, bool selected) => selected
    ? _blend(method, dark ? _cardDark : _cardLight, 0.08)
    : _blend(dark ? _chipDark : _chipLight, dark ? _cardDark : _cardLight, 0.4);

Color _mobileBg(Color method, bool dark, bool selected) => selected
    ? _blend(method, dark ? _cardDark : _cardLight, 0.15)
    : (dark ? _cardDark : _cardLight);

void main() {
  setUpAll(() {
    GoogleFonts.config.allowRuntimeFetching = false;
  });

  group('c33 chip label math (UI bar 4.5, text bar 7.0)', () {
    for (final dark in [false, true]) {
      final mode = dark ? 'dark' : 'light';
      final title = dark ? _titleDark : _titleLight;
      for (final entry in {'online': _plum, 'cash': _green}.entries) {
        for (final selected in [false, true]) {
          final state = selected ? 'selected' : 'unselected';
          test('desktop ${entry.key} $state $mode: label>=4.5 sublabel>=7', () {
            final bg = _desktopBg(entry.value, dark, selected);
            expect(_ratio(title, bg), greaterThanOrEqualTo(4.5));
            expect(_ratio(title, bg), greaterThanOrEqualTo(7.0));
          });
        }
      }
      for (final entry in {'online': _red, 'cash': _green}.entries) {
        for (final selected in [false, true]) {
          final state = selected ? 'selected' : 'unselected';
          test('mobile ${entry.key} $state $mode: label>=4.5', () {
            expect(
              _ratio(title, _mobileBg(entry.value, dark, selected)),
              greaterThanOrEqualTo(4.5),
            );
          });
        }
      }
    }
  });

  group('c33 DesktopPaymentPanel resolved colors', () {
    const pkg = Package(
      id: 99,
      name: null,
      description: null,
      price: null,
      images: null,
      inclusions: null,
      freebies: null,
      paxOptions: null,
    );

    for (final theme in [AppTheme.lightTheme, AppTheme.darkTheme]) {
      final mode = theme.brightness == Brightness.dark ? 'dark' : 'light';
      final dark = theme.brightness == Brightness.dark;
      for (final method in ['online', 'cash']) {
        testWidgets('chip text resolves to title token ($method $mode)', (
          WidgetTester tester,
        ) async {
          tester.view.physicalSize = const Size(1280, 1600);
          tester.view.devicePixelRatio = 1.0;
          addTearDown(tester.view.resetPhysicalSize);
          addTearDown(tester.view.resetDevicePixelRatio);
          await tester.pumpWidget(
            MaterialApp(
              theme: theme,
              home: Scaffold(
                body: SingleChildScrollView(
                  child: DesktopPaymentPanel(
                    package: pkg,
                    paymentMethod: method,
                    onPaymentMethodSelected: (_) {},
                  ),
                ),
              ),
            ),
          );
          await tester.pumpAndSettle();

          final ctx = tester.element(find.text('Online'));
          final title = CardSurfaces.title(ctx);
          expect(title, equals(dark ? _titleDark : _titleLight));

          // Labels (UI bar 4.5) + sublabels (text bar 7.0).
          for (final label in ['Online', 'Cash']) {
            final t = tester.widget<Text>(find.text(label));
            expect(t.style?.color, equals(title));
          }
          for (final sub in [
            'PayMongo secure checkout',
            'Pay on event day · admin confirms',
          ]) {
            final t = tester.widget<Text>(find.text(sub));
            expect(t.style?.color, equals(title));
          }

          // Method + state icons carry the same token.
          final methodColor = method == 'online' ? _plum : _green;
          final selectedBg = _desktopBg(methodColor, dark, true);
          final unselectedBg = _desktopBg(methodColor, dark, false);
          expect(_ratio(title, selectedBg), greaterThanOrEqualTo(4.5));
          expect(_ratio(title, unselectedBg), greaterThanOrEqualTo(4.5));
          expect(_ratio(title, selectedBg), greaterThanOrEqualTo(7.0));
          expect(_ratio(title, unselectedBg), greaterThanOrEqualTo(7.0));
          expect(tester.takeException(), isNull);
        });
      }
    }
  });
}
