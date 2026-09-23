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

/// C63 sticky bottom CTA bar proofs at 360px width:
/// bar present on all 3 wizard steps (Schedule/Details/Payment) with the
/// step's primary CTA, bar above the bottom safe-area inset, and every
/// step's last item scrollable fully clear of the bar.
Package _c63Package() => const Package(
  id: 42,
  name: 'Dior Women Luxury Experience',
  price: 4500.0,
  inclusions: ['Perfume Bar Setup', '2 staff members'],
  freebies: ['Selfie Mirror'],
  paxOptions: [20, 30, 50, 75, 100],
);

ProviderContainer _c63Container() {
  return ProviderContainer(
    overrides: [
      packageDetailsProvider(42).overrideWith((ref) => _c63Package()),
      apiClientProvider.overrideWithValue(
        buildFakeRestClient(FakeApiBackend()),
      ),
    ],
  );
}

Widget _c63Harness(ProviderContainer container) {
  return UncontrolledProviderScope(
    container: container,
    child: MaterialApp(
      theme: AppTheme.lightTheme,
      home: const ResponsiveAppShell(child: BookingScreen(packageId: 42)),
    ),
  );
}

Finder _pageScrollable() => find
    .descendant(
      of: find.byKey(const Key('app_shell_scroll_view')),
      matching: find.byType(Scrollable),
    )
    .first;

Future<void> _pump360(WidgetTester tester, ProviderContainer container) async {
  tester.view.physicalSize = const Size(360, 740);
  tester.view.devicePixelRatio = 1.0;
  // Simulated bottom system inset (home indicator): the bar must sit above it.
  tester.view.padding = const FakeViewPadding(bottom: 34);
  await tester.pumpWidget(_c63Harness(container));
  await tester.pumpAndSettle();
}

Future<void> _goToStep(
  WidgetTester tester,
  ProviderContainer container,
  int step,
) async {
  container.read(bookingFlowProvider.notifier).goToStep(step);
  await tester.pumpAndSettle();
}

/// Last in-flow content per wizard step (must stay clear of the bar).
Finder _lastItemForStep(int step) {
  switch (step) {
    case 2:
      return find.byKey(const Key('mobile_schedule_collapsed_summary'));
    case 3:
      return find.byKey(const ValueKey('mobile_venue_address'));
    case 4:
      return find.text('Cash');
    default:
      throw ArgumentError('C63 covers wizard steps 2-4, got $step');
  }
}

String _ctaForStep(int step) {
  switch (step) {
    case 2:
      return 'Proceed';
    case 3:
      return 'Proceed to Payment';
    case 4:
      return 'Confirm & Pay';
    default:
      throw ArgumentError('C63 covers wizard steps 2-4, got $step');
  }
}

void main() {
  setUpAll(() {
    GoogleFonts.config.allowRuntimeFetching = false;
  });

  group('c63 sticky bottom CTA bar', () {
    for (final step in [2, 3, 4]) {
      testWidgets('step $step: bar with CTA above safe-area, last item reachable', (
        WidgetTester tester,
      ) async {
        addTearDown(tester.view.resetPhysicalSize);
        addTearDown(tester.view.resetDevicePixelRatio);
        addTearDown(tester.view.resetPadding);
        final container = _c63Container();
        addTearDown(container.dispose);
        await _pump360(tester, container);
        await _goToStep(tester, container, step);

        final bar = find.byKey(const Key('mobile_booking_bottom_bar'));
        final cta = find.byKey(const Key('mobile_bottom_bar_cta'));

        // Bar present with the step's primary CTA.
        expect(bar, findsOneWidget);
        expect(cta, findsOneWidget);
        expect(find.textContaining(_ctaForStep(step)), findsOneWidget);

        // Bar lives outside the page scroll (Scaffold.bottomNavigationBar).
        expect(
          find.descendant(
            of: find.byKey(const Key('app_shell_scroll_view')),
            matching: bar,
          ),
          findsNothing,
        );
        expect(
          find.ancestor(of: bar, matching: find.byType(Scaffold)),
          findsWidgets,
        );

        // Bar sits above the bottom safe-area: wrapped in a SafeArea and,
        // with a 34px simulated inset, at least 34px clear of screen bottom.
        expect(
          find.ancestor(of: bar, matching: find.byType(SafeArea)),
          findsOneWidget,
        );
        final barRect = tester.getRect(bar);
        expect(740 - barRect.bottom, greaterThanOrEqualTo(34));

        // Last item scrolls fully above the bar — never hidden behind it.
        final last = _lastItemForStep(step);
        await tester.scrollUntilVisible(last, 100, scrollable: _pageScrollable());
        await tester.pumpAndSettle();
        final lastRect = tester.getRect(last);
        final barTop = tester.getTopRight(bar).dy;
        expect(lastRect.bottom, lessThanOrEqualTo(barTop + 0.5));

        expect(tester.takeException(), isNull);
      });
    }
  });
}
