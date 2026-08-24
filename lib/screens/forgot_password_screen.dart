import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:google_fonts/google_fonts.dart';
import '../providers/index.dart';
import '../src/providers/core_providers.dart';

class ForgotPasswordScreen extends ConsumerStatefulWidget {
  const ForgotPasswordScreen({super.key});

  @override
  ConsumerState<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends ConsumerState<ForgotPasswordScreen> {
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

    ref.listen(authProvider, (previous, next) async {
      if (next.isLoggedIn) {
        if (next.user?.isAdmin == true) {
          final url = await ref.read(authProvider.notifier).getMagicUrl();
          if (!context.mounted) return;
          if (url != null) {
            await launchUrl(Uri.parse(url), webOnlyWindowName: '_self');
          } else {
            context.go('/home'); // Fallback if magic URL fails
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
    final bgColor = isDark ? const Color(0xFF151012) : const Color(0xFFFDF4F5);
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
                color: isDark ? const Color(0x664A1C28) : const Color(0xFFDABDAC),
                angle: 30 * (3.14159 / 180),
              ),
            ),
            Positioned(
              top: sh * 0.10,
              left: sw * 0.05,
              child: _BlurBlob(
                width: 600,
                height: 300,
                color: isDark ? const Color(0x664A1C28) : const Color(0xFFDABDAC),
                angle: 15 * (3.14159 / 180),
              ),
            ),
            Positioned(
              top: sh * 0.30,
              left: -sw * 0.10,
              child: _BlurBlob(
                width: 800,
                height: 250,
                color: isDark ? const Color(0x806A4053) : const Color(0xFFC08D9E),
                angle: 10 * (3.14159 / 180),
              ),
            ),
            Positioned(
              top: sh * 0.65,
              left: -sw * 0.05,
              child: _BlurBlob(
                width: 500,
                height: 400,
                color: isDark ? const Color(0x994A2D3C) : const Color(0xFF988088),
              ),
            ),
            Positioned(
              top: -sh * 0.15,
              right: sw * 0.05,
              child: _BlurBlob(
                width: 800,
                height: 600,
                color: isDark ? const Color(0xB33B1019) : const Color(0xFFC4A5A8),
              ),
            ),
            Positioned(
              top: sh * 0.20,
              right: sw * 0.20,
              child: _BlurBlob(
                width: 500,
                height: 400,
                color: isDark ? const Color(0xB33B1019) : const Color(0xFFC4A5A8),
              ),
            ),
            Positioned(
              top: sh * 0.50,
              right: -sw * 0.05,
              child: _BlurBlob(
                width: 300,
                height: 500,
                color: isDark ? const Color(0x996A4053) : const Color(0xFF6E3C53),
              ),
            ),
            Positioned(
              top: sh * 0.75,
              right: sw * 0.05,
              child: _BlurBlob(
                width: 600,
                height: 250,
                color: isDark ? const Color(0x996A4053) : const Color(0xFF6E3C53),
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
                        const _ApplicationLogo(),
                        const SizedBox(height: 44),
                        Align(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            'Enter your email address to receive a secure password reset link.',
                            style: GoogleFonts.figtree(
                              color: isDark ? const Color(0xFFFDF4F5).withValues(alpha: 0.8) : const Color(0xFF6A4053).withValues(alpha: 0.8),
                              fontSize: 14,
                            ),
                          ),
                        ),
                        const SizedBox(height: 24),
                        _InputLabel(text: 'Email', color: inputLabelColor),
                        const SizedBox(height: 4),
                        _CustomTextField(
                          controller: emailController,
                          keyboardType: TextInputType.emailAddress,
                          textInputAction: TextInputAction.done,
                          autofillHints: const [AutofillHints.email],
                        ),
                        const SizedBox(height: 24),
                        SizedBox(
                          width: double.infinity,
                          height: 44,
                          child: ElevatedButton(
                            onPressed: authState.isLoading
                                ? null
                                : () async {
                                    final dioClient = ref.read(dioClientProvider);
                                    try {
                                      await dioClient.dio.post('/forgot-password', data: {'email': emailController.text.trim()});
                                      if (!context.mounted) return;
                                      ScaffoldMessenger.of(context).showSnackBar(
                                        const SnackBar(content: Text('Password reset link sent!')),
                                      );
                                    } catch (e) {
                                      if (!context.mounted) return;
                                      ScaffoldMessenger.of(context).showSnackBar(
                                        const SnackBar(content: Text('Failed to send reset link')),
                                      );
                                    }
                                  },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFF6A4053),
                              foregroundColor: Colors.white,
                              elevation: 0,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(30),
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
                                    'EMAIL PASSWORD RESET LINK',
                                    style: GoogleFonts.figtree(
                                      fontSize: 12,
                                      fontWeight: FontWeight.w600,
                                      letterSpacing: 1.2,
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

class _ApplicationLogo extends StatelessWidget {
  const _ApplicationLogo();

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final brandPrimary = isDark ? const Color(0xFFFDF4F5) : const Color(0xFF6A4053);
    final strokeColor = isDark ? const Color(0xFF151012) : const Color(0xFFFDF4F5);

    final sw = MediaQuery.of(context).size.width;
    final isDesktop = sw >= 640;

    final ineaSize = isDesktop ? 72.0 : 60.0;
    final ineaSpacing = ineaSize * 0.15;
    final scentsSize = isDesktop ? 96.0 : 72.0;
    
    // Adjusted offset for perfect visual 1:1 match with Inertia Web Rendering
    final scentsOffsetX = isDesktop ? -76.0 : -63.0; 
    final scentsOffsetY = isDesktop ? 34.0 : 25.0; 

    // Since Transform.translate only moves the visual layer, the layout bounding box
    // still reserves the original width on the right. We shift the whole block right
    // by half the offset to keep the logo perfectly centered.
    final visualCenterOffset = isDesktop ? 38.0 : 31.5;

    final ineaStroke = GoogleFonts.josefinSans(
      fontSize: ineaSize,
      fontWeight: FontWeight.w700,
      letterSpacing: ineaSpacing,
      foreground: Paint()
        ..style = PaintingStyle.stroke
        ..strokeWidth = 3
        ..strokeJoin = StrokeJoin.round
        ..color = strokeColor,
    );

    final ineaFill = GoogleFonts.josefinSans(
      fontSize: ineaSize,
      fontWeight: FontWeight.w700,
      letterSpacing: ineaSpacing,
      color: brandPrimary,
    );

    final scentsStroke = GoogleFonts.greatVibes(
      fontSize: scentsSize,
      foreground: Paint()
        ..style = PaintingStyle.stroke
        ..strokeWidth = 3
        ..strokeJoin = StrokeJoin.round
        ..color = strokeColor,
    );

    final scentsFill = GoogleFonts.greatVibes(
      fontSize: scentsSize,
      color: brandPrimary,
    );

    return FittedBox(
      fit: BoxFit.fitWidth,
      child: Transform.translate(
        offset: Offset(visualCenterOffset, 0),
        child: Stack(
          clipBehavior: Clip.none,
          children: [
            // ==============================================================
            // 1. INEA STROKE (Base layer, sizes the Stack)
            // ==============================================================
            Row(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('INEA', style: ineaStroke),
                // Invisible untranslated Scents guarantees the Stack layout width 
                // matches the natural flow of the two words.
                Opacity(opacity: 0, child: Text('Scents', style: scentsStroke)),
              ],
            ),
            
            // ==============================================================
            // 2. INEA FILL
            // ==============================================================
            Text('INEA', style: ineaFill),
            
            // ==============================================================
            // 3. SCENTS STROKE (Knocks out the INEA Fill beneath it!)
            // ==============================================================
            Row(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Opacity(opacity: 0, child: Text('INEA', style: ineaStroke)),
                Transform.translate(
                  offset: Offset(scentsOffsetX, scentsOffsetY),
                  child: Text('Scents', style: scentsStroke),
                ),
              ],
            ),
            
            // ==============================================================
            // 4. SCENTS FILL
            // ==============================================================
            Row(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Opacity(opacity: 0, child: Text('INEA', style: ineaStroke)),
                Transform.translate(
                  offset: Offset(scentsOffsetX, scentsOffsetY),
                  child: Text('Scents', style: scentsFill),
                ),
              ],
            ),
          ],
        ),
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
        : const Color(0xFF8B5D76).withValues(alpha: 0.70);
    final focusBg = isDark
        ? const Color(0xFF6A4053).withValues(alpha: 0.60)
        : const Color(0xFF8B5D76).withValues(alpha: 0.90);

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
          borderRadius: BorderRadius.circular(30),
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
          borderRadius: BorderRadius.circular(30),
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 12, sigmaY: 12),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              decoration: BoxDecoration(
                color: isFocused ? focusBg : baseBg,
                borderRadius: BorderRadius.circular(30),
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
        color: isDark ? const Color(0xFF261D21).withValues(alpha: 0.5) : Colors.white.withValues(alpha: 0.5),
        borderRadius: BorderRadius.circular(30),
        boxShadow: const [
          BoxShadow(
            color: Color(0x0C000000),
            blurRadius: 10,
          )
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(30),
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

