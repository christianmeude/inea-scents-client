import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../providers/index.dart';

class LoginScreen extends ConsumerStatefulWidget {
  const LoginScreen({super.key});

  @override
  ConsumerState<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  bool obscurePassword = true;
  bool rememberMe = false;

  // The authentication screens use the app's light design only.
  static const bool isDarkMode = false;

  @override
  void dispose() {
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
    // COLORS
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
        body: Stack(
          children: [
            // ======================================================
            // GRADIENT BACKGROUND
            // ======================================================
            Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [backgroundTop, backgroundMiddle, backgroundBottom],
                ),
              ),
            ),

            // ======================================================
            // DECORATIVE BLURRED CIRCLES
            // ======================================================
            Positioned(
              top: -140,
              left: -130,
              child: _BlurCircle(
                size: 400,
                color: isDarkMode
                    ? const Color(0xFF71485D).withValues(alpha: 0.45)
                    : const Color(0xFFEBC9B8).withValues(alpha: 0.75),
              ),
            ),

            Positioned(
              top: 100,
              right: -160,
              child: _BlurCircle(
                size: 380,
                color: isDarkMode
                    ? const Color(0xFF87556C).withValues(alpha: 0.35)
                    : const Color(0xFFD3A4AF).withValues(alpha: 0.75),
              ),
            ),

            Positioned(
              bottom: -170,
              left: -130,
              child: _BlurCircle(
                size: 430,
                color: isDarkMode
                    ? const Color(0xFF4A3541).withValues(alpha: 0.60)
                    : const Color(0xFF9C8491).withValues(alpha: 0.70),
              ),
            ),

            Positioned(
              bottom: -150,
              right: -120,
              child: _BlurCircle(
                size: 420,
                color: isDarkMode
                    ? const Color(0xFF6D3D55).withValues(alpha: 0.45)
                    : const Color(0xFF69384F).withValues(alpha: 0.70),
              ),
            ),

            // ======================================================
            // MAIN CONTENT
            // ======================================================
            SafeArea(
              child: Center(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 28,
                    vertical: 25,
                  ),
                  child: ConstrainedBox(
                    constraints: const BoxConstraints(maxWidth: 380),
                    child: Column(
                      children: [
                        const SizedBox(height: 25),

                        // ==================================================
                        // INEA SCENTS BRAND NAME
                        // ==================================================
                        _BrandName(isDarkMode: isDarkMode),

                        const SizedBox(height: 25),

                        // ==================================================
                        // EMAIL
                        // ==================================================
                        _InputLabel(text: 'Email', color: textColor),

                        const SizedBox(height: 8),

                        _CustomTextField(
                          controller: emailController,
                          isDarkMode: isDarkMode,
                          fillColor: inputColor,
                          keyboardType: TextInputType.emailAddress,
                          textInputAction: TextInputAction.next,
                        ),

                        const SizedBox(height: 22),

                        // ==================================================
                        // PASSWORD
                        // ==================================================
                        _InputLabel(text: 'Password', color: textColor),

                        const SizedBox(height: 8),

                        _CustomTextField(
                          controller: passwordController,
                          isDarkMode: isDarkMode,
                          fillColor: inputColor,
                          obscureText: obscurePassword,
                          suffixIcon: IconButton(
                            onPressed: () {
                              setState(() {
                                obscurePassword = !obscurePassword;
                              });
                            },
                            icon: Icon(
                              obscurePassword
                                  ? Icons.visibility_outlined
                                  : Icons.visibility_off_outlined,
                              color: Colors.white,
                              size: 21,
                            ),
                          ),
                        ),

                        const SizedBox(height: 15),

                        // ==================================================
                        // REMEMBER ME / FORGOT PASSWORD
                        // ==================================================
                        Row(
                          children: [
                            SizedBox(
                              width: 24,
                              height: 24,
                              child: Checkbox(
                                value: rememberMe,
                                onChanged: (value) {
                                  setState(() {
                                    rememberMe = value ?? false;
                                  });
                                },
                                activeColor: primaryColor,
                                side: BorderSide(color: textColor, width: 1.5),
                              ),
                            ),

                            const SizedBox(width: 8),

                            Text(
                              'Remember me',
                              style: TextStyle(
                                color: secondaryTextColor,
                                fontSize: 13,
                              ),
                            ),

                            const Spacer(),

                            GestureDetector(
                              onTap: () {
                                // Add forgot password later.
                              },
                              child: Text(
                                'Forgot password?',
                                style: TextStyle(
                                  color: textColor,
                                  fontSize: 13,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                          ],
                        ),

                        const SizedBox(height: 28),

                        // ==================================================
                        // LOGIN BUTTON
                        // ==================================================
                        SizedBox(
                          width: double.infinity,
                          height: 52,
                          child: ElevatedButton(
                            onPressed: authState.isLoading
                                ? null
                                : () {
                                    ref
                                        .read(authProvider.notifier)
                                        .login(
                                          email: emailController.text.trim(),
                                          password: passwordController.text,
                                        );
                                  },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: primaryColor,
                              foregroundColor: Colors.white,
                              elevation: 4,
                              shadowColor: primaryColor.withValues(alpha: 0.35),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(28),
                              ),
                            ),
                            child: authState.isLoading
                                ? const SizedBox(
                                    height: 21,
                                    width: 21,
                                    child: CircularProgressIndicator(
                                      strokeWidth: 2.2,
                                      color: Colors.white,
                                    ),
                                  )
                                : const Text(
                                    'LOG IN',
                                    style: TextStyle(
                                      fontSize: 15,
                                      fontWeight: FontWeight.bold,
                                      letterSpacing: 1.3,
                                    ),
                                  ),
                          ),
                        ),

                        const SizedBox(height: 22),

                        // ==================================================
                        // REGISTER
                        // ==================================================
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              "Don't have an account? ",
                              style: TextStyle(
                                color: secondaryTextColor,
                                fontSize: 14,
                              ),
                            ),

                            GestureDetector(
                              onTap: () {
                                context.go('/register');
                              },
                              child: Text(
                                'Register',
                                style: TextStyle(
                                  color: textColor,
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold,
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
          // INEA
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

          // Scents
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
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}

// ============================================================================
// CUSTOM TEXT FIELD
// ============================================================================

class _CustomTextField extends StatelessWidget {
  final TextEditingController controller;
  final bool isDarkMode;
  final Color fillColor;

  final bool obscureText;
  final Widget? suffixIcon;

  final TextInputType? keyboardType;
  final TextInputAction? textInputAction;

  const _CustomTextField({
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

          hintStyle: TextStyle(color: Colors.white.withValues(alpha: 0.75)),

          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(30),
            borderSide: BorderSide(
              color: Colors.white.withValues(alpha: isDarkMode ? 0.35 : 0.75),
              width: 1.1,
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
