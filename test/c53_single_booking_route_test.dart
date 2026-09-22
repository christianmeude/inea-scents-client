import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:inea_scents_client/config/theme.dart';
import 'package:inea_scents_client/models/index.dart';
import 'package:inea_scents_client/providers/index.dart';
import 'package:inea_scents_client/screens/booking_screen.dart';
import 'package:inea_scents_client/screens/calendar_screen.dart';
import 'package:inea_scents_client/screens/home_screen.dart';
import 'package:inea_scents_client/screens/packages_screen.dart';
import 'package:inea_scents_client/screens/profile_screen.dart';
import 'package:inea_scents_client/src/providers/core_providers.dart';
import 'package:inea_scents_client/src/services/token_storage.dart';
import 'package:inea_scents_client/widgets/index.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'helpers/fake_api.dart';

/// C53: single booking route with auto-filled details.
///
/// - Profile is the prefill source of truth (inline-editable, never writes
///   back to the profile) — the one booking route prefills contact details
///   every time, including late auth arrival and reroutes.
/// - Reroutes retain the draft date + Pax (never clobber).
/// - Calendar date pick reroutes to Packages; Home CTAs land on the right
///   tab; top-nav selection follows reroutes (`/booking/:id` reads as
///   Packages, `/bookings` as Bookings).
/// - Q9: persistent in-progress resume chip on all 5 screens.
Package _pkg() => const Package(
  id: 42,
  name: 'Unified Celebration Bar',
  price: 4499,
  paxOptions: [50, 70, 100],
  paxPrices: {50: 4499.0, 70: 6399.0, 100: 8799.0},
);

DateTime _futureDay([int offset = 30]) {
  final now = DateTime.now();
  final day = DateTime(now.year, now.month, now.day);
  return day.add(Duration(days: offset));
}

ProviderContainer _container(FakeApiBackend backend) {
  return ProviderContainer(
    overrides: [
      apiClientProvider.overrideWithValue(buildFakeRestClient(backend)),
      packageDetailsProvider(42).overrideWith((ref) => _pkg()),
    ],
  );
}

Override _authAs(String name, String email, FakeApiBackend backend) {
  return authProvider.overrideWith(
    (ref) =>
        AuthNotifier(buildFakeRestClient(backend), TokenStorage())
          // ignore: invalid_use_of_visible_for_testing_member
          ..state = AuthState(
            isLoggedIn: true,
            user: User(name: name, email: email),
          ),
  );
}

