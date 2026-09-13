import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
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
          // P7: flat theme background — decorative ambient layers were
          // stripped app-wide per owner direction; the theme scaffold
          // color (light cream / dark night) carries both modes.
          body: SingleChildScrollView(
            key: const Key('app_shell_scroll_view'),
            physics: const BouncingScrollPhysics(),
            child: Center(
              child: ConstrainedBox(
                constraints: BoxConstraints(
                  maxWidth: isDesktopView ? maxWidth : double.infinity,
                ),
                child: child,
              ),
            ),
          ),
          bottomNavigationBar: isDesktopView
              ? null
              : _buildMobileBottomNav(context),
        );
      },
    );
  }

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
