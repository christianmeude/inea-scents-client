import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:inea_scents_client/config/theme.dart';
import 'package:inea_scents_client/models/index.dart';
import 'package:inea_scents_client/providers/index.dart';
import 'package:inea_scents_client/screens/booking_detail_screen.dart';
import 'package:inea_scents_client/screens/my_bookings_screen.dart';
import 'package:inea_scents_client/utils/peso.dart';

/// C50: bookings surfaces show the selected variant price (priceForPax),
/// matching checkout/PayMongo — not the scalar base price.
void main() {
  setUpAll(() {
    GoogleFonts.config.allowRuntimeFetching = false;
  });

  Package tieredPackage() => const Package(
        id: 1,
        name: 'Essential 10ml Perfume Bar',
        price: 4499,
        paxPrices: {50: 4499.0, 70: 6399.0, 100: 8799.0},
      );

  Booking bookingFor100() => Booking(
        id: 7,
        bookingReference: 'IN-2026-000007',
        status: 'confirmed',
        pax: 100,
        eventDate: DateTime(2026, 10, 1),
        venueAddress: 'The Peninsula Manila',
        package: tieredPackage(),
      );

  testWidgets('list card shows selected variant price, not base 4,499', (
    WidgetTester tester,
  ) async {
    final router = GoRouter(
      initialLocation: '/bookings',
      routes: [
        GoRoute(
          path: '/bookings',
          builder: (context, state) => const MyBookingsScreen(),
        ),
      ],
    );
    tester.view.physicalSize = const Size(390, 844);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          bookingsProvider.overrideWith((ref) => Future.value([bookingFor100()])),
        ],
        child: MaterialApp.router(
          theme: AppTheme.lightTheme,
          routerConfig: router,
        ),
      ),
    );
    await tester.pumpAndSettle();

    // Selected variant (100 pax) prices at 8,799 — same amount checkout
    // charges via priceForPax. Base scalar 4,499 must not render.
    expect(find.text(formatPeso(8799.0)), findsOneWidget);
    expect(find.text(formatPeso(4499.0)), findsNothing);
    expect(tester.takeException(), isNull);
  });

  testWidgets('detail screen shows selected variant price', (
    WidgetTester tester,
  ) async {
    final router = GoRouter(
      initialLocation: '/bookings/7',
      routes: [
        GoRoute(
          path: '/bookings/:id',
          builder: (context, state) => BookingDetailScreen(
            bookingId: int.parse(state.pathParameters['id']!),
          ),
        ),
      ],
    );
    tester.view.physicalSize = const Size(390, 844);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          bookingsProvider.overrideWith((ref) => Future.value([bookingFor100()])),
        ],
        child: MaterialApp.router(
          theme: AppTheme.lightTheme,
          routerConfig: router,
        ),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text(formatPeso(8799.0)), findsOneWidget);
    expect(find.text(formatPeso(4499.0)), findsNothing);
    expect(tester.takeException(), isNull);
  });
}
