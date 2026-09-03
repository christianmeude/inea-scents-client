import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../config/theme.dart';

import 'responsive_app_shell.dart';

class BottomNavBar extends StatelessWidget {
  const BottomNavBar({super.key});

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    if (width >= ResponsiveAppShell.mobileBreakpoint) {
      return const SizedBox.shrink();
    }

    final isDark = Theme.of(context).brightness == Brightness.dark;
    final navBg = isDark
        ? const Color(0xFF2C1923).withValues(alpha: 0.88)
        : AppTheme.secondary.withValues(alpha: 0.85);

    return ClipRRect(
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
        child: Container(
          decoration: BoxDecoration(color: navBg),
          child: BottomNavigationBar(
            backgroundColor: Colors.transparent,
            elevation: 0,
            selectedItemColor: Colors.white,
            unselectedItemColor: Colors.white.withValues(alpha: 0.5),
            selectedFontSize: 10,
            unselectedFontSize: 10,
            selectedLabelStyle: const TextStyle(fontWeight: FontWeight.bold),
            type: BottomNavigationBarType.fixed,
            currentIndex: _getCurrentIndex(context),
            onTap: (index) {
              final router = GoRouter.maybeOf(context);
              if (router != null) {
                switch (index) {
                  case 0:
                    context.go('/home');
                    break;
                  case 1:
                    context.go('/packages');
                    break;
                  case 2:
                    context.go('/bookings');
                    break;
                  case 3:
                    context.go('/calendar');
                    break;
                  case 4:
                    context.go('/profile');
                    break;
                }
              }
            },
            items: const [
              BottomNavigationBarItem(
                icon: Padding(
                  padding: EdgeInsets.only(bottom: 4),
                  child: Icon(Icons.home_outlined),
                ),
                activeIcon: Padding(
                  padding: EdgeInsets.only(bottom: 4),
                  child: Icon(Icons.home),
                ),
                label: 'HOME',
              ),
              BottomNavigationBarItem(
                icon: Padding(
                  padding: EdgeInsets.only(bottom: 4),
                  child: Icon(Icons.card_giftcard_outlined),
                ),
                activeIcon: Padding(
                  padding: EdgeInsets.only(bottom: 4),
                  child: Icon(Icons.card_giftcard),
                ),
                label: 'PACKAGES',
              ),
              BottomNavigationBarItem(
                icon: Padding(
                  padding: EdgeInsets.only(bottom: 4),
                  child: Icon(Icons.calendar_today_outlined),
                ),
                activeIcon: Padding(
                  padding: EdgeInsets.only(bottom: 4),
                  child: Icon(Icons.calendar_today),
                ),
                label: 'BOOKINGS',
              ),
              BottomNavigationBarItem(
                icon: Padding(
                  padding: EdgeInsets.only(bottom: 4),
                  child: Icon(Icons.event_available_outlined),
                ),
                activeIcon: Padding(
                  padding: EdgeInsets.only(bottom: 4),
                  child: Icon(Icons.event_available),
                ),
                label: 'CALENDAR',
              ),
              BottomNavigationBarItem(
                icon: Padding(
                  padding: EdgeInsets.only(bottom: 4),
                  child: Icon(Icons.person_outline),
                ),
                activeIcon: Padding(
                  padding: EdgeInsets.only(bottom: 4),
                  child: Icon(Icons.person),
                ),
                label: 'PROFILE',
              ),
            ],
          ),
        ),
      ),
    );
  }

  int _getCurrentIndex(BuildContext context) {
    try {
      final router = GoRouter.maybeOf(context);
      if (router == null) return 0;
      String location = '';
      try {
        location = router.routeInformationProvider.value.uri.path;
      } catch (_) {
        try {
          location = router.location;
        } catch (_) {}
      }
      if (location.contains('package')) {
        return 1;
      } else if (location.contains('booking')) {
        return 2;
      } else if (location.contains('calendar')) {
        return 3;
      } else if (location.contains('profile') ||
          location.contains('wishlist')) {
        return 4;
      } else if (location == '/' || location.contains('home')) {
        return 0;
      }
      return 0;
    } catch (_) {
      return 0;
    }
  }
}
