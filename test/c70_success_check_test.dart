import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:inea_scents_client/widgets/success_check.dart';

/// C70: success check draw-in — stroke animates ≤400ms in success green,
/// static under reduced-motion, no layout change.
void main() {
  Widget wrap(Widget child, {bool disableAnimations = false}) {
    return MaterialApp(
      home: MediaQuery(
        data: MediaQueryData(disableAnimations: disableAnimations),
        child: Scaffold(body: Center(child: child)),
      ),
    );
  }

  test('success token is semantic green #22c55e and duration fits ≤400ms', () {
    expect(SuccessCheck.successGreen, const Color(0xFF22C55E));
    expect(
      SuccessCheck.drawDuration,
      lessThanOrEqualTo(const Duration(milliseconds: 400)),
    );
  });

  testWidgets('check draws in on mount and settles on the final stroke', (
    tester,
  ) async {
    await tester.pumpWidget(wrap(const SuccessCheck()));
    // Animated: the draw-in runs on mount.
    expect(find.byType(TweenAnimationBuilder<double>), findsOneWidget);
    await tester.pump(SuccessCheck.drawDuration ~/ 2);
    // Mid-flight the painter exists and is partial (no crash, still animating).
    expect(find.byType(CustomPaint), findsWidgets);
    await tester.pumpAndSettle();
    // Settles with the check still rendered.
    expect(find.byType(CustomPaint), findsWidgets);
    expect(find.bySemanticsLabel('Success'), findsOneWidget);
  });

  testWidgets('reduced-motion shows the final check instantly', (tester) async {
    await tester.pumpWidget(
      wrap(const SuccessCheck(), disableAnimations: true),
    );
    // No draw-in animation widgets inside the check itself
    // (app chrome may own unrelated builders).
    expect(
      find.descendant(
        of: find.byType(SuccessCheck),
        matching: find.byType(TweenAnimationBuilder<double>),
      ),
      findsNothing,
    );
    // Final check renders immediately.
    expect(find.byType(CustomPaint), findsWidgets);
    expect(find.bySemanticsLabel('Success'), findsOneWidget);
    await tester.pump(const Duration(seconds: 1));
    expect(
      find.descendant(
        of: find.byType(SuccessCheck),
        matching: find.byType(TweenAnimationBuilder<double>),
      ),
      findsNothing,
    );
  });

  testWidgets('layout box matches the static 40px icon it replaces', (
    tester,
  ) async {
    await tester.pumpWidget(wrap(const SuccessCheck()));
    final box = tester.getSize(find.byType(SuccessCheck));
    expect(box, const Size(40, 40));
    await tester.pumpWidget(
      wrap(const SuccessCheck(), disableAnimations: true),
    );
    expect(tester.getSize(find.byType(SuccessCheck)), const Size(40, 40));
  });
}
