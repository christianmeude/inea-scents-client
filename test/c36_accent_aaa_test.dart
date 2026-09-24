import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:inea_scents_client/config/theme.dart';
import 'package:inea_scents_client/models/index.dart';
import 'package:inea_scents_client/providers/index.dart';
import 'package:inea_scents_client/screens/my_bookings_screen.dart';
import 'package:inea_scents_client/widgets/index.dart';

/// C36: bounded non-button accent AAA audit fixes — text bar 7:1, UI bar
/// 4.5:1, both modes. Token swaps only; the defer-list (status chips,
/// checkout borders, timeline track/dots, decorative tokens) is untouched.
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

const _titleLight = Color(0xFF633E50);
const _titleDark = Color(0xFFFDF4F5);
const _cardLight = Colors.white;
const _cardDark = Color(0xFF1C1618);
const _chipLight = Color(0xFFFDF4F5);
const _chipDark = Color(0xFF36222C);

/// Effective (opaque) bottom-bar surface per mode, matching
/// bottom_nav_bar.dart: translucent navBg over the scaffold background.
Color _barSurface(bool isDark) {
  if (isDark) {
    return _over(AppTheme.night.withValues(alpha: 0.88), AppTheme.night);
  }
  return _over(
    AppTheme.secondary.withValues(alpha: 0.85),
    AppTheme.neutralBg,
  );
}

