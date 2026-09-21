import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:inea_scents_client/api/models/booking.dart';
import 'package:inea_scents_client/screens/booking_detail_screen.dart';
import 'package:inea_scents_client/screens/profile_screen.dart';
import 'package:inea_scents_client/src/providers/core_providers.dart';
import 'package:inea_scents_client/widgets/upcoming_booking_section.dart';

import 'helpers/fake_api.dart';

/// C37: Upcoming Booking section removed from Profile only — selector rules
/// still cover Home; Profile asserts no Upcoming section, no inline form
/// card, no Help tile, disabled tiles with deferred notes, and kept
/// /bookings/:id route. Profile renders without overflow at 360x800.
void main() {
  setUpAll(() {
    GoogleFonts.config.allowRuntimeFetching = false;
  });

  Booking booking({
    int? id,
    String status = 'confirmed',
    DateTime? date,
  }) =>
      Booking(
        id: id,
        bookingReference: 'IN-2026-00$id',
        status: status,
        eventDate: date,
        eventTime: '14:00:00',
        pax: 50,
      );

  group('selectUpcomingBooking', () {
    final now = DateTime(2026, 8, 30, 12);
    final today = DateTime(2026, 8, 30, 18);
    final tomorrow = DateTime(2026, 8, 31, 9);
    final yesterday = DateTime(2026, 8, 29, 9);

    test('picks the nearest future date', () {
      final result = selectUpcomingBooking(
        [booking(id: 2, date: tomorrow), booking(id: 1, date: today)],
        now: now,
      );
      expect(result?.id, 1);
    });

    test('excludes past, cancelled, unknown-status, and null dates', () {
      final result = selectUpcomingBooking(
        [
          booking(id: 1, date: yesterday),
          booking(id: 2, date: tomorrow, status: 'cancelled'),
          booking(id: 3, date: tomorrow, status: 'refunded'),
          booking(id: 4, status: 'confirmed'),
        ],
        now: now,
      );
      expect(result, isNull);
    });

    test('same-day tie prefers confirmed, then lowest id', () {
      final pending = booking(id: 1, date: today, status: 'pending');
      final confirmed = booking(id: 2, date: today, status: 'confirmed');
      expect(
        selectUpcomingBooking([pending, confirmed], now: now)?.id,
        2,
      );
      expect(
        selectUpcomingBooking(
          [
            booking(id: 9, date: today, status: 'pending'),
            booking(id: 7, date: today, status: 'pending'),
          ],
          now: now,
        )?.id,
        7,
      );
    });

    test('today counts as upcoming (date-only, Time Slot ignored)', () {
      final result = selectUpcomingBooking(
        [booking(id: 1, date: DateTime(2026, 8, 30, 7))],
        now: now,
      );
      expect(result?.id, 1);
    });
  });

  Map<String, Object?> upcomingJson({required int id, required String date}) => {
        'id': id,
        'booking_reference': 'IN-2026-0000$id',
        'user_id': 1,
        'customer_name': 'Maria Clara',
        'pax': 50,
        'event_date': date,
        'event_time': '14:00:00',
        'venue_address': 'The Peninsula Manila',
        'payment_method': 'online',
        'status': 'confirmed',
        'package': {'id': 2, 'name': 'Golden Hour'},
      };

  Widget appWith(GoRouter router, FakeApiBackend backend) {
    return ProviderScope(
      overrides: [
        apiClientProvider.overrideWithValue(buildFakeRestClient(backend)),
      ],
      child: MaterialApp.router(routerConfig: router),
    );
  }

  GoRouter router({String initialLocation = '/profile'}) => GoRouter(
        initialLocation: initialLocation,
        routes: [
          GoRoute(
            path: '/profile',
            builder: (context, state) => const ProfileScreen(),
          ),
          GoRoute(
            path: '/packages',
            builder: (context, state) =>
                const Scaffold(body: Text('packages screen')),
          ),
          GoRoute(
            path: '/bookings/:id',
            builder: (context, state) {
              final id = int.tryParse(state.pathParameters['id'] ?? '');
              if (id == null) return const Scaffold(body: Text('bad id'));
              return BookingDetailScreen(bookingId: id);
            },
          ),
        ],
      );

  // C9: Profile never scrolls — pin the phone viewport like
  // profile_no_overflow_test.dart so layout fits 360x800.
  void usePhoneViewport(WidgetTester tester) {
    tester.view.physicalSize = const Size(360, 800);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);
  }

  testWidgets('C38: profile Edit tile navigates, no inline form card',
      (tester) async {
    usePhoneViewport(tester);
    final future = DateTime.now().add(const Duration(days: 16));
    final backend = FakeApiBackend()
      ..bookingsOverride = [
        upcomingJson(id: 1, date: future.toIso8601String()),
      ];

    await tester.pumpWidget(appWith(router(), backend));
    await tester.pumpAndSettle();

    // C37: Upcoming section removed from profile even with data.
    expect(find.byType(UpcomingBookingSection), findsNothing);
    expect(find.text('UPCOMING BOOKING'), findsNothing);
    expect(find.text('No upcoming Booking yet'), findsNothing);
    // C37: inline form card removed (supersedes C29 scaffold).
    expect(find.byKey(const Key('profile_name')), findsNothing);
    expect(find.byKey(const Key('profile_email')), findsNothing);
    expect(find.byKey(const Key('profile_phone')), findsNothing);
    expect(find.text('Saving deferred — wiring in C14/C15.'), findsNothing);
    // C37: Help & Support tile removed (overflow fix).
    expect(find.text('Help & Support'), findsNothing);
    // C38: Edit Profile tile navigates to /profile/edit (plain nav).
    // C39: Change Password is plain navigation to /profile/password
    // (scaffold ships disabled submit, C15 wires it).
    expect(find.text('Edit Profile'), findsOneWidget);
    expect(find.text('Deferred — available in C14'), findsNothing);
    expect(find.text('Change Password'), findsOneWidget);
    expect(find.text('Deferred — available in C15'), findsNothing);
    // C9/C37: no overflow at 360x800 — any overflow throws.
    expect(tester.takeException(), isNull);
  });

  testWidgets('C29: /bookings/:id route still resolves to detail',
      (tester) async {
    usePhoneViewport(tester);
    final future = DateTime.now().add(const Duration(days: 16));
    final backend = FakeApiBackend()
      ..bookingsOverride = [
        upcomingJson(id: 1, date: future.toIso8601String()),
      ];

    await tester.pumpWidget(
        appWith(router(initialLocation: '/bookings/1'), backend));
    await tester.pumpAndSettle();

    expect(find.byType(BookingDetailScreen), findsOneWidget);
    expect(find.text('IN-2026-00001'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });
}
