import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:inea_scents_client/config/theme.dart';
import 'package:inea_scents_client/models/index.dart';
import 'package:inea_scents_client/providers/index.dart';
import 'package:inea_scents_client/screens/my_bookings_screen.dart';

/// C78: bookings list defaults to most-recent first with sort / filter /
/// search controls below the header.
void main() {
  setUpAll(() {
    GoogleFonts.config.allowRuntimeFetching = false;
  });

  Booking sample({
    required int id,
    required String status,
    required double price,
    required DateTime date,
    String name = 'Customer',
    String packageName = 'Essential 10ml',
  }) =>
      Booking(
        id: id,
        bookingReference: 'REF-$id',
        status: status,
        customerName: name,
        pax: 50,
        eventDate: date,
        package: Package(id: 1, name: packageName, price: price),
      );

  List<Booking> three() => [
        sample(
            id: 1,
            status: 'confirmed',
            price: 4499,
            date: DateTime(2026, 10, 3),
            name: 'Amy'),
        sample(
            id: 2,
            status: 'cancelled',
            price: 8799,
            date: DateTime(2026, 10, 1),
            name: 'Ben'),
        sample(
            id: 3,
            status: 'confirmed',
            price: 6399,
            date: DateTime(2026, 10, 2),
            name: 'Cara'),
      ];

  Future<void> pumpBookings(
      WidgetTester tester, List<Booking> bookings) async {
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
          bookingsProvider.overrideWith((ref) => Future.value(bookings)),
        ],
        child: MaterialApp.router(
          theme: AppTheme.lightTheme,
          routerConfig: router,
        ),
      ),
    );
    await tester.pumpAndSettle();
  }

  /// Vertical order of the three reference labels, top to bottom.
  List<String> referenceOrder(WidgetTester tester) {
    final ys = <String, double>{
      for (final ref in ['REF-1', 'REF-2', 'REF-3'])
        if (find.text(ref).evaluate().isNotEmpty)
          ref: tester.getCenter(find.text(ref)).dy,
    };
    final sorted = ys.entries.toList()
      ..sort((a, b) => a.value.compareTo(b.value));
    return [for (final e in sorted) e.key];
  }

  testWidgets('defaults to most recent first', (tester) async {
    await pumpBookings(tester, three());

    // No createdAt on Booking — most recent = highest id first.
    expect(referenceOrder(tester), ['REF-3', 'REF-2', 'REF-1']);
    expect(find.text('3 bookings'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });

  testWidgets('search filters by name', (tester) async {
    await pumpBookings(tester, three());

    await tester.enterText(
        find.byType(TextField), 'ben');
    await tester.pumpAndSettle();

    expect(find.text('REF-2'), findsOneWidget);
    expect(find.text('REF-1'), findsNothing);
    expect(find.text('REF-3'), findsNothing);
    expect(tester.takeException(), isNull);
  });

  testWidgets('search with no match shows empty message', (tester) async {
    await pumpBookings(tester, three());

    await tester.enterText(
        find.byType(TextField), 'zzz-no-one');
    await tester.pumpAndSettle();

    expect(
        find.text('No bookings match your filters.'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });

  testWidgets('status chip filters the list', (tester) async {
    await pumpBookings(tester, three());

    await tester.tap(find.text('cancelled'));
    await tester.pumpAndSettle();

    expect(find.text('REF-2'), findsOneWidget);
    expect(find.text('REF-1'), findsNothing);
    expect(find.text('REF-3'), findsNothing);
    expect(tester.takeException(), isNull);
  });

  testWidgets('price sort toggles ascending then descending', (tester) async {
    await pumpBookings(tester, three());

    await tester.tap(find.text('Price'));
    await tester.pumpAndSettle();
    expect(referenceOrder(tester), ['REF-1', 'REF-3', 'REF-2']);

    await tester.tap(find.text('Price'));
    await tester.pumpAndSettle();
    expect(referenceOrder(tester), ['REF-2', 'REF-3', 'REF-1']);
    expect(tester.takeException(), isNull);
  });

  testWidgets('event date sort orders chronologically', (tester) async {
    await pumpBookings(tester, three());

    await tester.tap(find.text('Event date'));
    await tester.pumpAndSettle();
    expect(referenceOrder(tester), ['REF-2', 'REF-3', 'REF-1']);
    expect(tester.takeException(), isNull);
  });

  testWidgets('status sort toggles ascending then descending', (tester) async {
    await pumpBookings(tester, three());

    await tester.tap(find.text('Status'));
    await tester.pumpAndSettle();
    // Ascending: cancelled first.
    expect(referenceOrder(tester).first, 'REF-2');

    await tester.tap(find.text('Status'));
    await tester.pumpAndSettle();
    // Descending: cancelled last, confirmed pair on top in either order.
    final order = referenceOrder(tester);
    expect(order.last, 'REF-2');
    expect(order.sublist(0, 2).toSet(), {'REF-1', 'REF-3'});
    expect(tester.takeException(), isNull);
  });

  testWidgets('search matches package, reference, and id', (tester) async {
    final bookings = [
      sample(
          id: 1,
          status: 'confirmed',
          price: 4499,
          date: DateTime(2026, 10, 3),
          packageName: 'Essential 10ml'),
      sample(
          id: 2,
          status: 'confirmed',
          price: 6399,
          date: DateTime(2026, 10, 1),
          packageName: 'Royal Oud Bar'),
      sample(
          id: 3,
          status: 'confirmed',
          price: 8799,
          date: DateTime(2026, 10, 2),
          packageName: 'Essential 10ml'),
    ];
    await pumpBookings(tester, bookings);

    await tester.enterText(find.byType(TextField), 'oud');
    await tester.pumpAndSettle();
    expect(find.text('Royal Oud Bar'), findsOneWidget);
    expect(find.text('Essential 10ml'), findsNothing);

    // Reference search: assert via the card's package name to avoid
    // matching the query text still shown inside the search field.
    await tester.enterText(find.byType(TextField), 'REF-1');
    await tester.pumpAndSettle();
    expect(find.text('Essential 10ml'), findsOneWidget);
    expect(find.text('Royal Oud Bar'), findsNothing);
    expect(tester.takeException(), isNull);
  });

  testWidgets('nulls sort last in both directions', (tester) async {
    final bookings = [
      sample(
          id: 1, status: 'confirmed', price: 4499, date: DateTime(2026, 10, 3)),
      Booking(
        id: 2,
        bookingReference: 'REF-2',
        status: 'confirmed',
        customerName: 'Ben',
        pax: 50,
        eventDate: null,
        package: null,
      ),
      sample(
          id: 3, status: 'confirmed', price: 8799, date: DateTime(2026, 10, 1)),
    ];
    await pumpBookings(tester, bookings);

    await tester.tap(find.text('Price'));
    await tester.pumpAndSettle();
    expect(referenceOrder(tester).last, 'REF-2');

    await tester.tap(find.text('Price'));
    await tester.pumpAndSettle();
    expect(referenceOrder(tester).last, 'REF-2');
    expect(tester.takeException(), isNull);
  });
}
