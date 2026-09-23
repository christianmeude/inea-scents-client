import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:inea_scents_client/config/theme.dart';
import 'package:inea_scents_client/models/index.dart';
import 'package:inea_scents_client/providers/index.dart';
import 'package:inea_scents_client/screens/calendar_screen.dart';
import 'package:inea_scents_client/screens/packages_screen.dart';
import 'package:inea_scents_client/widgets/index.dart';
import 'package:shared_preferences/shared_preferences.dart';

class _NeverAvailability extends AvailabilityNotifier {
  @override
  Future<AvailabilityState> build() {
    return Completer<AvailabilityState>().future;
  }
}

void main() {
  setUpAll(() {
    GoogleFonts.config.allowRuntimeFetching = false;
  });

  testWidgets('packages loading renders hero-mirror skeleton, no card grid',
      (WidgetTester tester) async {
    SharedPreferences.setMockInitialValues({'first_launch': false});
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          packagesProvider.overrideWith(
            (ref) => Completer<List<Package>>().future,
          ),
        ],
        child: MaterialApp(
          theme: AppTheme.lightTheme,
          home: const PackagesScreen(),
        ),
      ),
    );
    await tester.pump();

    expect(find.byType(SkeletonPackagesLoading), findsOneWidget);
    expect(find.byKey(const Key('skeleton_offering_hero')), findsOneWidget);
    expect(find.byType(SkeletonPackageCard), findsNothing);
    expect(find.byKey(const Key('offering_hero')), findsNothing);
    expect(tester.takeException(), isNull);
  });

  testWidgets('calendar loading renders calendar skeleton, no spinner',
      (WidgetTester tester) async {
    SharedPreferences.setMockInitialValues({'first_launch': false});
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          availabilityProvider.overrideWith(_NeverAvailability.new),
        ],
        child: MaterialApp(
          theme: AppTheme.lightTheme,
          home: const CalendarScreen(),
        ),
      ),
    );
    await tester.pump();

    expect(find.byType(SkeletonCalendar), findsOneWidget);
    expect(find.byKey(const Key('skeleton_calendar')), findsOneWidget);
    expect(find.byType(CircularProgressIndicator), findsNothing);
    expect(tester.takeException(), isNull);
  });
}
