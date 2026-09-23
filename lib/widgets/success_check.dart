import 'package:flutter/material.dart';

/// C70: success check draw-in — the payment/booking success moment.
///
/// The check stroke draws in over [drawDuration] (≤400ms) in semantic
/// success green's contrasting stroke (white on [#successGreen], per
/// DESIGN). Flutter built-ins only ([TweenAnimationBuilder] +
/// [CustomPainter]); no confetti, no new packages.
///
/// Reduced-motion ([MediaQuery.disableAnimationsOf]) renders the final
/// check instantly with no animation widgets. Layout is static: a fixed
/// [size]×[size] box matching the `Icon(..., size: 40)` it replaces, so
/// no layout shift.
class SuccessCheck extends StatelessWidget {
  /// Semantic success green per DESIGN (circle fill owned by caller).
  static const Color successGreen = Color(0xFF22C55E);

  /// Stroke draw-in duration. Must stay ≤400ms per C70 scope.
  static const Duration drawDuration = Duration(milliseconds: 350);

  /// Check stroke box. Defaults to 40 to match the replaced Icon size.
  final double size;

  /// Stroke color of the check mark itself.
  final Color strokeColor;

  const SuccessCheck({super.key, this.size = 40, this.strokeColor = Colors.white});

  @override
  Widget build(BuildContext context) {
    // Reduced-motion: final check instantly, no animation widgets.
    if (MediaQuery.disableAnimationsOf(context)) {
      return _CheckMark(size: size, progress: 1.0, strokeColor: strokeColor);
    }
    return TweenAnimationBuilder<double>(
      tween: Tween<double>(begin: 0.0, end: 1.0),
      duration: drawDuration,
      curve: Curves.easeOutCubic,
      builder: (context, value, _) =>
          _CheckMark(size: size, progress: value, strokeColor: strokeColor),
    );
  }
}

/// Fixed-size check mark; [progress] 0→1 draws the stroke in.
class _CheckMark extends StatelessWidget {
  final double size;
  final double progress;
  final Color strokeColor;

  const _CheckMark({
    required this.size,
    required this.progress,
    required this.strokeColor,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: size,
      height: size,
      child: Semantics(
        label: 'Success',
        child: CustomPaint(
          painter: _CheckPainter(progress: progress.clamp(0.0, 1.0), color: strokeColor),
        ),
      ),
    );
  }
}

/// Draws the check stroke up to [progress] of its total length.
class _CheckPainter extends CustomPainter {
  final double progress;
  final Color color;

  _CheckPainter({required this.progress, required this.color});

  static Path _checkPath(Size size) {
    return Path()
      ..moveTo(size.width * 0.22, size.height * 0.55)
      ..lineTo(size.width * 0.44, size.height * 0.77)
      ..lineTo(size.width * 0.80, size.height * 0.28);
  }

  @override
  void paint(Canvas canvas, Size size) {
    if (progress <= 0) return;
    final path = _checkPath(size);
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = size.width * 0.12
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round;
    if (progress >= 1) {
      canvas.drawPath(path, paint);
      return;
    }
    // Stroke-dash draw-in: reveal the leading [progress] of the path.
    final metrics = path.computeMetrics().toList();
    var total = 0.0;
    for (final metric in metrics) {
      total += metric.length;
    }
    var target = total * progress;
    final drawn = Path();
    for (final metric in metrics) {
      if (target <= 0) break;
      final take = target >= metric.length ? metric.length : target;
      drawn.addPath(metric.extractPath(0, take), Offset.zero);
      target -= take;
    }
    canvas.drawPath(drawn, paint);
  }

  @override
  bool shouldRepaint(_CheckPainter oldDelegate) =>
      oldDelegate.progress != progress || oldDelegate.color != color;
}
