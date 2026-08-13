import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;

  late Animation<double> _fadeAnimation;
  late Animation<double> _scaleAnimation;
  late Animation<double> _glowAnimation;

  @override
  void initState() {
    super.initState();

    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2200),
    );

    _fadeAnimation = CurvedAnimation(
      parent: _animationController,
      curve: const Interval(0.15, 0.75, curve: Curves.easeOut),
    );

    _scaleAnimation = Tween<double>(begin: 0.88, end: 1.0).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: const Interval(0.0, 0.75, curve: Curves.easeOutCubic),
      ),
    );

    _glowAnimation = Tween<double>(begin: 0.15, end: 0.40).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: const Interval(0.20, 0.85, curve: Curves.easeInOut),
      ),
    );

    _animationController.forward();

    _navigateToLogin();
  }

  Future<void> _navigateToLogin() async {
    await Future.delayed(const Duration(seconds: 3));

    if (mounted) {
      context.go('/login');
    }
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: AnimatedBuilder(
        animation: _animationController,
        builder: (context, child) {
          return Stack(
            children: [
              // ========================================================
              // BACKGROUND
              // ========================================================
              Container(
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      Color(0xFFF8E9DF),
                      Color(0xFFE8CDD2),
                      Color(0xFFD7B4C0),
                      Color(0xFF9C7285),
                      Color(0xFF6D3E55),
                    ],
                    stops: [0.0, 0.25, 0.52, 0.78, 1.0],
                  ),
                ),
              ),

              // ========================================================
              // TOP LEFT BLUR
              // ========================================================
              Positioned(
                top: -160,
                left: -140,
                child: _BlurCircle(
                  size: 420,
                  color: Colors.white.withOpacity(0.30),
                ),
              ),

              // ========================================================
              // TOP RIGHT BLUR
              // ========================================================
              Positioned(
                top: 80,
                right: -170,
                child: _BlurCircle(
                  size: 400,
                  color: const Color(0xFFECCBD4).withOpacity(0.45),
                ),
              ),

              // ========================================================
              // CENTER GLOW
              // ========================================================
              Positioned(
                top: MediaQuery.of(context).size.height * 0.22,
                left: MediaQuery.of(context).size.width * 0.12,
                child: _BlurCircle(
                  size: 430,
                  color: Colors.white.withOpacity(_glowAnimation.value),
                ),
              ),

              // ========================================================
              // BOTTOM LEFT BLUR
              // ========================================================
              Positioned(
                bottom: -180,
                left: -150,
                child: _BlurCircle(
                  size: 450,
                  color: const Color(0xFFB78C9C).withOpacity(0.50),
                ),
              ),

              // ========================================================
              // BOTTOM RIGHT BLUR
              // ========================================================
              Positioned(
                bottom: -150,
                right: -130,
                child: _BlurCircle(
                  size: 440,
                  color: const Color(0xFF5E344A).withOpacity(0.40),
                ),
              ),

              // ========================================================
              // SUBTLE GLASS EFFECT
              // ========================================================
              Positioned.fill(
                child: IgnorePointer(
                  child: BackdropFilter(
                    filter: ImageFilter.blur(sigmaX: 0, sigmaY: 0),
                    child: Container(color: Colors.white.withOpacity(0.015)),
                  ),
                ),
              ),

              // ========================================================
              // MAIN BRAND
              // ========================================================
              Center(
                child: FadeTransition(
                  opacity: _fadeAnimation,
                  child: ScaleTransition(
                    scale: _scaleAnimation,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        // ------------------------------------------------
                        // SMALL DECORATIVE LINE
                        // ------------------------------------------------
                        Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Container(
                              width: 42,
                              height: 1,
                              color: Colors.white.withOpacity(0.55),
                            ),

                            const SizedBox(width: 12),

                            Container(
                              width: 5,
                              height: 5,
                              decoration: BoxDecoration(
                                color: Colors.white.withOpacity(0.75),
                                shape: BoxShape.circle,
                              ),
                            ),

                            const SizedBox(width: 12),

                            Container(
                              width: 42,
                              height: 1,
                              color: Colors.white.withOpacity(0.55),
                            ),
                          ],
                        ),

                        const SizedBox(height: 25),

                        // ------------------------------------------------
                        // INEA
                        // ------------------------------------------------
                        Text(
                          'INEA',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontFamily: 'serif',
                            fontSize: 67,
                            fontWeight: FontWeight.w400,
                            letterSpacing: 12,
                            height: 0.95,
                            color: Colors.white,
                            shadows: [
                              Shadow(
                                color: const Color(
                                  0xFF4C283A,
                                ).withOpacity(0.25),
                                blurRadius: 12,
                                offset: const Offset(0, 5),
                              ),
                            ],
                          ),
                        ),

                        // ------------------------------------------------
                        // SCENTS
                        // ------------------------------------------------
                        Transform.translate(
                          offset: const Offset(8, -2),
                          child: Text(
                            'Scents',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontFamily: 'serif',
                              fontSize: 48,
                              fontStyle: FontStyle.italic,
                              fontWeight: FontWeight.w300,
                              letterSpacing: 1.5,
                              height: 1,
                              color: Colors.white.withOpacity(0.96),
                              shadows: [
                                Shadow(
                                  color: const Color(
                                    0xFF4C283A,
                                  ).withOpacity(0.25),
                                  blurRadius: 10,
                                  offset: const Offset(0, 4),
                                ),
                              ],
                            ),
                          ),
                        ),

                        const SizedBox(height: 25),

                        // ------------------------------------------------
                        // DECORATIVE LINE
                        // ------------------------------------------------
                        Container(
                          width: 125,
                          height: 1,
                          color: Colors.white.withOpacity(0.55),
                        ),

                        const SizedBox(height: 15),

                        // ------------------------------------------------
                        // TAGLINE
                        // ------------------------------------------------
                        Text(
                          'THE ART OF PERSONAL FRAGRANCE',
                          style: TextStyle(
                            fontSize: 9,
                            fontWeight: FontWeight.w500,
                            letterSpacing: 2.4,
                            color: Colors.white.withOpacity(0.82),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),

              // ========================================================
              // BOTTOM BRAND DETAIL
              // ========================================================
              Positioned(
                left: 0,
                right: 0,
                bottom: 38,
                child: FadeTransition(
                  opacity: _fadeAnimation,
                  child: Column(
                    children: [
                      Text(
                        'EST. 2025',
                        style: TextStyle(
                          fontSize: 8,
                          letterSpacing: 2,
                          fontWeight: FontWeight.w500,
                          color: Colors.white.withOpacity(0.55),
                        ),
                      ),

                      const SizedBox(height: 8),

                      Container(
                        width: 4,
                        height: 4,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.white.withOpacity(0.45),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}

// ============================================================================
// BLURRED BACKGROUND CIRCLE
// ============================================================================

class _BlurCircle extends StatelessWidget {
  final double size;
  final Color color;

  const _BlurCircle({required this.size, required this.color});

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
