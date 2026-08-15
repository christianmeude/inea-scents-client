import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../providers/index.dart';

class RegisterScreen extends ConsumerStatefulWidget {
  const RegisterScreen({super.key});

  @override
  ConsumerState<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends ConsumerState<RegisterScreen> {
  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  bool _obscurePassword = true;

  // The authentication screens use the app's light design only.
  static const bool isDarkMode = false;

  @override
  void dispose() {
    nameController.dispose();
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final authState = ref.watch(authProvider);

    ref.listen(authProvider, (previous, next) {
      if (next.isLoggedIn) {
        context.go('/home');
      } else if (next.errorMessage != null) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(next.errorMessage ?? 'Error'),
            behavior: SnackBarBehavior.floating,
            backgroundColor: isDarkMode
                ? const Color(0xFF9A607B)
                : const Color(0xFF74445C),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
        );
      }
    });

    // ============================================================
    // THEME COLORS
    // ============================================================

    final backgroundTop = isDarkMode
        ? const Color(0xFF21171D)
        : const Color(0xFFF8E9DF);

    final backgroundMiddle = isDarkMode
        ? const Color(0xFF4A3040)
        : const Color(0xFFD8B0BA);

    final backgroundBottom = isDarkMode
        ? const Color(0xFF2B1D25)
        : const Color(0xFFB78C9C);

    final primaryColor = isDarkMode
        ? const Color(0xFFB77D99)
        : const Color(0xFF74445C);

    final textColor = isDarkMode
        ? const Color(0xFFF1DDE5)
        : const Color(0xFF633E50);

    final secondaryTextColor = isDarkMode
        ? const Color(0xFFD0B5C1)
        : const Color(0xFF765867);

    final inputColor = isDarkMode
        ? const Color(0xFF654656)
        : const Color(0xFF95647E);

    return Theme(
      data: ThemeData.light(useMaterial3: true),
      child: Scaffold(
        resizeToAvoidBottomInset: true,
        body: Stack(
          children: [
            // ========================================================
            // GRADIENT BACKGROUND
            // ========================================================
            Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [backgroundTop, backgroundMiddle, backgroundBottom],
                ),
              ),
            ),

            // ========================================================
            // TOP-LEFT GLOW
            // ========================================================
            Positioned(
              top: -130,
              left: -120,
              child: _BlurCircle(
                size: 400,
                color: isDarkMode
                    ? const Color(0xFF71485D).withValues(alpha: 0.45)
                    : const Color(0xFFEBC9B8).withValues(alpha: 0.75),
              ),
            ),

            // ========================================================
            // TOP-RIGHT GLOW
            // ========================================================
            Positioned(
              top: 100,
              right: -140,
              child: _BlurCircle(
                size: 380,
                color: isDarkMode
                    ? const Color(0xFF87556C).withValues(alpha: 0.35)
                    : const Color(0xFFD3A4AF).withValues(alpha: 0.75),
              ),
            ),

            // ========================================================
            // BOTTOM-LEFT GLOW
            // ========================================================
            Positioned(
              bottom: -150,
              left: -120,
              child: _BlurCircle(
                size: 430,
                color: isDarkMode
                    ? const Color(0xFF4A3541).withValues(alpha: 0.60)
                    : const Color(0xFF9C8491).withValues(alpha: 0.70),
              ),
            ),

            // ========================================================
            // BOTTOM-RIGHT GLOW
            // ========================================================
            Positioned(
              bottom: -130,
              right: -100,
              child: _BlurCircle(
                size: 430,
                color: isDarkMode
                    ? const Color(0xFF6D3D55).withValues(alpha: 0.45)
                    : const Color(0xFF69384F).withValues(alpha: 0.70),
              ),
            ),

            // ========================================================
            // CENTER WHITE GLOW
            // ========================================================
            Positioned(
              top: MediaQuery.of(context).size.height * 0.30,
              left: MediaQuery.of(context).size.width * 0.18,
              child: _BlurCircle(
                size: 430,
                color: isDarkMode
                    ? Colors.white.withValues(alpha: 0.025)
                    : Colors.white.withValues(alpha: 0.30),
              ),
            ),

            // ========================================================
            // MAIN CONTENT
            // ========================================================
            SafeArea(
              child: Center(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 28,
                    vertical: 20,
                  ),
                  child: ConstrainedBox(
                    constraints: const BoxConstraints(maxWidth: 370),
                    child: Column(
                      children: [
                        const SizedBox(height: 5),

                        // ==================================================
                        // INEA SCENTS BRAND NAME
                        // ==================================================
                        _BrandName(isDarkMode: isDarkMode),

                        const SizedBox(height: 28),

                        // ==================================================
                        // FULL NAME
                        // ==================================================
                        _InputLabel(text: 'Full Name', color: textColor),

                        const SizedBox(height: 7),

                        _RegisterTextField(
                          controller: nameController,
                          isDarkMode: isDarkMode,
                          fillColor: inputColor,
                          textInputAction: TextInputAction.next,
                        ),

                        const SizedBox(height: 21),

                        // ==================================================
                        // EMAIL
                        // ==================================================
                        _InputLabel(text: 'Email', color: textColor),

                        const SizedBox(height: 7),

                        _RegisterTextField(
                          controller: emailController,
                          isDarkMode: isDarkMode,
                          fillColor: inputColor,
                          keyboardType: TextInputType.emailAddress,
                          textInputAction: TextInputAction.next,
                        ),

                        const SizedBox(height: 21),

                        // ==================================================
                        // PASSWORD
                        // ==================================================
                        _InputLabel(text: 'Password', color: textColor),

                        const SizedBox(height: 7),

                        _RegisterTextField(
                          controller: passwordController,
                          isDarkMode: isDarkMode,
                          fillColor: inputColor,
                          obscureText: _obscurePassword,
                          textInputAction: TextInputAction.done,
                          suffixIcon: IconButton(
                            onPressed: () {
                              setState(() {
                                _obscurePassword = !_obscurePassword;
                              });
                            },
                            icon: Icon(
                              _obscurePassword
                                  ? Icons.visibility_outlined
                                  : Icons.visibility_off_outlined,
                              color: Colors.white.withValues(alpha: 0.9),
                              size: 20,
                            ),
                          ),
                        ),

                        const SizedBox(height: 35),

                        // ==================================================
                        // REGISTER BUTTON
                        // ==================================================
                        SizedBox(
                          width: double.infinity,
                          height: 50,
                          child: ElevatedButton(
                            onPressed: authState.isLoading
                                ? null
                                : () {
                                    ref
                                        .read(authProvider.notifier)
                                        .register(
                                          name: nameController.text.trim(),
                                          email: emailController.text.trim(),
                                          password: passwordController.text,
                                        );
                                  },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: primaryColor,
                              disabledBackgroundColor: primaryColor.withValues(
                                alpha: 0.60,
                              ),
                              foregroundColor: Colors.white,
                              elevation: 3,
                              shadowColor: primaryColor.withValues(alpha: 0.30),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(25),
                              ),
                            ),
                            child: authState.isLoading
                                ? const SizedBox(
                                    width: 20,
                                    height: 20,
                                    child: CircularProgressIndicator(
                                      strokeWidth: 2,
                                      valueColor: AlwaysStoppedAnimation<Color>(
                                        Colors.white,
                                      ),
                                    ),
                                  )
                                : const Text(
                                    'REGISTER',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 13,
                                      fontWeight: FontWeight.w700,
                                      letterSpacing: 1.3,
                                    ),
                                  ),
                          ),
                        ),

                        const SizedBox(height: 20),

                        // ==================================================
                        // LOGIN LINK
                        // ==================================================
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              'Already have an account? ',
                              style: TextStyle(
                                color: secondaryTextColor,
                                fontSize: 14,
                              ),
                            ),
                            GestureDetector(
                              onTap: () {
                                context.go('/login');
                              },
                              child: Text(
                                'Login',
                                style: TextStyle(
                                  color: textColor,
                                  fontSize: 14,
                                  fontWeight: FontWeight.w600,
                                  decoration: TextDecoration.underline,
                                  decorationColor: textColor,
                                ),
                              ),
                            ),
                          ],
                        ),

                        const SizedBox(height: 15),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ============================================================================
