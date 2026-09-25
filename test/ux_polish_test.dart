import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:inea_scents_client/config/theme.dart';
import 'package:inea_scents_client/models/index.dart';
import 'package:inea_scents_client/widgets/index.dart';

/// P6 Visual polish proofs: responsive grids (G2), fixed ambient (G3/G4/G5),
/// monogram fallback (G6-A), read-only Pax row, shared error card (Q6/Q8).
Package _cardPackage() => const Package(
  id: 7,
  name: 'Unified Celebration Bar',
  price: 4499,
  paxOptions: [50, 70, 100, 150],
  paxPrices: {50: 4499.0, 70: 6399.0, 100: 8799.0, 150: 13119.0},
);

void main() {
  group('ux_polish grids 2-3-4', () {
    test('column counts follow mobile/tablet/desktop bands', () {
      expect(ResponsiveAppShell.getGridColumnCount(320), equals(2));
      expect(ResponsiveAppShell.getGridColumnCount(767.9), equals(2));
      expect(ResponsiveAppShell.getGridColumnCount(768), equals(3));
      expect(ResponsiveAppShell.getGridColumnCount(1024), equals(3));
      expect(ResponsiveAppShell.getGridColumnCount(1024.01), equals(4));
      expect(ResponsiveAppShell.getGridColumnCount(1920), equals(4));
    });

    test('gridDelegateForWidth carries column counts', () {
      SliverGridDelegateWithFixedCrossAxisCount delegateFor(double w) =>
          ResponsiveAppShell.gridDelegateForWidth(w)
              as SliverGridDelegateWithFixedCrossAxisCount;
      expect(delegateFor(400).crossAxisCount, equals(2));
      expect(delegateFor(900).crossAxisCount, equals(3));
      expect(delegateFor(1300).crossAxisCount, equals(4));
    });
  });

  group('ux_polish flat background (P7)', () {
    testWidgets('shell renders content on the flat theme background', (
      WidgetTester tester,
    ) async {
      tester.view.physicalSize = const Size(1280, 800);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);

      await tester.pumpWidget(
        MaterialApp(
          theme: AppTheme.lightTheme,
          home: const ResponsiveAppShell(child: Text('content')),
        ),
      );
      await tester.pumpAndSettle();

      // No decorative gradient layers remain behind the content.
      expect(
        find.descendant(
          of: find.byType(ResponsiveAppShell),
          matching: find.byWidgetPredicate(
            (w) =>
                w is Container &&
                w.decoration is BoxDecoration &&
                (w.decoration as BoxDecoration).gradient != null,
          ),
        ),
        findsNothing,
      );
      expect(find.text('content'), findsOneWidget);
    });
  });

  group('ux_polish monogram fallback', () {
    testWidgets('imageless card renders a monogram tile, never a void', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(
        MaterialApp(
          theme: AppTheme.lightTheme,
          home: Scaffold(
            body: SizedBox(
              width: 300,
              height: 620,
              child: SingleChildScrollView(
                child: PackageCard(package: _cardPackage()),
              ),
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();

      // Initial of "Unified Celebration Bar".
      expect(find.text('U'), findsOneWidget);
      expect(find.byType(Image), findsNothing);
    });

    testWidgets('monogram tile renders in dark theme without crashing', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(
        MaterialApp(
          theme: AppTheme.darkTheme,
          home: Scaffold(
            body: SizedBox(
              width: 300,
              height: 620,
              child: SingleChildScrollView(
                child: PackageCard(package: _cardPackage()),
              ),
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();
      expect(find.text('U'), findsOneWidget);
      expect(tester.takeException(), isNull);
    });
  });

  group('ux_polish read-only pax', () {
    testWidgets('details panel is time-only: no pax row, no selector', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(
        MaterialApp(
          theme: AppTheme.lightTheme,
          home: Scaffold(
            body: SingleChildScrollView(
              child: ReservationDetailsPanel(
                package: _cardPackage(),
                selectedPax: 70,
                onChangePax: () {},
                selectedTime: '14:00:00',
                onTimeSelected: (_) {},
              ),
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();

      // C92: Pax UI retired from the panel (rail owns the headcount) —
      // package summary + time picker remain, no selector anywhere.
      expect(find.text('Unified Celebration Bar'), findsOneWidget);
      expect(find.byKey(const Key('pax_readonly_row')), findsNothing);
      expect(find.text('70 PAX · ₱6,399.00'), findsNothing);
      expect(find.byKey(const Key('pax_change_link')), findsNothing);
      expect(find.text('2. Choose Available Pax'), findsNothing);
      expect(find.text('70 Guests'), findsNothing);
      expect(find.text('Choose Event Time'), findsOneWidget);
      expect(find.text('2:00 PM'), findsOneWidget);
      expect(find.byKey(const Key('event_time_picker_button')), findsOneWidget);
      expect(tester.takeException(), isNull);
    });

    testWidgets('missing pax falls back quietly without crashing', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(
        MaterialApp(
          theme: AppTheme.lightTheme,
          home: Scaffold(
            body: SingleChildScrollView(
              child: ReservationDetailsPanel(
                package: _cardPackage(),
                selectedPax: null,
                onChangePax: null,
                selectedTime: null,
                onTimeSelected: (_) {},
              ),
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();

      // C92: no Pax text at all; the time picker idles on its prompt.
      expect(find.text('50 PAX · ₱4,499.00'), findsNothing);
      expect(find.byKey(const Key('pax_change_link')), findsNothing);
      expect(find.text('Select time'), findsOneWidget);
      expect(tester.takeException(), isNull);
    });
  });

  group('ux_polish shared error card', () {
    testWidgets('friendly copy renders, raw error hidden, retry fires', (
      WidgetTester tester,
    ) async {
      var retried = false;
      await tester.pumpWidget(
        MaterialApp(
          theme: AppTheme.lightTheme,
          home: Scaffold(
            body: SingleChildScrollView(
              child: ErrorStateCard(
                title: 'Unable to load packages',
                message:
                    "We couldn't load the packages. "
                    'Check your connection and try again.',
                onRetry: () => retried = true,
              ),
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text('Unable to load packages'), findsOneWidget);
      expect(find.text('Try Again'), findsOneWidget);
      expect(find.textContaining('SocketException'), findsNothing);

      await tester.tap(find.text('Try Again'));
      await tester.pumpAndSettle();
      expect(retried, isTrue);
    });

    testWidgets('error card renders in dark theme without crashing', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(
        MaterialApp(
          theme: AppTheme.darkTheme,
          home: Scaffold(
            body: SingleChildScrollView(
              child: ErrorStateCard(
                title: 'Unable to load bookings',
                message:
                    "We couldn't load your bookings. "
                    'Check your connection and try again.',
                onRetry: () {},
              ),
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();
      expect(find.text('Unable to load bookings'), findsOneWidget);
      expect(tester.takeException(), isNull);
    });
  });

  group('ux_polish skeleton dark', () {
    testWidgets('loading skeleton renders in dark theme without flashing', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(
        MaterialApp(
          theme: AppTheme.darkTheme,
          home: const Scaffold(
            body: SizedBox(
              width: 200,
              height: 400,
              child: SkeletonPackageCard(),
            ),
          ),
        ),
      );
      await tester.pump();
      expect(find.byType(SkeletonPackageCard), findsOneWidget);
      expect(tester.takeException(), isNull);
    });
  });

  group('ux_polish P7 surfaces', () {
    testWidgets('CardSurfaces resolves light and dark fills', (
      WidgetTester tester,
    ) async {
      Color? light;
      await tester.pumpWidget(
        MaterialApp(
          theme: AppTheme.lightTheme,
          home: Builder(
            builder: (context) {
              light = CardSurfaces.cardBg(context);
              return const SizedBox();
            },
          ),
        ),
      );
      expect(light, equals(Colors.white));

      Color? dark;
      await tester.pumpWidget(
        MaterialApp(
          home: Theme(
            data: AppTheme.darkTheme,
            child: Builder(
              builder: (context) {
                dark = CardSurfaces.cardBg(context);
                return const SizedBox();
              },
            ),
          ),
        ),
      );
      expect(dark, equals(const Color(0xFF1C1618)));
    });

    testWidgets('details panel renders dark surfaces without crashing', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(
        MaterialApp(
          theme: AppTheme.darkTheme,
          home: Scaffold(
            body: SingleChildScrollView(
              child: ReservationDetailsPanel(
                package: _cardPackage(),
                selectedPax: 70,
                onChangePax: () {},
                selectedTime: '14:00:00',
                onTimeSelected: (_) {},
              ),
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();

      final panel = tester.widget<ReservationDetailsPanel>(
        find.byType(ReservationDetailsPanel),
      );
      expect(panel.selectedPax, equals(70));
      // C92: Pax UI retired from the panel — time picker carries the step.
      expect(find.byKey(const Key('pax_readonly_row')), findsNothing);
      expect(find.text('2:00 PM'), findsOneWidget);
      expect(tester.takeException(), isNull);
    });

    testWidgets('order summary renders dark surfaces without crashing', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(
        MaterialApp(
          theme: AppTheme.darkTheme,
          home: Scaffold(
            body: SingleChildScrollView(
              child: OrderSummaryPanel(
                package: _cardPackage(),
                selectedDate: DateTime(2030, 5, 4),
                selectedTime: '14:00:00',
                selectedPax: 70,
                paymentMethod: 'cash',
                isLoading: false,
                onProceed: () {},
              ),
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text('Your Booking'), findsOneWidget);
      expect(tester.takeException(), isNull);
    });
  });
}
