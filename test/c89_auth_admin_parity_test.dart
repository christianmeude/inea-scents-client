import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:inea_scents_client/config/theme.dart';
import 'package:inea_scents_client/widgets/app_logo.dart';
import 'package:inea_scents_client/widgets/auth_background.dart';
import 'package:inea_scents_client/widgets/custom_text_field.dart';

/// C89: exact admin parity (option b locked).
///
/// Pins the admin token values against the client widgets:
/// GuestLayout.vue:8-35 (solid base + 8 blobs), tailwind.config.js:38-39
/// (palette), ApplicationLogo.vue:4-6 (logo scale), TextInput.vue:39
/// (pill fields). Supersedes C88's light gradient (expected).
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
const _cream = Color(0xFFFDF4F5);

void main() {
  setUpAll(() {
    GoogleFonts.config.allowRuntimeFetching = false;
  });

  group('c89 admin background tokens', () {
    test('solid bases match tailwind brand.cream / brand.dark-base', () {
      expect(AuthBackground.lightBase, equals(const Color(0xFFFDF4F5)));
      expect(AuthBackground.darkBase, equals(const Color(0xFF151012)));
    });

    test('light blobs are the admin opaque fills (GuestLayout:20-35)', () {
      expect(AuthBackground.lightBlobs, equals(const <Color>[
        Color(0xFFDABDAC),
        Color(0xFFC08D9E),
        Color(0xFF988088),
        Color(0xFFC4A5A8),
        Color(0xFF6E3C53),
      ]));
    });

    test('dark blobs are the admin translucent fills', () {
      expect(AuthBackground.darkBlobs, equals(const <Color>[
        Color(0x666F2431), // burgundy-900/40
        Color(0x806A4053), // brand-primary/50
        Color(0x994A2D3C), // #4A2D3C/60
        Color(0xB33E1018), // burgundy-950/70
        Color(0x996A4053), // brand-primary/60
      ]));
    });

    testWidgets('both modes paint a solid base, 8 blobs, no gradient', (
      tester,
    ) async {
      for (final isDark in [false, true]) {
        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: AuthBackground(
                isDark: isDark,
                child: const SizedBox(),
              ),
            ),
          ),
        );
        await tester.pumpAndSettle();

        final containers = tester.widgetList<AnimatedContainer>(
          find.byType(AnimatedContainer),
        );
        final bases = containers.where((c) {
          final d = c.decoration;
          return d is BoxDecoration &&
              d.color != null &&
              d.borderRadius == null;
        }).toList();
        expect(bases, hasLength(1));
        expect(
          (bases.single.decoration as BoxDecoration).color,
          equals(isDark ? AuthBackground.darkBase : AuthBackground.lightBase),
        );
        // No LinearGradient anywhere in the auth backdrop.
        expect(
          containers.where((c) {
            final d = c.decoration;
            return d is BoxDecoration && d.gradient is LinearGradient;
          }),
          isEmpty,
        );
        // 8 admin blobs.
        final blobs = tester
            .widgetList<Positioned>(find.byType(Positioned))
            .where((p) => (p.left == null) != (p.right == null))
            .toList();
        expect(blobs, hasLength(8));
        expect(tester.takeException(), isNull);
      }
    });
  });

  group('c89 admin background contrast (reported, never restyled)', () {
    test('solid base holds the 5.7 budget', () {
      expect(_ratio(_plum, AuthBackground.lightBase), greaterThanOrEqualTo(5.7));
    });

    test('opaque blob cores miss 5.7 (reported)', () {
      // Measured: 4.80 / 3.05 / 2.34 / 3.76 / 1.02.
      for (final blob in AuthBackground.lightBlobs) {
        expect(
          _ratio(_plum, blob),
          lessThan(5.7),
          reason: 'blob $blob unexpectedly meets budget',
        );
      }
    });

    test('dark cream-on-mesh stays AAA', () {
      expect(
        _ratio(_cream, AuthBackground.darkBase),
        greaterThanOrEqualTo(7.0),
      );
      for (final blob in AuthBackground.darkBlobs) {
        expect(
          _ratio(_cream, _over(blob, AuthBackground.darkBase)),
          greaterThanOrEqualTo(7.0),
          reason: 'dark blob $blob tinted surface fails AAA',
        );
      }
    });
  });

  group('c89 admin logo scale (ApplicationLogo:4-6)', () {
    Future<List<Text>> logoTexts(WidgetTester tester, double width) async {
      tester.view.physicalSize = Size(width, 800);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);
      await tester.pumpWidget(
        MaterialApp(theme: AppTheme.lightTheme, home: const AppLogo()),
      );
      await tester.pumpAndSettle();
      expect(tester.takeException(), isNull);
      return tester.widgetList<Text>(find.byType(Text)).toList();
    }

    testWidgets('mobile: INEA 60 tracking 0.15em, Scents 72', (tester) async {
      final texts = await logoTexts(tester, 360);
      final inea = texts
          .where((t) => t.data == 'INEA' && t.style?.color == _plum)
          .toList();
      expect(inea, isNotEmpty);
      expect(inea.first.style?.fontSize, equals(60.0));
      expect(inea.first.style?.letterSpacing, closeTo(60.0 * 0.15, 0.01));
      expect(inea.first.style?.fontWeight, equals(FontWeight.w700));
      final scents = texts
          .where((t) => t.data == 'Scents' && t.style?.color == _plum)
          .toList();
      expect(scents, isNotEmpty);
      expect(scents.first.style?.fontSize, equals(72.0));
    });

    testWidgets('desktop: INEA 72 tracking 0.15em, Scents 96', (tester) async {
      final texts = await logoTexts(tester, 1024);
      final inea = texts
          .where((t) => t.data == 'INEA' && t.style?.color == _plum)
          .toList();
      expect(inea, isNotEmpty);
      expect(inea.first.style?.fontSize, equals(72.0));
      expect(inea.first.style?.letterSpacing, closeTo(72.0 * 0.15, 0.01));
      final scents = texts
          .where((t) => t.data == 'Scents' && t.style?.color == _plum)
          .toList();
      expect(scents, isNotEmpty);
      expect(scents.first.style?.fontSize, equals(96.0));
    });
  });

  group('c89 admin field tokens (TextInput:39)', () {
    Future<AnimatedContainer> fieldBox(
      WidgetTester tester,
      ThemeData theme, {
      bool focus = false,
    }) async {
      final controller = TextEditingController();
      addTearDown(controller.dispose);
      await tester.pumpWidget(
        MaterialApp(
          theme: theme,
          home: Scaffold(body: CustomTextField(controller: controller)),
        ),
      );
      await tester.pumpAndSettle();
      if (focus) {
        final detector = tester.widget<FocusableActionDetector>(
          find.descendant(
            of: find.byType(CustomTextField),
            matching: find.byType(FocusableActionDetector),
          ),
        );
        detector.onShowFocusHighlight!(true);
        await tester.pumpAndSettle();
      }
      return tester.widget<AnimatedContainer>(
        find.descendant(
          of: find.byType(CustomTextField),
          matching: find.byType(AnimatedContainer),
        ),
      );
    }

    testWidgets('light: pill, 1px white/20 border, mauve/70 fill, py-3 px-5', (
      tester,
    ) async {
      final box = await fieldBox(tester, AppTheme.lightTheme);
      final dec = box.decoration as BoxDecoration;
      final border = dec.border as Border;
      // Pill (rounded-full): radius far above half-height.
      expect(
        dec.borderRadius,
        equals(BorderRadius.circular(999.0)),
      );
      // 1px translucent-white border.
      expect(border.top.width, equals(1.0));
      expect(
        border.top.color,
        equals(Colors.white.withValues(alpha: 0.20)),
      );
      // Mauve fill #8B5D76/70.
      expect(
        dec.color,
        equals(const Color(0xFF8B5D76).withValues(alpha: 0.70)),
      );
      // py-3 px-5.
      final field = tester.widget<TextField>(
        find.descendant(
          of: find.byType(CustomTextField),
          matching: find.byType(TextField),
        ),
      );
      final padding =
          field.decoration?.contentPadding as EdgeInsets?;
      expect(padding?.top, equals(12.0));
      expect(padding?.bottom, equals(12.0));
      expect(padding?.left, equals(20.0));
      expect(padding?.right, equals(20.0));
      expect(tester.takeException(), isNull);
    });

    testWidgets('dark: 1px white/10 border, brand-primary/40 fill', (
      tester,
    ) async {
      final box = await fieldBox(tester, AppTheme.darkTheme);
      final dec = box.decoration as BoxDecoration;
      final border = dec.border as Border;
      expect(border.top.width, equals(1.0));
      expect(
        border.top.color,
        equals(Colors.white.withValues(alpha: 0.10)),
      );
      expect(
        dec.color,
        equals(const Color(0xFF6A4053).withValues(alpha: 0.40)),
      );
      expect(tester.takeException(), isNull);
    });

    testWidgets('focus: mauve/90 + white border + white/30 ring (light)', (
      tester,
    ) async {
      final box = await fieldBox(tester, AppTheme.lightTheme, focus: true);
      final dec = box.decoration as BoxDecoration;
      final border = dec.border as Border;
      expect(
        dec.color,
        equals(const Color(0xFF8B5D76).withValues(alpha: 0.90)),
      );
      expect(border.top.color, equals(Colors.white));
      expect(border.top.width, equals(1.0));
      final outer = tester.widget<Container>(
        find
            .descendant(
              of: find.byType(CustomTextField),
              matching: find.byType(Container),
            )
            .first,
      );
      final shadows = (outer.decoration as BoxDecoration).boxShadow!;
      expect(
        shadows.any(
          (s) => s.color == Colors.white.withValues(alpha: 0.30),
        ),
        isTrue,
        reason: 'missing white/30 focus ring',
      );
      expect(tester.takeException(), isNull);
    });

    testWidgets(
      'focus: brand-primary/60 + brand-primary border/ring (dark)',
      (tester) async {
        final box = await fieldBox(tester, AppTheme.darkTheme, focus: true);
        final dec = box.decoration as BoxDecoration;
        final border = dec.border as Border;
        expect(
          dec.color,
          equals(const Color(0xFF6A4053).withValues(alpha: 0.60)),
        );
        expect(border.top.color, equals(const Color(0xFF6A4053)));
        expect(border.top.width, equals(1.0));
        final outer = tester.widget<Container>(
          find
              .descendant(
                of: find.byType(CustomTextField),
                matching: find.byType(Container),
              )
              .first,
        );
        final shadows = (outer.decoration as BoxDecoration).boxShadow!;
        expect(
          shadows.any(
            (s) =>
                s.color ==
                const Color(0xFF6A4053).withValues(alpha: 0.40),
          ),
          isTrue,
          reason: 'missing brand-primary/40 focus ring',
        );
        expect(tester.takeException(), isNull);
      },
    );

    test('field copy contrast deltas (reported, never restyled)', () {
      // White on mauve/70 = 3.05, on mauve/90 = 4.40: below 5.7.
      expect(
        _ratio(
          Colors.white,
          _over(
            const Color(0xB38B5D76),
            AuthBackground.lightBase,
          ),
        ),
        lessThan(5.7),
      );
      // Cream on dark brand-primary/40 over night base passes AAA.
      expect(
        _ratio(
          _cream,
          _over(
            const Color(0x666A4053),
            AuthBackground.darkBase,
          ),
        ),
        greaterThanOrEqualTo(7.0),
      );
    });
  });
}
