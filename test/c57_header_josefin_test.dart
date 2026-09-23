import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:inea_scents_client/config/theme.dart';
import 'package:inea_scents_client/widgets/index.dart';

/// C57: header/brand text renders Josefin Sans (web + mobile) with the
/// single-source offline-safe fallback stack.
void main() {
  setUpAll(() {
    GoogleFonts.config.allowRuntimeFetching = false;
  });

  group('c57 header Josefin Sans', () {
    testWidgets('TabHeader title renders Josefin Sans family', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(body: TabHeader(title: 'My Bookings', count: 'C')),
        ),
      );
      await tester.pumpAndSettle();
      expect(tester.takeException(), isNull);
      final style = tester.widget<Text>(find.text('My Bookings')).style!;
      // google_fonts names the family 'JosefinSans_<weight>' at runtime;
      // the human-readable 'Josefin Sans' leads the fallback stack.
      expect(style.fontFamily, contains('JosefinSans'));
      expect(style.fontFamilyFallback, AppTheme.brandFontFallback);
      expect(style.fontFamilyFallback!.first, 'Josefin Sans');
      // Readable weight in both modes (w600 on CardSurfaces title token).
      expect(style.fontWeight, FontWeight.w600);
    });

    testWidgets('TopNavBar brand INEA renders Josefin Sans family', (
      tester,
    ) async {
      tester.view.physicalSize = const Size(1200, 800);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);
      await tester.pumpWidget(
        MaterialApp(theme: AppTheme.lightTheme, home: const TopNavBar()),
      );
      await tester.pumpAndSettle();
      expect(tester.takeException(), isNull);
      final style = tester.widget<Text>(find.text('INEA')).style!;
      expect(style.fontFamily, contains('JosefinSans'));
      expect(style.fontFamilyFallback, AppTheme.brandFontFallback);
      expect(style.fontWeight, FontWeight.w700);
      // Light mode: white brand on plum nav.
      expect(style.color, Colors.white);
    });

    testWidgets('TopNavBar brand holds Josefin Sans in dark mode', (
      tester,
    ) async {
      tester.view.physicalSize = const Size(1200, 800);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);
      await tester.pumpWidget(
        MaterialApp(theme: AppTheme.darkTheme, home: const TopNavBar()),
      );
      await tester.pumpAndSettle();
      expect(tester.takeException(), isNull);
      final style = tester.widget<Text>(find.text('INEA')).style!;
      expect(style.fontFamily, contains('JosefinSans'));
      expect(style.color, Colors.white);
    });

    testWidgets('AppLogo INEA renders Josefin Sans family', (tester) async {
      await tester.pumpWidget(
        MaterialApp(theme: AppTheme.lightTheme, home: const AppLogo()),
      );
      await tester.pumpAndSettle();
      expect(tester.takeException(), isNull);
      final inea = tester.widgetList<Text>(find.text('INEA'));
      expect(inea, isNotEmpty);
      for (final t in inea) {
        expect(t.style?.fontFamily, contains('JosefinSans'));
        expect(t.style?.fontFamilyFallback, AppTheme.brandFontFallback);
      }
    });

    test('brand fallback stack is Josefin-first, offline-safe', () {
      expect(AppTheme.brandFontFallback.first, 'Josefin Sans');
      expect(AppTheme.brandFontFallback, contains('sans-serif'));
      expect(TabHeader.titleFallback, AppTheme.brandFontFallback);
    });
  });
}
