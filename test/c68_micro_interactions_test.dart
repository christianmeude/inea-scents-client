import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:inea_scents_client/config/theme.dart';
import 'package:inea_scents_client/widgets/index.dart';

/// C68: micro-interactions — press-scale on primary CTA buttons, appear
/// fade/scale on status chips, slide-in on the C52 toast. All ≤200ms,
/// layout-stable, instant under reduced-motion. Flutter built-ins only.
void main() {
  setUpAll(() {
    GoogleFonts.config.allowRuntimeFetching = false;
  });

  Widget harness(Widget child, {bool disableAnimations = false}) {
    return MaterialApp(
      theme: AppTheme.lightTheme,
      home: MediaQuery(
        data: MediaQueryData(disableAnimations: disableAnimations),
        child: Scaffold(body: Center(child: child)),
      ),
    );
  }

  group('C68 press-scale on primary CTA', () {
    testWidgets('press shrinks, release restores, size stable', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(
        harness(
          PressScale(
            child: FilledButton(
              onPressed: () {},
              child: const Text('Check date'),
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();

      final before = tester.getSize(find.byType(FilledButton));
      expect(find.byType(AnimatedScale), findsOneWidget);

      final center = tester.getCenter(find.byType(FilledButton));
      final gesture = await tester.startGesture(center);
      await tester.pump();
      final pressedScale =
          tester.widget<AnimatedScale>(find.byType(AnimatedScale)).scale;
      expect(pressedScale, lessThan(1.0));

      await gesture.up();
      await tester.pumpAndSettle();
      final releasedScale =
          tester.widget<AnimatedScale>(find.byType(AnimatedScale)).scale;
      expect(releasedScale, 1.0);
      expect(tester.getSize(find.byType(FilledButton)), before);
      expect(PressScale.pressDuration.inMilliseconds, lessThanOrEqualTo(200));
    });

    testWidgets('reduced-motion renders button with no scale widgets', (
      WidgetTester tester,
    ) async {
      var taps = 0;
      await tester.pumpWidget(
        harness(
          PressScale(
            child: FilledButton(
              onPressed: () => taps++,
              child: const Text('Check date'),
            ),
          ),
          disableAnimations: true,
        ),
      );
      await tester.pumpAndSettle();

      expect(find.byType(AnimatedScale), findsNothing);
      expect(find.text('Check date'), findsOneWidget);
      await tester.tap(find.byType(FilledButton));
      await tester.pumpAndSettle();
      expect(taps, 1);
    });
  });

  group('C68 chip appear fade/scale', () {
    const chip = ChipAppear(
      key: Key('c68_chip'),
      child: Text('CONFIRMED'),
    );

    testWidgets('animates in then settles at full opacity, size stable', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(harness(chip));
      // Mid-flight: entrance running below full opacity.
      await tester.pump(const Duration(milliseconds: 60));
      expect(find.byType(TweenAnimationBuilder<double>), findsOneWidget);
      final mid =
          tester
              .widgetList<Opacity>(find.byType(Opacity))
              .map((o) => o.opacity)
              .fold<double>(1.0, (a, b) => a < b ? a : b);
      expect(mid, lessThan(1.0));

      final sizeBefore = tester.getSize(find.byKey(const Key('c68_chip')));
      await tester.pumpAndSettle();
      expect(find.text('CONFIRMED'), findsOneWidget);
      expect(tester.getSize(find.byKey(const Key('c68_chip'))), sizeBefore);
      expect(ChipAppear.appearDuration.inMilliseconds, lessThanOrEqualTo(200));
    });

    testWidgets('reduced-motion renders instantly, no animation', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(
        harness(chip, disableAnimations: true),
      );
      await tester.pump();
      expect(find.byType(TweenAnimationBuilder<double>), findsNothing);
      expect(find.text('CONFIRMED'), findsOneWidget);
    });
  });

  group('C68 toast slide-in', () {
    testWidgets('entry slides then settles, size stable', (
      WidgetTester tester,
    ) async {
      const entry = ToastEntry(
        key: Key('c68_toast'),
        child: Text('Load failed.'),
      );
      await tester.pumpWidget(harness(entry));
      await tester.pump(const Duration(milliseconds: 60));
      expect(find.byType(TweenAnimationBuilder<double>), findsOneWidget);

      final sizeBefore = tester.getSize(find.byKey(const Key('c68_toast')));
      await tester.pumpAndSettle();
      expect(find.text('Load failed.'), findsOneWidget);
      expect(tester.getSize(find.byKey(const Key('c68_toast'))), sizeBefore);
      expect(ToastEntry.entryDuration.inMilliseconds, lessThanOrEqualTo(200));
    });

    testWidgets('reduced-motion toast renders instantly', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(
        harness(
          const ToastEntry(child: Text('Load failed.')),
          disableAnimations: true,
        ),
      );
      await tester.pump();
      expect(find.byType(TweenAnimationBuilder<double>), findsNothing);
      expect(find.text('Load failed.'), findsOneWidget);
    });

    testWidgets('showAppError toast carries the slide-in entry', (
      WidgetTester tester,
    ) async {
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

      showAppError(ctx, message: 'Load failed. Check and try again.');
      await tester.pump();
      expect(find.byType(SnackBar), findsOneWidget);
      expect(find.byType(ToastEntry), findsOneWidget);
      await tester.pumpAndSettle();
      expect(
        find.text('Load failed. Check and try again.'),
        findsOneWidget,
      );
      expect(tester.takeException(), isNull);
    });

    testWidgets('showAppError toast entry instant under reduced-motion', (
      WidgetTester tester,
    ) async {
      late BuildContext ctx;
      await tester.pumpWidget(
        MaterialApp(
          theme: AppTheme.lightTheme,
          home: MediaQuery(
            data: const MediaQueryData(disableAnimations: true),
            child: Scaffold(
              body: Builder(
                builder: (context) {
                  ctx = context;
                  return const SizedBox.shrink();
                },
              ),
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();

      showAppError(ctx, message: 'Load failed. Check and try again.');
      await tester.pumpAndSettle();
      expect(find.byType(SnackBar), findsOneWidget);
      // ToastEntry still wraps content (tokens untouched) but mounts
      // no animation widgets when reduced-motion is on.
      expect(find.byType(ToastEntry), findsOneWidget);
      expect(find.byType(TweenAnimationBuilder<double>), findsNothing);
    });
  });
}
