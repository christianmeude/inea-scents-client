import 'dart:ui';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:google_fonts/google_fonts.dart';
import '../providers/index.dart';
import '../src/providers/core_providers.dart';

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

  void _showAdminRestrictedBottomSheet(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return Container(
          decoration: BoxDecoration(
            color: isDark ? const Color(0xFF1A1A1A) : Colors.white,
            borderRadius: const BorderRadius.vertical(top: Radius.circular(28)),
            boxShadow: [
              BoxShadow(
                color: const Color(0xFF6A4053).withValues(alpha: 0.1),
                blurRadius: 20,
                offset: const Offset(0, -5),
              ),
            ],
          ),
          padding: const EdgeInsets.fromLTRB(24, 12, 24, 40),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Drag indicator
              Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: isDark ? Colors.white.withValues(alpha: 0.2) : const Color(0xFF6A4053).withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              const SizedBox(height: 32),
              
              // Warning Icon
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: const Color(0xFF6A4053).withValues(alpha: 0.1),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.desktop_mac_outlined,
                  color: Color(0xFF6A4053),
                  size: 32,
                ),
              ),
              const SizedBox(height: 24),
              
              // Title
              Text(
                'Admin Access Restricted',
                style: GoogleFonts.figtree(
                  fontSize: 22,
                  fontWeight: FontWeight.w700,
                  color: isDark ? const Color(0xFFFDF4F5) : const Color(0xFF6A4053),
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 12),
              
              // Subtitle
              Text(
                'The admin dashboard is heavily optimized for desktop displays. Please log in via the web portal to manage bookings, packages, and clients.',
                style: GoogleFonts.figtree(
                  fontSize: 15,
                  height: 1.5,
                  color: isDark ? const Color(0xFFFDF4F5).withValues(alpha: 0.7) : const Color(0xFF6A4053).withValues(alpha: 0.7),
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 32),
              
              // Primary Button
              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  onPressed: () => Navigator.of(context).pop(),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF6A4053),
                    foregroundColor: Colors.white,
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(9999),
                    ),
                  ),
                  child: Text(
                    'UNDERSTOOD',
                    style: GoogleFonts.figtree(
                      fontSize: 13,
                      fontWeight: FontWeight.w700,
                      letterSpacing: 1.2,
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final authState = ref.watch(authProvider);

    ref.listen(authProvider, (previous, next) async {
      if (next.isLoggedIn) {
        if (next.user?.isAdmin == true) {
          if (kIsWeb) {
            final url = await ref.read(authProvider.notifier).getMagicUrl();
            if (!context.mounted) return;
            if (url != null) {
              await launchUrl(Uri.parse(url), webOnlyWindowName: '_self');
            } else {
              context.go('/home'); // Fallback if magic URL fails
            }
          } else {
            // Block mobile app admin logins and force logout
            ref.read(authProvider.notifier).logout();
            if (!context.mounted) return;
            _showAdminRestrictedBottomSheet(context);
          }
        } else {
          context.go('/home');
        }
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

    final isDark = Theme.of(context).brightness == Brightness.dark;
    final bgColor = isDark ? const Color(0xFF6A4053) : const Color(0xFFFDF4F5);
    final primaryColor = isDark ? const Color(0xFFFDF4F5) : const Color(0xFF6A4053);
    final inputLabelColor = isDark ? const Color(0xFFFDF4F5) : const Color(0xFF6A4053);

    final sw = MediaQuery.of(context).size.width;
    final sh = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: Colors.transparent, // Let AnimatedContainer handle background
      body: AnimatedContainer(
        duration: const Duration(milliseconds: 500),
        color: bgColor,
        child: Stack(
          children: [
            // ======================================================
            // MESH GRADIENT BLOBS
            // ======================================================
            Positioned(
              top: -sh * 0.10,
              left: -sw * 0.05,
              child: _BlurBlob(
                width: 300,
                height: 600,
                color: isDark ? const Color(0x664A1C28) : const Color(0xFF99868C),
                angle: 30 * (3.14159 / 180),
              ),
            ),
            Positioned(
              top: sh * 0.10,
              left: sw * 0.05,
              child: _BlurBlob(
                width: 600,
                height: 300,
                color: isDark ? const Color(0x664A1C28) : const Color(0xFF99868C),
                angle: 15 * (3.14159 / 180),
              ),
            ),
            Positioned(
              top: sh * 0.30,
              left: -sw * 0.10,
              child: _BlurBlob(
                width: 800,
                height: 250,
                color: isDark ? const Color(0x806A4053) : const Color(0xFFC4ACAC),
                angle: 10 * (3.14159 / 180),
              ),
            ),
            Positioned(
              top: sh * 0.65,
              left: -sw * 0.05,
              child: _BlurBlob(
                width: 500,
                height: 400,
                color: isDark ? const Color(0x994A2D3C) : const Color(0xFF99868C),
              ),
            ),
            Positioned(
              top: -sh * 0.15,
              right: sw * 0.05,
              child: _BlurBlob(
                width: 800,
                height: 600,
                color: isDark ? const Color(0xB33B1019) : const Color(0xFFC4ACAC),
              ),
            ),
            Positioned(
              top: sh * 0.20,
              right: sw * 0.20,
              child: _BlurBlob(
                width: 500,
                height: 400,
                color: isDark ? const Color(0xB33B1019) : const Color(0xFFC4ACAC),
              ),
            ),
            Positioned(
              top: sh * 0.50,
              right: -sw * 0.05,
              child: _BlurBlob(
                width: 300,
                height: 500,
                color: isDark ? const Color(0x996A4053) : const Color(0xFF6A4053),
              ),
            ),
            Positioned(
              top: sh * 0.75,
              right: sw * 0.05,
              child: _BlurBlob(
                width: 600,
                height: 250,
                color: isDark ? const Color(0x996A4053) : const Color(0xFF6A4053),
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
                    constraints: const BoxConstraints(maxWidth: 336),
                    child: Column(
                      children: [
                        AppLogo(),
                        const SizedBox(height: 44), // Adjusted to account for the visual overhang of the logo

                        _InputLabel(text: 'Email', color: inputLabelColor),
                        const SizedBox(height: 4),
                        _CustomTextField(
                          controller: emailController,
                          keyboardType: TextInputType.emailAddress,
                          textInputAction: TextInputAction.next,
                          autofillHints: const [AutofillHints.email],
                        ),

                        const SizedBox(height: 24), // gap-6

                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            _InputLabel(text: 'Password', color: inputLabelColor),
                            GestureDetector(
                              onTap: () {
                                context.push('/forgot-password');
                              },
                              child: Text(
                                'Forgot password?',
                                style: GoogleFonts.figtree(
                                  color: isDark ? const Color(0xFFFDF4F5).withValues(alpha: 0.8) : const Color(0xFF6A4053),
                                  fontSize: 14,
                                  fontWeight: FontWeight.w400,
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 4),
                        _CustomTextField(
                          controller: passwordController,
                          obscureText: obscurePassword,
                          autofillHints: const [AutofillHints.password],
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

                        const SizedBox(height: 32), // gap-6 (24px) + mt-2 (8px) = 32px

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
                                activeColor: const Color(0xFF6A4053),
                                checkColor: Colors.white,
                                fillColor: WidgetStateProperty.resolveWith((states) {
                                  if (states.contains(WidgetState.selected)) {
                                    return const Color(0xFF6A4053);
                                  }
                                  return isDark ? const Color(0xFF6A4053) : Colors.white;
                                }),
                                side: BorderSide(
                                  color: const Color(0xFF6A4053).withValues(alpha: 0.3),
                                  width: 1.0,
                                ),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(4),
                                ),
                              ),
                            ),
                            const SizedBox(width: 8),
                            Text(
                              'Remember me',
                              style: GoogleFonts.figtree(
                                color: isDark ? const Color(0xFFFDF4F5).withValues(alpha: 0.8) : const Color(0xFF6A4053),
                                fontSize: 14,
                              ),
                            ),
                          ],
                        ),

                        const SizedBox(height: 32), // gap-6 (24px) + mt-2 (8px) = 32px

                        SizedBox(
                          width: double.infinity,
                          height: 44,
                          child: ElevatedButton(
                            onPressed: authState.isLoading
                                ? null
                                : () {
                                    ref.read(authProvider.notifier).login(
                                      email: emailController.text.trim(),
                                      password: passwordController.text,
                                    );
                                  },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFF6A4053),
                              foregroundColor: Colors.white,
                              elevation: 0,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(9999),
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
                                : Text(
                                    'LOG IN',
                                    style: GoogleFonts.figtree(
                                      fontSize: 12,
                                      fontWeight: FontWeight.w600,
                                      letterSpacing: 1.2,
                                    ),
                                  ),
                          ),
                        ),

                        const SizedBox(height: 32),
                        
                        SizedBox(
                          width: double.infinity,
                          height: 44,
                          child: OutlinedButton(
                            onPressed: () => context.go('/register'),
                            style: OutlinedButton.styleFrom(
                              foregroundColor: const Color(0xFF6A4053),
                              side: BorderSide(
                                color: isDark ? const Color(0xFFFDF4F5).withValues(alpha: 0.5) : const Color(0xFF6A4053), 
                                width: 1.5,
                              ),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(9999),
                              ),
                            ),
                            child: Text(
                              'CREATE NEW ACCOUNT',
                              style: GoogleFonts.figtree(
                                fontSize: 12,
                                fontWeight: FontWeight.w700,
                                letterSpacing: 1.2,
                                color: isDark ? const Color(0xFFFDF4F5) : const Color(0xFF6A4053),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
            
            // ======================================================
            // THEME TOGGLE
            // ======================================================
            const Positioned(
              top: 24,
              right: 24,
              child: SafeArea(
                child: _ThemeToggle(),
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
        style: GoogleFonts.figtree(
          color: color,
          fontWeight: FontWeight.w600,
          fontSize: 14,
        ),
      ),
    );
  }
}

// ============================================================================
// CUSTOM TEXT FIELD
// ============================================================================

class _CustomTextField extends StatefulWidget {
  final TextEditingController controller;
  final bool obscureText;
  final Widget? suffixIcon;
  final TextInputType? keyboardType;
  final TextInputAction? textInputAction;
  final Iterable<String>? autofillHints;

  const _CustomTextField({
    required this.controller,
    this.obscureText = false,
    this.suffixIcon,
    this.keyboardType,
    this.textInputAction,
    this.autofillHints,
  });

  @override
  State<_CustomTextField> createState() => _CustomTextFieldState();
}

class _CustomTextFieldState extends State<_CustomTextField> {
  bool isFocused = false;
  
  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    
    final baseBg = isDark 
        ? const Color(0xFF6A4053).withValues(alpha: 0.40)
        : const Color(0xFF99868C).withValues(alpha: 0.70);
    final focusBg = isDark
        ? const Color(0xFF6A4053).withValues(alpha: 0.60)
        : const Color(0xFF99868C).withValues(alpha: 0.90);

    final baseBorder = isDark 
        ? Colors.white.withValues(alpha: 0.10)
        : Colors.white.withValues(alpha: 0.20);
    final focusBorder = isDark
        ? const Color(0xFF6A4053)
        : Colors.white;

    return Focus(
      onFocusChange: (hasFocus) {
        setState(() {
          isFocused = hasFocus;
        });
      },
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          boxShadow: const [
            BoxShadow(
              color: Color(0x0D6A4053),
              offset: Offset(0, 10),
              blurRadius: 25,
              spreadRadius: -5,
            ),
            BoxShadow(
              color: Color(0x056A4053),
              offset: Offset(0, 8),
              blurRadius: 10,
              spreadRadius: -6,
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(12),
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 12, sigmaY: 12),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              decoration: BoxDecoration(
                color: isFocused ? focusBg : baseBg,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: isFocused ? focusBorder : baseBorder,
                  width: 1.0,
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
                      autofillHints: widget.autofillHints,
                      style: GoogleFonts.figtree(
                        color: isDark ? const Color(0xFFFDF4F5) : Colors.white, 
                        fontSize: 16
                      ),
                      cursorColor: isDark ? const Color(0xFFFDF4F5) : Colors.white,
                      decoration: InputDecoration(
                        border: InputBorder.none,
                        contentPadding: EdgeInsets.only(
                          top: 12,
                          bottom: 12,
                          left: 20,
                          right: widget.suffixIcon != null ? 0 : 20,
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

// ============================================================================
// THEME TOGGLE
// ============================================================================

class _ThemeToggle extends ConsumerWidget {
  const _ThemeToggle();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = ref.watch(themeModeProvider);
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF6A4053).withValues(alpha: 0.5) : Colors.white.withValues(alpha: 0.5),
        borderRadius: BorderRadius.circular(12),
        boxShadow: const [
          BoxShadow(
            color: Color(0x0C000000),
            blurRadius: 10,
          )
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(12),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 12, sigmaY: 12),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              _buildButton(
                icon: Icons.light_mode_outlined,
                isSelected: theme == ThemeMode.light,
                isDarkEnv: isDark,
                onTap: () => ref.read(themeModeProvider.notifier).state = ThemeMode.light,
              ),
              const SizedBox(width: 4),
              _buildButton(
                icon: Icons.dark_mode_outlined,
                isSelected: theme == ThemeMode.dark,
                isDarkEnv: isDark,
                onTap: () => ref.read(themeModeProvider.notifier).state = ThemeMode.dark,
              ),
              const SizedBox(width: 4),
              _buildButton(
                icon: Icons.monitor_outlined,
                isSelected: theme == ThemeMode.system,
                isDarkEnv: isDark,
                onTap: () => ref.read(themeModeProvider.notifier).state = ThemeMode.system,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildButton({
    required IconData icon,
    required bool isSelected,
    required bool isDarkEnv,
    required VoidCallback onTap,
  }) {
    final selectedBg = isDarkEnv ? const Color(0xFF6A4053) : Colors.white;
    final selectedIconColor = isDarkEnv ? const Color(0xFFFDF4F5) : const Color(0xFF6A4053);
    final unselectedIconColor = isDarkEnv 
        ? const Color(0xFFFDF4F5).withValues(alpha: 0.6) 
        : const Color(0xFF6A4053).withValues(alpha: 0.6);

    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: isSelected ? selectedBg : Colors.transparent,
          shape: BoxShape.circle,
          boxShadow: isSelected
              ? const [
                  BoxShadow(
                    color: Color(0x0C000000),
                    blurRadius: 4,
                  )
                ]
              : [],
        ),
        child: Icon(
          icon,
          size: 14,
          color: isSelected ? selectedIconColor : unselectedIconColor,
        ),
      ),
    );
  }
}

