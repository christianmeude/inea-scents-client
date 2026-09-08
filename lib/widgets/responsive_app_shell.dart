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
  static int getGridColumnCount(double width) {
    if (width > tabletBreakpoint) {
      return 3;
    } else if (width >= mobileBreakpoint) {
      return 2;
    } else {
      return 1;
    }
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
          backgroundColor: backgroundColor,
          appBar: isDesktopView
              ? TopNavBar(themeToggle: themeToggle)
              : null,
          body: Center(
            child: ConstrainedBox(
              constraints: BoxConstraints(
                maxWidth: isDesktopView ? maxWidth : double.infinity,
              ),
              child: child,
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
