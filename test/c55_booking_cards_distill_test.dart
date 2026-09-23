import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:inea_scents_client/config/theme.dart';
import 'package:inea_scents_client/models/index.dart';
import 'package:inea_scents_client/providers/index.dart';
import 'package:inea_scents_client/screens/my_bookings_screen.dart';

/// C55: booking cards distill — card subtitle gone, status chips use
/// AppTheme semantic tokens with a bolder treatment.
void main() {
  setUpAll(() {
    GoogleFonts.config.allowRuntimeFetching = false;
  });

  Booking bookingWithStatus(int id, String status) => Booking(
    id: id,
    bookingReference: 'IN-2026-${id.toString().padLeft(6, '0')}',
    status: status,
    pax: 50,
    eventDate: DateTime(2026, 10, 1),
    venueAddress: 'The Peninsula Manila',
    package: const Package(id: 1, name: 'Essential 10ml Perfume Bar', price: 4499),
  );

  Future<void> pumpBookings(WidgetTester tester, List<Booking> bookings) async {
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

  /// Walks up from the chip label to the rounded chip Container.
  Container chipContainerOf(WidgetTester tester, String label) {
    final ancestors = find.ancestor(
      of: find.text(label),
      matching: find.byType(Container),
    );
    for (final element in ancestors.evaluate()) {
      final container = element.widget as Container;
      final decoration = container.decoration;
      if (decoration is BoxDecoration &&
          decoration.borderRadius == BorderRadius.circular(20)) {
        return container;
      }
    }
    fail('status chip container for $label not found');
  }

  void expectChipColor(WidgetTester tester, String label, Color expected) {
    final labelWidget = tester.widget<Text>(find.text(label));
    expect(labelWidget.style?.color, expected);
    expect(labelWidget.style?.fontWeight, FontWeight.w800);
    final chip = chipContainerOf(tester, label);
    final decoration = chip.decoration as BoxDecoration;
    expect(decoration.color, expected.withValues(alpha: 0.18));
    expect(
      decoration.border,
      Border.all(color: expected.withValues(alpha: 0.40), width: 1),
    );
  }

  testWidgets('card subtitle removed', (WidgetTester tester) async {
    await pumpBookings(tester, [bookingWithStatus(1, 'confirmed')]);

    expect(find.text('INEA Scents Perfume Experience'), findsNothing);
    // Card content itself still renders.
    expect(find.text('IN-2026-000001'), findsOneWidget);
    expect(find.text('Essential 10ml Perfume Bar'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });

  testWidgets('status chips map to AppTheme semantic colors', (
    WidgetTester tester,
  ) async {
    await pumpBookings(tester, [
      bookingWithStatus(1, 'confirmed'),
      bookingWithStatus(2, 'pending'),
      bookingWithStatus(3, 'cancelled'),
      bookingWithStatus(4, 'refunded'),
    ]);

    expectChipColor(tester, 'CONFIRMED', AppTheme.success);
    expectChipColor(tester, 'PENDING', AppTheme.pending);
    expectChipColor(tester, 'CANCELLED', AppTheme.errorOnLight);
    expectChipColor(tester, 'REFUNDED', AppTheme.secondary);
    expect(tester.takeException(), isNull);
  });
}
