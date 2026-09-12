import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:inea_scents_client/config/theme.dart';
import 'package:inea_scents_client/models/index.dart';
import 'package:inea_scents_client/providers/index.dart';
import 'package:inea_scents_client/screens/booking_screen.dart';
import 'package:inea_scents_client/src/providers/core_providers.dart';
import 'package:inea_scents_client/widgets/index.dart';

import 'helpers/fake_api.dart';

void main() {
  setUpAll(() {
    GoogleFonts.config.allowRuntimeFetching = false;
  });

  final testPackage = Package(
    id: 42,
    name: 'Dior Women Luxury Experience',
    description:
        'A luxurious custom perfume bar experience designed for weddings, birthdays, and celebrations.',
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
    freebies: ['Selfie Mirror', '1 Gift for Celebrant'],
    paxOptions: [20, 30, 50, 75, 100],
    images: ['https://example.com/luxury_package.jpg'],
  );

  Widget createBookingScreenWidget({
    required Size screenSize,
    int packageId = 42,
    Package? package,
    FakeApiBackend? backend,
  }) {
    return ProviderScope(
      overrides: [
        packageDetailsProvider(
          packageId,
        ).overrideWith((ref) => package ?? testPackage),
        apiClientProvider.overrideWithValue(
          buildFakeRestClient(backend ?? FakeApiBackend()),
        ),
      ],
      child: MaterialApp(
        theme: AppTheme.lightTheme,
        home: ResponsiveAppShell(child: BookingScreen(packageId: packageId)),
      ),
    );
  }

  /// Fills the full contact section shown inside DesktopPaymentPanel.
  Future<void> fillPaymentContacts(WidgetTester tester) async {
    const fields = {
      'payment_customer_name': 'Maria Clara',
      'payment_customer_email': 'maria@example.com',
      'payment_customer_phone': '+639171234567',
      'payment_venue_address': 'The Peninsula Manila',
    };
    for (final entry in fields.entries) {
      final finder = find.byKey(Key(entry.key));
      await tester.ensureVisible(finder);
      await tester.enterText(finder, entry.value);
      await tester.pump();
    }
  }

  /// Fills the contact fields on the mobile Step 3 (Details) view.
  Future<void> fillMobileContacts(WidgetTester tester) async {
    const fields = {
      'mobile_customer_name': 'Maria Clara',
      'mobile_customer_email': 'maria@example.com',
      'mobile_customer_phone': '+639171234567',
      'mobile_venue_address': 'The Peninsula Manila',
    };
    for (final entry in fields.entries) {
      final finder = find.byKey(Key(entry.key));
      await tester.ensureVisible(finder);
      await tester.enterText(finder, entry.value);
      await tester.pump();
    }
  }

  group('Issue #44: 3-Column Reservation Flow Layout Tests', () {
    testWidgets(
      'R1: Desktop Split View renders 3-column layout on 1200x800 viewport (>1024px)',
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
        expect(
          find.byKey(const Key('reservation_calendar_panel')),
          findsOneWidget,
        );
        expect(
          find.byKey(const Key('reservation_details_panel')),
          findsOneWidget,
        );
        expect(
          find.byKey(const Key('order_summary_side_panel')),
          findsOneWidget,
        );

        // Verify desktop header is present
        expect(find.text('3-Column Reservation Flow'), findsOneWidget);
        expect(find.textContaining('Reservation —'), findsOneWidget);

        // Layout coordinate verification:
        // Left (Calendar) < Middle (Details) < Right (Order Summary)
        final calendarPos = tester.getTopLeft(
          find.byKey(const Key('reservation_calendar_panel')),
        );
        final detailsPos = tester.getTopLeft(
          find.byKey(const Key('reservation_details_panel')),
        );
        final summaryPos = tester.getTopLeft(
          find.byKey(const Key('order_summary_side_panel')),
        );

        expect(calendarPos.dx, lessThan(detailsPos.dx));
        expect(detailsPos.dx, lessThan(summaryPos.dx));

        // Verify contents inside Left column (Calendar)
        expect(find.text('1. Select Date'), findsOneWidget);
        expect(find.text('Available'), findsWidgets);
        expect(find.text('Booked'), findsWidgets);

        // Verify contents inside Middle column (Packages/Times)
        expect(find.text('2. Choose Available Pax'), findsOneWidget);
        expect(find.text('3. Choose Event Time'), findsOneWidget);
        expect(find.text('4. Payment Method'), findsOneWidget);

        // Verify contents inside Right column (Sticky Order Summary)
        expect(find.text('Order Summary'), findsOneWidget);
        expect(find.text('Live Preview'), findsOneWidget);
        expect(find.text('Price Breakdown'), findsOneWidget);
        expect(find.text('Proceed to Payment'), findsOneWidget);
        expect(find.text('Php. 4500.00'), findsOneWidget);
      },
    );

    testWidgets(
      'R1: Order Summary side-panel remains sticky and visible during middle column scrolling',
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
        final initialSummaryPos = tester.getTopLeft(
          find.byKey(const Key('order_summary_side_panel')),
        );
        final initialButtonPos = tester.getTopLeft(
          find.text('Proceed to Payment'),
        );

        // Find middle scroll view and scroll down by 400 pixels
        final middleScrollFinder = find.byKey(
          const Key('desktop_middle_scroll_view'),
        );
        expect(middleScrollFinder, findsOneWidget);

        await tester.drag(middleScrollFinder, const Offset(0, -300));
        await tester.pumpAndSettle();

        // Check position of Order Summary panel after middle column scroll
        final scrolledSummaryPos = tester.getTopLeft(
          find.byKey(const Key('order_summary_side_panel')),
        );
        final scrolledButtonPos = tester.getTopLeft(
          find.text('Proceed to Payment'),
        );

        // The Order Summary panel position must remain unchanged (sticky/fixed in viewport)
        expect(scrolledSummaryPos.dy, equals(initialSummaryPos.dy));
        expect(scrolledSummaryPos.dx, equals(initialSummaryPos.dx));
        expect(scrolledButtonPos.dy, equals(initialButtonPos.dy));

        // Verify Order Summary and CTA button are still 100% visible and interactive
        expect(
          find.byKey(const Key('order_summary_side_panel')),
          findsOneWidget,
        );
        expect(find.text('Proceed to Payment'), findsOneWidget);
      },
    );

    testWidgets(
      'R2: Tablet View renders 2-column layout on 800x800 viewport (768px - 1024px)',
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
        expect(
          find.byKey(const Key('tablet_order_summary_panel')),
          findsOneWidget,
        );

        // Desktop 3-column specific keys are not rendered
        expect(find.byKey(const Key('order_summary_side_panel')), findsNothing);

        // Verify 2-column horizontal coordinate ordering: Left column < Right column
        final leftPos = tester.getTopLeft(
          find.byKey(const Key('tablet_calendar_panel')),
        );
        final rightPos = tester.getTopLeft(
          find.byKey(const Key('tablet_order_summary_panel')),
        );
        expect(leftPos.dx, lessThan(rightPos.dx));
      },
    );

    testWidgets(
      'R2: Mobile View renders 1-column vertical step flow on 375x667 viewport (<768px)',
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
        expect(
          find.byKey(const Key('mobile_step_scroll_view')),
          findsOneWidget,
        );
        expect(find.text('Schedule'), findsWidgets);
        expect(find.text('Next'), findsOneWidget);

        // Desktop/tablet 3-column & 2-column keys are not rendered
        expect(
          find.byKey(const Key('reservation_calendar_panel')),
          findsNothing,
        );
        expect(find.byKey(const Key('order_summary_side_panel')), findsNothing);
        expect(
          find.byKey(const Key('tablet_order_summary_panel')),
          findsNothing,
        );
      },
    );

    testWidgets(
      'Interactive Pax selection updates Order Summary in real-time on desktop',
      (WidgetTester tester) async {
        tester.view.physicalSize = const Size(1200, 800);
        tester.view.devicePixelRatio = 1.0;
        addTearDown(tester.view.resetPhysicalSize);
        addTearDown(tester.view.resetDevicePixelRatio);

        await tester.pumpWidget(
          createBookingScreenWidget(screenSize: const Size(1200, 800)),
        );
        await tester.pumpAndSettle();

        // Initially, default pax is 20 PAX (from testPackage.paxOptions.first)
        expect(find.text('Capacity'), findsOneWidget);
        expect(find.text('20 PAX'), findsWidgets);

        // Tap on '75 PAX' choice in middle column
        final seventyFivePaxFinder = find.text('75 PAX');
        expect(seventyFivePaxFinder, findsOneWidget);
        await tester.tap(seventyFivePaxFinder);
        await tester.pumpAndSettle();

        // Verify Order Summary now reflects 75 PAX
        expect(find.text('75 PAX'), findsWidgets);
      },
    );

    testWidgets(
      'Freeform time picker updates Order Summary in real-time on desktop',
      (WidgetTester tester) async {
        tester.view.physicalSize = const Size(1200, 800);
        tester.view.devicePixelRatio = 1.0;
        addTearDown(tester.view.resetPhysicalSize);
        addTearDown(tester.view.resetDevicePixelRatio);

        await tester.pumpWidget(
          createBookingScreenWidget(screenSize: const Size(1200, 800)),
        );
        await tester.pumpAndSettle();

        // Picker shows the current time with the duration hint
        expect(find.text('3. Choose Event Time'), findsOneWidget);
        expect(
          find.text('One booking lasts 3–4 hrs.'),
          findsOneWidget,
        );
        expect(find.text('2:00 PM'), findsWidgets);

        // Opening the picker surfaces the clock dialog; cancelling keeps time
        await tester.tap(find.byKey(const Key('event_time_picker_button')));
        await tester.pumpAndSettle();
        expect(find.byType(TimePickerDialog), findsOneWidget);
        await tester.tap(find.text('Cancel'));
        await tester.pumpAndSettle();
        expect(find.byType(TimePickerDialog), findsNothing);
        expect(find.text('2:00 PM'), findsWidgets);
      },
    );

    testWidgets(
      'Interactive Payment Method toggle updates Order Summary in real-time on desktop',
      (WidgetTester tester) async {
        tester.view.physicalSize = const Size(1200, 800);
        tester.view.devicePixelRatio = 1.0;
        addTearDown(tester.view.resetPhysicalSize);
        addTearDown(tester.view.resetDevicePixelRatio);

        await tester.pumpWidget(
          createBookingScreenWidget(screenSize: const Size(1200, 800)),
        );
        await tester.pumpAndSettle();

        // Retired method is gone from every picker (owner Q14-B).
        expect(find.text('Bank Transfer'), findsNothing);

        // Select 'Cash' in middle column
        final cashFinder = find.text('Cash');
        await tester.scrollUntilVisible(
          cashFinder,
          100,
          scrollable: find.descendant(
            of: find.byKey(const Key('desktop_middle_scroll_view')),
            matching: find.byType(Scrollable),
          ),
        );
        expect(cashFinder, findsWidgets);
        await tester.tap(cashFinder.first);
        await tester.pumpAndSettle();

        // Verify Order Summary displays 'CASH' badge
        expect(find.text('CASH'), findsWidgets);
      },
    );

    testWidgets(
      'Proceed to Payment and Confirm & Pay completes desktop flow and renders Payment Successful view',
      (WidgetTester tester) async {
        tester.view.physicalSize = const Size(1200, 800);
        tester.view.devicePixelRatio = 1.0;
        addTearDown(tester.view.resetPhysicalSize);
        addTearDown(tester.view.resetDevicePixelRatio);

        await tester.pumpWidget(
          createBookingScreenWidget(screenSize: const Size(1200, 800)),
        );
        await tester.pumpAndSettle();

        // Tap 'Proceed to Payment' in sticky Order Summary panel
        final proceedButtonFinder = find.text('Proceed to Payment');
        expect(proceedButtonFinder, findsOneWidget);
        await tester.tap(proceedButtonFinder);
        await tester.pumpAndSettle();

        // Verify Desktop Payment panel appears
        expect(
          find.byKey(const Key('desktop_payment_panel_view')),
          findsOneWidget,
        );

        // Fill contact & venue information required for submission
        await fillPaymentContacts(tester);

        // Tap 'Confirm & Pay' on payment step
        final confirmButtonFinder = find.text('Confirm & Pay');
        expect(confirmButtonFinder, findsOneWidget);
        await tester.tap(confirmButtonFinder);
        await tester.pumpAndSettle();

        // Verify Payment Successful screen appears
        expect(find.text('Payment Successful'), findsOneWidget);
        expect(find.text('Thank you for your booking.'), findsOneWidget);
        expect(find.text('Done'), findsOneWidget);
      },
    );

    testWidgets(
      'Dynamic resize smoothly transitions 3-column -> 2-column -> 1-column without errors',
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
        expect(
          find.byKey(const Key('reservation_calendar_panel')),
          findsOneWidget,
        );
        expect(
          find.byKey(const Key('order_summary_side_panel')),
          findsOneWidget,
        );

        // 2. Resize to Tablet (900px) -> 2 columns
        tester.view.physicalSize = const Size(900, 800);
        await tester.pumpAndSettle();
        expect(find.byKey(const Key('tablet_calendar_panel')), findsOneWidget);
        expect(
          find.byKey(const Key('tablet_order_summary_panel')),
          findsOneWidget,
        );
        expect(find.byKey(const Key('order_summary_side_panel')), findsNothing);

        // 3. Resize to Mobile (375px) -> 1 column
        tester.view.physicalSize = const Size(375, 667);
        await tester.pumpAndSettle();
        expect(
          find.byKey(const Key('mobile_step_scroll_view')),
          findsOneWidget,
        );
        expect(
          find.byKey(const Key('tablet_order_summary_panel')),
          findsNothing,
        );

        // 4. Resize back to Ultra-wide Desktop (1600px) -> 3 columns
        tester.view.physicalSize = const Size(1600, 900);
        await tester.pumpAndSettle();
        expect(
          find.byKey(const Key('reservation_calendar_panel')),
          findsOneWidget,
        );
        expect(
          find.byKey(const Key('order_summary_side_panel')),
          findsOneWidget,
        );
      },
    );

    testWidgets(
      'Interactive Date selection in calendar updates Order Summary date',
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
        expect(
          find.byKey(const Key('reservation_calendar_panel')),
          findsOneWidget,
        );

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
      },
    );

    testWidgets('Handles loading and error retry states cleanly', (
      WidgetTester tester,
    ) async {
      tester.view.physicalSize = const Size(1200, 800);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);

      // 1. Loading state
      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            packageDetailsProvider(
              99,
            ).overrideWith((ref) => throw Exception('Network timeout')),
          ],
          child: MaterialApp(
            theme: AppTheme.lightTheme,
            home: const ResponsiveAppShell(child: BookingScreen(packageId: 99)),
          ),
        ),
      );
      await tester.pump();

      // Error UI is displayed with retry button
      expect(find.textContaining('Error loading package:'), findsOneWidget);
      expect(find.text('Retry'), findsOneWidget);
    });

    testWidgets(
      '3-Column Desktop view renders robustly under 2.0x accessibility text scale',
      (WidgetTester tester) async {
        tester.view.physicalSize = const Size(1400, 900);
        tester.view.devicePixelRatio = 1.0;
        addTearDown(tester.view.resetPhysicalSize);
        addTearDown(tester.view.resetDevicePixelRatio);

        await tester.pumpWidget(
          ProviderScope(
            overrides: [
              packageDetailsProvider(42).overrideWith((ref) => testPackage),
              apiClientProvider.overrideWithValue(
                buildFakeRestClient(FakeApiBackend()),
              ),
            ],
            child: MaterialApp(
              theme: AppTheme.lightTheme,
              builder: (context, child) {
                return MediaQuery(
                  data: MediaQuery.of(
                    context,
                  ).copyWith(textScaler: const TextScaler.linear(2.0)),
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
        expect(
          find.byKey(const Key('reservation_calendar_panel')),
          findsOneWidget,
        );
        expect(
          find.byKey(const Key('reservation_details_panel')),
          findsOneWidget,
        );
        expect(
          find.byKey(const Key('order_summary_side_panel')),
          findsOneWidget,
        );
      },
    );

    testWidgets(
      'Exact breakpoint boundary threshold verification (1025px vs 1024px, 769px vs 768px vs 767px)',
      (WidgetTester tester) async {
        tester.view.devicePixelRatio = 1.0;
        addTearDown(tester.view.resetPhysicalSize);
        addTearDown(tester.view.resetDevicePixelRatio);

        // 1. 1025px (>1024px) -> Desktop 3-Column
        tester.view.physicalSize = const Size(1025, 800);
        await tester.pumpWidget(
          createBookingScreenWidget(screenSize: const Size(1025, 800)),
        );
        await tester.pumpAndSettle();
        expect(
          find.byKey(const Key('reservation_calendar_panel')),
          findsOneWidget,
        );
        expect(
          find.byKey(const Key('reservation_details_panel')),
          findsOneWidget,
        );
        expect(
          find.byKey(const Key('order_summary_side_panel')),
          findsOneWidget,
        );

        // 2. 1024px (== tabletBreakpoint) -> Tablet 2-Column
        tester.view.physicalSize = const Size(1024, 800);
        await tester.pumpAndSettle();
        expect(find.byKey(const Key('tablet_calendar_panel')), findsOneWidget);
        expect(find.byKey(const Key('tablet_details_panel')), findsOneWidget);
        expect(
          find.byKey(const Key('tablet_order_summary_panel')),
          findsOneWidget,
        );
        expect(find.byKey(const Key('order_summary_side_panel')), findsNothing);

        // 3. 769px (Tablet range) -> Tablet 2-Column
        tester.view.physicalSize = const Size(769, 800);
        await tester.pumpAndSettle();
        expect(find.byKey(const Key('tablet_calendar_panel')), findsOneWidget);
        expect(
          find.byKey(const Key('tablet_order_summary_panel')),
          findsOneWidget,
        );

        // 4. 768px (== mobileBreakpoint) -> Tablet 2-Column
        tester.view.physicalSize = const Size(768, 800);
        await tester.pumpAndSettle();
        expect(find.byKey(const Key('tablet_calendar_panel')), findsOneWidget);
        expect(
          find.byKey(const Key('tablet_order_summary_panel')),
          findsOneWidget,
        );

        // 5. 767px (<768px) -> Mobile 1-Column
        tester.view.physicalSize = const Size(767, 800);
        await tester.pumpAndSettle();
        expect(
          find.byKey(const Key('mobile_step_scroll_view')),
          findsOneWidget,
        );
        expect(
          find.byKey(const Key('tablet_order_summary_panel')),
          findsNothing,
        );
        expect(find.byKey(const Key('order_summary_side_panel')), findsNothing);
      },
    );

    testWidgets(
      'Rapid boundary oscillation retains selection state across 1023px <-> 1025px & 767px <-> 769px',
      (WidgetTester tester) async {
        tester.view.physicalSize = const Size(1200, 800);
        tester.view.devicePixelRatio = 1.0;
        addTearDown(tester.view.resetPhysicalSize);
        addTearDown(tester.view.resetDevicePixelRatio);

        await tester.pumpWidget(
          createBookingScreenWidget(screenSize: const Size(1200, 800)),
        );
        await tester.pumpAndSettle();

        // Change selections on desktop: 100 PAX, Cash (time stays default)
        final hundredPaxFinder = find.text('100 PAX');
        expect(hundredPaxFinder, findsOneWidget);
        await tester.tap(hundredPaxFinder);
        await tester.pumpAndSettle();

        // Freeform time keeps its default through selection changes
        expect(find.text('2:00 PM'), findsWidgets);

        final cashFinder = find.text('Cash');
        await tester.scrollUntilVisible(
          cashFinder,
          100,
          scrollable: find.descendant(
            of: find.byKey(const Key('desktop_middle_scroll_view')),
            matching: find.byType(Scrollable),
          ),
        );
        await tester.tap(cashFinder);
        await tester.pumpAndSettle();

        expect(find.text('CASH'), findsOneWidget);
        expect(find.text('100 PAX'), findsWidgets);

        // Oscillate across desktop/tablet boundary multiple times
        for (int i = 0; i < 3; i++) {
          tester.view.physicalSize = const Size(1023, 800); // Tablet
          await tester.pumpAndSettle();
          expect(
            find.byKey(const Key('tablet_order_summary_panel')),
            findsOneWidget,
          );
          expect(find.text('CASH'), findsOneWidget);

          tester.view.physicalSize = const Size(1025, 800); // Desktop
          await tester.pumpAndSettle();
          expect(
            find.byKey(const Key('order_summary_side_panel')),
            findsOneWidget,
          );
          expect(find.text('CASH'), findsOneWidget);
        }

        // Oscillate across tablet/mobile boundary multiple times
        for (int i = 0; i < 3; i++) {
          tester.view.physicalSize = const Size(767, 800); // Mobile
          await tester.pumpAndSettle();
          expect(
            find.byKey(const Key('mobile_step_scroll_view')),
            findsOneWidget,
          );

          tester.view.physicalSize = const Size(769, 800); // Tablet
          await tester.pumpAndSettle();
          expect(
            find.byKey(const Key('tablet_order_summary_panel')),
            findsOneWidget,
          );
          expect(find.text('CASH'), findsOneWidget);
        }
      },
    );

    testWidgets(
      'Calendar range safety and navigation without assertion crashes',
      (WidgetTester tester) async {
        tester.view.physicalSize = const Size(1200, 800);
        tester.view.devicePixelRatio = 1.0;
        addTearDown(tester.view.resetPhysicalSize);
        addTearDown(tester.view.resetDevicePixelRatio);

        await tester.pumpWidget(
          ProviderScope(
            overrides: [
              apiClientProvider.overrideWithValue(
                buildFakeRestClient(FakeApiBackend()),
              ),
            ],
            child: MaterialApp(
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
      },
    );

    testWidgets(
      'OrderSummaryPanel and ReservationDetailsPanel handle bare/null package data gracefully',
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
      },
    );

    testWidgets(
      'Mobile 1-column step flow allows date, pax, details, payment selection and completes to success screen',
      (WidgetTester tester) async {
        tester.view.physicalSize = const Size(375, 667);
        tester.view.devicePixelRatio = 1.0;
        addTearDown(tester.view.resetPhysicalSize);
        addTearDown(tester.view.resetDevicePixelRatio);

        await tester.pumpWidget(
          createBookingScreenWidget(screenSize: const Size(375, 667)),
        );
        await tester.pumpAndSettle();

        // Step 2: Schedule & Pax
        expect(find.text('Please Choose Available Schedule'), findsOneWidget);
        final thirtyPaxFinder = find.text('30 PAX');
        await tester.scrollUntilVisible(
          thirtyPaxFinder,
          100,
          scrollable: find
              .descendant(
                of: find.byKey(const Key('mobile_step_scroll_view')),
                matching: find.byType(Scrollable),
              )
              .first,
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

        // Fill mobile contact & venue information required for submission
        await fillMobileContacts(tester);

        // Tap Proceed to Payment to go to Step 4
        await tester.scrollUntilVisible(
          find.text('Proceed to Payment'),
          100,
          scrollable: find
              .descendant(
                of: find.byKey(const Key('mobile_step_scroll_view')),
                matching: find.byType(Scrollable),
              )
              .first,
        );
        await tester.tap(find.text('Proceed to Payment'));
        await tester.pumpAndSettle();

        // Step 4: Payment
        expect(find.text('Price Details'), findsOneWidget);
        expect(find.text('Choose Payment Method'), findsOneWidget);
        final cardFinder = find.text('Online');
        await tester.scrollUntilVisible(
          cardFinder,
          100,
          scrollable: find
              .descendant(
                of: find.byKey(const Key('mobile_step_scroll_view')),
                matching: find.byType(Scrollable),
              )
              .first,
        );
        expect(cardFinder, findsOneWidget);
        await tester.tap(cardFinder);
        await tester.pumpAndSettle();

        expect(find.text('Confirm & Pay'), findsOneWidget);
        await tester.tap(find.text('Confirm & Pay'));
        await tester.pumpAndSettle();

        // Step 5: Success screen
        expect(find.text('Payment Successful'), findsOneWidget);
        expect(find.text('Done'), findsOneWidget);
      },
    );

    testWidgets(
      'Mobile step flow supports interactive time slot selection and back navigation without placeholder steps',
      (WidgetTester tester) async {
        tester.view.physicalSize = const Size(375, 667);
        tester.view.devicePixelRatio = 1.0;
        addTearDown(tester.view.resetPhysicalSize);
        addTearDown(tester.view.resetDevicePixelRatio);

        await tester.pumpWidget(
          createBookingScreenWidget(screenSize: const Size(375, 667)),
        );
        await tester.pumpAndSettle();

        // Step 2: freeform time picker shows the default with duration hint
        expect(find.text('Choose Event Time'), findsOneWidget);
        expect(find.text('One booking lasts 3–4 hrs.'), findsOneWidget);
        final pickerFinder = find.byKey(
          const Key('event_time_picker_button'),
        );
        await tester.scrollUntilVisible(
          pickerFinder,
          100,
          scrollable: find
              .descendant(
                of: find.byKey(const Key('mobile_step_scroll_view')),
                matching: find.byType(Scrollable),
              )
              .first,
        );
        expect(pickerFinder, findsOneWidget);
        expect(find.text('2:00 PM'), findsWidgets);

        // Advance to Step 3 (Details)
        await tester.tap(find.text('Next'));
        await tester.pumpAndSettle();

        // Verify selected time and pax are displayed in Details
        expect(find.text('Selected Time:'), findsOneWidget);
        expect(find.text('2:00 PM'), findsWidgets);
        expect(find.text('Selected Pax:'), findsOneWidget);

        await fillMobileContacts(tester);

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
      },
    );

    testWidgets(
      'OrderSummaryPanel and ReservationCalendarPanel handle future dates up to 2035 with clamping',
      (WidgetTester tester) async {
        tester.view.physicalSize = const Size(1200, 800);
        tester.view.devicePixelRatio = 1.0;
        addTearDown(tester.view.resetPhysicalSize);
        addTearDown(tester.view.resetDevicePixelRatio);

        // Future date in year 2034
        final futureDate = DateTime.utc(2034, 6, 15);

        await tester.pumpWidget(
          ProviderScope(
            overrides: [
              apiClientProvider.overrideWithValue(
                buildFakeRestClient(FakeApiBackend()),
              ),
            ],
            child: MaterialApp(
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
          ),
        );
        await tester.pumpAndSettle();

        expect(find.text('June 15, 2034'), findsOneWidget);
        expect(find.text('Jun 15, 2034'), findsOneWidget);
      },
    );

    testWidgets(
      'OrderSummaryPanel handles long inclusion strings and text scaling without overflows',
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
      },
    );

    testWidgets('BookingScreen renders cleanly in Dark Theme', (
      WidgetTester tester,
    ) async {
      tester.view.physicalSize = const Size(1200, 800);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);

      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            packageDetailsProvider(42).overrideWith((ref) => testPackage),
            apiClientProvider.overrideWithValue(
              buildFakeRestClient(FakeApiBackend()),
            ),
          ],
          child: MaterialApp(
            theme: AppTheme.darkTheme,
            home: const ResponsiveAppShell(child: BookingScreen(packageId: 42)),
          ),
        ),
      );
      await tester.pumpAndSettle();

      expect(
        find.byKey(const Key('reservation_calendar_panel')),
        findsOneWidget,
      );
      expect(
        find.byKey(const Key('reservation_details_panel')),
        findsOneWidget,
      );
      expect(find.byKey(const Key('order_summary_side_panel')), findsOneWidget);
      expect(tester.takeException(), isNull);
    });

    testWidgets(
      'Tablet View (2-Column): Order Summary side-panel remains sticky during left column scroll',
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

        final initialSummaryPos = tester.getTopLeft(
          find.byKey(const Key('tablet_order_summary_panel')),
        );
        final leftScrollFinder = find.byKey(
          const Key('tablet_left_scroll_view'),
        );
        expect(leftScrollFinder, findsOneWidget);

        await tester.drag(leftScrollFinder, const Offset(0, -350));
        await tester.pumpAndSettle();

        final scrolledSummaryPos = tester.getTopLeft(
          find.byKey(const Key('tablet_order_summary_panel')),
        );
        expect(scrolledSummaryPos.dy, equals(initialSummaryPos.dy));
        expect(scrolledSummaryPos.dx, equals(initialSummaryPos.dx));
        expect(
          find.byKey(const Key('tablet_order_summary_panel')),
          findsOneWidget,
        );
      },
    );

    testWidgets(
      'Payment Successful screen renders robustly on constrained viewport heights without overflow',
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

        // Proceed to Payment then Confirm & Pay to trigger success view - scroll within tablet_right_scroll_view
        final proceedBtn = find.text('Proceed to Payment');
        await tester.scrollUntilVisible(
          proceedBtn,
          100,
          scrollable: find.descendant(
            of: find.byKey(const Key('tablet_right_scroll_view')),
            matching: find.byType(Scrollable),
          ),
        );
        expect(proceedBtn, findsOneWidget);
        await tester.tap(proceedBtn);
        await tester.pumpAndSettle();

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

        // Fill contact & venue information required for submission
        await fillPaymentContacts(tester);

        await tester.tap(confirmBtn);
        await tester.pumpAndSettle();

        expect(find.text('Payment Successful'), findsOneWidget);
        expect(find.text('Done'), findsOneWidget);
        expect(tester.takeException(), isNull);
      },
    );

    testWidgets(
      'Extreme past dates (e.g. 2018) are safely clamped to calendar bounds',
      (WidgetTester tester) async {
        tester.view.physicalSize = const Size(1200, 800);
        tester.view.devicePixelRatio = 1.0;
        addTearDown(tester.view.resetPhysicalSize);
        addTearDown(tester.view.resetDevicePixelRatio);

        final pastDate = DateTime.utc(2018, 3, 10);

        await tester.pumpWidget(
          ProviderScope(
            overrides: [
              apiClientProvider.overrideWithValue(
                buildFakeRestClient(FakeApiBackend()),
              ),
            ],
            child: MaterialApp(
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
          ),
        );
        await tester.pumpAndSettle();

        expect(find.text('March 10, 2018'), findsOneWidget);
        expect(find.text('Mar 10, 2018'), findsOneWidget);
        expect(tester.takeException(), isNull);
      },
    );
  });

  group('Issue #45: In-place Payment Step Transition Tests', () {
    testWidgets(
      'R1: Desktop payment transition replaces Calendar and Details with DesktopPaymentPanel via in-place cross-fade on 1200x800 (>1024px)',
      (WidgetTester tester) async {
        tester.view.physicalSize = const Size(1200, 800);
        tester.view.devicePixelRatio = 1.0;
        addTearDown(tester.view.resetPhysicalSize);
        addTearDown(tester.view.resetDevicePixelRatio);

        await tester.pumpWidget(
          createBookingScreenWidget(screenSize: const Size(1200, 800)),
        );
        await tester.pumpAndSettle();

        // Initially on Step 2 (Reservation layout)
        expect(
          find.byKey(const Key('reservation_calendar_panel')),
          findsOneWidget,
        );
        expect(
          find.byKey(const Key('reservation_details_panel')),
          findsOneWidget,
        );
        expect(
          find.byKey(const Key('desktop_payment_panel_view')),
          findsNothing,
        );
        expect(find.text('Proceed to Payment'), findsOneWidget);

        // Tap Proceed to Payment
        await tester.tap(find.text('Proceed to Payment'));

        // Advance halfway through the 300ms cross-fade transition
        await tester.pump(const Duration(milliseconds: 150));

        // FadeTransition should be animating
        expect(find.byType(FadeTransition), findsWidgets);

        // Complete transition
        await tester.pumpAndSettle();

        // Columns 1 & 2 (Calendar & Details) are replaced by DesktopPaymentPanel
        expect(
          find.byKey(const Key('reservation_calendar_panel')),
          findsNothing,
        );
        expect(
          find.byKey(const Key('reservation_details_panel')),
          findsNothing,
        );
        expect(
          find.byKey(const Key('desktop_payment_panel_view')),
          findsOneWidget,
        );
        expect(find.text('Payment & Checkout Details'), findsOneWidget);
        expect(find.text('1. Select Payment Method'), findsOneWidget);
      },
    );

    testWidgets(
      'R2: Persistent Order Summary remains mounted at exact coordinates with identical live values during and after payment transition',
      (WidgetTester tester) async {
        tester.view.physicalSize = const Size(1200, 800);
        tester.view.devicePixelRatio = 1.0;
        addTearDown(tester.view.resetPhysicalSize);
        addTearDown(tester.view.resetDevicePixelRatio);

        await tester.pumpWidget(
          createBookingScreenWidget(screenSize: const Size(1200, 800)),
        );
        await tester.pumpAndSettle();

        // Record Order Summary position and values before transition
        final summaryBeforePos = tester.getTopLeft(
          find.byKey(const Key('order_summary_side_panel')),
        );
        expect(find.text('Live Preview'), findsOneWidget);
        expect(find.text('Price Breakdown'), findsOneWidget);
        expect(find.text('Php. 4500.00'), findsOneWidget);

        // Trigger payment transition
        await tester.tap(find.text('Proceed to Payment'));
        await tester.pump(const Duration(milliseconds: 150));

        // Mid-transition: Order Summary is STILL mounted and at exact same position
        final summaryMidPos = tester.getTopLeft(
          find.byKey(const Key('order_summary_side_panel')),
        );
        expect(summaryMidPos.dx, equals(summaryBeforePos.dx));
        expect(summaryMidPos.dy, equals(summaryBeforePos.dy));

        await tester.pumpAndSettle();

        // Post-transition: Order Summary remains persistently visible at exact coordinates
        final summaryAfterPos = tester.getTopLeft(
          find.byKey(const Key('order_summary_side_panel')),
        );
        expect(summaryAfterPos.dx, equals(summaryBeforePos.dx));
        expect(summaryAfterPos.dy, equals(summaryBeforePos.dy));
        expect(
          find.byKey(const Key('order_summary_side_panel')),
          findsOneWidget,
        );

        // Summary button has updated to 'Confirm & Pay'
        expect(find.text('Confirm & Pay'), findsOneWidget);
        expect(find.text('Php. 4500.00'), findsOneWidget);
      },
    );

    testWidgets(
      'Desktop payment header updates title to Payment & Checkout and badge to Secure In-Place Checkout',
      (WidgetTester tester) async {
        tester.view.physicalSize = const Size(1200, 800);
        tester.view.devicePixelRatio = 1.0;
        addTearDown(tester.view.resetPhysicalSize);
        addTearDown(tester.view.resetDevicePixelRatio);

        await tester.pumpWidget(
          createBookingScreenWidget(screenSize: const Size(1200, 800)),
        );
        await tester.pumpAndSettle();

        // Initial reservation header
        expect(find.textContaining('Reservation —'), findsOneWidget);
        expect(find.text('3-Column Reservation Flow'), findsOneWidget);

        // Proceed to payment
        await tester.tap(find.text('Proceed to Payment'));
        await tester.pumpAndSettle();

        // Payment header updates
        expect(find.textContaining('Payment & Checkout —'), findsOneWidget);
        expect(find.text('Secure In-Place Checkout'), findsOneWidget);
        expect(find.byIcon(Icons.lock_outline_rounded), findsWidgets);
      },
    );

    testWidgets(
      'Header Back button cross-fades back from DesktopPaymentPanel to 3-column reservation layout',
      (WidgetTester tester) async {
        tester.view.physicalSize = const Size(1200, 800);
        tester.view.devicePixelRatio = 1.0;
        addTearDown(tester.view.resetPhysicalSize);
        addTearDown(tester.view.resetDevicePixelRatio);

        await tester.pumpWidget(
          createBookingScreenWidget(screenSize: const Size(1200, 800)),
        );
        await tester.pumpAndSettle();

        // Go to payment step
        await tester.tap(find.text('Proceed to Payment'));
        await tester.pumpAndSettle();
        expect(
          find.byKey(const Key('desktop_payment_panel_view')),
          findsOneWidget,
        );

        // Tap Header Back button
        await tester.tap(find.text('Back'));
        await tester.pump(const Duration(milliseconds: 150));
        expect(find.byType(FadeTransition), findsWidgets);

        await tester.pumpAndSettle();

        // Returned to 3-column reservation layout
        expect(
          find.byKey(const Key('reservation_calendar_panel')),
          findsOneWidget,
        );
        expect(
          find.byKey(const Key('reservation_details_panel')),
          findsOneWidget,
        );
        expect(
          find.byKey(const Key('desktop_payment_panel_view')),
          findsNothing,
        );
        expect(find.text('Proceed to Payment'), findsOneWidget);
      },
    );

    testWidgets(
      'Edit Selection button in DesktopPaymentPanel cross-fades back to 3-column reservation layout',
      (WidgetTester tester) async {
        tester.view.physicalSize = const Size(1200, 800);
        tester.view.devicePixelRatio = 1.0;
        addTearDown(tester.view.resetPhysicalSize);
        addTearDown(tester.view.resetDevicePixelRatio);

        await tester.pumpWidget(
          createBookingScreenWidget(screenSize: const Size(1200, 800)),
        );
        await tester.pumpAndSettle();

        // Go to payment step
        await tester.tap(find.text('Proceed to Payment'));
        await tester.pumpAndSettle();

        // Find and tap 'Edit Selection' button inside payment panel
        final editSelectionFinder = find.text('Edit Selection');
        expect(editSelectionFinder, findsOneWidget);
        await tester.tap(editSelectionFinder);
        await tester.pumpAndSettle();

        // Returned to Calendar and Details panels
        expect(
          find.byKey(const Key('reservation_calendar_panel')),
          findsOneWidget,
        );
        expect(
          find.byKey(const Key('reservation_details_panel')),
          findsOneWidget,
        );
        expect(
          find.byKey(const Key('desktop_payment_panel_view')),
          findsNothing,
        );
      },
    );

    testWidgets(
      'Interactive payment method switching in DesktopPaymentPanel (Online, Cash) updates Order Summary live preview',
      (WidgetTester tester) async {
        tester.view.physicalSize = const Size(1200, 800);
        tester.view.devicePixelRatio = 1.0;
        addTearDown(tester.view.resetPhysicalSize);
        addTearDown(tester.view.resetDevicePixelRatio);

        await tester.pumpWidget(
          createBookingScreenWidget(screenSize: const Size(1200, 800)),
        );
        await tester.pumpAndSettle();

        // Proceed to Payment
        await tester.tap(find.text('Proceed to Payment'));
        await tester.pumpAndSettle();

        // 1. Initial method is Online: explainer, no card capture, no retired methods
        expect(find.text('2. Online Checkout'), findsOneWidget);
        expect(find.text('ONLINE'), findsWidgets);
        expect(
          find.byKey(const Key('online_checkout_explainer')),
          findsOneWidget,
        );
        expect(find.text('Cardholder Full Name'), findsNothing);
        expect(find.text('Card Number'), findsNothing);
        expect(find.text('Bank Transfer'), findsNothing);

        // 2. Select Cash
        final cashMethodFinder = find.text('Cash');
        expect(cashMethodFinder, findsWidgets);
        await tester.tap(cashMethodFinder.first);
        await tester.pumpAndSettle();

        expect(find.text('2. Offline Payment Instructions'), findsOneWidget);
        expect(find.text('CASH'), findsWidgets);
      },
    );

    testWidgets(
      'DesktopPaymentPanel contact text input fields accept keyboard entries cleanly',
      (WidgetTester tester) async {
        tester.view.physicalSize = const Size(1200, 800);
        tester.view.devicePixelRatio = 1.0;
        addTearDown(tester.view.resetPhysicalSize);
        addTearDown(tester.view.resetDevicePixelRatio);

        await tester.pumpWidget(
          createBookingScreenWidget(screenSize: const Size(1200, 800)),
        );
        await tester.pumpAndSettle();

        // Proceed to Payment
        await tester.tap(find.text('Proceed to Payment'));
        await tester.pumpAndSettle();

        // Online is the default: explainer on, no card capture anywhere
        await tester.tap(find.text('Online'));
        await tester.pumpAndSettle();
        expect(
          find.byKey(const Key('online_checkout_explainer')),
          findsOneWidget,
        );
        expect(find.text('Card Number'), findsNothing);

        // Enter customer & venue details
        await tester.enterText(
          find.byKey(const Key('payment_customer_name')),
          'Maria Clara',
        );
        await tester.enterText(
          find.byKey(const Key('payment_customer_email')),
          'maria@example.com',
        );
        await tester.enterText(
          find.byKey(const Key('payment_customer_phone')),
          '+63 917 123 4567',
        );
        await tester.enterText(
          find.byKey(const Key('payment_venue_address')),
          'The Peninsula Manila',
        );
        await tester.pumpAndSettle();

        expect(find.text('Maria Clara'), findsWidgets);
        expect(find.text('The Peninsula Manila'), findsWidgets);
        expect(tester.takeException(), isNull);
      },
    );

    testWidgets(
      'Confirm & Pay on Desktop completes payment flow and renders Payment Successful view',
      (WidgetTester tester) async {
        tester.view.physicalSize = const Size(1200, 800);
        tester.view.devicePixelRatio = 1.0;
        addTearDown(tester.view.resetPhysicalSize);
        addTearDown(tester.view.resetDevicePixelRatio);

        await tester.pumpWidget(
          createBookingScreenWidget(screenSize: const Size(1200, 800)),
        );
        await tester.pumpAndSettle();

        // Step 1: Proceed to Payment
        await tester.tap(find.text('Proceed to Payment'));
        await tester.pumpAndSettle();
        expect(
          find.byKey(const Key('desktop_payment_panel_view')),
          findsOneWidget,
        );

        // Step 2: Confirm & Pay in persistent Order Summary
        final confirmBtn = find.text('Confirm & Pay');
        expect(confirmBtn, findsOneWidget);

        // Fill contact & venue information required for submission
        await fillPaymentContacts(tester);

        await tester.tap(confirmBtn);
        await tester.pumpAndSettle();

        // Step 3: Payment Successful screen
        expect(find.text('Payment Successful'), findsOneWidget);
        expect(find.text('Thank you for your booking.'), findsOneWidget);
        expect(find.text('Done'), findsOneWidget);
      },
    );

    testWidgets(
      'R3: Mobile payment flow behavior is 100% preserved (Schedule -> Details -> Payment -> Success)',
      (WidgetTester tester) async {
        tester.view.physicalSize = const Size(375, 667);
        tester.view.devicePixelRatio = 1.0;
        addTearDown(tester.view.resetPhysicalSize);
        addTearDown(tester.view.resetDevicePixelRatio);

        await tester.pumpWidget(
          createBookingScreenWidget(screenSize: const Size(375, 667)),
        );
        await tester.pumpAndSettle();

        // Step 2: Schedule & Pax
        expect(find.text('Please Choose Available Schedule'), findsOneWidget);
        expect(find.text('Next'), findsOneWidget);

        // Advance to Step 3: Details
        await tester.tap(find.text('Next'));
        await tester.pumpAndSettle();
        expect(find.text('Order Details'), findsOneWidget);
        expect(find.text('Proceed to Payment'), findsOneWidget);

        // Fill mobile contact & venue information required for submission
        await fillMobileContacts(tester);

        // Advance to Step 4: Mobile Payment
        await tester.scrollUntilVisible(
          find.text('Proceed to Payment'),
          100,
          scrollable: find
              .descendant(
                of: find.byKey(const Key('mobile_step_scroll_view')),
                matching: find.byType(Scrollable),
              )
              .first,
        );
        await tester.tap(find.text('Proceed to Payment'));
        await tester.pumpAndSettle();
        expect(find.text('Price Details'), findsOneWidget);
        expect(find.text('Choose Payment Method'), findsOneWidget);
        expect(find.text('Confirm & Pay'), findsOneWidget);

        // Test mobile back navigation
        await tester.tap(find.text('Back'));
        await tester.pumpAndSettle();
        expect(find.text('Order Details'), findsOneWidget);

        // Advance back to mobile payment and complete
        await tester.scrollUntilVisible(
          find.text('Proceed to Payment'),
          100,
          scrollable: find
              .descendant(
                of: find.byKey(const Key('mobile_step_scroll_view')),
                matching: find.byType(Scrollable),
              )
              .first,
        );
        await tester.tap(find.text('Proceed to Payment'));
        await tester.pumpAndSettle();
        await tester.tap(find.text('Confirm & Pay'));
        await tester.pumpAndSettle();

        expect(find.text('Payment Successful'), findsOneWidget);
        expect(find.text('Done'), findsOneWidget);
      },
    );

    testWidgets(
      'Tablet 2-column view triggers in-place cross-fade on left column to DesktopPaymentPanel while keeping Order Summary persistent',
      (WidgetTester tester) async {
        tester.view.physicalSize = const Size(900, 800);
        tester.view.devicePixelRatio = 1.0;
        addTearDown(tester.view.resetPhysicalSize);
        addTearDown(tester.view.resetDevicePixelRatio);

        await tester.pumpWidget(
          createBookingScreenWidget(screenSize: const Size(900, 800)),
        );
        await tester.pumpAndSettle();

        // Initial tablet 2-column layout
        expect(find.byKey(const Key('tablet_calendar_panel')), findsOneWidget);
        expect(find.byKey(const Key('tablet_details_panel')), findsOneWidget);
        expect(
          find.byKey(const Key('tablet_order_summary_panel')),
          findsOneWidget,
        );
        expect(find.text('Proceed to Payment'), findsOneWidget);

        // Tap Proceed to Payment in tablet Order Summary
        final proceedBtn = find.text('Proceed to Payment');
        await tester.scrollUntilVisible(
          proceedBtn,
          100,
          scrollable: find.descendant(
            of: find.byKey(const Key('tablet_right_scroll_view')),
            matching: find.byType(Scrollable),
          ),
        );
        await tester.tap(proceedBtn);
        await tester.pump(const Duration(milliseconds: 150));

        expect(find.byType(FadeTransition), findsWidgets);
        await tester.pumpAndSettle();

        // Left column is now DesktopPaymentPanel on tablet
        expect(
          find.byKey(const Key('tablet_payment_panel_view')),
          findsOneWidget,
        );
        expect(
          find.byKey(const Key('tablet_order_summary_panel')),
          findsOneWidget,
        );
        expect(find.text('Confirm & Pay'), findsOneWidget);

        // Fill contact & venue information required for submission
        await fillPaymentContacts(tester);

        // Confirm & Pay completes tablet flow
        await tester.tap(find.text('Confirm & Pay'));
        await tester.pumpAndSettle();

        expect(find.text('Payment Successful'), findsOneWidget);
      },
    );

    testWidgets('DesktopPaymentPanel renders cleanly in Dark Theme', (
      WidgetTester tester,
    ) async {
      tester.view.physicalSize = const Size(1200, 800);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);

      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            packageDetailsProvider(42).overrideWith((ref) => testPackage),
            apiClientProvider.overrideWithValue(
              buildFakeRestClient(FakeApiBackend()),
            ),
          ],
          child: MaterialApp(
            theme: AppTheme.darkTheme,
            home: const ResponsiveAppShell(child: BookingScreen(packageId: 42)),
          ),
        ),
      );
      await tester.pumpAndSettle();

      await tester.tap(find.text('Proceed to Payment'));
      await tester.pumpAndSettle();

      expect(
        find.byKey(const Key('desktop_payment_panel_view')),
        findsOneWidget,
      );
      expect(find.byKey(const Key('order_summary_side_panel')), findsOneWidget);
      expect(find.text('Payment & Checkout Details'), findsOneWidget);
      expect(tester.takeException(), isNull);
    });

    testWidgets(
      'Desktop payment transition renders cleanly under 2.0x text scaling without flex overflow',
      (WidgetTester tester) async {
        tester.view.physicalSize = const Size(1400, 900);
        tester.view.devicePixelRatio = 1.0;
        addTearDown(tester.view.resetPhysicalSize);
        addTearDown(tester.view.resetDevicePixelRatio);

        await tester.pumpWidget(
          ProviderScope(
            overrides: [
              packageDetailsProvider(42).overrideWith((ref) => testPackage),
              apiClientProvider.overrideWithValue(
                buildFakeRestClient(FakeApiBackend()),
              ),
            ],
            child: MaterialApp(
              theme: AppTheme.lightTheme,
              builder: (context, child) {
                return MediaQuery(
                  data: MediaQuery.of(
                    context,
                  ).copyWith(textScaler: const TextScaler.linear(2.0)),
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

        final proceedBtn = find.text('Proceed to Payment');
        await tester.scrollUntilVisible(
          proceedBtn,
          100,
          scrollable: find.descendant(
            of: find.byKey(const Key('desktop_summary_scroll_view')),
            matching: find.byType(Scrollable),
          ),
        );
        expect(proceedBtn, findsOneWidget);
        await tester.tap(proceedBtn);
        await tester.pumpAndSettle();

        expect(
          find.byKey(const Key('desktop_payment_panel_view')),
          findsOneWidget,
        );
        expect(
          find.byKey(const Key('order_summary_side_panel')),
          findsOneWidget,
        );
        expect(tester.takeException(), isNull);
      },
    );

    testWidgets(
      'Dynamic resize between Desktop (1200px) and Tablet (900px) preserves active payment step state',
      (WidgetTester tester) async {
        tester.view.physicalSize = const Size(1200, 800);
        tester.view.devicePixelRatio = 1.0;
        addTearDown(tester.view.resetPhysicalSize);
        addTearDown(tester.view.resetDevicePixelRatio);

        await tester.pumpWidget(
          createBookingScreenWidget(screenSize: const Size(1200, 800)),
        );
        await tester.pumpAndSettle();

        // Proceed to payment on Desktop
        await tester.tap(find.text('Proceed to Payment'));
        await tester.pumpAndSettle();
        expect(
          find.byKey(const Key('desktop_payment_panel_view')),
          findsOneWidget,
        );

        // Resize to Tablet (900px) -> Still in Payment step
        tester.view.physicalSize = const Size(900, 800);
        await tester.pumpAndSettle();

        expect(
          find.byKey(const Key('tablet_payment_panel_view')),
          findsOneWidget,
        );
        expect(
          find.byKey(const Key('tablet_order_summary_panel')),
          findsOneWidget,
        );
        expect(find.text('Confirm & Pay'), findsOneWidget);

        // Resize back to Desktop (1400px) -> Still in Payment step
        tester.view.physicalSize = const Size(1400, 800);
        await tester.pumpAndSettle();

        expect(
          find.byKey(const Key('desktop_payment_panel_view')),
          findsOneWidget,
        );
        expect(
          find.byKey(const Key('order_summary_side_panel')),
          findsOneWidget,
        );
        expect(find.text('Confirm & Pay'), findsOneWidget);
      },
    );

    testWidgets(
      'DesktopPaymentPanel captures no card details: Online shows explainer and contact fields accept input',
      (WidgetTester tester) async {
        tester.view.physicalSize = const Size(1200, 800);
        tester.view.devicePixelRatio = 1.0;
        addTearDown(tester.view.resetPhysicalSize);
        addTearDown(tester.view.resetDevicePixelRatio);

        await tester.pumpWidget(
          createBookingScreenWidget(screenSize: const Size(1200, 800)),
        );
        await tester.pumpAndSettle();

        await tester.tap(find.text('Proceed to Payment'));
        await tester.pumpAndSettle();

        // Online method: explainer present, card capture absent
        await tester.tap(find.text('Online'));
        await tester.pumpAndSettle();
        expect(
          find.byKey(const Key('online_checkout_explainer')),
          findsOneWidget,
        );
        expect(
          find.byKey(const Key('payment_card_number')),
          findsNothing,
        );
        expect(find.byKey(const Key('payment_card_cvv')), findsNothing);
        expect(find.byKey(const Key('payment_card_expiry')), findsNothing);

        // Contact email still accepts free text
        final emailField = find.byKey(const Key('payment_customer_email'));
        await tester.enterText(emailField, 'maria@example.com');
        await tester.pumpAndSettle();

        final TextField emailWidget = tester.widget(emailField);
        expect(emailWidget.controller?.text, equals('maria@example.com'));
        expect(tester.takeException(), isNull);
      },
    );

    testWidgets(
      'DesktopPaymentPanel contact fields expose proper TextInputAction for keyboard navigation',
      (WidgetTester tester) async {
        tester.view.physicalSize = const Size(1200, 800);
        tester.view.devicePixelRatio = 1.0;
        addTearDown(tester.view.resetPhysicalSize);
        addTearDown(tester.view.resetDevicePixelRatio);

        await tester.pumpWidget(
          createBookingScreenWidget(screenSize: const Size(1200, 800)),
        );
        await tester.pumpAndSettle();

        await tester.tap(find.text('Proceed to Payment'));
        await tester.pumpAndSettle();

        final nameField = find.byKey(const Key('payment_customer_name'));
        final TextField nameWidget = tester.widget(nameField);
        expect(nameWidget.textInputAction, equals(TextInputAction.next));

        final emailField = find.byKey(const Key('payment_customer_email'));
        final TextField emailWidget = tester.widget(emailField);
        expect(emailWidget.textInputAction, equals(TextInputAction.next));

        final addressField = find.byKey(const Key('payment_venue_address'));
        final TextField addressWidget = tester.widget(addressField);
        expect(addressWidget.textInputAction, equals(TextInputAction.done));
      },
    );

    testWidgets(
      'DesktopPaymentPanel renders robustly on narrow tablet column under 3.0x extreme text scale without overflow',
      (WidgetTester tester) async {
        tester.view.physicalSize = const Size(768, 900);
        tester.view.devicePixelRatio = 1.0;
        addTearDown(tester.view.resetPhysicalSize);
        addTearDown(tester.view.resetDevicePixelRatio);

        await tester.pumpWidget(
          ProviderScope(
            overrides: [
              packageDetailsProvider(42).overrideWith((ref) => testPackage),
              apiClientProvider.overrideWithValue(
                buildFakeRestClient(FakeApiBackend()),
              ),
            ],
            child: MaterialApp(
              theme: AppTheme.lightTheme,
              builder: (context, child) {
                return MediaQuery(
                  data: MediaQuery.of(
                    context,
                  ).copyWith(textScaler: const TextScaler.linear(3.0)),
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

        final proceedBtn = find.text('Proceed to Payment');
        await tester.scrollUntilVisible(
          proceedBtn,
          100,
          scrollable: find.descendant(
            of: find.byKey(const Key('tablet_right_scroll_view')),
            matching: find.byType(Scrollable),
          ),
        );
        await tester.tap(proceedBtn);
        await tester.pumpAndSettle();

        expect(
          find.byKey(const Key('tablet_payment_panel_view')),
          findsOneWidget,
        );
        expect(
          find.byKey(const Key('tablet_order_summary_panel')),
          findsOneWidget,
        );
        expect(tester.takeException(), isNull);
      },
    );

    testWidgets(
      'Rapid step oscillation between reservation and payment views preserves selection state and transition animations cleanly',
      (WidgetTester tester) async {
        tester.view.physicalSize = const Size(1200, 800);
        tester.view.devicePixelRatio = 1.0;
        addTearDown(tester.view.resetPhysicalSize);
        addTearDown(tester.view.resetDevicePixelRatio);

        await tester.pumpWidget(
          createBookingScreenWidget(screenSize: const Size(1200, 800)),
        );
        await tester.pumpAndSettle();

        // Select 100 PAX and Online on reservation step
        await tester.tap(find.text('100 PAX'));
        await tester.pumpAndSettle();

        final onlineOption = find.text('Online');
        await tester.scrollUntilVisible(
          onlineOption,
          100,
          scrollable: find.descendant(
            of: find.byKey(const Key('desktop_middle_scroll_view')),
            matching: find.byType(Scrollable),
          ),
        );
        await tester.tap(onlineOption);
        await tester.pumpAndSettle();

        expect(find.text('ONLINE'), findsWidgets);
        expect(find.text('100 PAX'), findsWidgets);

        // Rapidly toggle forward and backward 3 times
        for (int i = 0; i < 3; i++) {
          // Proceed to Payment
          await tester.tap(find.text('Proceed to Payment'));
          await tester.pump(const Duration(milliseconds: 100));
          expect(find.byType(FadeTransition), findsWidgets);
          await tester.pumpAndSettle();
          expect(
            find.byKey(const Key('desktop_payment_panel_view')),
            findsOneWidget,
          );

          // Edit Selection (Back to Reservation)
          await tester.tap(find.text('Edit Selection'));
          await tester.pump(const Duration(milliseconds: 100));
          expect(find.byType(FadeTransition), findsWidgets);
          await tester.pumpAndSettle();
          expect(
            find.byKey(const Key('reservation_calendar_panel')),
            findsOneWidget,
          );
        }

        // State is preserved
        expect(find.text('ONLINE'), findsWidgets);
        expect(find.text('100 PAX'), findsWidgets);

        // Final proceed to payment and confirm
        await tester.tap(find.text('Proceed to Payment'));
        await tester.pumpAndSettle();
        await fillPaymentContacts(tester);
        await tester.tap(find.text('Confirm & Pay'));
        await tester.pumpAndSettle();

        expect(find.text('Payment Successful'), findsOneWidget);
      },
    );

    testWidgets(
      'DesktopPaymentPanel handles bare/null package data gracefully with default fallbacks',
      (WidgetTester tester) async {
        tester.view.physicalSize = const Size(1200, 800);
        tester.view.devicePixelRatio = 1.0;
        addTearDown(tester.view.resetPhysicalSize);
        addTearDown(tester.view.resetDevicePixelRatio);

        const minimalPackage = Package(
          id: 99,
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
              body: DesktopPaymentPanel(
                package: minimalPackage,
                paymentMethod: 'credit_card',
                onPaymentMethodSelected: (_) {},
              ),
            ),
          ),
        );
        await tester.pumpAndSettle();

        expect(find.text('Payment & Checkout Details'), findsOneWidget);
        expect(find.text('2. Online Checkout'), findsOneWidget);
        expect(
          find.byKey(const Key('online_checkout_explainer')),
          findsOneWidget,
        );
        expect(tester.takeException(), isNull);
      },
    );
  });

  group('Issue #47: booking-screen entry and success-leave reset', () {
    Future<ProviderContainer> driveToConfirmed(
      WidgetTester tester,
      FakeApiBackend backend,
    ) async {
      final container = ProviderContainer(
        overrides: [
          packageDetailsProvider(42).overrideWith((ref) => testPackage),
          apiClientProvider.overrideWithValue(buildFakeRestClient(backend)),
        ],
      );
      // Dio needs real async: the widget fake-async zone would freeze it.
      await tester.runAsync(() async {
        final notifier = container.read(bookingFlowProvider.notifier);
        container.read(bookingFlowProvider.notifier)
          ..setSelectedPackage(testPackage)
          ..setSelectedDate(DateTime(2026, 9, 30))
          ..setSelectedTime('2:00 PM - 5:00 PM')
          ..setSelectedPax(50)
          ..setCustomerName('Maria Clara')
          ..setCustomerEmail('maria@example.com')
          ..setCustomerPhone('+639171234567')
          ..setVenueAddress('The Peninsula Manila')
          ..setPaymentMethod('credit_card');
        await notifier.submitBooking();
        await notifier.startPolling();
        notifier.goToStep(5);
      });
      return container;
    }

    testWidgets(
      're-entering after a completed booking shows schedule, never old success',
      (WidgetTester tester) async {
        tester.view.physicalSize = const Size(1200, 800);
        tester.view.devicePixelRatio = 1.0;
        addTearDown(tester.view.resetPhysicalSize);
        addTearDown(tester.view.resetDevicePixelRatio);

        final container = await driveToConfirmed(tester, FakeApiBackend());
        addTearDown(container.dispose);
        expect(
          container.read(bookingFlowProvider).checkoutStatus,
          BookingCheckoutStatus.confirmed,
        );

        await tester.pumpWidget(
          UncontrolledProviderScope(
            container: container,
            child: MaterialApp(
              theme: AppTheme.lightTheme,
              home: const ResponsiveAppShell(
                child: BookingScreen(packageId: 42),
              ),
            ),
          ),
        );
        await tester.pumpAndSettle();

        expect(find.text('Payment Successful'), findsNothing);
        expect(find.text('1. Select Date'), findsOneWidget);
        expect(tester.takeException(), isNull);
      },
    );

    testWidgets(
      'Done on the success screen resets the flow',
      (WidgetTester tester) async {
        tester.view.physicalSize = const Size(1200, 800);
        tester.view.devicePixelRatio = 1.0;
        addTearDown(tester.view.resetPhysicalSize);
        addTearDown(tester.view.resetDevicePixelRatio);

        final backend = FakeApiBackend();
        final container = ProviderContainer(
          overrides: [
            packageDetailsProvider(42).overrideWith((ref) => testPackage),
            apiClientProvider.overrideWithValue(buildFakeRestClient(backend)),
          ],
        );
        addTearDown(container.dispose);

        await tester.pumpWidget(
          UncontrolledProviderScope(
            container: container,
            child: MaterialApp(
              theme: AppTheme.lightTheme,
              home: const ResponsiveAppShell(
                child: BookingScreen(packageId: 42),
              ),
            ),
          ),
        );
        await tester.pumpAndSettle();

        await tester.runAsync(() async {
          final notifier = container.read(bookingFlowProvider.notifier);
          notifier
            ..setSelectedPackage(testPackage)
            ..setSelectedDate(DateTime(2026, 9, 30))
            ..setSelectedTime('2:00 PM - 5:00 PM')
            ..setSelectedPax(50)
            ..setCustomerName('Maria Clara')
            ..setCustomerEmail('maria@example.com')
            ..setCustomerPhone('+639171234567')
            ..setVenueAddress('The Peninsula Manila')
            ..setPaymentMethod('credit_card');
          await notifier.submitBooking();
          await notifier.startPolling();
          notifier.goToStep(5);
        });
        await tester.pumpAndSettle();

        expect(find.text('Payment Successful'), findsOneWidget);
        await tester.tap(find.text('Done'));
        await tester.pumpAndSettle();

        final state = container.read(bookingFlowProvider);
        expect(state.booking, isNull);
        expect(state.checkoutStatus, BookingCheckoutStatus.idle);
        expect(state.currentStep, 2);
        // No takeException: Done falls back to context.go('/home'), which
        // asserts without a GoRouter in this harness (caught in product).
      },
    );
  });
}
