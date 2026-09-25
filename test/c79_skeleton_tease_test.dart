import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:inea_scents_client/config/theme.dart';
import 'package:inea_scents_client/widgets/index.dart';

void main() {
  setUpAll(() {
    GoogleFonts.config.allowRuntimeFetching = false;
  });

  testWidgets('bookings skeleton renders with key and 2 cards by default',
      (WidgetTester tester) async {
    await tester.pumpWidget(
      MaterialApp(
        theme: AppTheme.lightTheme,
        home: const Scaffold(
          body: SingleChildScrollView(child: SkeletonBookingsList()),
        ),
      ),
    );
    await tester.pump();

    expect(find.byKey(const Key('skeleton_bookings_list')), findsOneWidget);
    expect(find.byKey(const Key('skeleton_booking_card_0')), findsOneWidget);
    expect(find.byKey(const Key('skeleton_booking_card_1')), findsOneWidget);
    expect(find.byType(CircularProgressIndicator), findsNothing);
    expect(tester.takeException(), isNull);
  });

  testWidgets('bookings skeleton shows N cards', (WidgetTester tester) async {
    await tester.pumpWidget(
      MaterialApp(
        theme: AppTheme.lightTheme,
        home: const Scaffold(
          body: SingleChildScrollView(
            child: SkeletonBookingsList(cardCount: 3),
          ),
        ),
      ),
    );
    await tester.pump();

    expect(find.byKey(const Key('skeleton_booking_card_0')), findsOneWidget);
    expect(find.byKey(const Key('skeleton_booking_card_1')), findsOneWidget);
    expect(find.byKey(const Key('skeleton_booking_card_2')), findsOneWidget);
    expect(tester.takeException(), isNull);
  });

  testWidgets('booking flow skeleton renders with key', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(
      MaterialApp(
        theme: AppTheme.lightTheme,
        home: const Scaffold(
          body: SingleChildScrollView(child: SkeletonBookingFlow()),
        ),
      ),
    );
    await tester.pump();

    expect(find.byKey(const Key('skeleton_booking_flow')), findsOneWidget);
    expect(
      find.byKey(const Key('skeleton_flow_pax_header')),
      findsOneWidget,
    );
    expect(find.byKey(const Key('skeleton_flow_cta')), findsOneWidget);
    expect(find.byType(CircularProgressIndicator), findsNothing);
    expect(tester.takeException(), isNull);
  });

  testWidgets('booking flow skeleton shows rail on wide', (
    WidgetTester tester,
  ) async {
    tester.view.physicalSize = const Size(1400, 900);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    await tester.pumpWidget(
      MaterialApp(
        theme: AppTheme.lightTheme,
        home: const Scaffold(
          body: SizedBox(width: 1400, child: SkeletonBookingFlow()),
        ),
      ),
    );
    await tester.pump();

    expect(find.byKey(const Key('skeleton_flow_summary')), findsOneWidget);
    expect(find.byKey(const Key('skeleton_flow_month_nav')), findsOneWidget);
    expect(
      find.byKey(const Key('skeleton_flow_weekday_header')),
      findsOneWidget,
    );
    expect(tester.takeException(), isNull);
  });
}
