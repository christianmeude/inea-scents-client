import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:inea_scents_client/config/theme.dart';
import 'package:inea_scents_client/widgets/index.dart';
import 'package:shimmer/shimmer.dart';

void main() {
  setUpAll(() {
    GoogleFonts.config.allowRuntimeFetching = false;
  });

  Future<void> pumpSkeleton(WidgetTester tester) async {
    await tester.pumpWidget(
      MaterialApp(
        theme: AppTheme.lightTheme,
        home: const Scaffold(
          body: SingleChildScrollView(child: SkeletonBookingsList()),
        ),
      ),
    );
    await tester.pump();
  }

  testWidgets('header teases title-over-count pairing', (
    WidgetTester tester,
  ) async {
    await pumpSkeleton(tester);

    final title = find.byKey(const Key('skeleton_bookings_header_title'));
    final count = find.byKey(const Key('skeleton_bookings_header_count'));
    expect(title, findsOneWidget);
    expect(count, findsOneWidget);

    expect(tester.getSize(title).height, 32);
    expect(tester.getSize(count).height, 13);
    // Stacked: title renders above count.
    expect(
      tester.getTopLeft(title).dy,
      lessThan(tester.getTopLeft(count).dy),
    );
    expect(tester.takeException(), isNull);
  });

  testWidgets('detail rows stack label-over-value', (
    WidgetTester tester,
  ) async {
    await pumpSkeleton(tester);

    for (int row = 0; row < 3; row++) {
      final label = find.byKey(
        Key('skeleton_booking_card_0_detail_${row}_label'),
      );
      final value = find.byKey(
        Key('skeleton_booking_card_0_detail_${row}_value'),
      );
      expect(label, findsOneWidget, reason: 'row $row label');
      expect(value, findsOneWidget, reason: 'row $row value');

      expect(tester.getSize(label).height, 9);
      expect(tester.getSize(value).height, 12);
      // Stacked: label renders above value.
      expect(
        tester.getTopLeft(label).dy,
        lessThan(tester.getTopLeft(value).dy),
        reason: 'row $row stacked',
      );
    }
    expect(tester.takeException(), isNull);
  });

  testWidgets('single parent Shimmer invariant holds', (
    WidgetTester tester,
  ) async {
    await pumpSkeleton(tester);

    expect(find.byType(Shimmer), findsOneWidget);
    expect(tester.takeException(), isNull);
  });
}
