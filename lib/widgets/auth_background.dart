import 'dart:ui';

import 'package:flutter/material.dart';

/// C88: shared auth backdrop — restored old diagonal gradient + mesh blobs.
///
/// Light mode paints the pre-C59 old gradient recovered from e130957
/// (topLeft → bottomRight, no stops) with the C45 AAA-checked blob alphas
/// over it. Dark mode keeps the flat night base + existing mesh, untouched.
///
/// Blob geometry is the C45 mesh; below 640px the blobs shrink
/// ([blobScaleForWidth]) and the off-screen-anchored pair is pulled inward
/// so the composition stays behind the 336px column instead of spilling
/// past the viewport edge. Everything is clipped, so narrow widths cannot
/// overflow.
class AuthBackground extends StatelessWidget {
  final bool isDark;
  final Widget child;

  const AuthBackground({super.key, required this.isDark, required this.child});

  static const Color darkBase = Color(0xFF151012);

  /// C88 restored old gradient stops, top → bottom (from e130957).
  /// Plum copy (0xFF6A4053) reads 7.17 / 4.39 / 2.93 on the bare stops —
  /// mid + bottom fall below the light >= 5.7 budget (reported, not restyled).
  static const List<Color> lightStops = <Color>[
    Color(0xFFF8E9DF),
    Color(0xFFD8B0BA),
    Color(0xFFB78C9C),
  ];

  static const LinearGradient lightGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: lightStops,
  );

  /// C45 AAA-checked light blob alphas (0x14 pale / 0x0D plum), unchanged.
  static const List<Color> lightBlobs = <Color>[
    Color(0x14DABDAC),
    Color(0x14C08D9E),
    Color(0x14988088),
    Color(0x14C4A5A8),
    Color(0x0D6E3C53),
  ];

  /// Dark-mode mesh colors, untouched by C59.
  static const List<Color> darkBlobs = <Color>[
    Color(0x664A1C28),
    Color(0x806A4053),
    Color(0x9936222C),
    Color(0xB33B1019),
    Color(0x996A4053),
  ];

  /// Mobile shrink factor: full-size at tablet/desktop widths, scaled down
  /// (floored at 0.5) below 768px so 800px blobs fit a 360px viewport.
  static double blobScaleForWidth(double width) {
    if (width >= 768) return 1.0;
    return (width / 768).clamp(0.5, 1.0);
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final sw = size.width;
    final sh = size.height;
    // C59: reposition off-screen-anchored blobs inward on mobile so the
    // mesh stays composed behind the column instead of past the edge.
    // Dark geometry is frozen at the pre-C59 desktop mesh (full scale,
    // base anchors); scale/narrow overrides are light-mode only.
    final narrow = !isDark && sw < 640;
    final s = isDark ? 1.0 : blobScaleForWidth(sw);
    final specs = <_BlobSpec>[
      _BlobSpec(
        w: 300, h: 600, angleDeg: 30,
        topFrac: -0.10, leftFrac: -0.05, narrowLeftFrac: -0.02,
        light: lightBlobs[0], dark: darkBlobs[0],
      ),
      _BlobSpec(
        w: 600, h: 300, angleDeg: 15,
        topFrac: 0.10, leftFrac: 0.05,
        light: lightBlobs[0], dark: darkBlobs[0],
      ),
      _BlobSpec(
        w: 800, h: 250, angleDeg: 10,
        topFrac: 0.30, leftFrac: -0.10, narrowLeftFrac: -0.05,
        light: lightBlobs[1], dark: darkBlobs[1],
      ),
      _BlobSpec(
        w: 500, h: 400,
        topFrac: 0.65, leftFrac: -0.05,
        light: lightBlobs[2], dark: darkBlobs[2],
      ),
      _BlobSpec(
        w: 800, h: 600,
        topFrac: -0.15, rightFrac: 0.05, narrowRightFrac: 0.15,
        light: lightBlobs[3], dark: darkBlobs[3],
      ),
      _BlobSpec(
        w: 500, h: 400,
        topFrac: 0.20, rightFrac: 0.20, narrowRightFrac: 0.25,
        light: lightBlobs[3], dark: darkBlobs[3],
      ),
      _BlobSpec(
        w: 300, h: 500,
        topFrac: 0.50, rightFrac: -0.05,
        light: lightBlobs[4], dark: darkBlobs[4],
      ),
      _BlobSpec(
        w: 600, h: 250,
        topFrac: 0.75, rightFrac: 0.05, narrowRightFrac: 0.12,
        light: lightBlobs[4], dark: darkBlobs[4],
      ),
    ];

    return AnimatedContainer(
      duration: const Duration(milliseconds: 500),
      decoration: isDark
          ? const BoxDecoration(color: darkBase)
          : const BoxDecoration(gradient: lightGradient),
      child: Stack(
        children: [
          Positioned.fill(
            child: ClipRect(
              child: Stack(
                clipBehavior: Clip.hardEdge,
                children: [
                  for (final spec in specs)
                    Positioned(
                      top: sh * spec.topFrac,
                      left: spec.leftFrac == null
                          ? null
                          : sw *
                              (narrow
                                  ? spec.narrowLeftFrac ?? spec.leftFrac!
                                  : spec.leftFrac!),
                      right: spec.rightFrac == null
                          ? null
                          : sw *
                              (narrow
                                  ? spec.narrowRightFrac ?? spec.rightFrac!
                                  : spec.rightFrac!),
                      child: _AuthBlurBlob(
                        width: spec.w * s,
                        height: spec.h * s,
                        color: isDark ? spec.dark : spec.light,
                        angle: spec.angleDeg * (3.14159 / 180),
                      ),
                    ),
                ],
              ),
            ),
          ),
          child,
        ],
      ),
    );
  }
}

class _BlobSpec {
  final double w;
  final double h;
  final double angleDeg;
  final double topFrac;
  final double? leftFrac;
  final double? rightFrac;
  final double? narrowLeftFrac;
  final double? narrowRightFrac;
  final Color light;
  final Color dark;

  const _BlobSpec({
    required this.w,
    required this.h,
    this.angleDeg = 0,
    required this.topFrac,
    this.leftFrac,
    this.rightFrac,
    this.narrowLeftFrac,
    this.narrowRightFrac,
    required this.light,
    required this.dark,
  });
}

class _AuthBlurBlob extends StatelessWidget {
  final double width;
  final double height;
  final Color color;
  final double angle;

  const _AuthBlurBlob({
    required this.width,
    required this.height,
    required this.color,
    this.angle = 0,
  });

  @override
  Widget build(BuildContext context) {
    return Transform.rotate(
      angle: angle,
      child: ImageFiltered(
        imageFilter: ImageFilter.blur(sigmaX: 60, sigmaY: 60),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 500),
          width: width,
          height: height,
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.all(Radius.elliptical(width, height)),
          ),
        ),
      ),
    );
  }
}
