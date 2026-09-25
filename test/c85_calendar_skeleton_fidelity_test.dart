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
          body: SingleChildScrollView(child: SkeletonCalendar()),
        ),
      ),
    );
    await tester.pump();
  }

  Finder cellsWithPrefix(String prefix) => find.byWidgetPredicate(
        (w) =>
            w.key is ValueKey &&
            (w.key! as ValueKey).value.toString().startsWith(prefix),
      );

  testWidgets('C85: leading blanks match real month (Monday-start)',
      (WidgetTester tester) async {
    await pumpSkeleton(tester);

    final now = DateTime.now();
    final expectedLeading =
        DateTime(now.year, now.month, 1).weekday - DateTime.monday;
    expect(
      cellsWithPrefix('skeleton_leading_cell_'),
      findsNWidgets(expectedLeading),
    );

    final daysInMonth = DateTime(now.year, now.month + 1, 0).day;
    expect(
      cellsWithPrefix('skeleton_day_cell_'),
      findsNWidgets(daysInMonth),
    );
    expect(tester.takeException(), isNull);
  });

  testWidgets('C85: month-nav + weekday header present, no pill CTA',
      (WidgetTester tester) async {
    await pumpSkeleton(tester);

    expect(find.byKey(const Key('skeleton_month_nav')), findsOneWidget);
    expect(find.byKey(const Key('skeleton_weekday_header')), findsOneWidget);
    expect(find.byKey(const Key('skeleton_agenda')), findsOneWidget);
    expect(find.byKey(const Key('skeleton_agenda_pill')), findsNothing);
    expect(tester.takeException(), isNull);
  });

  testWidgets('C85: single-parent Shimmer invariant holds',
      (WidgetTester tester) async {
    await pumpSkeleton(tester);

    expect(find.byType(Shimmer), findsOneWidget);
    expect(tester.takeException(), isNull);
  });
}