void main() {
  setUpAll(() {
    GoogleFonts.config.allowRuntimeFetching = false;
  });

  group('C53 nav index follows reroutes', () {
    test('single booking route reads as Packages, list as Bookings', () {
      expect(navIndexForLocation('/booking/42'), 1);
      expect(navIndexForLocation('/booking/42?pax=50'), 1);
      expect(navIndexForLocation('/packages'), 1);
      expect(navIndexForLocation('/packages?date=2026-10-03'), 1);
      expect(navIndexForLocation('/bookings'), 2);
      expect(navIndexForLocation('/bookings/9'), 2);
      expect(navIndexForLocation('/calendar'), 3);
      expect(navIndexForLocation('/profile'), 4);
      expect(navIndexForLocation('/home'), 0);
      expect(navIndexForLocation('/'), 0);
    });
  });

  group('C53 booking route prefills details every time', () {
    testWidgets('profile name+email prefill the details step', (
      WidgetTester tester,
    ) async {
      tester.view.physicalSize = const Size(360, 800);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);
      SharedPreferences.setMockInitialValues({'first_launch': false});
      final backend = FakeApiBackend();
      final container = _container(backend);
      addTearDown(container.dispose);

      await tester.pumpWidget(
        UncontrolledProviderScope(
          container: container,
          child: MaterialApp(
            theme: AppTheme.lightTheme,
            home: const ResponsiveAppShell(
              child: BookingScreen(packageId: 42),
            ),
          ),
        ),
      );
      // Profile arrives (late or present) — details must prefill every time.
      container.read(authProvider.notifier).state = AuthState(
        isLoggedIn: true,
        user: const User(name: 'Maria Clara', email: 'maria@example.com'),
      );
      await tester.pumpAndSettle();
      container.read(bookingFlowProvider.notifier).goToStep(3);
      await tester.pumpAndSettle();

      final nameField = tester.widget<TextField>(
        find.byKey(const ValueKey('mobile_customer_name')),
      );
      final emailField = tester.widget<TextField>(
        find.byKey(const ValueKey('mobile_customer_email')),
      );
      expect(nameField.controller?.text, 'Maria Clara');
      expect(emailField.controller?.text, 'maria@example.com');
      expect(
        container.read(bookingFlowProvider).customerName,
        'Maria Clara',
      );
      expect(tester.takeException(), isNull);
    });

    testWidgets('inline edits survive later profile arrival (never clobber)', (
      WidgetTester tester,
    ) async {
      tester.view.physicalSize = const Size(360, 800);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);
      SharedPreferences.setMockInitialValues({'first_launch': false});
      final backend = FakeApiBackend();
      final container = _container(backend);
      addTearDown(container.dispose);

      await tester.pumpWidget(
        UncontrolledProviderScope(
          container: container,
          child: MaterialApp(
            theme: AppTheme.lightTheme,
            home: const ResponsiveAppShell(
              child: BookingScreen(packageId: 42),
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();
      container.read(bookingFlowProvider.notifier).goToStep(3);
      await tester.pumpAndSettle();

      await tester.enterText(
        find.byKey(const ValueKey('mobile_customer_name')),
        'Inline Edited',
      );
      await tester.pump();
      // Profile arrives after the user typed — the inline edit wins.
      container.read(authProvider.notifier).state = AuthState(
        isLoggedIn: true,
        user: const User(name: 'Maria Clara', email: 'maria@example.com'),
      );
      await tester.pumpAndSettle();

      final nameField = tester.widget<TextField>(
        find.byKey(const ValueKey('mobile_customer_name')),
      );
      expect(nameField.controller?.text, 'Inline Edited');
      expect(
        container.read(bookingFlowProvider).customerName,
        'Inline Edited',
      );
      // Profile itself is untouched (editable inline, never overwrites).
      expect(container.read(authProvider).user?.name, 'Maria Clara');
      expect(tester.takeException(), isNull);
    });

    testWidgets('reroute retains draft date + Pax, keeps prefill', (
      WidgetTester tester,
    ) async {
      tester.view.physicalSize = const Size(360, 800);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);
      SharedPreferences.setMockInitialValues({'first_launch': false});
      final backend = FakeApiBackend();
      final container = _container(backend);
      addTearDown(container.dispose);

      final draftDate = _futureDay(30);
      final otherDate = _futureDay(45);
      Widget frame({DateTime? date, int? pax}) => UncontrolledProviderScope(
        container: container,
        child: MaterialApp(
          theme: AppTheme.lightTheme,
          home: ResponsiveAppShell(
            child: BookingScreen(
              packageId: 42,
              initialDate: date,
              initialPax: pax,
            ),
          ),
        ),
      );

      await tester.pumpWidget(frame(date: draftDate, pax: 70));
      await tester.pumpAndSettle();
      container.read(bookingFlowProvider.notifier).setCustomerName('Draft Name');
      // Reroute carries a different date + Pax — the draft wins.
      await tester.pumpWidget(frame(date: otherDate, pax: 100));
      await tester.pumpAndSettle();

      final flow = container.read(bookingFlowProvider);
      expect(flow.selectedDate, draftDate);
      expect(flow.selectedPax, 70);
      expect(flow.customerName, 'Draft Name');
      expect(tester.takeException(), isNull);
    });
  });

  group('C53 Q9 resume chip on all 5 screens', () {
    Future<void> pumpWithDraft(
      WidgetTester tester,
      Widget screen, {
      bool withPackages = false,
    }) async {
      SharedPreferences.setMockInitialValues({'first_launch': false});
      final backend = FakeApiBackend();
      final draftDate = _futureDay(30);
      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            apiClientProvider.overrideWithValue(
              buildFakeRestClient(backend),
            ),
            if (withPackages)
              packagesProvider.overrideWith((ref) async => [_pkg()]),
            bookingFlowProvider.overrideWith(
              (ref) =>
                  BookingFlowNotifier(ref, ref.watch(apiClientProvider))
                    ..setSelectedPackage(_pkg())
                    ..setSelectedDate(draftDate)
                    ..setSelectedPax(70),
            ),
          ],
          child: MaterialApp(
            theme: AppTheme.lightTheme,
            home: ResponsiveAppShell(child: screen),
          ),
        ),
      );
      await tester.pumpAndSettle();
    }

    testWidgets('chip hidden on Home without draft', (
      WidgetTester tester,
    ) async {
      tester.view.physicalSize = const Size(360, 800);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);
      SharedPreferences.setMockInitialValues({'first_launch': false});
      final backend = FakeApiBackend();
      backend.bookingsOverride = [];
      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            apiClientProvider.overrideWithValue(
              buildFakeRestClient(backend),
            ),
            _authAs('Maria Clara', 'maria@example.com', backend),
          ],
          child: MaterialApp(
            theme: AppTheme.lightTheme,
            home: const ResponsiveAppShell(child: HomeScreen()),
          ),
        ),
      );
      await tester.pumpAndSettle();
      expect(find.byKey(const Key('booking_resume_chip')), findsNothing);
      expect(tester.takeException(), isNull);
    });

    testWidgets('chip shows on Home with draft', (
      WidgetTester tester,
    ) async {
      tester.view.physicalSize = const Size(360, 800);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);
      await pumpWithDraft(tester, const HomeScreen());
      expect(find.byKey(const Key('booking_resume_chip')), findsOneWidget);
      expect(tester.takeException(), isNull);
    });

    testWidgets('chip shows on Packages with draft', (
      WidgetTester tester,
    ) async {
      tester.view.physicalSize = const Size(360, 800);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);
      await pumpWithDraft(
        tester,
        const PackagesScreen(),
        withPackages: true,
      );
      expect(find.byKey(const Key('booking_resume_chip')), findsOneWidget);
      expect(tester.takeException(), isNull);
    });

    testWidgets('chip shows on Calendar with draft', (
      WidgetTester tester,
    ) async {
      tester.view.physicalSize = const Size(360, 800);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);
      await pumpWithDraft(tester, const CalendarScreen());
      // Calendar without availability override shows the error card; the
      // persistent chip still renders above it.
      expect(find.byKey(const Key('booking_resume_chip')), findsOneWidget);
      expect(tester.takeException(), isNull);
    });

    testWidgets('chip shows on Booking with a different drafted booking', (
      WidgetTester tester,
    ) async {
      tester.view.physicalSize = const Size(360, 800);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);
      // Draft belongs to package 42; viewing package 7 keeps the chip.
      await pumpWithDraft(tester, const BookingScreen(packageId: 7));
      expect(find.byKey(const Key('booking_resume_chip')), findsOneWidget);
      expect(tester.takeException(), isNull);
    });

    testWidgets('chip hides when already viewing the drafted booking', (
      WidgetTester tester,
    ) async {
      tester.view.physicalSize = const Size(360, 800);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);
      // Already on booking 42 with 42 drafted — the flow itself is the UI.
      await pumpWithDraft(tester, const BookingScreen(packageId: 42));
      expect(find.byKey(const Key('booking_resume_chip')), findsNothing);
      expect(tester.takeException(), isNull);
    });

    testWidgets('chip shows on Profile with draft', (
      WidgetTester tester,
    ) async {
      tester.view.physicalSize = const Size(360, 800);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);
      await pumpWithDraft(tester, const ProfileScreen());
      expect(find.byKey(const Key('booking_resume_chip')), findsOneWidget);
      expect(tester.takeException(), isNull);
    });

    testWidgets('chip tap resumes the single booking route', (
      WidgetTester tester,
    ) async {
      tester.view.physicalSize = const Size(360, 800);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);
      SharedPreferences.setMockInitialValues({'first_launch': false});
      final backend = FakeApiBackend();
      backend.bookingsOverride = [];
      final draftDate = _futureDay(30);
      final router = GoRouter(
        initialLocation: '/home',
        routes: [
          GoRoute(
            path: '/home',
            builder: (context, state) => const HomeScreen(),
          ),
          GoRoute(
            path: '/packages',
            builder: (context, state) => const PackagesScreen(),
          ),
          GoRoute(
            path: '/booking/:id',
            builder: (context, state) => BookingScreen(
              packageId: int.parse(state.pathParameters['id']!),
            ),
          ),
        ],
      );
      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            apiClientProvider.overrideWithValue(
              buildFakeRestClient(backend),
            ),
            _authAs('Maria Clara', 'maria@example.com', backend),
            bookingFlowProvider.overrideWith(
              (ref) =>
                  BookingFlowNotifier(ref, ref.watch(apiClientProvider))
                    ..setSelectedPackage(_pkg())
                    ..setSelectedDate(draftDate)
                    ..setSelectedPax(70),
            ),
          ],
          child: MaterialApp.router(
            theme: AppTheme.lightTheme,
            routerConfig: router,
          ),
        ),
      );
      await tester.pumpAndSettle();
      expect(find.byKey(const Key('booking_resume_chip')), findsOneWidget);

      await tester.tap(find.byKey(const Key('booking_resume_chip')));
      await tester.pumpAndSettle();
      final resumed = Uri.parse(router.location);
      expect(resumed.path, '/booking/42');
      expect(resumed.queryParameters['pax'], '70');
      expect(tester.takeException(), isNull);
    });
  });
}