void main() {
  setUpAll(() {
    GoogleFonts.config.allowRuntimeFetching = false;
  });

  group('c36 token ratios (text 7.0, UI 4.5)', () {
    test('title vs card bg hits text bar both modes', () {
      expect(_ratio(_titleLight, _cardLight), greaterThanOrEqualTo(7.0));
      expect(_ratio(_titleDark, _cardDark), greaterThanOrEqualTo(7.0));
    });

    test('title vs explainer tint fills hits text bar both modes', () {
      // C77: both reminders share the plum brand tint (no green).
      final plumTintL = _over(
        const Color(0xFF6A4053).withValues(alpha: 0.06),
        _cardLight,
      );
      final plumTintD = _over(
        const Color(0xFF6A4053).withValues(alpha: 0.06),
        _cardDark,
      );
      expect(_ratio(_titleLight, plumTintL), greaterThanOrEqualTo(7.0));
      expect(_ratio(_titleDark, plumTintD), greaterThanOrEqualTo(7.0));
    });

    test('title vs chip fill hits text bar both modes', () {
      expect(_ratio(_titleLight, _chipLight), greaterThanOrEqualTo(7.0));
      expect(_ratio(_titleDark, _chipDark), greaterThanOrEqualTo(7.0));
    });

    test('title vs fallback fill hits UI bar both modes', () {
      // booking_screen image fallback now uses the surfaceBorder token.
      final fillL = _over(const Color(0x4D99868C), _cardLight);
      expect(_ratio(_titleLight, fillL), greaterThanOrEqualTo(4.5));
      expect(_ratio(_titleDark, _chipDark), greaterThanOrEqualTo(4.5));
    });

    test('selected tab vs bar surface hits UI bar both modes', () {
      expect(
        _ratio(AppTheme.night, _barSurface(false)),
        greaterThanOrEqualTo(4.5),
      );
      expect(
        _ratio(Colors.white, _barSurface(true)),
        greaterThanOrEqualTo(4.5),
      );
    });

    test('error tokens hit text bar both modes', () {
      expect(AppTheme.errorOnLight, equals(const Color(0xFF7A2531)));
      expect(
        _ratio(AppTheme.errorOnLight, _cardLight),
        greaterThanOrEqualTo(7.0),
      );
      expect(
        _ratio(const Color(0xFFF0A6B0), _cardDark),
        greaterThanOrEqualTo(7.0),
      );
    });
  });

  group('c36 BottomNavBar selected resolves per mode', () {
    Future<BottomNavigationBar> pumpBar(
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
      return tester.widget<BottomNavigationBar>(
        find.byType(BottomNavigationBar),
      );
    }

    testWidgets('light selected is night, >=4.5 vs bar', (tester) async {
      final bar = await pumpBar(tester, AppTheme.lightTheme);
      expect(bar.selectedItemColor, equals(AppTheme.night));
      expect(
        _ratio(bar.selectedItemColor!, _barSurface(false)),
        greaterThanOrEqualTo(4.5),
      );
      expect(tester.takeException(), isNull);
    });

    testWidgets('dark selected stays white, >=4.5 vs bar', (tester) async {
      final bar = await pumpBar(tester, AppTheme.darkTheme);
      expect(bar.selectedItemColor, equals(Colors.white));
      expect(
        _ratio(bar.selectedItemColor!, _barSurface(true)),
        greaterThanOrEqualTo(4.5),
      );
      expect(tester.takeException(), isNull);
    });
  });

  group('c36 DesktopPaymentPanel accents resolve to title', () {
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

    Future<Color> pumpPanel(
      WidgetTester tester,
      ThemeData theme,
      String method,
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
      return CardSurfaces.title(tester.element(find.text('Online')));
    }

    for (final theme in [AppTheme.lightTheme, AppTheme.darkTheme]) {
      final mode = theme.brightness == Brightness.dark ? 'dark' : 'light';
      testWidgets('online explainer + trust icons are title ($mode)', (
        tester,
      ) async {
        final title = await pumpPanel(tester, theme, 'online');
        expect(
          tester.widget<Icon>(find.byIcon(Icons.lock_outline_rounded)).color,
          equals(title),
        );
        final explainer = tester.widget<Text>(
          find.byWidgetPredicate(
            (w) => w is Text && (w.data?.contains('no card details') ?? false),
          ),
        );
        expect(explainer.style?.color, equals(title));
        for (final icon in [
          Icons.shield_rounded,
          Icons.verified_user_rounded,
          Icons.lock_rounded,
        ]) {
          expect(
            tester.widget<Icon>(find.byIcon(icon)).color,
            equals(title),
          );
        }
        expect(tester.takeException(), isNull);
      });

      testWidgets('cash explainer + trust icons are title ($mode)', (
        tester,
      ) async {
        final title = await pumpPanel(tester, theme, 'cash');
        expect(
          tester.widget<Icon>(find.byIcon(Icons.info_outline_rounded)).color,
          equals(title),
        );
        expect(
          tester
              .widget<Text>(
                find.text(
                  'You will pay in cash on the event day. Our team will confirm your booking shortly.',
                ),
              )
              .style
              ?.color,
          equals(title),
        );
        for (final icon in [
          Icons.shield_rounded,
          Icons.verified_user_rounded,
          Icons.lock_rounded,
        ]) {
          expect(
            tester.widget<Icon>(find.byIcon(icon)).color,
            equals(title),
          );
        }
        expect(tester.takeException(), isNull);
      });
    }
  });

  group('c36 reservation facts resolve to title', () {
    const pkg = Package(
      id: 7,
      name: 'Test Bar',
      description: null,
      price: null,
      images: null,
      inclusions: null,
      freebies: null,
      paxOptions: [50, 100],
    );

    for (final theme in [AppTheme.lightTheme, AppTheme.darkTheme]) {
      final mode = theme.brightness == Brightness.dark ? 'dark' : 'light';
      testWidgets('facts text is title ($mode)', (tester) async {
        tester.view.physicalSize = const Size(500, 1200);
        tester.view.devicePixelRatio = 1.0;
        addTearDown(tester.view.resetPhysicalSize);
        addTearDown(tester.view.resetDevicePixelRatio);
        await tester.pumpWidget(
          MaterialApp(
            theme: theme,
            home: const Scaffold(
              body: SingleChildScrollView(
                child: SizedBox(
                  width: 500,
                  child: ReservationDetailsPanel(
                    package: pkg,
                    selectedPax: 50,
                    onChangePax: null,
                    selectedTime: null,
                    onTimeSelected: _noopTime,
                  ),
                ),
              ),
            ),
          ),
        );
        await tester.pumpAndSettle();
        final facts = tester.widget<Text>(
          find.text('50–100 PAX — 3–4 hrs'),
        );
        final title = CardSurfaces.title(tester.element(find.text('Test Bar')));
        expect(facts.style?.color, equals(title));
        expect(tester.takeException(), isNull);
      });
    }
  });

  group('c36 empty-bookings icon resolves to title', () {
    for (final theme in [AppTheme.lightTheme, AppTheme.darkTheme]) {
      final mode = theme.brightness == Brightness.dark ? 'dark' : 'light';
      testWidgets('empty icon is title ($mode)', (tester) async {
        tester.view.physicalSize = const Size(390, 844);
        tester.view.devicePixelRatio = 1.0;
        addTearDown(tester.view.resetPhysicalSize);
        addTearDown(tester.view.resetDevicePixelRatio);
        await tester.pumpWidget(
          ProviderScope(
            overrides: [
              bookingsProvider.overrideWith(
                (ref) => Future.value(<Booking>[]),
              ),
            ],
            child: MaterialApp(theme: theme, home: const MyBookingsScreen()),
          ),
        );
        await tester.pumpAndSettle();
        expect(find.text('No bookings yet'), findsOneWidget);
        final icon = tester.widget<Icon>(
          find.byIcon(Icons.calendar_month_outlined),
        );
        final title = CardSurfaces.title(
          tester.element(find.text('No bookings yet')),
        );
        expect(icon.color, equals(title));
        expect(tester.takeException(), isNull);
      });
    }
  });
}

void _noopTime(String value) {}
