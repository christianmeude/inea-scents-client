import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:inea_scents_client/config/theme.dart';
import 'package:inea_scents_client/widgets/index.dart';

/// C30: wide shows a persistent inline banner (never auto-dismisses),
/// narrow keeps the SnackBar. Retry + dismiss covered on both.
void main() {
  setUpAll(() {
    GoogleFonts.config.allowRuntimeFetching = false;
  });

  /// Pumps a bare Scaffold and returns its [BuildContext] so tests can
  /// call [showAppError] at the requested [size].
  Future<BuildContext> pumpHarness(
    WidgetTester tester, {
    required Size size,
  }) async {
    tester.view.physicalSize = size;
    tester.view.devicePixelRatio = 1.0;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    late BuildContext ctx;
    await tester.pumpWidget(
      MaterialApp(
        theme: AppTheme.lightTheme,
        home: Scaffold(
          body: Builder(
            builder: (context) {
              ctx = context;
              return const SizedBox.shrink();
            },
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();
    return ctx;
  }

  group('C30 wide error banner', () {
    testWidgets('error renders persistent inline banner, no SnackBar', (
      WidgetTester tester,
    ) async {
      final ctx = await pumpHarness(
        tester,
        size: const Size(1200, 800),
      );
      showAppError(ctx, message: 'Load failed. Check and try again.');
      await tester.pumpAndSettle();

      expect(find.byType(MaterialBanner), findsOneWidget);
      expect(find.byType(SnackBar), findsNothing);
      expect(find.text('Load failed. Check and try again.'), findsOneWidget);
      expect(find.byKey(const Key('app_error_dismiss')), findsOneWidget);
    });

    testWidgets('banner never auto-dismisses', (
      WidgetTester tester,
    ) async {
      final ctx = await pumpHarness(
        tester,
        size: const Size(1200, 800),
      );
      showAppError(ctx, message: 'Still here after settle.');
      await tester.pumpAndSettle();
      // Past every SnackBar duration: the banner must persist.
      await tester.pump(const Duration(seconds: 10));
      await tester.pumpAndSettle();

      expect(find.byType(MaterialBanner), findsOneWidget);
      expect(find.text('Still here after settle.'), findsOneWidget);
      expect(tester.takeException(), isNull);
    });

    testWidgets('retry fires then clears the banner', (
      WidgetTester tester,
    ) async {
      final ctx = await pumpHarness(
        tester,
        size: const Size(1200, 800),
      );
      var retried = 0;
      showAppError(
        ctx,
        message: 'Submit failed.',
        onRetry: () => retried++,
      );
      await tester.pumpAndSettle();

      await tester.tap(find.byKey(const Key('app_error_retry')));
      await tester.pumpAndSettle();

      expect(retried, 1);
      expect(find.byType(MaterialBanner), findsNothing);
    });

    testWidgets('dismiss clears the banner', (
      WidgetTester tester,
    ) async {
      final ctx = await pumpHarness(
        tester,
        size: const Size(1200, 800),
      );
      showAppError(ctx, message: 'Dismiss me.', onRetry: () {});
      await tester.pumpAndSettle();

      await tester.tap(find.byKey(const Key('app_error_dismiss')));
      await tester.pumpAndSettle();

      expect(find.byType(MaterialBanner), findsNothing);
    });

    testWidgets('long message wraps without overflow', (
      WidgetTester tester,
    ) async {
      final ctx = await pumpHarness(
        tester,
        size: const Size(1200, 800),
      );
      showAppError(ctx, message: 'Long error. ' * 40, onRetry: () {});
      await tester.pumpAndSettle();

      expect(find.byType(MaterialBanner), findsOneWidget);
      expect(tester.takeException(), isNull);
    });
  });

  group('C30 narrow error SnackBar', () {
    testWidgets('error renders SnackBar, no banner', (
      WidgetTester tester,
    ) async {
      final ctx = await pumpHarness(
        tester,
        size: const Size(375, 667),
      );
      showAppError(ctx, message: 'Load failed. Check and try again.');
      await tester.pumpAndSettle();

      expect(find.byType(SnackBar), findsOneWidget);
      expect(find.byType(MaterialBanner), findsNothing);
      expect(find.text('Load failed. Check and try again.'), findsOneWidget);
    });

    testWidgets('retry fires then clears the SnackBar', (
      WidgetTester tester,
    ) async {
      final ctx = await pumpHarness(
        tester,
        size: const Size(375, 667),
      );
      var retried = 0;
      showAppError(
        ctx,
        message: 'Submit failed.',
        onRetry: () => retried++,
      );
      await tester.pumpAndSettle();

      await tester.tap(find.byKey(const Key('app_error_retry')));
      await tester.pumpAndSettle();

      expect(retried, 1);
      expect(find.byType(SnackBar), findsNothing);
    });

    testWidgets('dismiss clears the SnackBar', (
      WidgetTester tester,
    ) async {
      final ctx = await pumpHarness(
        tester,
        size: const Size(375, 667),
      );
      showAppError(ctx, message: 'Dismiss me.', onRetry: () {});
      await tester.pumpAndSettle();

      await tester.tap(find.byKey(const Key('app_error_dismiss')));
      await tester.pumpAndSettle();

      expect(find.byType(SnackBar), findsNothing);
    });
  });

  group('C30 error card retry-only', () {
    testWidgets('card carries retry, no dismiss affordance', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(
        MaterialApp(
          theme: AppTheme.lightTheme,
          home: Scaffold(
            body: ErrorStateCard(
              title: 'Unable to load bookings',
              message: "We couldn't load your bookings. Try again.",
              onRetry: () {},
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();

      // C30: dismiss lives on the banner/SnackBar path; the full-page
      // card is retry-only (dismissing it would blank the screen).
      expect(find.byKey(const Key('error_card_dismiss')), findsNothing);
      expect(find.text('Try Again'), findsOneWidget);
      expect(tester.takeException(), isNull);
    });
  });
}
