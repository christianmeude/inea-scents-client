import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:inea_scents_client/config/theme.dart';
import 'package:inea_scents_client/models/index.dart';
import 'package:inea_scents_client/providers/index.dart';
import 'package:inea_scents_client/screens/booking_screen.dart';
import 'package:inea_scents_client/src/providers/core_providers.dart';
import 'package:inea_scents_client/utils/peso.dart';
import 'package:inea_scents_client/widgets/index.dart';

import 'helpers/fake_api.dart';

/// C48 dense schedule shape proofs (owner-APPROVED C47 spec §1–§3):
/// web grid order + retired §1, mobile stack order + collapsed one-liner
/// verbatim, single CTA in the sticky bar outside the scroll, desktop
/// intact (keys, gate, prefill, rail CTA).
Package _c48Package() => const Package(
  id: 42,
  name: 'Dior Women Luxury Experience',
  price: 4500.0,
  inclusions: ['Perfume Bar Setup', '2 staff members'],
  freebies: ['Selfie Mirror'],
  paxOptions: [20, 30, 50, 75, 100],
);

ProviderContainer _c48Container() {
  return ProviderContainer(
    overrides: [
      packageDetailsProvider(42).overrideWith((ref) => _c48Package()),
      apiClientProvider.overrideWithValue(
        buildFakeRestClient(FakeApiBackend()),
      ),
    ],
  );
}

Widget _c48Harness(ProviderContainer container) {
  return UncontrolledProviderScope(
    container: container,
    child: MaterialApp(
      theme: AppTheme.lightTheme,
      home: const ResponsiveAppShell(child: BookingScreen(packageId: 42)),
    ),
  );
}

Future<void> _pump(
  WidgetTester tester,
  ProviderContainer container,
  Size size,
) async {
  tester.view.physicalSize = size;
  tester.view.devicePixelRatio = 1.0;
  await tester.pumpWidget(_c48Harness(container));
  await tester.pumpAndSettle();
}

String _shortDate(DateTime date) {
  const months = [
    'Jan',
    'Feb',
    'Mar',
    'Apr',
    'May',
    'Jun',
    'Jul',
    'Aug',
    'Sep',
    'Oct',
    'Nov',
    'Dec',
  ];
  return '${months[date.month - 1]} ${date.day}, ${date.year}';
}

