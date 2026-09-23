import 'package:flutter/material.dart';

/// C68: shared micro-interactions — subtle motion on shared surfaces.
///
/// Flutter built-ins only, every effect ≤200ms, transform/opacity-only
/// (never size/position in layout, so no layout shift), and instant when
/// reduced-motion is on ([MediaQuery.disableAnimationsOf]).
///
/// No restyle: tokens, shapes, and padding stay with the C55 chips /
/// C31 toast owners — these wrappers only animate.
class PressScale extends StatefulWidget {
  /// The primary CTA button wrapped without restyle.
  final Widget child;

  /// Pressed scale factor. 0.97 reads as tactile, never a layout shift.
  final double pressedScale;

  /// Must stay ≤200ms per C68 scope.
  static const Duration pressDuration = Duration(milliseconds: 150);

  const PressScale({
    super.key,
    required this.child,
    this.pressedScale = 0.97,
  });

  @override
  State<PressScale> createState() => _PressScaleState();
}

class _PressScaleState extends State<PressScale> {
  var _pressed = false;

  @override
  Widget build(BuildContext context) {
    // Reduced-motion: no animation widgets, child renders untouched.
    if (MediaQuery.disableAnimationsOf(context)) return widget.child;
    // Listener (not GestureDetector) so the wrapped button keeps its
    // own tap gesture — press state never swallows onPressed.
    return Listener(
      onPointerDown: (_) => setState(() => _pressed = true),
      onPointerUp: (_) => setState(() => _pressed = false),
      onPointerCancel: (_) => setState(() => _pressed = false),
      child: AnimatedScale(
        scale: _pressed ? widget.pressedScale : 1.0,
        duration: PressScale.pressDuration,
        curve: Curves.easeOut,
        child: widget.child,
      ),
    );
  }
}

/// C68: status-chip appear — fade + scale-in on mount.
///
/// Entrance-only: opacity 0→1 with scale 0.92→1.0 over 180ms.
/// [Transform.scale] keeps layout size stable (no shift); reduced-motion
/// renders the child instantly with no animation widgets.
class ChipAppear extends StatelessWidget {
  final Widget child;

  /// Must stay ≤200ms per C68 scope.
  static const Duration appearDuration = Duration(milliseconds: 180);

  const ChipAppear({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    if (MediaQuery.disableAnimationsOf(context)) return child;
    return TweenAnimationBuilder<double>(
      tween: Tween<double>(begin: 0.0, end: 1.0),
      duration: appearDuration,
      curve: Curves.easeOut,
      builder: (context, value, inner) {
        final scale = 0.92 + 0.08 * value;
        return Opacity(
          opacity: value.clamp(0.0, 1.0),
          child: Transform.scale(scale: scale, child: inner),
        );
      },
      child: child,
    );
  }
}

/// C68: toast entry — slide + fade-in on mount for the C52 toast.
///
/// Rises 16px with a fade over 200ms ([Curves.easeOutCubic]); the offset
/// is a transform so layout size never shifts. Reduced-motion renders
/// the child instantly with no animation widgets.
class ToastEntry extends StatelessWidget {
  final Widget child;

  /// Must stay ≤200ms per C68 scope.
  static const Duration entryDuration = Duration(milliseconds: 200);

  const ToastEntry({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    if (MediaQuery.disableAnimationsOf(context)) return child;
    return TweenAnimationBuilder<double>(
      tween: Tween<double>(begin: 0.0, end: 1.0),
      duration: entryDuration,
      curve: Curves.easeOutCubic,
      builder: (context, value, inner) {
        return Opacity(
          opacity: value.clamp(0.0, 1.0),
          child: Transform.translate(
            offset: Offset(0, (1 - value) * 16),
            child: inner,
          ),
        );
      },
      child: child,
    );
  }
}
