import 'dart:ui';
import 'package:flutter/material.dart';
import '../config/index.dart';

class AmbientBackground extends StatelessWidget {
  final Widget child;
  final PreferredSizeWidget? appBar;
  final Widget? bottomNavigationBar;

  const AmbientBackground({
    super.key,
    required this.child,
    this.appBar,
    this.bottomNavigationBar,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.backgroundTop,
      appBar: appBar,
      bottomNavigationBar: bottomNavigationBar,
      body: Stack(
        children: [
          // GRADIENT BACKGROUND
          Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  AppTheme.backgroundTop,
                  AppTheme.backgroundMiddle,
                  AppTheme.backgroundBottom,
                ],
                stops: [0.0, 0.52, 1.0],
              ),
            ),
          ),

          // TOP LEFT GLOW
          Positioned(
            top: -130,
            left: -120,
            child: _SoftCircle(
              size: 390,
              color: const Color(0xFFEBC9B8).withValues(alpha: 0.72),
            ),
          ),

          // TOP RIGHT GLOW
          Positioned(
            top: 80,
            right: -145,
            child: _SoftCircle(
              size: 370,
              color: const Color(0xFFD3A4AF).withValues(alpha: 0.68),
            ),
          ),

          // CENTER LIGHT GLOW
          Positioned(
            top: 260,
            left: 80,
            child: _SoftCircle(
              size: 390,
              color: Colors.white.withValues(alpha: 0.25),
            ),
          ),

          // BOTTOM LEFT GLOW
          Positioned(
            bottom: -180,
            left: -130,
            child: _SoftCircle(
              size: 430,
              color: const Color(0xFF9C8491).withValues(alpha: 0.42),
            ),
          ),

          // BOTTOM RIGHT GLOW
          Positioned(
            bottom: -160,
            right: -120,
            child: _SoftCircle(
              size: 430,
              color: const Color(0xFF69384F).withValues(alpha: 0.28),
            ),
          ),

          // MAIN CONTENT
          child,
        ],
      ),
    );
  }
}

class _SoftCircle extends StatelessWidget {
  final double size;
  final Color color;

  const _SoftCircle({required this.size, required this.color});

  @override
  Widget build(BuildContext context) {
    return ImageFiltered(
      imageFilter: ImageFilter.blur(sigmaX: 70, sigmaY: 70),
      child: Container(
        width: size,
        height: size,
        decoration: BoxDecoration(shape: BoxShape.circle, color: color),
      ),
    );
  }
}
