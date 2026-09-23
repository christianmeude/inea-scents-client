import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:inea_scents_client/config/theme.dart';
import 'package:inea_scents_client/models/index.dart';
import 'package:inea_scents_client/providers/index.dart';
import 'package:inea_scents_client/screens/booking_screen.dart';
import 'package:inea_scents_client/src/providers/core_providers.dart';
import 'package:inea_scents_client/widgets/index.dart';

import 'helpers/fake_api.dart';

/// C65 booking-flow stage transitions: slide + fade on step change,
/// animated timeline progress, instant settle under reduced motion.
Package _c65Package() => const Package(
  id: 42,
  name: 'Dior Women Luxury Experience',
  price: 4500.0,
  paxOptions: [20, 30, 50, 75, 100],
);

ProviderContainer _c65Container() {
  return ProviderContainer(
    overrides: [
      packageDetailsProvider(42).overrideWith((ref) => _c65Package()),
      apiClientProvider.overrideWithValue(buildFakeRestClient(FakeApiBackend())),
    ],
  );
}

Widget _c65Harness(ProviderContainer container, {bool disableAnimations = false}) {
  return UncontrolledProviderScope(
    container: container,
    child: MaterialApp(
      theme: AppTheme.lightTheme,
      // C65: flip the flag below MaterialApp's own MediaQuery so the
      // real view size survives (a raw MediaQueryData would zero it).
      builder: (context, child) => MediaQuery(
        data: MediaQuery.of(
          context,
        ).copyWith(disableAnimations: disableAnimations),
        child: child!,
      ),
      home: ResponsiveAppShell(child: BookingScreen(packageId: 42)),
    ),
  );
}

Future<void> _pumpMobile(
  WidgetTester tester,
  ProviderContainer container, {
  bool disableAnimations = false,
}) async {
  tester.view.physicalSize = const Size(390, 844);
  tester.view.devicePixelRatio = 1.0;
  await tester.pumpWidget(
    _c65Harness(container, disableAnimations: disableAnimations),
  );
  await tester.pumpAndSettle();
}

void main() {
  group('c65 stage transitions', () {
    testWidgets('step change slides + fades the stage body', (
      WidgetTester tester,
    ) async {
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);
      final container = _c65Container();
      addTearDown(container.dispose);
      await _pumpMobile(tester, container);

      expect(find.byKey(const Key('mobile_inea_calendar')), findsOneWidget);

      container.read(bookingFlowProvider.notifier).goToStep(3);
      await tester.pump(const Duration(milliseconds: 50));

      // Mid-transition: slide + fade are both driving the stage swap.
      expect(find.byType(SlideTransition), findsWidgets);
      expect(find.byType(FadeTransition), findsWidgets);

      await tester.pumpAndSettle();
      expect(
        find.byKey(const Key('mobile_details_summary_card')),
        findsOneWidget,
      );
      expect(tester.takeException(), isNull);
    });

    testWidgets('timeline progress animates on step change', (
      WidgetTester tester,
    ) async {
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);
      final container = _c65Container();
      addTearDown(container.dispose);
      await _pumpMobile(tester, container);

      expect(find.byKey(const Key('timeline_dot_0')), findsOneWidget);
      expect(find.byType(AnimatedContainer), findsWidgets);

      container.read(bookingFlowProvider.notifier).goToStep(4);
      await tester.pump(const Duration(milliseconds: 50));
      // The dot implicits are mid-flight while the stage settles.
      expect(find.byType(AnimatedContainer), findsWidgets);

      await tester.pumpAndSettle();
      expect(find.text('Price Details'), findsOneWidget);
      expect(tester.takeException(), isNull);
    });

    testWidgets('reduced motion settles instantly with no anim', (
      WidgetTester tester,
    ) async {
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);
      final container = _c65Container();
      addTearDown(container.dispose);
      await _pumpMobile(tester, container, disableAnimations: true);

      container.read(bookingFlowProvider.notifier).goToStep(3);
      // One frame is enough: zero-duration switch + zero-duration dots.
      await tester.pump();

      expect(
        find.byKey(const Key('mobile_details_summary_card')),
        findsOneWidget,
      );
      // No active slide/fade transitions driving the swap.
      final slides = tester
          .widgetList<SlideTransition>(find.byType(SlideTransition))
          .where((w) {
            final anim = w.position;
            return anim.status == AnimationStatus.forward ||
                anim.status == AnimationStatus.reverse;
          });
      expect(slides, isEmpty);
      expect(tester.takeException(), isNull);
    });
  });
}
