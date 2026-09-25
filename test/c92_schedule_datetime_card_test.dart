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

/// C92 schedule datetime card: desktop shows one "Select Date & Time" card
/// (calendar inner col 1 + time inner col 2, `Your Booking` rail col 3),
/// no Pax UI and no event recap anywhere in Schedule, desktop fixed
/// (no page scroll) while tablet keeps its scroll and mobile stays intact.
Package _c92Package() => const Package(
  id: 42,
  name: 'Dior Women Luxury Experience',
  price: 4500.0,
  inclusions: ['Perfume Bar Setup', '2 staff members'],
  freebies: ['Selfie Mirror'],
  paxOptions: [20, 30, 50, 75, 100],
);

ProviderContainer _c92Container() {
  return ProviderContainer(
    overrides: [
      packageDetailsProvider(42).overrideWith((ref) => _c92Package()),
      apiClientProvider.overrideWithValue(
        buildFakeRestClient(FakeApiBackend()),
      ),
    ],
  );
}

Widget _c92Harness(ProviderContainer container) {
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
  await tester.pumpWidget(_c92Harness(container));
  await tester.pumpAndSettle();
}

void main() {
  setUpAll(() {
    GoogleFonts.config.allowRuntimeFetching = false;
  });

  group('c92 schedule datetime card', () {
    testWidgets('desktop 1200px: 3-col card + rail, no pax/event, no scroll', (
      WidgetTester tester,
    ) async {
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);
      final container = _c92Container();
      addTearDown(container.dispose);
      await _pump(tester, container, const Size(1200, 800));

      expect(find.byKey(const Key('schedule_datetime_card')), findsOneWidget);
      expect(find.text('Select Date & Time'), findsOneWidget);
      expect(
        find.byKey(const Key('reservation_calendar_panel')),
        findsOneWidget,
      );
      expect(find.byKey(const Key('event_time_picker_button')), findsOneWidget);
      expect(find.text('Your Booking'), findsOneWidget);

      // No Pax UI, no event recap left in Schedule.
      expect(find.byKey(const Key('schedule_pax_header')), findsNothing);
      expect(find.byKey(const Key('schedule_event_summary')), findsNothing);
      expect(find.byKey(const Key('pax_readonly_row')), findsNothing);
      expect(find.byKey(const Key('pax_change_link')), findsNothing);
      expect(find.text('Event Summary'), findsNothing);

      // 3-col geometry: calendar | time | rail.
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
      expect(timeRect.right, lessThanOrEqualTo(railLeft));

      // Desktop fixed: no page-level scroll view, no overflow.
      expect(find.byKey(const Key('app_shell_scroll_view')), findsNothing);
      expect(tester.takeException(), isNull);
    });

    testWidgets('desktop short viewport 1200x650: fixed, no overflow', (
      WidgetTester tester,
    ) async {
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);
      final container = _c92Container();
      addTearDown(container.dispose);
      await _pump(tester, container, const Size(1200, 650));

      expect(find.byKey(const Key('schedule_datetime_card')), findsOneWidget);
      expect(find.byKey(const Key('reservation_calendar_panel')), findsOneWidget);
      expect(find.byKey(const Key('event_time_picker_button')), findsOneWidget);
      expect(find.byKey(const Key('order_summary_side_panel')), findsOneWidget);
      expect(find.byKey(const Key('app_shell_scroll_view')), findsNothing);
      expect(tester.takeException(), isNull);
    });

    testWidgets('tablet 900px: scroll retained, calendar + time, no pax/event', (
      WidgetTester tester,
    ) async {
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);
      final container = _c92Container();
      addTearDown(container.dispose);
      await _pump(tester, container, const Size(900, 800));

      expect(find.byKey(const Key('app_shell_scroll_view')), findsOneWidget);
      expect(find.byKey(const Key('tablet_calendar_panel')), findsOneWidget);
      expect(find.byKey(const Key('tablet_details_panel')), findsOneWidget);
      expect(
        find.byKey(const Key('tablet_order_summary_panel')),
        findsOneWidget,
      );
      expect(find.byKey(const Key('schedule_pax_header')), findsNothing);
      expect(find.byKey(const Key('schedule_event_summary')), findsNothing);
      expect(find.byKey(const Key('pax_readonly_row')), findsNothing);
      expect(tester.takeException(), isNull);
    });

    testWidgets('mobile 390px: calendar + time + collapsed summary intact', (
      WidgetTester tester,
    ) async {
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);
      final container = _c92Container();
      addTearDown(container.dispose);
      await _pump(tester, container, const Size(390, 844));

      expect(find.byKey(const Key('app_shell_scroll_view')), findsOneWidget);
      expect(find.byKey(const Key('mobile_inea_calendar')), findsOneWidget);
      expect(find.byKey(const Key('event_time_picker_button')), findsOneWidget);
      expect(
        find.byKey(const Key('mobile_schedule_collapsed_summary')),
        findsOneWidget,
      );
      expect(find.byKey(const Key('mobile_booking_bottom_bar')), findsOneWidget);
      expect(find.byKey(const Key('pax_readonly_row')), findsNothing);
      expect(find.byKey(const Key('schedule_event_summary')), findsNothing);
      expect(tester.takeException(), isNull);
    });
  });
}
