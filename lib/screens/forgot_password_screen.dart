import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import '../providers/index.dart';
import '../src/providers/core_providers.dart';
import '../widgets/index.dart';

class ForgotPasswordScreen extends ConsumerStatefulWidget {
  const ForgotPasswordScreen({super.key});

  @override
  ConsumerState<ForgotPasswordScreen> createState() =>
      _ForgotPasswordScreenState();
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

    final isDark = Theme.of(context).brightness == Brightness.dark;
    final bgColor = isDark ? const Color(0xFF151012) : const Color(0xFFFDF4F5);
    final inputLabelColor = isDark
        ? const Color(0xFFFDF4F5)
        : const Color(0xFF6A4053);

    final sw = MediaQuery.of(context).size.width;
    final sh = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor:
          Colors.transparent, // Let AnimatedContainer handle background
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
                color: isDark
                    ? const Color(0x664A1C28)
                    : const Color(0xFFDABDAC),
                angle: 30 * (3.14159 / 180),
              ),
            ),
            Positioned(
              top: sh * 0.10,
              left: sw * 0.05,
              child: _BlurBlob(
                width: 600,
                height: 300,
                color: isDark
                    ? const Color(0x664A1C28)
                    : const Color(0xFFDABDAC),
                angle: 15 * (3.14159 / 180),
              ),
            ),
            Positioned(
              top: sh * 0.30,
              left: -sw * 0.10,
              child: _BlurBlob(
                width: 800,
                height: 250,
                color: isDark
                    ? const Color(0x806A4053)
                    : const Color(0xFFC08D9E),
                angle: 10 * (3.14159 / 180),
              ),
            ),
            Positioned(
              top: sh * 0.65,
              left: -sw * 0.05,
              child: _BlurBlob(
                width: 500,
                height: 400,
                color: isDark
                    ? const Color(0x9936222C)
                    : const Color(0xFF988088),
              ),
            ),
            Positioned(
              top: -sh * 0.15,
              right: sw * 0.05,
              child: _BlurBlob(
                width: 800,
                height: 600,
                color: isDark
                    ? const Color(0xB33B1019)
                    : const Color(0xFFC4A5A8),
              ),
            ),
            Positioned(
              top: sh * 0.20,
              right: sw * 0.20,
              child: _BlurBlob(
                width: 500,
                height: 400,
                color: isDark
                    ? const Color(0xB33B1019)
                    : const Color(0xFFC4A5A8),
              ),
            ),
            Positioned(
              top: sh * 0.50,
              right: -sw * 0.05,
              child: _BlurBlob(
                width: 300,
                height: 500,
                color: isDark
                    ? const Color(0x996A4053)
                    : const Color(0xFF6E3C53),
              ),
            ),
            Positioned(
              top: sh * 0.75,
              right: sw * 0.05,
              child: _BlurBlob(
                width: 600,
                height: 250,
                color: isDark
                    ? const Color(0x996A4053)
                    : const Color(0xFF6E3C53),
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
                              color: isDark
                                  ? const Color(
                                      0xFFFDF4F5,
                                    ).withValues(alpha: 0.8)
                                  : const Color(
                                      0xFF6A4053,
                                    ).withValues(alpha: 0.8),
                              fontSize: 14,
                            ),
                          ),
                        ),
                        const SizedBox(height: 24),
                        _InputLabel(text: 'Email', color: inputLabelColor),
                        const SizedBox(height: 4),
                        CustomTextField(
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
                                    final dioClient = ref.read(
                                      dioClientProvider,
                                    );
                                    try {
                                      await dioClient.dio.post(
                                        '/forgot-password',
                                        data: {
                                          'email': emailController.text.trim(),
                                        },
                                      );
                                      if (!context.mounted) return;
                                      ScaffoldMessenger.of(
                                        context,
                                      ).showSnackBar(
                                        const SnackBar(
                                          content: Text(
                                            'Password reset link sent!',
                                          ),
                                        ),
                                      );
                                    } catch (e) {
                                      if (!context.mounted) return;
                                      ScaffoldMessenger.of(
                                        context,
                                      ).showSnackBar(
                                        const SnackBar(
                                          content: Text(
                                            'Failed to send reset link',
                                          ),
                                        ),
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
                        const SizedBox(height: 32),

                        SizedBox(
                          width: double.infinity,
                          height: 44,
                          child: OutlinedButton(
                            onPressed: () => context.go('/login'),
                            style: OutlinedButton.styleFrom(
                              foregroundColor: const Color(0xFF6A4053),
                              side: BorderSide(
                                color: isDark
                                    ? const Color(
                                        0xFFFDF4F5,
                                      ).withValues(alpha: 0.5)
                                    : const Color(0xFF6A4053),
                                width: 1.5,
                              ),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(30),
                              ),
                            ),
                            child: Text(
                              'BACK TO LOGIN',
                              style: GoogleFonts.figtree(
                                fontSize: 12,
                                fontWeight: FontWeight.w700,
                                letterSpacing: 1.2,
                                color: isDark
                                    ? const Color(0xFFFDF4F5)
                                    : const Color(0xFF6A4053),
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
              child: SafeArea(child: ConnectedThemeToggleButton()),
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
    final brandPrimary = isDark
        ? const Color(0xFFFDF4F5)
        : const Color(0xFF6A4053);
    final strokeColor = isDark
        ? const Color(0xFF151012)
        : const Color(0xFFFDF4F5);

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
