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

Package _offering() => const Package(
  id: 1,
  name: 'Essential 10ml Perfume Bar',
  description: 'A signature scent experience for your celebration.',
  price: 4499,
  paxOptions: [50, 70, 100, 150],
  paxPrices: {50: 4499.0, 70: 6399.0, 100: 8799.0, 150: 13119.0},
  inclusions: ['2-hour perfume bar'],
  freebies: ['Keepsake atomizer'],
);

AvailabilityState _canned() {
  final now = DateTime.now();
  return AvailabilityState(
    month: now.month,
    year: now.year,
    data: [
      GetApiAvailabilityResponse(
        date: DateTime(now.year, now.month, 10),
        status: 'Available',
      ),
    ],
  );
}

class _GatedAvailability extends AvailabilityNotifier {
  _GatedAvailability(this.gate);

  final Completer<AvailabilityState> gate;

  @override
  Future<AvailabilityState> build() => gate.future;
}

Future<void> _pumpCrossfade(
  WidgetTester tester,
  bool isLoading, {
  bool disableAnimations = false,
}) {
  return tester.pumpWidget(
    MaterialApp(
      home: MediaQuery(
        data: MediaQueryData(disableAnimations: disableAnimations),
        child: SkeletonCrossfade(
          isLoading: isLoading,
          skeleton: const Text('skeleton'),
          child: const Text('content'),
        ),
      ),
    ),
  );
}

void main() {
  setUpAll(() {
    GoogleFonts.config.allowRuntimeFetching = false;
  });

  group('c66 skeleton crossfade', () {
    test('fade duration stays within 300ms budget', () {
      expect(
        SkeletonCrossfade.fadeDuration.inMilliseconds,
        lessThanOrEqualTo(300),
      );
      expect(SkeletonCrossfade.fadeDuration.inMilliseconds, greaterThan(0));
    });

    testWidgets('packages loading crossfades skeleton to content, no flash', (
      WidgetTester tester,
    ) async {
      SharedPreferences.setMockInitialValues({'first_launch': false});
      final gate = Completer<List<Package>>();
      await tester.pumpWidget(
        ProviderScope(
          overrides: [packagesProvider.overrideWith((ref) => gate.future)],
          child: MaterialApp(
            theme: AppTheme.lightTheme,
            home: const PackagesScreen(),
          ),
        ),
      );
      await tester.pump();

      expect(find.byType(SkeletonCrossfade), findsOneWidget);
      expect(find.byType(SkeletonPackagesLoading), findsOneWidget);
      expect(find.byKey(const Key('offering_hero')), findsNothing);

      gate.complete([_offering()]);
      await tester.pump();
      await tester.pumpAndSettle();

      expect(find.byKey(const Key('offering_hero')), findsOneWidget);
      expect(find.byType(SkeletonPackagesLoading), findsNothing);
      expect(tester.takeException(), isNull);
    });

    testWidgets('calendar loading crossfades skeleton to content, no flash', (
      WidgetTester tester,
    ) async {
      SharedPreferences.setMockInitialValues({'first_launch': false});
      final gate = Completer<AvailabilityState>();
      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            availabilityProvider.overrideWith(() => _GatedAvailability(gate)),
          ],
          child: MaterialApp(
            theme: AppTheme.lightTheme,
            home: const CalendarScreen(),
          ),
        ),
      );
      await tester.pump();

      expect(find.byType(SkeletonCrossfade), findsOneWidget);
      expect(find.byType(SkeletonCalendar), findsOneWidget);
      expect(find.byType(IneaCalendar), findsNothing);

      gate.complete(_canned());
      await tester.pump();
      await tester.pumpAndSettle();

      expect(find.byType(IneaCalendar), findsOneWidget);
      expect(find.byType(SkeletonCalendar), findsNothing);
      expect(tester.takeException(), isNull);
    });

    testWidgets('swap animates through a fade, not a pop-in', (
      WidgetTester tester,
    ) async {
      await _pumpCrossfade(tester, true);
      await tester.pumpAndSettle();
      expect(find.text('skeleton'), findsOneWidget);

      await _pumpCrossfade(tester, false);
      await tester.pump();
      // Mid-transition: outgoing skeleton still fading under content.
      expect(find.text('content'), findsOneWidget);

      await tester.pumpAndSettle();
      expect(find.text('content'), findsOneWidget);
      expect(find.text('skeleton'), findsNothing);
    });

    testWidgets('reduced-motion swaps instantly with zero duration', (
      WidgetTester tester,
    ) async {
      await _pumpCrossfade(tester, true, disableAnimations: true);
      await tester.pump();
      expect(find.text('skeleton'), findsOneWidget);

      await _pumpCrossfade(tester, false, disableAnimations: true);
      await tester.pump();

      final switcher = tester.widget<AnimatedSwitcher>(
        find.byType(AnimatedSwitcher),
      );
      expect(switcher.duration, Duration.zero);
      expect(find.text('content'), findsOneWidget);
      expect(find.text('skeleton'), findsNothing);
      expect(tester.takeException(), isNull);
    });
  });
}
