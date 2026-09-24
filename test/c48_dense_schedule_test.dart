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
    testWidgets('desktop stack: pax header + full-width calendar, then time/pax + event recap, sticky rail, §1 retired', (
      WidgetTester tester,
    ) async {
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);
      final container = _c48Container();
      addTearDown(container.dispose);
      await _pump(tester, container, const Size(1280, 800));

      // C76: ColB dissolved beside the calendar — the schedule step is a
      // vertical stack in the flow column.
      expect(
        find.byKey(const Key('desktop_schedule_stack_view')),
        findsOneWidget,
      );
      expect(
        find.byKey(const Key('reservation_calendar_panel')),
        findsOneWidget,
      );
      expect(
        find.byKey(const Key('reservation_details_panel')),
        findsOneWidget,
      );
      expect(find.byKey(const Key('schedule_pax_header')), findsOneWidget);
      expect(find.byKey(const Key('schedule_event_summary')), findsOneWidget);
      expect(
        find.byKey(const Key('order_summary_side_panel')),
        findsOneWidget,
      );

      // Stack order: Pax header above calendar above details above the
      // event recap; the rail stays right of the flow column.
      final headerTop = tester
          .getTopLeft(find.byKey(const Key('schedule_pax_header')))
          .dy;
      final calTop = tester
          .getTopLeft(find.byKey(const Key('reservation_calendar_panel')))
          .dy;
      final detTop = tester
          .getTopLeft(find.byKey(const Key('reservation_details_panel')))
          .dy;
      final recapTop = tester
          .getTopLeft(find.byKey(const Key('schedule_event_summary')))
          .dy;
      final railLeft = tester
          .getTopLeft(find.byKey(const Key('order_summary_side_panel')))
          .dx;
      final detLeft = tester
          .getTopLeft(find.byKey(const Key('reservation_details_panel')))
          .dx;
      expect(headerTop, lessThan(calTop));
      expect(calTop, lessThan(detTop));
      expect(detTop, lessThan(recapTop));
      expect(detLeft, lessThan(railLeft));

      // Calendar spans the full flow-column width (no side-by-side ColB).
      final stackWidth = tester
          .getRect(find.byKey(const Key('desktop_schedule_stack_view')))
          .width;
      final calWidth = tester
          .getRect(find.byKey(const Key('reservation_calendar_panel')))
          .width;
      expect(calWidth, moreOrLessEquals(stackWidth, epsilon: 2.0));

      // Pax locked: readonly row stays, Change affordance is gone (C76).
      expect(find.byKey(const Key('pax_readonly_row')), findsOneWidget);
      expect(find.byKey(const Key('pax_change_link')), findsNothing);
      expect(find.byKey(const Key('event_time_picker_button')), findsOneWidget);

      // §1 package card retired from the schedule step on both panels.
      expect(
        find.descendant(
          of: find.byKey(const Key('reservation_details_panel')),
          matching: find.textContaining('Starting at'),
        ),
        findsNothing,
      );

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

    testWidgets('tablet keeps stacked flow + rail with §1 retired, pax locked', (
      WidgetTester tester,
    ) async {
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);
      final container = _c48Container();
      addTearDown(container.dispose);
      await _pump(tester, container, const Size(900, 800));

      expect(find.byKey(const Key('tablet_calendar_panel')), findsOneWidget);
      expect(find.byKey(const Key('tablet_details_panel')), findsOneWidget);
      expect(find.byKey(const Key('schedule_pax_header')), findsOneWidget);
      expect(find.byKey(const Key('schedule_event_summary')), findsOneWidget);
      expect(
        find.byKey(const Key('tablet_order_summary_panel')),
        findsOneWidget,
      );
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

    testWidgets('mobile stack order: pax header, calendar, time, event recap, collapsed summary', (
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
      // C76: the mobile pax block IS the locked header (no Change link).
      expect(find.byKey(const Key('pax_readonly_row')), findsOneWidget);
      expect(find.byKey(const Key('pax_change_link')), findsNothing);
      expect(find.byKey(const Key('schedule_event_summary')), findsOneWidget);
      expect(
        find.byKey(const Key('mobile_schedule_collapsed_summary')),
        findsOneWidget,
      );

      // Pax header first, then calendar, time, event recap, collapsed.
      final paxTop = tester
          .getTopLeft(find.byKey(const Key('pax_readonly_row')))
          .dy;
      final calTop = tester
          .getTopLeft(find.byKey(const Key('mobile_inea_calendar')))
          .dy;
      final timeTop = tester
          .getTopLeft(find.byKey(const Key('event_time_picker_button')))
          .dy;
      final recapTop = tester
          .getTopLeft(find.byKey(const Key('schedule_event_summary')))
          .dy;
      final collapsedTop = tester
          .getTopLeft(find.byKey(const Key('mobile_schedule_collapsed_summary')))
          .dy;
      expect(paxTop, lessThan(calTop));
      expect(calTop, lessThan(timeTop));
      expect(timeTop, lessThan(recapTop));
      expect(recapTop, lessThan(collapsedTop));
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
