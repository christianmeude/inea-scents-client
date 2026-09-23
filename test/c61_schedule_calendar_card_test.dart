import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:inea_scents_client/config/theme.dart';
import 'package:inea_scents_client/src/providers/core_providers.dart';
import 'package:inea_scents_client/widgets/index.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'helpers/fake_api.dart';

// C61: schedule-step calendar lives in a card container with elevation;
// C54 muted spec stays intact (unavailable muted body@50% w400 no-strike,
// available opaque title w600).
void main() {
  for (final theme in [AppTheme.lightTheme, AppTheme.darkTheme]) {
    final mode = theme.brightness == Brightness.dark ? 'dark' : 'light';
    testWidgets('c61 schedule calendar card + elevation, muted intact ($mode)',
        (tester) async {
      SharedPreferences.setMockInitialValues({'first_launch': false});
      final now = DateTime.now();
      final month = DateTime(now.year, now.month + 1, 1);
      final backend = FakeApiBackend();
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
                  enabledDays: {
                    DateTime(month.year, month.month, 11),
                    DateTime(month.year, month.month, 12),
                  },
                  selectedDate: DateTime(month.year, month.month, 12),
                  onDateSelected: (_) {},
                ),
              ),
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();

      // 1. Card container present with elevation.
      final card = find.byKey(const Key('schedule_calendar_card'));
      expect(card, findsOneWidget);
      final container = tester.widget<Container>(card);
      final decoration = container.decoration as BoxDecoration?;
      expect(decoration, isNotNull);
      expect(decoration!.borderRadius, isNotNull);
      expect(decoration.border, isNotNull);
      expect(decoration.boxShadow, isNotNull);
      expect(decoration.boxShadow, isNotEmpty);

      // 2. C54 intact: no strikethrough anywhere.
      final struck = find.byWidgetPredicate(
        (w) =>
            w is Text &&
            (w.style?.decoration == TextDecoration.lineThrough ||
                w.style?.decoration?.contains(TextDecoration.lineThrough) ==
                    true),
      );
      expect(struck, findsNothing);

      // 3. Unavailable muted (translucent, w400), available opaque + bolder.
      final unavailable =
          tester.widget<Text>(find.byWidgetPredicate(
        (w) => w is Text && w.data == '10',
      ));
      final available = tester.widget<Text>(find.byWidgetPredicate(
        (w) => w is Text && w.data == '11',
      ));
      final ctx = tester.element(card);
      expect(unavailable.style?.color?.a, lessThan(1.0));
      expect(unavailable.style?.fontWeight, equals(FontWeight.w400));
      expect(unavailable.style?.color,
          isNot(equals(CardSurfaces.title(ctx))));
      expect(available.style?.color, equals(CardSurfaces.title(ctx)));
      expect(available.style?.color?.a, equals(1.0));
      expect(available.style?.fontWeight, equals(FontWeight.w600));
      expect(tester.takeException(), isNull);
    });
  }
}