// INEA SCENTS BRAND NAME
// ============================================================================

class _BrandName extends StatelessWidget {
  final bool isDarkMode;

  const _BrandName({required this.isDarkMode});

  @override
  Widget build(BuildContext context) {
    final brandColor = isDarkMode
        ? const Color(0xFFE7C3D1)
        : const Color(0xFF6D3E55);

    return SizedBox(
      width: double.infinity,
      height: 125,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // ==========================================================
          // INEA
          // ==========================================================
          Text(
            'INEA',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 52,
              fontWeight: FontWeight.w400,
              letterSpacing: 9,
              height: 0.9,
              color: brandColor,
            ),
          ),

          const SizedBox(height: 2),

          // ==========================================================
          // SCENTS
          // ==========================================================
          Text(
            'Scents',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 48,
              fontStyle: FontStyle.italic,
              fontWeight: FontWeight.w300,
              fontFamily: 'serif',
              letterSpacing: 0.5,
              height: 1.0,
              color: brandColor,
            ),
          ),
        ],
      ),
    );
  }
}

// ============================================================================
// INPUT LABEL
// ============================================================================

class _InputLabel extends StatelessWidget {
  final String text;
  final Color color;

  const _InputLabel({required this.text, required this.color});

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.centerLeft,
      child: Text(
        text,
        style: TextStyle(
          color: color,
          fontSize: 14,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }
}

// ============================================================================
// REGISTER TEXT FIELD
// ============================================================================

class _RegisterTextField extends StatelessWidget {
  final TextEditingController controller;

  final bool isDarkMode;
  final Color fillColor;

  final bool obscureText;
  final Widget? suffixIcon;

  final TextInputType? keyboardType;
  final TextInputAction? textInputAction;

  const _RegisterTextField({
    required this.controller,
    required this.isDarkMode,
    required this.fillColor,
    this.obscureText = false,
    this.suffixIcon,
    this.keyboardType,
    this.textInputAction,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 54,
      child: TextField(
        controller: controller,
        obscureText: obscureText,
        keyboardType: keyboardType,
        textInputAction: textInputAction,
        style: const TextStyle(color: Colors.white, fontSize: 15),
        cursorColor: Colors.white,
        decoration: InputDecoration(
          filled: true,
          fillColor: fillColor,

          contentPadding: const EdgeInsets.symmetric(
            horizontal: 20,
            vertical: 15,
          ),

          suffixIcon: suffixIcon,

          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(30),
            borderSide: BorderSide(
              color: Colors.white.withValues(alpha: isDarkMode ? 0.35 : 0.85),
              width: 1.2,
            ),
          ),

          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(30),
            borderSide: const BorderSide(color: Colors.white, width: 1.5),
          ),
        ),
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
