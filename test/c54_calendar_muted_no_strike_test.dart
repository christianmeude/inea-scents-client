import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:inea_scents_client/config/theme.dart';
import 'package:inea_scents_client/src/providers/core_providers.dart';
import 'package:inea_scents_client/widgets/index.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'helpers/fake_api.dart';

// C54: unavailable dates are muted without strikethrough; available dates
// stand out via contrast; no per-cell AVAILABLE text.
DateTime _targetMonth() {
  final now = DateTime.now();
  return DateTime(now.year, now.month + 1, 1);
}

/// Weight rank helper for contrast ordering checks.
int _weightRank(FontWeight? w) {
  if (w == null) return 0;
  if (w == FontWeight.w100) return 1;
  if (w == FontWeight.w200) return 2;
  if (w == FontWeight.w300) return 3;
  if (w == FontWeight.w400) return 4;
  if (w == FontWeight.w500) return 5;
  if (w == FontWeight.w600) return 6;
  if (w == FontWeight.w700) return 7;
  if (w == FontWeight.w800) return 8;
  return 9;
}

void main() {
  for (final theme in [AppTheme.lightTheme, AppTheme.darkTheme]) {
    final mode = theme.brightness == Brightness.dark ? 'dark' : 'light';
    testWidgets('c54 unavailable muted without strike, available stands out ($mode)',
        (tester) async {
      SharedPreferences.setMockInitialValues({'first_launch': false});
      final month = _targetMonth();
      final backend = FakeApiBackend();
      DateTime? tapped;
      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            apiClientProvider.overrideWithValue(
              buildFakeRestClient(backend),
            ),
          ],
          child: MaterialApp(
            theme: theme,
            home: Scaffold(
              body: SingleChildScrollView(
                child: IneaCalendar(
                  // Only 11 + 12 enabled: 10 renders via disabledBuilder,
                  // 11 via the available defaultBuilder, 12 selected.
                  enabledDays: {
                    DateTime(month.year, month.month, 11),
                    DateTime(month.year, month.month, 12),
                  },
                  selectedDate: DateTime(month.year, month.month, 12),
                  onDateSelected: (d) => tapped = d,
                ),
              ),
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();

      // 1. No strikethrough anywhere in the calendar.
      final struck = find.byWidgetPredicate(
        (w) =>
            w is Text &&
            (w.style?.decoration == TextDecoration.lineThrough ||
                w.style?.decoration?.contains(TextDecoration.lineThrough) ==
                    true),
      );
      expect(struck, findsNothing);

      // 2. No per-cell AVAILABLE/Full captions — day cells are bare numbers.
      final cellCaptions = find.byWidgetPredicate(
        (w) =>
            w is Text &&
            w.data != null &&
            (w.data!.toUpperCase() == 'AVAILABLE' ||
                w.data!.toUpperCase() == 'FULL'),
      );
      expect(cellCaptions, findsNothing);

      // 3. Unavailable day is disabled + muted (translucent, light weight,
      // no strike); available day stands out (opaque title, bolder).
      final unavailableFinder = find.byWidgetPredicate(
        (w) => w is Text && w.data == '10',
      );
      final availableFinder = find.byWidgetPredicate(
        (w) => w is Text && w.data == '11',
      );
      expect(unavailableFinder, findsOneWidget);
      expect(availableFinder, findsOneWidget);
      final unavailable = tester.widget<Text>(unavailableFinder);
      final available = tester.widget<Text>(availableFinder);
      final ctx = tester.element(unavailableFinder);
      expect(unavailable.style?.decoration, isNot(TextDecoration.lineThrough));
      expect(unavailable.style?.color?.a, lessThan(1.0));
      expect(unavailable.style?.color, isNot(equals(CardSurfaces.title(ctx))));
      expect(available.style?.color, equals(CardSurfaces.title(ctx)));
      expect(available.style?.color?.a, equals(1.0));
      expect(
        _weightRank(available.style?.fontWeight),
        greaterThan(_weightRank(unavailable.style?.fontWeight)),
      );

      // 4. Unavailable day is disabled — tapping it selects nothing.
      await tester.tap(unavailableFinder);
      await tester.pumpAndSettle();
      expect(tapped, isNull);
      expect(tester.takeException(), isNull);
    });
  }
}
