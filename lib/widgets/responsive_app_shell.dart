import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../config/theme.dart';
import 'bottom_nav_bar.dart';
import 'theme_toggle_button.dart';
import 'top_nav_bar.dart';

/// Foundational responsive layout scaffolding for the application.
///
/// Breakpoints:
/// - Mobile (`< 768px`, 1-col): Hides [TopNavBar], renders unconstrained content, and renders [BottomNavBar].
/// - Tablet (`768px - 1024px`, 2-col): Displays [TopNavBar], centers content in [maxContentWidth] container.
/// - Desktop (`> 1024px`, 3-col): Displays [TopNavBar], centers content in [maxContentWidth] container.
/// - Max content width: `1200px`.
class ResponsiveAppShell extends StatelessWidget {
  static const double mobileBreakpoint = 768.0;
  static const double tabletBreakpoint = 1024.0;
  static const double maxContentWidth = 1200.0;

  final Widget child;
  final double maxWidth;
  final double breakpoint;
  final Color? backgroundColor;

  /// Injectable so provider-less tests can render the shell; production
  /// passes the connected toggle.
  final Widget themeToggle;

  const ResponsiveAppShell({
    super.key,
    required this.child,
    this.maxWidth = maxContentWidth,
    this.breakpoint = mobileBreakpoint,
    this.backgroundColor,
    this.themeToggle = const ThemeToggleButton(isDark: false),
  });

  /// Helper to get responsive column counts based on R1 breakpoints.
  /// P6 (G2): package grids render 2 → 3 → 4 columns across
  /// mobile / tablet / desktop.
  static int getGridColumnCount(double width) {
    if (width > tabletBreakpoint) {
      return 4;
    } else if (width >= mobileBreakpoint) {
      return 3;
    } else {
      return 2;
    }
  }

  /// Shared grid delegate for package grids (P6 G2). Keeps the
  /// established card proportions and spacing; only the column count
  /// adapts to the available width.
  static SliverGridDelegate gridDelegateForWidth(
    double width, {
    double childAspectRatio = 0.52,
    double crossAxisSpacing = 14,
    double mainAxisSpacing = 16,
  }) {
    return SliverGridDelegateWithFixedCrossAxisCount(
      crossAxisCount: getGridColumnCount(width),
      childAspectRatio: childAspectRatio,
      crossAxisSpacing: crossAxisSpacing,
      mainAxisSpacing: mainAxisSpacing,
    );
  }

  /// Returns `true` if the screen width is strictly in the Desktop range (`> 1024px`).
  static bool isDesktop(BuildContext context) {
    return MediaQuery.of(context).size.width > tabletBreakpoint;
  }

  /// Returns `true` if the screen width is strictly in the Tablet range (`768px - 1024px`).
  static bool isTablet(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    return width >= mobileBreakpoint && width <= tabletBreakpoint;
  }

  /// Returns `true` if the screen width is strictly in the Mobile range (`< 768px`).
  static bool isMobile(BuildContext context) {
    return MediaQuery.of(context).size.width < mobileBreakpoint;
  }

  /// Returns `true` if the screen width qualifies for wide layout / Top Navigation Bar (`>= 768px`).
  static bool isWideScreen(BuildContext context) {
    return MediaQuery.of(context).size.width >= mobileBreakpoint;
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final width = constraints.maxWidth;
        final isDesktopView = width >= breakpoint;

        return Scaffold(
          // Null inherits the theme scaffold color; the fixed ambient
          // below paints the shared gradient over it full-bleed.
          backgroundColor: backgroundColor,
          appBar: isDesktopView
              ? TopNavBar(themeToggle: themeToggle)
              : null,
          // P6 (G3/G4/G5): one fixed full-bleed ambient behind the
          // centered content column. Per-screen gradients inside the
          // 1200px cap blend into this layer instead of stopping at it.
          body: Stack(
            children: [
              const Positioned.fill(
                child: IgnorePointer(child: _ShellAmbient()),
              ),
              Center(
                child: ConstrainedBox(
                  constraints: BoxConstraints(
                    maxWidth: isDesktopView ? maxWidth : double.infinity,
                  ),
                  child: child,
                ),
              ),
            ],
          ),
          bottomNavigationBar: isDesktopView
              ? null
              : _buildMobileBottomNav(context),
        );
      },
    );
  }

  /// Fixed viewport ambient (P6 G3/G4/G5): the shared Elegant Concierge
  /// gradient with soft glows. Dark-aware: deep plum base with muted
  /// glows so content margins never render flat black or cream seams.
  static const _lightGradient = [
    AppTheme.backgroundTop,
    AppTheme.backgroundMiddle,
    AppTheme.backgroundBottom,
  ];

  Widget? _buildMobileBottomNav(BuildContext context) {
    try {
      final router = GoRouter.maybeOf(context);
      if (router != null) {
        String location = '';
        try {
          location = router.routeInformationProvider.value.uri.path;
        } catch (_) {
          try {
            location = router.location;
          } catch (_) {}
        }
        final hideBottomNav =
            location.contains('package-details') ||
            location.contains('booking/') ||
            location.contains('login') ||
            location.contains('register') ||
            location.contains('forgot-password') ||
            location.contains('splash');
        if (hideBottomNav) {
          return null;
        }
      }
    } catch (_) {}
    return const BottomNavBar();
  }
}

/// Fixed full-bleed ambient shared by every in-shell screen.
class _ShellAmbient extends StatelessWidget {
  const _ShellAmbient();

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Stack(
      children: [
        Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: isDark
                  ? const [
                      AppTheme.night,
                      AppTheme.nightSurface,
                      Color(0xFF2A1B23),
                    ]
                  : ResponsiveAppShell._lightGradient,
              stops: const [0.0, 0.52, 1.0],
            ),
          ),
        ),
        Positioned(
          top: -130,
          left: -120,
          child: _SoftGlow(
            size: 390,
            color: const Color(0xFFEBC9B8)
                .withValues(alpha: isDark ? 0.12 : 0.55),
          ),
        ),
        Positioned(
          top: 80,
          right: -145,
          child: _SoftGlow(
            size: 370,
            color: const Color(0xFFD3A4AF)
                .withValues(alpha: isDark ? 0.10 : 0.50),
          ),
        ),
        Positioned(
          bottom: -180,
          left: -130,
          child: _SoftGlow(
            size: 430,
            color: const Color(0xFF9C8491)
                .withValues(alpha: isDark ? 0.10 : 0.42),
          ),
        ),
        Positioned(
          bottom: -160,
          right: -120,
          child: _SoftGlow(
            size: 430,
            color: const Color(0xFF69384F)
                .withValues(alpha: isDark ? 0.14 : 0.28),
          ),
        ),
      ],
    );
  }
}

class _SoftGlow extends StatelessWidget {
  final double size;
  final Color color;

  const _SoftGlow({required this.size, required this.color});

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
