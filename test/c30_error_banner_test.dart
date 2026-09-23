import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:inea_scents_client/config/theme.dart';
import 'package:inea_scents_client/widgets/index.dart';

/// C52: [showAppError] is toast-only on every width — the wide
/// nav-level MaterialBanner is gone. Retry appears only for transient
/// failures; validation copy gets a bare toast (callers render those
/// in-card via [FormErrorSummary] instead).
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

  group('C52 wide error toast (no banner)', () {
    testWidgets('error renders SnackBar, never MaterialBanner', (
      WidgetTester tester,
    ) async {
      final ctx = await pumpHarness(
        tester,
        size: const Size(1200, 800),
      );
      showAppError(ctx, message: 'Load failed. Check and try again.');
      await tester.pumpAndSettle();

      expect(find.byType(SnackBar), findsOneWidget);
      expect(find.byType(MaterialBanner), findsNothing);
      expect(find.text('Load failed. Check and try again.'), findsOneWidget);
    });

    testWidgets('validation copy gets no Retry even with onRetry', (
      WidgetTester tester,
    ) async {
      final ctx = await pumpHarness(
        tester,
        size: const Size(1200, 800),
      );
      showAppError(
        ctx,
        message: 'Please select date and time',
        onRetry: () {},
      );
      await tester.pumpAndSettle();

      expect(find.byType(SnackBar), findsOneWidget);
      expect(find.byType(MaterialBanner), findsNothing);
      expect(find.byKey(const Key('app_error_retry')), findsNothing);
    });

    testWidgets('transient failure keeps toast Retry', (
      WidgetTester tester,
    ) async {
      final ctx = await pumpHarness(
        tester,
        size: const Size(1200, 800),
      );
      var retried = 0;
      showAppError(
        ctx,
        message: 'Could not connect. Check your connection and try again.',
        transient: true,
        onRetry: () => retried++,
      );
      await tester.pumpAndSettle();

      await tester.tap(find.byKey(const Key('app_error_retry')));
      await tester.pumpAndSettle();

      expect(retried, 1);
      expect(find.byType(SnackBar), findsNothing);
      expect(find.byType(MaterialBanner), findsNothing);
    });

    testWidgets('long message wraps without overflow', (
      WidgetTester tester,
    ) async {
      final ctx = await pumpHarness(
        tester,
        size: const Size(360, 800),
      );
      showAppError(
        ctx,
        message: 'Long error. ' * 40,
        transient: true,
        onRetry: () {},
      );
      await tester.pumpAndSettle();

      expect(find.byType(SnackBar), findsOneWidget);
      expect(find.byType(MaterialBanner), findsNothing);
      expect(tester.takeException(), isNull);
    });
  });

  group('C52 narrow error toast', () {
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

    testWidgets('transient retry fires then clears the toast', (
      WidgetTester tester,
    ) async {
      final ctx = await pumpHarness(
        tester,
        size: const Size(375, 667),
      );
      var retried = 0;
      showAppError(
        ctx,
        message: 'Request timed out. Try again.',
        transient: true,
        onRetry: () => retried++,
      );
      await tester.pumpAndSettle();

      await tester.tap(find.byKey(const Key('app_error_retry')));
      await tester.pumpAndSettle();

      expect(retried, 1);
      expect(find.byType(SnackBar), findsNothing);
    });

    testWidgets('copy-link action preserved on the toast', (
      WidgetTester tester,
    ) async {
      final ctx = await pumpHarness(
        tester,
        size: const Size(375, 667),
      );
      var copied = 0;
      showAppError(
        ctx,
        message: 'Checkout did not open automatically. Use the button below.',
        actionLabel: 'Copy link',
        onAction: () => copied++,
      );
      await tester.pumpAndSettle();

      await tester.tap(find.byKey(const Key('app_error_action')));
      await tester.pumpAndSettle();

      expect(copied, 1);
      expect(find.byType(MaterialBanner), findsNothing);
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

      // C30: dismiss lives on the toast path; the full-page
      // card is retry-only (dismissing it would blank the screen).
      expect(find.byKey(const Key('error_card_dismiss')), findsNothing);
      expect(find.text('Try Again'), findsOneWidget);
      expect(tester.takeException(), isNull);
    });
  });
}
