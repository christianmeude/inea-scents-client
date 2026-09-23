import 'package:flutter/material.dart';

/// C66: skeleton→content crossfade — content fades in as the shimmer
/// fades out (no pop-in). Instant swap when reduced-motion is on.
/// Flutter built-ins only (AnimatedSwitcher + FadeTransition), 250ms.
class SkeletonCrossfade extends StatelessWidget {
  /// True while the skeleton shows; false once content is ready.
  final bool isLoading;

  /// The C58 shimmer skeleton shown while [isLoading].
  final Widget skeleton;

  /// The loaded content (or error card) faded in when ready.
  final Widget child;

  /// Crossfade length; must stay ≤300ms per C66 scope.
  static const Duration fadeDuration = Duration(milliseconds: 250);

  const SkeletonCrossfade({
    super.key,
    required this.isLoading,
    required this.skeleton,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    // Reduced-motion: instant swap, no animation.
    final duration = MediaQuery.disableAnimationsOf(context)
        ? Duration.zero
        : fadeDuration;
    return AnimatedSwitcher(
      duration: duration,
      transitionBuilder: (widget, animation) =>
          FadeTransition(opacity: animation, child: widget),
      child: isLoading
          ? KeyedSubtree(key: const ValueKey('skeleton'), child: skeleton)
          : KeyedSubtree(key: const ValueKey('content'), child: child),
    );
  }
}
