import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../screens/index.dart';

class AppRouter {
  static final router = GoRouter(
    initialLocation: '/splash',
    redirect: (context, state) async {
      // You can add auth checks here if needed
      return null;
    },
    routes: [
      GoRoute(
        path: '/',
        redirect: (context, state) => '/home',
      ),
      GoRoute(
        path: '/splash',
        builder: (context, state) => const SplashScreen(),
      ),
      GoRoute(path: '/login', builder: (context, state) => const LoginScreen()),
      GoRoute(path: '/register', builder: (context, state) => const RegisterScreen()),
      GoRoute(
        path: '/forgot-password',
        builder: (context, state) => const ForgotPasswordScreen(),
      ),
      GoRoute(path: '/home', builder: (context, state) => const HomeScreen()),
      GoRoute(
        path: '/packages',
        builder: (context, state) => const PackagesScreen(),
      ),
      GoRoute(
        path: '/package-details/:id',
        builder: (context, state) {
          final packageId = int.parse(state.pathParameters['id']!);
          return PackageDetailScreen(packageId: packageId);
        },
      ),
      GoRoute(
        path: '/booking/:id',
        builder: (context, state) {
          final packageId = int.parse(state.pathParameters['id']!);
          return BookingScreen(packageId: packageId);
        },
      ),
      GoRoute(
        path: '/bookings',
        builder: (context, state) => const MyBookingsScreen(),
      ),
      GoRoute(
        path: '/calendar',
        builder: (context, state) => const CalendarScreen(),
      ),
      GoRoute(
        path: '/wishlist',
        builder: (context, state) => const ProfileScreen(),
      ),
      GoRoute(
        path: '/profile',
        builder: (context, state) => const ProfileScreen(),
      ),
    ],
  );
}

final routerProvider = Provider((ref) => AppRouter.router);
