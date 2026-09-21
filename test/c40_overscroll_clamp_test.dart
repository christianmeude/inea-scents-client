import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:inea_scents_client/widgets/mobile_clamp_scroll.dart';

// C40: mobile overscroll clamp — root cause is the SDK default
// (StretchingOverscrollIndicator on Android / bounce on iOS); no screen
// set explicit physics. Per-screen ClampingScrollPhysics gated to mobile
// width only (<768px); desktop/web physics untouched. Manual 360px note:
// overscroll drag at 360px must show no content displacement past edge
// on both platforms (bounce also fails); verified @1200px default kept.
void main() {
  group('c40 helper gating', () {
    test('360px clamps, 768/1200 keep platform default', () {
      expect(
        MobileClampScroll.physicsForWidth(360),
        isA<ClampingScrollPhysics>(),
      );
      expect(MobileClampScroll.physicsForWidth(768), isNull);
      expect(MobileClampScroll.physicsForWidth(1200), isNull);
    });

    testWidgets('360px resolves clamp, 1200px resolves default', (
      tester,
    ) async {
      // Pump a probe widget that applies the helper at each width.
      Future<ScrollPhysics?> probe(double width) async {
        tester.view.physicalSize = Size(width, 800);
        tester.view.devicePixelRatio = 1.0;
        ScrollPhysics? captured;
        await tester.pumpWidget(
          MaterialApp(
            home: Builder(
              builder: (context) {
                captured = MobileClampScroll.physicsOf(context);
                return SingleChildScrollView(
                  physics: captured,
                  child: const SizedBox(height: 2000, width: double.infinity),
                );
              },
            ),
          ),
        );
        final view = tester.widget<SingleChildScrollView>(
          find.byType(SingleChildScrollView),
        );
        expect(view.physics, same(captured));
        return captured;
      }

      expect(await probe(360), isA<ClampingScrollPhysics>());
      expect(await probe(1200), isNull);
      addTearDown(tester.view.reset);
    });
  });

  group('c40 per-surface source pins', () {
    const surfaces = [
      'lib/screens/home_screen.dart',
      'lib/screens/booking_screen.dart',
      'lib/screens/calendar_screen.dart',
      'lib/screens/packages_screen.dart',
      'lib/screens/my_bookings_screen.dart',
      'lib/screens/booking_detail_screen.dart',
      'lib/screens/login_screen.dart',
      'lib/screens/register_screen.dart',
      'lib/screens/forgot_password_screen.dart',
      'lib/screens/change_password_screen.dart',
      'lib/screens/edit_profile_screen.dart',
    ];

    for (final path in surfaces) {
      test('$path clamps on mobile paths', () {
        final src = File(path).readAsStringSync();
        expect(
          src.contains('MobileClampScroll'),
          isTrue,
          reason: '$path must gate scroll physics via MobileClampScroll',
        );
        expect(
          src.contains('BouncingScrollPhysics'),
          isFalse,
          reason: '$path must not bounce on mobile',
        );
      });
    }

    test('no unbounded stretch helpers on mobile paths', () {
      for (final path in surfaces) {
        final src = File(path).readAsStringSync();
        expect(
          src.contains('StretchingOverscrollIndicator'),
          isFalse,
          reason: '$path must not stretch on mobile',
        );
      }
    });
  });
}
