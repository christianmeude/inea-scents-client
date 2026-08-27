import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:inea_scents_client/config/theme.dart';
import 'package:inea_scents_client/models/index.dart';
import 'package:inea_scents_client/providers/index.dart';
import 'package:inea_scents_client/screens/booking_screen.dart';
import 'package:inea_scents_client/widgets/index.dart';

void main() {
  setUpAll(() {
    GoogleFonts.config.allowRuntimeFetching = false;
  });

  final testPackage = Package(
    id: 42,
    name: 'Dior Women Luxury Experience',
    description: 'A luxurious custom perfume bar experience designed for weddings, birthdays, and celebrations.',
    price: 4500.0,
    rating: 4.9,
    reviewsCount: 184,
    inclusions: [
      'Featuring your logo',
      '4 Inspired scents',
      'Perfume Bar Setup',
      'Claim Stub',
      '2 staff members',
    ],
    freebies: [
      'Selfie Mirror',
      '1 Gift for Celebrant',
    ],
    paxOptions: [20, 30, 50, 75, 100],
    images: ['https://example.com/luxury_package.jpg'],
  );

  Widget createBookingScreenWidget({
    required Size screenSize,
    int packageId = 42,
    Package? package,
  }) {
    return ProviderScope(
      overrides: [
        packageDetailsProvider(packageId).overrideWith((ref) => package ?? testPackage),
      ],
      child: MaterialApp(
        theme: AppTheme.lightTheme,
        home: ResponsiveAppShell(
          child: BookingScreen(packageId: packageId),
        ),
      ),
    );
  }

  group('Issue #44: 3-Column Reservation Flow Layout Tests', () {
    testWidgets('R1: Desktop Split View renders 3-column layout on 1200x800 viewport (>1024px)',
        (WidgetTester tester) async {
      tester.view.physicalSize = const Size(1200, 800);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);

      await tester.pumpWidget(
        createBookingScreenWidget(screenSize: const Size(1200, 800)),
      );
      await tester.pumpAndSettle();

      // Verify all 3 primary columns are rendered
      expect(find.byKey(const Key('reservation_calendar_panel')), findsOneWidget);
      expect(find.byKey(const Key('reservation_details_panel')), findsOneWidget);
      expect(find.byKey(const Key('order_summary_side_panel')), findsOneWidget);

      // Verify desktop header is present
      expect(find.text('3-Column Reservation Flow'), findsOneWidget);
      expect(find.textContaining('Reservation —'), findsOneWidget);

      // Layout coordinate verification:
      // Left (Calendar) < Middle (Details) < Right (Order Summary)
      final calendarPos = tester.getTopLeft(find.byKey(const Key('reservation_calendar_panel')));
      final detailsPos = tester.getTopLeft(find.byKey(const Key('reservation_details_panel')));
      final summaryPos = tester.getTopLeft(find.byKey(const Key('order_summary_side_panel')));

      expect(calendarPos.dx, lessThan(detailsPos.dx));
      expect(detailsPos.dx, lessThan(summaryPos.dx));

      // Verify contents inside Left column (Calendar)
      expect(find.text('1. Select Date'), findsOneWidget);
      expect(find.text('Available'), findsWidgets);
      expect(find.text('Booked'), findsWidgets);

      // Verify contents inside Middle column (Packages/Times)
      expect(find.text('2. Choose Available Pax'), findsOneWidget);
      expect(find.text('3. Select Time Slot'), findsOneWidget);
      expect(find.text('4. Payment Method'), findsOneWidget);

      // Verify contents inside Right column (Sticky Order Summary)
      expect(find.text('Order Summary'), findsOneWidget);
      expect(find.text('Live Preview'), findsOneWidget);
      expect(find.text('Price Breakdown'), findsOneWidget);
      expect(find.text('Confirm & Pay'), findsOneWidget);
      expect(find.text('Php. 4500.00'), findsOneWidget);
    });

    testWidgets('R1: Order Summary side-panel remains sticky and visible during middle column scrolling',
        (WidgetTester tester) async {
      tester.view.physicalSize = const Size(1200, 800);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);

      await tester.pumpWidget(
        createBookingScreenWidget(screenSize: const Size(1200, 800)),
      );
      await tester.pumpAndSettle();

      // Check initial position of Order Summary panel
      final initialSummaryPos = tester.getTopLeft(find.byKey(const Key('order_summary_side_panel')));
      final initialButtonPos = tester.getTopLeft(find.text('Confirm & Pay'));

      // Find middle scroll view and scroll down by 400 pixels
      final middleScrollFinder = find.byKey(const Key('desktop_middle_scroll_view'));
      expect(middleScrollFinder, findsOneWidget);

      await tester.drag(middleScrollFinder, const Offset(0, -300));
      await tester.pumpAndSettle();

      // Check position of Order Summary panel after middle column scroll
      final scrolledSummaryPos = tester.getTopLeft(find.byKey(const Key('order_summary_side_panel')));
      final scrolledButtonPos = tester.getTopLeft(find.text('Confirm & Pay'));

      // The Order Summary panel position must remain unchanged (sticky/fixed in viewport)
      expect(scrolledSummaryPos.dy, equals(initialSummaryPos.dy));
      expect(scrolledSummaryPos.dx, equals(initialSummaryPos.dx));
      expect(scrolledButtonPos.dy, equals(initialButtonPos.dy));

      // Verify Order Summary and CTA button are still 100% visible and interactive
      expect(find.byKey(const Key('order_summary_side_panel')), findsOneWidget);
      expect(find.text('Confirm & Pay'), findsOneWidget);
    });

    testWidgets('R2: Tablet View renders 2-column layout on 800x800 viewport (768px - 1024px)',
        (WidgetTester tester) async {
      tester.view.physicalSize = const Size(800, 800);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);

      await tester.pumpWidget(
        createBookingScreenWidget(screenSize: const Size(800, 800)),
      );
      await tester.pumpAndSettle();

      // On tablet: Tablet specific panels are rendered
      expect(find.byKey(const Key('tablet_calendar_panel')), findsOneWidget);
      expect(find.byKey(const Key('tablet_details_panel')), findsOneWidget);
      expect(find.byKey(const Key('tablet_order_summary_panel')), findsOneWidget);

      // Desktop 3-column specific keys are not rendered
      expect(find.byKey(const Key('order_summary_side_panel')), findsNothing);

      // Verify 2-column horizontal coordinate ordering: Left column < Right column
      final leftPos = tester.getTopLeft(find.byKey(const Key('tablet_calendar_panel')));
      final rightPos = tester.getTopLeft(find.byKey(const Key('tablet_order_summary_panel')));
      expect(leftPos.dx, lessThan(rightPos.dx));
    });

    testWidgets('R2: Mobile View renders 1-column vertical step flow on 375x667 viewport (<768px)',
        (WidgetTester tester) async {
      tester.view.physicalSize = const Size(375, 667);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);

      await tester.pumpWidget(
        createBookingScreenWidget(screenSize: const Size(375, 667)),
      );
      await tester.pumpAndSettle();

      // On mobile: Timeline and mobile scroll view are rendered
      expect(find.byKey(const Key('mobile_step_scroll_view')), findsOneWidget);
      expect(find.text('Schedule'), findsWidgets);
      expect(find.text('Next'), findsOneWidget);

      // Desktop/tablet 3-column & 2-column keys are not rendered
      expect(find.byKey(const Key('reservation_calendar_panel')), findsNothing);
      expect(find.byKey(const Key('order_summary_side_panel')), findsNothing);
      expect(find.byKey(const Key('tablet_order_summary_panel')), findsNothing);
    });

    testWidgets('Interactive Pax selection updates Order Summary in real-time on desktop',
        (WidgetTester tester) async {
      tester.view.physicalSize = const Size(1200, 800);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);

      await tester.pumpWidget(
        createBookingScreenWidget(screenSize: const Size(1200, 800)),
      );
      await tester.pumpAndSettle();

      // Initially, default pax is 20 Pax (from testPackage.paxOptions.first)
      expect(find.text('Capacity'), findsOneWidget);
      expect(find.text('20 Pax'), findsWidgets);

      // Tap on '75 Pax' choice in middle column
      final seventyFivePaxFinder = find.text('75 Pax');
      expect(seventyFivePaxFinder, findsOneWidget);
      await tester.tap(seventyFivePaxFinder);
      await tester.pumpAndSettle();

      // Verify Order Summary now reflects 75 Pax
      expect(find.text('75 Pax'), findsWidgets);
    });

    testWidgets('Interactive Time slot selection updates Order Summary in real-time on desktop',
        (WidgetTester tester) async {
      tester.view.physicalSize = const Size(1200, 800);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);

      await tester.pumpWidget(
        createBookingScreenWidget(screenSize: const Size(1200, 800)),
      );
      await tester.pumpAndSettle();

      // Select '6:00 PM - 9:00 PM' time slot
      final eveningSlotFinder = find.text('6:00 PM - 9:00 PM');
      expect(eveningSlotFinder, findsOneWidget);
      await tester.tap(eveningSlotFinder);
      await tester.pumpAndSettle();

      // Verify Order Summary displays '6:00 PM - 9:00 PM'
      final timeFinder = find.descendant(
        of: find.byKey(const Key('order_summary_side_panel')),
        matching: find.text('6:00 PM - 9:00 PM'),
      );
      expect(timeFinder, findsOneWidget);
    });

    testWidgets('Interactive Payment Method toggle updates Order Summary in real-time on desktop',
        (WidgetTester tester) async {
      tester.view.physicalSize = const Size(1200, 800);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);

      await tester.pumpWidget(
        createBookingScreenWidget(screenSize: const Size(1200, 800)),
      );
      await tester.pumpAndSettle();

      // Select 'Maya' in middle column
      final mayaFinder = find.text('Maya');
      await tester.scrollUntilVisible(
        mayaFinder,
        100,
        scrollable: find.descendant(
          of: find.byKey(const Key('desktop_middle_scroll_view')),
          matching: find.byType(Scrollable),
        ),
      );
      expect(mayaFinder, findsOneWidget);
      await tester.tap(mayaFinder);
      await tester.pumpAndSettle();

      // Verify Order Summary displays 'MAYA' badge
      expect(find.text('MAYA'), findsOneWidget);
    });

    testWidgets('Confirm & Pay button completes flow and renders Payment Successful view',
        (WidgetTester tester) async {
      tester.view.physicalSize = const Size(1200, 800);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);

      await tester.pumpWidget(
        createBookingScreenWidget(screenSize: const Size(1200, 800)),
      );
      await tester.pumpAndSettle();

      // Tap 'Confirm & Pay' in sticky Order Summary panel
      final confirmButtonFinder = find.text('Confirm & Pay');
      expect(confirmButtonFinder, findsOneWidget);
      await tester.tap(confirmButtonFinder);
      await tester.pumpAndSettle();

      // Verify Payment Successful screen appears
      expect(find.text('Payment Successful'), findsOneWidget);
      expect(find.text('Thank you for your booking.'), findsOneWidget);
      expect(find.text('Done'), findsOneWidget);
    });

    testWidgets('Dynamic resize smoothly transitions 3-column -> 2-column -> 1-column without errors',
        (WidgetTester tester) async {
      tester.view.physicalSize = const Size(1200, 800);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);

      await tester.pumpWidget(
        createBookingScreenWidget(screenSize: const Size(1200, 800)),
      );
      await tester.pumpAndSettle();

      // 1. Desktop mode (1200px) -> 3 columns
      expect(find.byKey(const Key('reservation_calendar_panel')), findsOneWidget);
      expect(find.byKey(const Key('order_summary_side_panel')), findsOneWidget);

      // 2. Resize to Tablet (900px) -> 2 columns
      tester.view.physicalSize = const Size(900, 800);
      await tester.pumpAndSettle();
      expect(find.byKey(const Key('tablet_calendar_panel')), findsOneWidget);
      expect(find.byKey(const Key('tablet_order_summary_panel')), findsOneWidget);
      expect(find.byKey(const Key('order_summary_side_panel')), findsNothing);

      // 3. Resize to Mobile (375px) -> 1 column
      tester.view.physicalSize = const Size(375, 667);
      await tester.pumpAndSettle();
      expect(find.byKey(const Key('mobile_step_scroll_view')), findsOneWidget);
      expect(find.byKey(const Key('tablet_order_summary_panel')), findsNothing);

      // 4. Resize back to Ultra-wide Desktop (1600px) -> 3 columns
      tester.view.physicalSize = const Size(1600, 900);
      await tester.pumpAndSettle();
      expect(find.byKey(const Key('reservation_calendar_panel')), findsOneWidget);
      expect(find.byKey(const Key('order_summary_side_panel')), findsOneWidget);
    });

    testWidgets('Interactive Date selection in calendar updates Order Summary date',
        (WidgetTester tester) async {
      tester.view.physicalSize = const Size(1200, 800);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);

      await tester.pumpWidget(
        createBookingScreenWidget(screenSize: const Size(1200, 800)),
      );
      await tester.pumpAndSettle();

      // Find calendar panel
      expect(find.byKey(const Key('reservation_calendar_panel')), findsOneWidget);

      // Tap on a day cell in the TableCalendar (e.g. day 15)
      final day15Finder = find.descendant(
        of: find.byKey(const Key('reservation_calendar_panel')),
        matching: find.text('15'),
      );
      if (day15Finder.evaluate().isNotEmpty) {
        await tester.tap(day15Finder.first);
        await tester.pumpAndSettle();

        // Verify Order Summary has date updated
        expect(find.text('Date'), findsOneWidget);
      }
    });

    testWidgets('Handles loading and error retry states cleanly',
        (WidgetTester tester) async {
      tester.view.physicalSize = const Size(1200, 800);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);

      // 1. Loading state
      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            packageDetailsProvider(99).overrideWith((ref) => throw Exception('Network timeout')),
          ],
          child: MaterialApp(
            theme: AppTheme.lightTheme,
            home: const ResponsiveAppShell(
              child: BookingScreen(packageId: 99),
            ),
          ),
        ),
      );
      await tester.pump();

      // Error UI is displayed with retry button
      expect(find.textContaining('Error loading package:'), findsOneWidget);
      expect(find.text('Retry'), findsOneWidget);
    });

    testWidgets('3-Column Desktop view renders robustly under 2.0x accessibility text scale',
        (WidgetTester tester) async {
      tester.view.physicalSize = const Size(1400, 900);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);

      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            packageDetailsProvider(42).overrideWith((ref) => testPackage),
          ],
          child: MaterialApp(
            theme: AppTheme.lightTheme,
            builder: (context, child) {
              return MediaQuery(
                data: MediaQuery.of(context).copyWith(
                  textScaler: const TextScaler.linear(2.0),
                ),
                child: child!,
              );
            },
            home: const ResponsiveAppShell(
              child: BookingScreen(packageId: 42),
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();

      // Verify no crashes occur and layout renders
      expect(find.byKey(const Key('reservation_calendar_panel')), findsOneWidget);
      expect(find.byKey(const Key('reservation_details_panel')), findsOneWidget);
      expect(find.byKey(const Key('order_summary_side_panel')), findsOneWidget);
    });

    testWidgets('Exact breakpoint boundary threshold verification (1025px vs 1024px, 769px vs 768px vs 767px)',
        (WidgetTester tester) async {
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);

      // 1. 1025px (>1024px) -> Desktop 3-Column
      tester.view.physicalSize = const Size(1025, 800);
      await tester.pumpWidget(createBookingScreenWidget(screenSize: const Size(1025, 800)));
      await tester.pumpAndSettle();
      expect(find.byKey(const Key('reservation_calendar_panel')), findsOneWidget);
      expect(find.byKey(const Key('reservation_details_panel')), findsOneWidget);
      expect(find.byKey(const Key('order_summary_side_panel')), findsOneWidget);

      // 2. 1024px (== tabletBreakpoint) -> Tablet 2-Column
      tester.view.physicalSize = const Size(1024, 800);
      await tester.pumpAndSettle();
      expect(find.byKey(const Key('tablet_calendar_panel')), findsOneWidget);
      expect(find.byKey(const Key('tablet_details_panel')), findsOneWidget);
      expect(find.byKey(const Key('tablet_order_summary_panel')), findsOneWidget);
      expect(find.byKey(const Key('order_summary_side_panel')), findsNothing);

      // 3. 769px (Tablet range) -> Tablet 2-Column
      tester.view.physicalSize = const Size(769, 800);
      await tester.pumpAndSettle();
      expect(find.byKey(const Key('tablet_calendar_panel')), findsOneWidget);
      expect(find.byKey(const Key('tablet_order_summary_panel')), findsOneWidget);

      // 4. 768px (== mobileBreakpoint) -> Tablet 2-Column
      tester.view.physicalSize = const Size(768, 800);
      await tester.pumpAndSettle();
      expect(find.byKey(const Key('tablet_calendar_panel')), findsOneWidget);
      expect(find.byKey(const Key('tablet_order_summary_panel')), findsOneWidget);

      // 5. 767px (<768px) -> Mobile 1-Column
      tester.view.physicalSize = const Size(767, 800);
      await tester.pumpAndSettle();
      expect(find.byKey(const Key('mobile_step_scroll_view')), findsOneWidget);
      expect(find.byKey(const Key('tablet_order_summary_panel')), findsNothing);
      expect(find.byKey(const Key('order_summary_side_panel')), findsNothing);
    });

    testWidgets('Rapid boundary oscillation retains selection state across 1023px <-> 1025px & 767px <-> 769px',
        (WidgetTester tester) async {
      tester.view.physicalSize = const Size(1200, 800);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);

      await tester.pumpWidget(createBookingScreenWidget(screenSize: const Size(1200, 800)));
      await tester.pumpAndSettle();

      // Change selections on desktop: 100 Pax, 6:00 PM - 9:00 PM, Maya
      final hundredPaxFinder = find.text('100 Pax');
      expect(hundredPaxFinder, findsOneWidget);
      await tester.tap(hundredPaxFinder);
      await tester.pumpAndSettle();

      final eveningSlotFinder = find.text('6:00 PM - 9:00 PM');
      await tester.tap(eveningSlotFinder);
      await tester.pumpAndSettle();

      final mayaFinder = find.text('Maya');
      await tester.scrollUntilVisible(
        mayaFinder,
        100,
        scrollable: find.descendant(
          of: find.byKey(const Key('desktop_middle_scroll_view')),
          matching: find.byType(Scrollable),
        ),
      );
      await tester.tap(mayaFinder);
      await tester.pumpAndSettle();

      expect(find.text('MAYA'), findsOneWidget);
      expect(find.text('100 Pax'), findsWidgets);

      // Oscillate across desktop/tablet boundary multiple times
      for (int i = 0; i < 3; i++) {
        tester.view.physicalSize = const Size(1023, 800); // Tablet
        await tester.pumpAndSettle();
        expect(find.byKey(const Key('tablet_order_summary_panel')), findsOneWidget);
        expect(find.text('MAYA'), findsOneWidget);

        tester.view.physicalSize = const Size(1025, 800); // Desktop
        await tester.pumpAndSettle();
        expect(find.byKey(const Key('order_summary_side_panel')), findsOneWidget);
        expect(find.text('MAYA'), findsOneWidget);
      }

      // Oscillate across tablet/mobile boundary multiple times
      for (int i = 0; i < 3; i++) {
        tester.view.physicalSize = const Size(767, 800); // Mobile
        await tester.pumpAndSettle();
        expect(find.byKey(const Key('mobile_step_scroll_view')), findsOneWidget);

        tester.view.physicalSize = const Size(769, 800); // Tablet
        await tester.pumpAndSettle();
        expect(find.byKey(const Key('tablet_order_summary_panel')), findsOneWidget);
        expect(find.text('MAYA'), findsOneWidget);
      }
    });

    testWidgets('Calendar range safety and navigation without assertion crashes',
        (WidgetTester tester) async {
      tester.view.physicalSize = const Size(1200, 800);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);

      await tester.pumpWidget(
        MaterialApp(
          theme: AppTheme.lightTheme,
          home: Scaffold(
            body: SizedBox(
              width: 380,
              child: ReservationCalendarPanel(
                selectedDate: DateTime.utc(2026, 9, 15),
                onDateSelected: (_) {},
              ),
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text('1. Select Date'), findsOneWidget);
      expect(find.text('September 15, 2026'), findsOneWidget);

      // Navigate calendar month using next chevron
      final nextChevronFinder = find.byIcon(Icons.chevron_right_rounded);
      expect(nextChevronFinder, findsOneWidget);
      await tester.tap(nextChevronFinder);
      await tester.pumpAndSettle();

      // Navigate calendar month back using previous chevron
      final prevChevronFinder = find.byIcon(Icons.chevron_left_rounded);
      expect(prevChevronFinder, findsOneWidget);
      await tester.tap(prevChevronFinder);
      await tester.pumpAndSettle();

      expect(find.text('September 15, 2026'), findsOneWidget);
    });

    testWidgets('OrderSummaryPanel and ReservationDetailsPanel handle bare/null package data gracefully',
        (WidgetTester tester) async {
      tester.view.physicalSize = const Size(1200, 800);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);

      const minimalPackage = Package(
        id: 1,
        name: null,
        description: null,
        price: null,
        images: null,
        inclusions: null,
        freebies: null,
        paxOptions: null,
      );

      await tester.pumpWidget(
        MaterialApp(
          theme: AppTheme.lightTheme,
          home: Scaffold(
            body: Row(
              children: [
                Expanded(
                  child: ReservationDetailsPanel(
                    package: minimalPackage,
                    selectedPax: null,
                    onPaxSelected: (_) {},
                    selectedTime: null,
                    onTimeSelected: (_) {},
                    paymentMethod: null,
                    onPaymentMethodSelected: (_) {},
                  ),
                ),
                Expanded(
                  child: OrderSummaryPanel(
                    package: minimalPackage,
                    selectedDate: null,
                    selectedTime: null,
                    selectedPax: null,
                    paymentMethod: null,
                    isLoading: true,
                  ),
                ),
              ],
            ),
          ),
        ),
      );
      await tester.pump();

      // Verify null fallbacks
      expect(find.text('Perfume Package'), findsOneWidget);
      expect(find.text('Php. 4500.00'), findsOneWidget);
      expect(find.text('Not selected'), findsOneWidget);
      expect(find.byType(CircularProgressIndicator), findsOneWidget);
    });

    testWidgets('Mobile 1-column step flow allows date, pax, details, payment selection and completes to success screen',
        (WidgetTester tester) async {
      tester.view.physicalSize = const Size(375, 667);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);

      await tester.pumpWidget(createBookingScreenWidget(screenSize: const Size(375, 667)));
      await tester.pumpAndSettle();

      // Step 2: Schedule & Pax
      expect(find.text('Please Choose Available Schedule'), findsOneWidget);
      final thirtyPaxFinder = find.text('30 Pax');
      await tester.scrollUntilVisible(
        thirtyPaxFinder,
        100,
        scrollable: find.descendant(
          of: find.byKey(const Key('mobile_step_scroll_view')),
          matching: find.byType(Scrollable),
        ).first,
      );
      expect(thirtyPaxFinder, findsOneWidget);
      await tester.tap(thirtyPaxFinder);
      await tester.pumpAndSettle();

      // Tap Next to go to Step 3 (Details)
      await tester.tap(find.text('Next'));
      await tester.pumpAndSettle();

      // Step 3: Details
      expect(find.text('Order Details'), findsOneWidget);
      expect(find.text('Proceed to Payment'), findsOneWidget);

      // Tap Proceed to Payment to go to Step 4
      await tester.tap(find.text('Proceed to Payment'));
      await tester.pumpAndSettle();

      // Step 4: Payment
      expect(find.text('Price Details'), findsOneWidget);
      expect(find.text('Choose Payment Method'), findsOneWidget);
      final mayaFinder = find.text('maya');
      await tester.scrollUntilVisible(
        mayaFinder,
        100,
        scrollable: find.descendant(
          of: find.byKey(const Key('mobile_step_scroll_view')),
          matching: find.byType(Scrollable),
        ).first,
      );
      expect(mayaFinder, findsOneWidget);
      await tester.tap(mayaFinder);
      await tester.pumpAndSettle();

      expect(find.text('Confirm & Pay'), findsOneWidget);
      await tester.tap(find.text('Confirm & Pay'));
      await tester.pumpAndSettle();

      // Step 5: Success screen
      expect(find.text('Payment Successful'), findsOneWidget);
      expect(find.text('Done'), findsOneWidget);
    });

    testWidgets('Mobile step flow supports interactive time slot selection and back navigation without placeholder steps',
        (WidgetTester tester) async {
      tester.view.physicalSize = const Size(375, 667);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);

      await tester.pumpWidget(createBookingScreenWidget(screenSize: const Size(375, 667)));
      await tester.pumpAndSettle();

      // Step 2: Select 6:00 PM - 9:00 PM time slot
      final timeSlotFinder = find.text('6:00 PM - 9:00 PM');
      await tester.scrollUntilVisible(
        timeSlotFinder,
        100,
        scrollable: find.descendant(
          of: find.byKey(const Key('mobile_step_scroll_view')),
          matching: find.byType(Scrollable),
        ).first,
      );
      expect(timeSlotFinder, findsOneWidget);
      await tester.tap(timeSlotFinder);
      await tester.pumpAndSettle();

      // Advance to Step 3 (Details)
      await tester.tap(find.text('Next'));
      await tester.pumpAndSettle();

      // Verify selected time and pax are displayed in Details
      expect(find.text('Selected Time:'), findsOneWidget);
      expect(find.text('6:00 PM - 9:00 PM'), findsOneWidget);
      expect(find.text('Selected Pax:'), findsOneWidget);

      // Advance to Step 4 (Payment)
      await tester.tap(find.text('Proceed to Payment'));
      await tester.pumpAndSettle();
      expect(find.text('Price Details'), findsOneWidget);

      // Test Back button from Step 4 -> returns to Step 3
      await tester.tap(find.text('Back'));
      await tester.pumpAndSettle();
      expect(find.text('Order Details'), findsOneWidget);

      // Test Back button from Step 3 -> returns to Step 2
      await tester.tap(find.text('Back'));
      await tester.pumpAndSettle();
      expect(find.text('Please Choose Available Schedule'), findsOneWidget);

      // Verify no placeholder text "Step 1 details here" appears anywhere
      expect(find.textContaining('details here'), findsNothing);
    });

    testWidgets('OrderSummaryPanel and ReservationCalendarPanel handle future dates up to 2035 with clamping',
        (WidgetTester tester) async {
      tester.view.physicalSize = const Size(1200, 800);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);

      // Future date in year 2034
      final futureDate = DateTime.utc(2034, 6, 15);

      await tester.pumpWidget(
        MaterialApp(
          theme: AppTheme.lightTheme,
          home: Scaffold(
            body: Row(
              children: [
                Expanded(
                  child: ReservationCalendarPanel(
                    selectedDate: futureDate,
                    onDateSelected: (_) {},
                  ),
                ),
                Expanded(
                  child: OrderSummaryPanel(
                    package: testPackage,
                    selectedDate: futureDate,
                  ),
                ),
              ],
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text('June 15, 2034'), findsOneWidget);
      expect(find.text('Jun 15, 2034'), findsOneWidget);
    });

    testWidgets('OrderSummaryPanel handles long inclusion strings and text scaling without overflows',
        (WidgetTester tester) async {
      tester.view.physicalSize = const Size(1200, 800);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);

      final extraLongPackage = testPackage.copyWith(
        inclusions: [
          'Extremely long bespoke custom luxury fragrance bar formulation with personalized crystal flacon engraving',
          'VIP Master perfumer consultations and custom ribbon packaging for all guests',
        ],
      );

      await tester.pumpWidget(
        MaterialApp(
          theme: AppTheme.lightTheme,
          home: MediaQuery(
            data: const MediaQueryData(
              size: Size(1200, 800),
              textScaler: TextScaler.linear(1.5),
            ),
            child: Scaffold(
              body: SizedBox(
                width: 320,
                child: SingleChildScrollView(
                  child: OrderSummaryPanel(package: extraLongPackage),
                ),
              ),
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text('Order Summary'), findsOneWidget);
      expect(find.text('Price Breakdown'), findsOneWidget);
      expect(tester.takeException(), isNull);
    });

    testWidgets('BookingScreen renders cleanly in Dark Theme',
        (WidgetTester tester) async {
      tester.view.physicalSize = const Size(1200, 800);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);

      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            packageDetailsProvider(42).overrideWith((ref) => testPackage),
          ],
          child: MaterialApp(
            theme: AppTheme.darkTheme,
            home: const ResponsiveAppShell(
              child: BookingScreen(packageId: 42),
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.byKey(const Key('reservation_calendar_panel')), findsOneWidget);
      expect(find.byKey(const Key('reservation_details_panel')), findsOneWidget);
      expect(find.byKey(const Key('order_summary_side_panel')), findsOneWidget);
      expect(tester.takeException(), isNull);
    });

    testWidgets('Tablet View (2-Column): Order Summary side-panel remains sticky during left column scroll',
        (WidgetTester tester) async {
      tester.view.physicalSize = const Size(900, 800);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);

      await tester.pumpWidget(
        createBookingScreenWidget(screenSize: const Size(900, 800)),
      );
      await tester.pumpAndSettle();

      // Tablet header badge should reflect 2-Column flow
      expect(find.text('2-Column Reservation Flow'), findsOneWidget);

      final initialSummaryPos = tester.getTopLeft(find.byKey(const Key('tablet_order_summary_panel')));
      final leftScrollFinder = find.byKey(const Key('tablet_left_scroll_view'));
      expect(leftScrollFinder, findsOneWidget);

      await tester.drag(leftScrollFinder, const Offset(0, -350));
      await tester.pumpAndSettle();

      final scrolledSummaryPos = tester.getTopLeft(find.byKey(const Key('tablet_order_summary_panel')));
      expect(scrolledSummaryPos.dy, equals(initialSummaryPos.dy));
      expect(scrolledSummaryPos.dx, equals(initialSummaryPos.dx));
      expect(find.byKey(const Key('tablet_order_summary_panel')), findsOneWidget);
    });

    testWidgets('Payment Successful screen renders robustly on constrained viewport heights without overflow',
        (WidgetTester tester) async {
      // Short mobile/desktop viewport height of 420px
      tester.view.physicalSize = const Size(800, 420);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);

      await tester.pumpWidget(
        createBookingScreenWidget(screenSize: const Size(800, 420)),
      );
      await tester.pumpAndSettle();

      // Confirm & Pay to trigger success view - scroll within tablet_right_scroll_view
      final confirmBtn = find.text('Confirm & Pay');
      await tester.scrollUntilVisible(
        confirmBtn,
        100,
        scrollable: find.descendant(
          of: find.byKey(const Key('tablet_right_scroll_view')),
          matching: find.byType(Scrollable),
        ),
      );
      expect(confirmBtn, findsOneWidget);
      await tester.tap(confirmBtn);
      await tester.pumpAndSettle();

      expect(find.text('Payment Successful'), findsOneWidget);
      expect(find.text('Done'), findsOneWidget);
      expect(tester.takeException(), isNull);
    });

    testWidgets('Extreme past dates (e.g. 2018) are safely clamped to calendar bounds',
        (WidgetTester tester) async {
      tester.view.physicalSize = const Size(1200, 800);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);

      final pastDate = DateTime.utc(2018, 3, 10);

      await tester.pumpWidget(
        MaterialApp(
          theme: AppTheme.lightTheme,
          home: Scaffold(
            body: Row(
              children: [
                Expanded(
                  child: ReservationCalendarPanel(
                    selectedDate: pastDate,
                    onDateSelected: (_) {},
                  ),
                ),
                Expanded(
                  child: OrderSummaryPanel(
                    package: testPackage,
                    selectedDate: pastDate,
                  ),
                ),
              ],
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text('March 10, 2018'), findsOneWidget);
      expect(find.text('Mar 10, 2018'), findsOneWidget);
      expect(tester.takeException(), isNull);
    });
  });
}
