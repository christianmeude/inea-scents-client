import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class BottomNavBar extends StatelessWidget {
  const BottomNavBar({super.key});

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      backgroundColor: const Color(0xFF8B6B7C),
      selectedItemColor: Colors.white,
      unselectedItemColor: Colors.white70,
      type: BottomNavigationBarType.fixed,
      currentIndex: _getCurrentIndex(context),
      onTap: (index) {
        switch (index) {
          case 0:
            context.go('/home');
            break;
          case 1:
            context.go('/packages');
            break;
          case 2:
            context.go('/calendar');
            break;
          case 3:
            context.go('/bookings');
            break;
          case 4:
            context.go('/profile');
            break;
        }
      },
      items: const [
        BottomNavigationBarItem(icon: Icon(Icons.home), label: 'HOME'),
        BottomNavigationBarItem(
          icon: Icon(Icons.card_giftcard),
          label: 'PACKAGES',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.calendar_today),
          label: 'CALENDAR',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.event_note),
          label: 'BOOKINGS',
        ),
        BottomNavigationBarItem(icon: Icon(Icons.person), label: 'PROFILE'),
      ],
    );
  }

  int _getCurrentIndex(BuildContext context) {
    final location = GoRouter.of(
      context,
    ).routeInformationProvider.value.uri.path;
    if (location.contains('packages') &&
        !location.contains('package-details')) {
      return 1;
    } else if (location.contains('calendar')) {
      return 2;
    } else if (location.contains('bookings')) {
      return 3;
    } else if (location.contains('profile') || location.contains('wishlist')) {
      return 4;
    }
    return 0;
  }
}
