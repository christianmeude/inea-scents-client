import 'dart:ui';

import 'package:flutter/material.dart';

/// C89: exact admin parity (option b locked) — supersedes C88's light
/// gradient (GuestLayout.vue paints a solid base, never a gradient).
///
/// Admin source: `resources/js/Layouts/GuestLayout.vue:8-35`
/// (solid `bg-brand-cream` / `dark:bg-brand-dark-base` + 8 `blur-[60px]`
/// blobs) with palette from `tailwind.config.js:38-39`
/// (`brand.cream #fdf4f5`, `brand.dark-base #151012`,
/// `brand.primary #6a4053`, `burgundy.900 #6f2431`,
/// `burgundy.950 #3e1018`).
///
/// Light blobs are the admin opaque fills (#DABDAC, #C08D9E, #988088,
/// #C4A5A8, #6E3C53); the 60px blur softens them, no alpha needed.
/// Dark blobs are the admin translucent fills (burgundy-900/40,
/// brand-primary/50, #4A2D3C/60, burgundy-950/70, brand-primary/60).
///
/// Contrast vs the light >= 5.7 budget (plum #6A4053 on surface —
/// REPORTED, never restyled): solid base 7.87 (passes); opaque blob
/// cores miss — #DABDAC 4.80, #C08D9E 3.05, #988088 2.34, #C4A5A8 3.76,
/// #6E3C53 1.02. Dark cream-on-mesh stays AAA (>= 11 on every tint).
///
/// Blob geometry is the admin % anchors/sizes/rotations; below 640px the
/// blobs shrink ([blobScaleForWidth]) and the off-screen-anchored pair is
/// pulled inward so the composition stays behind the 336px column instead
/// of spilling past the viewport edge. Everything is clipped, so narrow
/// widths cannot overflow.
class AuthBackground extends StatelessWidget {
  final bool isDark;
  final Widget child;

  const AuthBackground({super.key, required this.isDark, required this.child});

  /// C89 admin solid bases (tailwind brand.cream / brand.dark-base).
  static const Color lightBase = Color(0xFFFDF4F5);
  static const Color darkBase = Color(0xFF151012);

  /// C89 admin light blobs — opaque fills, blur-softened (GuestLayout:20-35).
  static const List<Color> lightBlobs = <Color>[
    Color(0xFFDABDAC),
    Color(0xFFC08D9E),
    Color(0xFF988088),
    Color(0xFFC4A5A8),
    Color(0xFF6E3C53),
  ];

  /// C89 admin dark blobs — burgundy-900/40, brand-primary/50,
  /// #4A2D3C/60, burgundy-950/70, brand-primary/60.
  static const List<Color> darkBlobs = <Color>[
    Color(0x666F2431),
    Color(0x806A4053),
    Color(0x994A2D3C),
    Color(0xB33E1018),
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
      // C89: solid admin base both modes (no gradient).
      decoration: BoxDecoration(
        color: isDark ? darkBase : lightBase,
      ),
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