void main() {
  setUpAll(() {
    GoogleFonts.config.allowRuntimeFetching = false;
  });

  group('c48 dense schedule shape', () {
    testWidgets('desktop card: Select Date & Time holds calendar + time, rail owns booking, no page scroll', (
      WidgetTester tester,
    ) async {
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);
      final container = _c48Container();
      addTearDown(container.dispose);
      await _pump(tester, container, const Size(1280, 800));

      // C92: one datetime card in the flow column; the rail stays col 3.
      expect(
        find.byKey(const Key('desktop_schedule_stack_view')),
        findsOneWidget,
      );
      expect(
        find.byKey(const Key('schedule_datetime_card')),
        findsOneWidget,
      );
      expect(find.text('Select Date & Time'), findsOneWidget);
      expect(
        find.byKey(const Key('reservation_calendar_panel')),
        findsOneWidget,
      );
      expect(find.byKey(const Key('event_time_picker_button')), findsOneWidget);
      expect(
        find.byKey(const Key('order_summary_side_panel')),
        findsOneWidget,
      );

      // C92: Pax header + event recap + in-panel Pax row are gone.
      expect(find.byKey(const Key('schedule_pax_header')), findsNothing);
      expect(find.byKey(const Key('schedule_event_summary')), findsNothing);
      expect(find.byKey(const Key('pax_readonly_row')), findsNothing);
      expect(find.byKey(const Key('pax_change_link')), findsNothing);
      expect(find.byKey(const Key('reservation_details_panel')), findsNothing);

      // 3-col geometry: calendar (inner col 1) left of time (inner col 2)
      // on the same row, both left of the rail (col 3).
      final calRect = tester.getRect(
        find.byKey(const Key('reservation_calendar_panel')),
      );
      final timeRect = tester.getRect(
        find.byKey(const Key('event_time_picker_button')),
      );
      final railLeft = tester
          .getTopLeft(find.byKey(const Key('order_summary_side_panel')))
          .dx;
      expect(calRect.left, lessThan(timeRect.left));
      expect(calRect.top, moreOrLessEquals(timeRect.top, epsilon: 220.0));
      expect(timeRect.right, lessThanOrEqualTo(railLeft));

      // C92: desktop is fixed — no page-level scroll view.
      expect(find.byKey(const Key('app_shell_scroll_view')), findsNothing);

      // Rail intact: CTA text stays `Proceed to Payment` (no amount).
      expect(find.text('Proceed to Payment'), findsOneWidget);
      expect(find.text('Your Booking'), findsOneWidget);
      expect(tester.takeException(), isNull);
    });

    testWidgets('desktop gate + prefill intact: canProceedFromSchedule, 14:00 default', (
      WidgetTester tester,
    ) async {
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);
      final container = _c48Container();
      addTearDown(container.dispose);
      await _pump(tester, container, const Size(1280, 800));

      final flow = container.read(bookingFlowProvider);
      expect(flow.selectedTime, equals('14:00:00'));
      expect(flow.selectedDate, isNotNull);
      expect(
        container.read(bookingFlowProvider.notifier).canProceedFromSchedule(),
        isTrue,
      );
      expect(find.text('2:00 PM'), findsWidgets);
      expect(tester.takeException(), isNull);
    });

    testWidgets('tablet keeps stacked flow + rail, scroll retained, pax/event retired', (
      WidgetTester tester,
    ) async {
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);
      final container = _c48Container();
      addTearDown(container.dispose);
      await _pump(tester, container, const Size(900, 800));

      expect(find.byKey(const Key('tablet_calendar_panel')), findsOneWidget);
      expect(find.byKey(const Key('tablet_details_panel')), findsOneWidget);
      // C92: Pax header + event recap retired on tablet too.
      expect(find.byKey(const Key('schedule_pax_header')), findsNothing);
      expect(find.byKey(const Key('schedule_event_summary')), findsNothing);
      expect(find.byKey(const Key('pax_readonly_row')), findsNothing);
      expect(
        find.byKey(const Key('tablet_order_summary_panel')),
        findsOneWidget,
      );
      // C92: tablet keeps the page-level scroll (desktop-only fixed).
      expect(find.byKey(const Key('app_shell_scroll_view')), findsOneWidget);
      // C76: no Change affordance anywhere on the schedule step.
      expect(find.byKey(const Key('pax_change_link')), findsNothing);
      expect(
        find.descendant(
          of: find.byKey(const Key('tablet_details_panel')),
          matching: find.textContaining('Starting at'),
        ),
        findsNothing,
      );
      expect(tester.takeException(), isNull);
    });

    testWidgets('mobile stack order: calendar, time, collapsed summary (pax/event retired)', (
      WidgetTester tester,
    ) async {
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);
      final container = _c48Container();
      addTearDown(container.dispose);
      await _pump(tester, container, const Size(360, 740));

      expect(find.byKey(const Key('schedule_pax_header')), findsNothing);
      expect(find.byKey(const Key('mobile_inea_calendar')), findsOneWidget);
      expect(find.byKey(const Key('event_time_picker_button')), findsOneWidget);
      // C92: the mobile Pax block + event recap are retired (the collapsed
      // summary below keeps the PAX one-liner).
      expect(find.byKey(const Key('pax_readonly_row')), findsNothing);
      expect(find.byKey(const Key('pax_change_link')), findsNothing);
      expect(find.byKey(const Key('schedule_event_summary')), findsNothing);
      expect(
        find.byKey(const Key('mobile_schedule_collapsed_summary')),
        findsOneWidget,
      );

      // Calendar, then time, then collapsed summary.
      final calTop = tester
          .getTopLeft(find.byKey(const Key('mobile_inea_calendar')))
          .dy;
      final timeTop = tester
          .getTopLeft(find.byKey(const Key('event_time_picker_button')))
          .dy;
      final collapsedTop = tester
          .getTopLeft(find.byKey(const Key('mobile_schedule_collapsed_summary')))
          .dy;
      expect(calTop, lessThan(timeTop));
      expect(timeTop, lessThan(collapsedTop));
      expect(tester.takeException(), isNull);
    });

    testWidgets('mobile collapsed one-liner verbatim + Total row, no inline full panel', (
      WidgetTester tester,
    ) async {
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);
      final container = _c48Container();
      addTearDown(container.dispose);
      await _pump(tester, container, const Size(360, 740));

      final flow = container.read(bookingFlowProvider);
      final expected =
          '${flow.selectedPax} PAX · ${_shortDate(flow.selectedDate!)} · ${TimeSlot.display(flow.selectedTime)}';
      expect(
        find.byKey(const Key('mobile_schedule_collapsed_oneliner')),
        findsOneWidget,
      );
      expect(find.text(expected), findsOneWidget);
      expect(
        find.descendant(
          of: find.byKey(const Key('mobile_schedule_collapsed_summary')),
          matching: find.text('Total'),
        ),
        findsOneWidget,
      );
      expect(
        find.descendant(
          of: find.byKey(const Key('mobile_schedule_collapsed_summary')),
          matching: find.text(formatPeso(_c48Package().priceForPax(flow.selectedPax))),
        ),
        findsOneWidget,
      );

      // Full summary (inclusions header) does not render inline.
      expect(find.text('Inclusions'), findsNothing);
      expect(tester.takeException(), isNull);
    });

    testWidgets('mobile single CTA in the sticky bar, outside the scroll', (
      WidgetTester tester,
    ) async {
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);
      final container = _c48Container();
      addTearDown(container.dispose);
      await _pump(tester, container, const Size(360, 740));

      expect(find.byKey(const Key('mobile_booking_bottom_bar')), findsOneWidget);
      expect(find.byKey(const Key('mobile_bottom_bar_cta')), findsOneWidget);
      expect(find.text('Proceed'), findsOneWidget);

      // One CTA on screen: the bar button is the only ElevatedButton.
      expect(find.byType(ElevatedButton), findsOneWidget);

      // Bar lives outside the page scroll (Scaffold.bottomNavigationBar).
      expect(
        find.descendant(
          of: find.byKey(const Key('app_shell_scroll_view')),
          matching: find.byKey(const Key('mobile_booking_bottom_bar')),
        ),
        findsNothing,
      );
      final scaffolds = tester.widgetList<Scaffold>(find.byType(Scaffold));
      expect(
        scaffolds.where((s) => s.bottomNavigationBar != null),
        isNotEmpty,
      );

      // C40 clamp stays on the page scroll.
      final scrollable = tester.widget<Scrollable>(
        find
            .descendant(
              of: find.byKey(const Key('app_shell_scroll_view')),
              matching: find.byType(Scrollable),
            )
            .first,
      );
      expect(scrollable.physics, isA<ClampingScrollPhysics>());
      expect(tester.takeException(), isNull);
    });

    testWidgets('mobile bar labels per step: Proceed, Proceed to Payment, Confirm & Pay', (
      WidgetTester tester,
    ) async {
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);
      final container = _c48Container();
      addTearDown(container.dispose);
      await _pump(tester, container, const Size(360, 740));

      expect(find.text('Proceed'), findsOneWidget);

      container.read(bookingFlowProvider.notifier).goToStep(3);
      await tester.pumpAndSettle();
      expect(find.text('Proceed to Payment'), findsOneWidget);

      container.read(bookingFlowProvider.notifier).goToStep(4);
      await tester.pumpAndSettle();
      expect(find.textContaining('Confirm & Pay'), findsOneWidget);
      expect(tester.takeException(), isNull);
    });
  });
}
