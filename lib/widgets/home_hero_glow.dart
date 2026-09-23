import 'package:flutter/material.dart';

import '../config/theme.dart';

/// C69: home concierge-hero ambient richness — C59 blob/gradient language.
///
/// A translucent plum/cream wash that lives behind the hero content and
/// drifts slowly from soft to full warmth once on mount (single 5s cycle,
/// so pumpAndSettle suites stay green). Tokens only: plum
/// [AppTheme.primaryButtonBackground] + cream [AppTheme.onPrimaryButton].
/// [Positioned.fill] usage keeps the wash exactly the hero's size (no
/// layout change, no overflow); reduced-motion renders the resting warmth
/// with no animation widgets (C68 precedent).
class HomeHeroGlow extends StatelessWidget {
  /// Slow single drift cycle.
  static const Duration driftDuration = Duration(seconds: 5);

  /// Opacity drift range: soft start → full resting warmth.
  static const double minOpacity = 0.55;
  static const double maxOpacity = 1.0;

  /// Opacity for drift progress [t] in [0, 1] (pure, testable).
  static double opacityFor(double t) =>
      minOpacity + (maxOpacity - minOpacity) * t.clamp(0.0, 1.0);

  /// Plum wash (C59 blob tone) — stronger on dark for legibility.
  static Color plumWash(bool isDark) =>
      AppTheme.primaryButtonBackground.withValues(alpha: isDark ? 0.22 : 0.12);

  /// Cream wash — reads on dark, near-invisible on white by design.
  static Color creamWash(bool isDark) =>
      AppTheme.onPrimaryButton.withValues(alpha: isDark ? 0.08 : 0.6);

  const HomeHeroGlow({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final wash = _GlowWash(isDark: isDark);
    // Reduced-motion: resting warmth, no animation widgets.
    if (MediaQuery.disableAnimationsOf(context)) {
      return Opacity(opacity: maxOpacity, child: wash);
    }
    return TweenAnimationBuilder<double>(
      tween: Tween<double>(begin: 0.0, end: 1.0),
      duration: driftDuration,
      curve: Curves.easeOut,
      builder: (BuildContext context, double value, Widget? child) {
        return Opacity(opacity: opacityFor(value), child: child);
      },
      child: wash,
    );
  }
}

/// Two radial washes (plum top-left, cream bottom-right) — the C59 mesh
/// reduced to the hero's bounds. Static; the parent animates opacity.
class _GlowWash extends StatelessWidget {
  final bool isDark;

  const _GlowWash({required this.isDark});

  @override
  Widget build(BuildContext context) {
    final plum = HomeHeroGlow.plumWash(isDark);
    final cream = HomeHeroGlow.creamWash(isDark);
    return Stack(
      children: [
        Positioned.fill(
          child: DecoratedBox(
            decoration: BoxDecoration(
              gradient: RadialGradient(
                center: const Alignment(-0.85, -0.7),
                radius: 1.1,
                colors: <Color>[
                  plum,
                  AppTheme.primaryButtonBackground.withValues(alpha: 0),
                ],
              ),
            ),
          ),
        ),
        Positioned.fill(
          child: DecoratedBox(
            decoration: BoxDecoration(
              gradient: RadialGradient(
                center: const Alignment(0.9, 0.95),
                radius: 1.1,
                colors: <Color>[
                  cream,
                  AppTheme.onPrimaryButton.withValues(alpha: 0),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}
