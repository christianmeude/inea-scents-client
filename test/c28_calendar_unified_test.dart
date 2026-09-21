import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:inea_scents_client/models/index.dart';
import 'package:inea_scents_client/providers/index.dart';
import 'package:inea_scents_client/screens/calendar_screen.dart';
import 'package:inea_scents_client/src/providers/core_providers.dart';
import 'package:inea_scents_client/widgets/index.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'helpers/fake_api.dart';

// C28: date-entry grid and booking-wizard grid share one widget.
class _CannedAvailability extends AvailabilityNotifier {
  _CannedAvailability(this.canned);

  final AvailabilityState canned;

  @override
  Future<AvailabilityState> build() async => canned;
}

DateTime _targetMonth() {
  final now = DateTime.now();
  return DateTime(now.year, now.month + 1, 1);
}

AvailabilityState _canned(DateTime month,
    {required List<int> available, List<int> booked = const []}) {
  return AvailabilityState(
    month: month.month,
    year: month.year,
    data: [
      for (final d in available)
        GetApiAvailabilityResponse(
          date: DateTime(month.year, month.month, d),
          status: 'Available',
        ),
      for (final d in booked)
        GetApiAvailabilityResponse(
          date: DateTime(month.year, month.month, d),
          status: 'Booked',
        ),
    ],
  );
}

List<Override> _overrides(AvailabilityState canned) => [
      apiClientProvider.overrideWithValue(
        buildFakeRestClient(FakeApiBackend()),
      ),
      availabilityProvider.overrideWith(() => _CannedAvailability(canned)),
    ];

void main() {
  testWidgets('C28: CalendarScreen renders the shared IneaCalendar grid',
      (WidgetTester tester) async {
    SharedPreferences.setMockInitialValues({'first_launch': false});
    final month = _targetMonth();
    await tester.pumpWidget(
      ProviderScope(
        overrides: _overrides(_canned(month, available: [10, 11, 12])),
        child: const MaterialApp(home: CalendarScreen()),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('Availability'), findsOneWidget);
    expect(find.byType(IneaCalendar), findsOneWidget);
  });

  testWidgets('C28: booking schedule panel delegates to IneaCalendar',
      (WidgetTester tester) async {
    SharedPreferences.setMockInitialValues({'first_launch': false});
    final month = _targetMonth();
    await tester.pumpWidget(
      ProviderScope(
        overrides: _overrides(_canned(month, available: [10, 11, 12])),
        child: MaterialApp(
          home: Scaffold(
            body: ReservationCalendarPanel(
              selectedDate: DateTime(month.year, month.month, 11),
              onDateSelected: (_) {},
            ),
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.byType(ReservationCalendarPanel), findsOneWidget);
    expect(find.byType(IneaCalendar), findsOneWidget);
  });

  testWidgets('C28: selected day target is 44px or larger',
      (WidgetTester tester) async {
    SharedPreferences.setMockInitialValues({'first_launch': false});
    final month = _targetMonth();
    await tester.pumpWidget(
      ProviderScope(
        overrides: _overrides(_canned(month, available: [10, 11, 12])),
        child: MaterialApp(
          home: Scaffold(
            body: SingleChildScrollView(
              child: IneaCalendar(
                selectedDate: DateTime(month.year, month.month, 11),
                onDateSelected: (_) {},
              ),
            ),
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();

    final selected = find.byKey(const Key('inea_selected_day'));
    expect(selected, findsOneWidget);
    final size = tester.getSize(selected);
    expect(size.width, greaterThanOrEqualTo(44));
    expect(size.height, greaterThanOrEqualTo(44));
  });

  group('C28: date-entry agenda flow', () {
    testWidgets('agenda + CTA appear after selecting a date',
        (WidgetTester tester) async {
      SharedPreferences.setMockInitialValues({'first_launch': false});
      tester.view.physicalSize = const Size(390, 1400);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);

      final month = _targetMonth();
      await tester.pumpWidget(
        ProviderScope(
          overrides: _overrides(_canned(month, available: [10, 11, 12])),
          child: const MaterialApp(home: CalendarScreen()),
        ),
      );
      await tester.pumpAndSettle();

      await tester.tap(find.text('11'));
      await tester.pumpAndSettle();

      expect(find.byKey(const Key('calendar_agenda')), findsOneWidget);
      expect(find.byKey(const Key('calendar_continue_cta')), findsOneWidget);
      expect(find.textContaining('Continue with'), findsOneWidget);
    });

    testWidgets('selection survives month paging',
        (WidgetTester tester) async {
      SharedPreferences.setMockInitialValues({'first_launch': false});
      tester.view.physicalSize = const Size(390, 1400);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);

      final month = _targetMonth();
      await tester.pumpWidget(
        ProviderScope(
          overrides: _overrides(_canned(month, available: [10, 11, 12])),
          child: const MaterialApp(home: CalendarScreen()),
        ),
      );
      await tester.pumpAndSettle();

      await tester.tap(find.text('11'));
      await tester.pumpAndSettle();
      expect(find.byKey(const Key('calendar_continue_cta')), findsOneWidget);

      await tester.tap(find.byIcon(Icons.chevron_right_rounded));
      await tester.pumpAndSettle();

      // Selection (agenda + CTA) is preserved across the page.
      expect(find.byKey(const Key('calendar_agenda')), findsOneWidget);
      expect(find.byKey(const Key('calendar_continue_cta')), findsOneWidget);
      expect(find.textContaining('Continue with'), findsOneWidget);
    });
  });
}
