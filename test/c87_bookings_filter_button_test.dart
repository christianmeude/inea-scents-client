import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:inea_scents_client/config/theme.dart';
import 'package:inea_scents_client/models/index.dart';
import 'package:inea_scents_client/providers/index.dart';
import 'package:inea_scents_client/screens/my_bookings_screen.dart';

/// C87: Bookings filter button sits at the search bar's RIGHT (below the
/// header, never header level); it opens a popover panel on web (≥768px)
/// and a bottom sheet on mobile. Sort + status live inside the
/// panel (C90: search lives only in the in-row field below the header);
/// the main layout shows zero bare chips.
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
    WidgetTester tester, {
    required Size size,
  }) async {
    final router = GoRouter(
      initialLocation: '/bookings',
      routes: [
        GoRoute(
          path: '/bookings',
          builder: (context, state) => const MyBookingsScreen(),
        ),
      ],
    );
    tester.view.physicalSize = size;
    tester.view.devicePixelRatio = 1.0;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          bookingsProvider.overrideWith((ref) => Future.value(three())),
        ],
        child: MaterialApp.router(
          theme: AppTheme.lightTheme,
          routerConfig: router,
        ),
      ),
    );
    await tester.pumpAndSettle();
  }

  Future<void> openFilters(WidgetTester tester) async {
    await tester.tap(find.byKey(const Key('bookings_filter_button')));
    await tester.pumpAndSettle();
  }

  /// Shared assertions: search row below header, button at its right,
  /// no bare chips in the main layout.
  void expectSearchRowLayout(WidgetTester tester) {
    final searchCenter = tester.getCenter(
      find.byKey(const Key('bookings_search_field')),
    );
    final buttonCenter = tester.getCenter(
      find.byKey(const Key('bookings_filter_button')),
    );
    final headerCenter = tester.getCenter(find.text('My Bookings'));
    // Button sits at the search bar's right, on the same row.
    expect(buttonCenter.dx, greaterThan(searchCenter.dx));
    expect(
      (buttonCenter.dy - searchCenter.dy).abs(),
      lessThan(40),
    );
    // Both sit below the header — never header level.
    expect(searchCenter.dy, greaterThan(headerCenter.dy));
    expect(buttonCenter.dy, greaterThan(headerCenter.dy));
    // Zero bare chips in the main layout.
    expect(find.byType(ChoiceChip), findsNothing);
    expect(find.byType(FilterChip), findsNothing);
  }

  testWidgets('390px: filter button at search right opens bottom sheet',
      (tester) async {
    await pumpBookings(tester, size: const Size(390, 844));
    expectSearchRowLayout(tester);

    await openFilters(tester);

    // Mobile (<768px) → bottom sheet, never a dialog popover.
    expect(find.byType(BottomSheet), findsOneWidget);
    expect(find.byType(Dialog), findsNothing);
    // Sort + status live inside the panel; search lives only in-row.
    expect(find.byKey(const Key('filter_panel_search')), findsNothing);
    expect(find.text('Sort by'), findsOneWidget);
    expect(find.text('Booking status'), findsOneWidget);
    expect(find.byType(ChoiceChip), findsWidgets);
    expect(find.byType(FilterChip), findsWidgets);
    expect(tester.takeException(), isNull);
  });

  testWidgets('1200px: filter button at search right opens popover',
      (tester) async {
    await pumpBookings(tester, size: const Size(1200, 800));
    expectSearchRowLayout(tester);

    await openFilters(tester);

    // Web (≥768px) → dialog popover, never a bottom sheet.
    expect(find.byKey(const Key('bookings_filter_dialog')), findsOneWidget);
    expect(find.byType(BottomSheet), findsNothing);
    // Sort + status live inside the panel; search lives only in-row.
    expect(find.byKey(const Key('filter_panel_search')), findsNothing);
    expect(find.text('Sort by'), findsOneWidget);
    expect(find.text('Booking status'), findsOneWidget);
    expect(find.byType(ChoiceChip), findsWidgets);
    expect(find.byType(FilterChip), findsWidgets);
    expect(tester.takeException(), isNull);
  });

  testWidgets('390px: panel status chip filters the list', (tester) async {
    await pumpBookings(tester, size: const Size(390, 844));
    await openFilters(tester);

    await tester.tap(find.text('cancelled'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Show results'));
    await tester.pumpAndSettle();

    expect(find.text('REF-2'), findsOneWidget);
    expect(find.text('REF-1'), findsNothing);
    expect(find.text('REF-3'), findsNothing);
    expect(tester.takeException(), isNull);
  });

  testWidgets('1200px: panel price sort reorders the list', (tester) async {
    await pumpBookings(tester, size: const Size(1200, 800));
    await openFilters(tester);

    await tester.tap(find.text('Price'));
    await tester.pumpAndSettle();

    List<String> order() {
      final ys = <String, double>{
        for (final ref in ['REF-1', 'REF-2', 'REF-3'])
          if (find.text(ref).evaluate().isNotEmpty)
            ref: tester.getCenter(find.text(ref)).dy,
      };
      final sorted = ys.entries.toList()
        ..sort((a, b) => a.value.compareTo(b.value));
      return [for (final e in sorted) e.key];
    }

    // Ascending by price: 4499, 6399, 8799.
    expect(order(), ['REF-1', 'REF-3', 'REF-2']);
    expect(tester.takeException(), isNull);
  });

  testWidgets('390px: in-row search is the sole search', (tester) async {
    await pumpBookings(tester, size: const Size(390, 844));
    await openFilters(tester);

    // C90: no search slot inside the panel (web popover + mobile sheet).
    expect(find.byKey(const Key('filter_panel_search')), findsNothing);
    await tester.tap(find.text('Show results'));
    await tester.pumpAndSettle();

    // The in-row field below the header remains the only search.
    await tester.enterText(
      find.byKey(const Key('bookings_search_field')),
      'ben',
    );
    await tester.pumpAndSettle();

    expect(find.text('REF-2'), findsOneWidget);
    expect(find.text('REF-1'), findsNothing);
    expect(find.text('REF-3'), findsNothing);
    expect(tester.takeException(), isNull);
  });
}
