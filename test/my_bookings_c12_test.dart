import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:inea_scents_client/config/theme.dart';
import 'package:inea_scents_client/models/index.dart';
import 'package:inea_scents_client/providers/index.dart';
import 'package:inea_scents_client/screens/my_bookings_screen.dart';
import 'package:inea_scents_client/src/providers/core_providers.dart';
import 'package:inea_scents_client/widgets/index.dart';

import 'helpers/fake_api.dart';

/// C12: Bookings empty state routes to /packages (not /) with Pax-Choice
/// copy. C43: data header shows title+count only (no book-another).
void main() {
  setUpAll(() {
    GoogleFonts.config.allowRuntimeFetching = false;
  });

  Booking sampleBooking() => Booking(
    id: 1,
    bookingReference: 'IN-2026-000001',
    status: 'confirmed',
    pax: 50,
    eventDate: DateTime(2026, 10, 1),
    venueAddress: 'The Peninsula Manila',
  );

  GoRouter buildRouter({String initial = '/bookings'}) {
    return GoRouter(
      initialLocation: initial,
      routes: [
        GoRoute(
          path: '/bookings',
          builder: (context, state) => const MyBookingsScreen(),
        ),
        GoRoute(
          path: '/packages',
          builder: (context, state) => const Text('Packages Screen Page'),
        ),
        GoRoute(
          path: '/home',
          builder: (context, state) => const Text('Home Screen Page'),
        ),
      ],
    );
  }

  Future<void> pumpBookings(
    WidgetTester tester,
    GoRouter router,
    List<Override> overrides, {
    Size size = const Size(390, 844),
  }) async {
    tester.view.physicalSize = size;
    tester.view.devicePixelRatio = 1.0;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);
    await tester.pumpWidget(
      ProviderScope(
        overrides: overrides,
        child: MaterialApp.router(
          theme: AppTheme.lightTheme,
          routerConfig: router,
        ),
      ),
    );
    await tester.pumpAndSettle();
  }

  testWidgets('empty state CTA goes to /packages with Pax-Choice copy', (
    WidgetTester tester,
  ) async {
    final router = buildRouter();
    tester.view.physicalSize = const Size(390, 844);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          bookingsProvider.overrideWith((ref) => Future.value(<Booking>[])),
        ],
        child: MaterialApp.router(
          theme: AppTheme.lightTheme,
          routerConfig: router,
        ),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('No bookings yet'), findsOneWidget);
    expect(find.text('Explore Pax Choices'), findsOneWidget);
    expect(find.text('Explore Packages'), findsNothing);

    await tester.tap(find.text('Explore Pax Choices'));
    await tester.pumpAndSettle();
    expect(router.location, '/packages');
    expect(find.text('Packages Screen Page'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });

  testWidgets('non-empty mobile shows title+count only, no AppBar plus', (
    WidgetTester tester,
  ) async {
    final router = buildRouter();
    await pumpBookings(
      tester,
      router,
      [
        bookingsProvider.overrideWith((ref) => Future.value([sampleBooking()])),
      ],
      // C25 acceptance probes 360px: overflow/overshoot would throw.
      size: const Size(360, 740),
    );

    expect(find.text('My Bookings'), findsOneWidget);
    expect(find.text('1 booking'), findsOneWidget);
    // C43: no book-another affordance in the header on any width.
    expect(find.byType(AppBar), findsNothing);
    expect(
      find.byTooltip('Book another Pax Choice'),
      findsNothing,
    );
    expect(find.text('Book another'), findsNothing);
    expect(find.text('Book another Pax Choice'), findsNothing);
    expect(find.text('Explore Packages'), findsNothing);
    expect(router.location, '/bookings');
    expect(tester.takeException(), isNull);
  });

  testWidgets('non-empty desktop shows title+count only, no book-another', (
    WidgetTester tester,
  ) async {
    final router = buildRouter();
    await pumpBookings(
      tester,
      router,
      [
        bookingsProvider.overrideWith(
          (ref) => Future.value([sampleBooking()]),
        ),
      ],
      size: const Size(1280, 800),
    );

    expect(find.text('My Bookings'), findsOneWidget);
    expect(find.text('1 booking'), findsOneWidget);
    expect(find.text('Book another Pax Choice'), findsNothing);
    expect(find.text('Book another'), findsNothing);
    expect(router.location, '/bookings');
    expect(tester.takeException(), isNull);
  });

  testWidgets('loading state shows no book-another action', (
    WidgetTester tester,
  ) async {
    // C79: never-resolving-until-teardown future stays in the skeleton
    // (pump, not pumpAndSettle — shimmer never settles). Completed
    // at the end so no timer is pending when the tree is disposed.
    final loadingRouter = buildRouter();
    final loadingCompleter = Completer<List<Booking>>();
    tester.view.physicalSize = const Size(390, 844);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          bookingsProvider.overrideWith((ref) => loadingCompleter.future),
        ],
        child: MaterialApp.router(
          theme: AppTheme.lightTheme,
          routerConfig: loadingRouter,
        ),
      ),
    );
    await tester.pump();
    // C79: loading teases the bookings layout, never a spinner.
    expect(find.byType(SkeletonBookingsList), findsOneWidget);
    expect(find.byKey(const Key('skeleton_bookings_list')), findsOneWidget);
    expect(find.byType(CircularProgressIndicator), findsNothing);
    expect(find.byTooltip('Book another Pax Choice'), findsNothing);
    expect(find.text('Book another Pax Choice'), findsNothing);
    expect(find.text('Book another'), findsNothing);
    loadingCompleter.complete(<Booking>[]);
    await tester.pumpAndSettle();
    expect(find.text('No bookings yet'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });

  testWidgets('error state shows no book-another action', (
    WidgetTester tester,
  ) async {
    tester.view.physicalSize = const Size(390, 844);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);
    // Error: GET /api/bookings 500 renders the friendly card, no action.
    final errorBackend = FakeApiBackend()..failBookings = true;
    final errorRouter = buildRouter();
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          apiClientProvider.overrideWithValue(
            buildFakeRestClient(errorBackend),
          ),
        ],
        child: MaterialApp.router(
          theme: AppTheme.lightTheme,
          routerConfig: errorRouter,
        ),
      ),
    );
    await tester.pumpAndSettle();
    // Note: ErrorStateCard renders title/message via SelectableText,
    // which find.text does not match — assert card type + retry action.
    expect(find.byType(ErrorStateCard), findsOneWidget);
    expect(find.text('Try Again'), findsOneWidget);
    expect(find.byTooltip('Book another Pax Choice'), findsNothing);
    expect(find.text('Book another Pax Choice'), findsNothing);
    expect(find.text('Book another'), findsNothing);
    expect(tester.takeException(), isNull);
  });
}
