import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:url_launcher/url_launcher.dart';
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
            backgroundColor: const Color(0xFF6A4053),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
        );
      }
    });

    // Inertia theme colors
    const bgColor = Color(0xFFFDF4F5); // brand-cream
    const primaryColor = Color(0xFF6A4053); // brand-primary

    return Theme(
      data: ThemeData.light(useMaterial3: true),
      child: Scaffold(
        backgroundColor: bgColor,
        body: Stack(
          children: [
            // ======================================================
            // MESH GRADIENT BLOBS
            // ======================================================
            
            // Top Left Peach
            Positioned(
              top: -100,
              left: -50,
              child: _BlurBlob(
                width: 300,
                height: 600,
                color: const Color(0xFFDABDAC),
                angle: 30 * (3.14159 / 180),
              ),
            ),
            Positioned(
              top: 100,
              left: 50,
              child: _BlurBlob(
                width: 600,
                height: 300,
                color: const Color(0xFFDABDAC),
                angle: 15 * (3.14159 / 180),
              ),
            ),
            
            // Middle Left Mauve
            Positioned(
              top: MediaQuery.of(context).size.height * 0.3,
              left: -100,
              child: _BlurBlob(
                width: 800,
                height: 250,
                color: const Color(0xFFC08D9E),
                angle: 10 * (3.14159 / 180),
              ),
            ),
            
            // Bottom Left Gray-Purple
            Positioned(
              top: MediaQuery.of(context).size.height * 0.65,
              left: -50,
              child: _BlurBlob(
                width: 500,
                height: 400,
                color: const Color(0xFF988088),
              ),
            ),

            // Top Right Pale Rose
            Positioned(
              top: -100,
              right: 50,
              child: _BlurBlob(
                width: 800,
                height: 600,
                color: const Color(0xFFC4A5A8),
              ),
            ),
            Positioned(
              top: 200,
              right: 200,
              child: _BlurBlob(
                width: 500,
                height: 400,
                color: const Color(0xFFC4A5A8),
              ),
            ),

            // Bottom Right Dark Plum
            Positioned(
              top: MediaQuery.of(context).size.height * 0.5,
              right: -50,
              child: _BlurBlob(
                width: 300,
                height: 500,
                color: const Color(0xFF6E3C53),
              ),
            ),
            Positioned(
              top: MediaQuery.of(context).size.height * 0.75,
              right: 50,
              child: _BlurBlob(
                width: 600,
                height: 250,
                color: const Color(0xFF6E3C53),
              ),
            ),

            // ======================================================
            // MAIN CONTENT
            // ======================================================
            SafeArea(
              child: Center(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 24,
                    vertical: 48,
                  ),
                  child: ConstrainedBox(
                    constraints: const BoxConstraints(maxWidth: 384),
                    child: Column(
                      children: [
                        // ==================================================
                        // APPLICATION LOGO
                        // ==================================================
                        const _ApplicationLogo(),

                        const SizedBox(height: 40),

                        // ==================================================
                        // EMAIL
                        // ==================================================
                        const _InputLabel(text: 'Email', color: Color(0xFF374151)), // gray-700
                        const SizedBox(height: 4),

                        _CustomTextField(
                          controller: emailController,
                          keyboardType: TextInputType.emailAddress,
                          textInputAction: TextInputAction.next,
                        ),

                        const SizedBox(height: 24),

                        // ==================================================
                        // PASSWORD
                        // ==================================================
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const _InputLabel(text: 'Password', color: Color(0xFF374151)),
                            GestureDetector(
                              onTap: () {
                                // Add forgot password later.
                              },
                              child: const Text(
                                'Forgot password?',
                                style: TextStyle(
                                  color: primaryColor,
                                  fontSize: 14,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 4),

                        _CustomTextField(
                          controller: passwordController,
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
                              color: Colors.white.withValues(alpha: 0.7),
                              size: 18,
                            ),
                          ),
                        ),

                        const SizedBox(height: 16),

                        // ==================================================
                        // REMEMBER ME
                        // ==================================================
                        Row(
                          children: [
                            SizedBox(
                              width: 20,
                              height: 20,
                              child: Checkbox(
                                value: rememberMe,
                                onChanged: (value) {
                                  setState(() {
                                    rememberMe = value ?? false;
                                  });
                                },
                                activeColor: primaryColor,
                                side: const BorderSide(color: Color(0xFFD1D5DB), width: 1.5),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(4),
                                ),
                              ),
                            ),
                            const SizedBox(width: 8),
                            const Text(
                              'Remember me',
                              style: TextStyle(
                                color: primaryColor,
                                fontSize: 14,
                              ),
                            ),
                          ],
                        ),

                        const SizedBox(height: 32),

                        // ==================================================
                        // LOGIN BUTTON
                        // ==================================================
                        SizedBox(
                          width: double.infinity,
                          height: 44,
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
                              backgroundColor: const Color(0xFF1F2937), // gray-800
                              foregroundColor: Colors.white,
                              elevation: 0,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(6),
                              ),
                            ),
                            child: authState.isLoading
                                ? const SizedBox(
                                    height: 16,
                                    width: 16,
                                    child: CircularProgressIndicator(
                                      strokeWidth: 2,
                                      color: Colors.white,
                                    ),
                                  )
                                : const Text(
                                    'Log In',
                                    style: TextStyle(
                                      fontSize: 12,
                                      fontWeight: FontWeight.w600,
                                      letterSpacing: 1.1,
                                    ),
                                  ),
                          ),
                        ),

                        const SizedBox(height: 16),

                        // ==================================================
                        // REGISTER & ADMIN LOG IN
                        // ==================================================
                        Text(
                          "Don't have an account?",
                          style: const TextStyle(
                            color: primaryColor,
                            fontSize: 14,
                          ),
                        ),
                        const SizedBox(height: 4),
                        GestureDetector(
                          onTap: () {
                            context.go('/register');
                          },
                          child: const Text(
                            'Register',
                            style: TextStyle(
                              color: primaryColor,
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                              decoration: TextDecoration.underline,
                              decorationColor: primaryColor,
                            ),
                          ),
                        ),
                        
                        const SizedBox(height: 24),
                        
                        GestureDetector(
                          onTap: () async {
                            final url = Uri.parse('/admin/login');
                            if (await canLaunchUrl(url)) {
                              await launchUrl(url, webOnlyWindowName: '_self');
                            }
                          },
                          child: const Text(
                            'Log in as Admin',
                            style: TextStyle(
                              color: primaryColor,
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                              decoration: TextDecoration.underline,
                              decorationColor: primaryColor,
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
        ),
      ),
    );
  }
}

// ============================================================================
// APPLICATION LOGO
// ============================================================================

class _ApplicationLogo extends StatelessWidget {
  const _ApplicationLogo();

  @override
  Widget build(BuildContext context) {
    const brandPrimary = Color(0xFF6A4053);
    const strokeColor = Color(0xFFFDF4F5);

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.baseline,
      textBaseline: TextBaseline.alphabetic,
      children: [
        Stack(
          children: [
            Text(
              'INEA',
              style: TextStyle(
                fontSize: 60,
                fontWeight: FontWeight.bold,
                letterSpacing: 9.0, // approx 0.15em of 60
                foreground: Paint()
                  ..style = PaintingStyle.stroke
                  ..strokeWidth = 2
                  ..color = strokeColor,
              ),
            ),
            const Text(
              'INEA',
              style: TextStyle(
                fontSize: 60,
                fontWeight: FontWeight.bold,
                letterSpacing: 9.0,
                color: brandPrimary,
              ),
            ),
          ],
        ),
        Transform.translate(
          offset: const Offset(-25, 20),
          child: Stack(
            children: [
              Text(
                'Scents',
                style: TextStyle(
                  fontSize: 72,
                  fontFamily: 'cursive', // fallback for great vibes
                  foreground: Paint()
                    ..style = PaintingStyle.stroke
                    ..strokeWidth = 2
                    ..color = strokeColor,
                ),
              ),
              const Text(
                'Scents',
                style: TextStyle(
                  fontSize: 72,
                  fontFamily: 'cursive',
                  color: brandPrimary,
                ),
              ),
            ],
          ),
        ),
      ],
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
// CUSTOM TEXT FIELD (INERTIA STYLE)
// ============================================================================

class _CustomTextField extends StatefulWidget {
  final TextEditingController controller;
  final bool obscureText;
  final Widget? suffixIcon;
  final TextInputType? keyboardType;
  final TextInputAction? textInputAction;

  const _CustomTextField({
    required this.controller,
    this.obscureText = false,
    this.suffixIcon,
    this.keyboardType,
    this.textInputAction,
  });

  @override
  State<_CustomTextField> createState() => _CustomTextFieldState();
}

class _CustomTextFieldState extends State<_CustomTextField> {
  bool isFocused = false;
  
  @override
  Widget build(BuildContext context) {
    return Focus(
      onFocusChange: (hasFocus) {
        setState(() {
          isFocused = hasFocus;
        });
      },
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(30),
          boxShadow: const [
            BoxShadow(
              color: Color(0x0C6A4053), // rgba(106, 64, 83, 0.05)
              blurRadius: 25,
              offset: Offset(0, 10),
            ),
            BoxShadow(
              color: Color(0x056A4053), // rgba(106, 64, 83, 0.02)
              blurRadius: 10,
              offset: Offset(0, 8),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(30),
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 12, sigmaY: 12),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              height: 48,
              decoration: BoxDecoration(
                color: isFocused 
                    ? const Color(0xFF8B5D76).withValues(alpha: 0.90) 
                    : const Color(0xFF8B5D76).withValues(alpha: 0.70),
                borderRadius: BorderRadius.circular(30),
                border: Border.all(
                  color: isFocused 
                      ? Colors.white 
                      : Colors.white.withValues(alpha: 0.20),
                  width: isFocused ? 1.5 : 1.0,
                ),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: widget.controller,
                      obscureText: widget.obscureText,
                      keyboardType: widget.keyboardType,
                      textInputAction: widget.textInputAction,
                      style: const TextStyle(color: Colors.white, fontSize: 16),
                      cursorColor: Colors.white,
                      decoration: InputDecoration(
                        border: InputBorder.none,
                        contentPadding: EdgeInsets.only(
                          left: 20,
                          right: widget.suffixIcon != null ? 0 : 20,
                          bottom: 2,
                        ),
                      ),
                    ),
                  ),
                  if (widget.suffixIcon != null)
                    Padding(
                      padding: const EdgeInsets.only(right: 12),
                      child: widget.suffixIcon,
                    ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

// ============================================================================
// BLURRED BACKGROUND BLOB
// ============================================================================

class _BlurBlob extends StatelessWidget {
  final double width;
  final double height;
  final Color color;
  final double angle;

  const _BlurBlob({
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
        child: Container(
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
