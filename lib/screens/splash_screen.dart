import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';

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
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Color(0xFFF1E3D3), // Nude/Peach
                      Color(0xFFE4C3C7),
                      Color(0xFFC7A2AE),
                      Color(0xFF90697B),
                      Color(0xFF653A4C), // Plum
                    ],
                    stops: [0.0, 0.3, 0.55, 0.8, 1.0],
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
                    child: SizedBox(
                      width: 280,
                      height: 120,
                      child: Stack(
                        alignment: Alignment.center,
                        children: [
                          Positioned(
                            top: 20,
                            left: 30,
                            child: Text(
                              'INEA',
                              style: GoogleFonts.josefinSans(
                                fontSize: 68,
                                fontWeight: FontWeight.w900,
                                letterSpacing: 6,
                                height: 1,
                                color: Colors.white,
                                shadows: const [
                                  Shadow(
                                    color: Color(0xB3653A4C),
                                    blurRadius: 12,
                                    offset: Offset(0, 2),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          Positioned(
                            bottom: 10,
                            right: 20,
                            child: Text(
                              'Scents',
                              style: GoogleFonts.greatVibes(
                                fontSize: 66,
                                fontWeight: FontWeight.w400,
                                height: 1,
                                color: Colors.white,
                                shadows: const [
                                  Shadow(
                                    color: Color(0xB3653A4C),
                                    blurRadius: 12,
                                    offset: Offset(0, 2),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
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
