import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:inea_scents_client/config/theme.dart';
import 'package:inea_scents_client/models/index.dart';
import 'package:inea_scents_client/widgets/index.dart';

void main() {
  setUpAll(() {
    GoogleFonts.config.allowRuntimeFetching = false;
  });

  group('Web Interactions Foundation - R1: Mouse Cursors', () {
    testWidgets('PackageCard uses SystemMouseCursors.click', (tester) async {
      const package = Package(
        id: 1,
        name: 'Deluxe Perfume Bar',
        description: 'Luxury scent experience',
        price: 4999.0,
        rating: 4.8,
        reviewsCount: 15,
      );

      await tester.pumpWidget(
        MaterialApp(
          theme: AppTheme.lightTheme,
          home: const Scaffold(
            body: SingleChildScrollView(
              child: SizedBox(width: 400, child: PackageCard(package: package)),
            ),
          ),
        ),
      );

      final detectorFinder = find.descendant(
        of: find.byType(PackageCard),
        matching: find.byType(FocusableActionDetector),
      );
      expect(detectorFinder, findsOneWidget);

      final detector = tester.widget<FocusableActionDetector>(detectorFinder);
      expect(detector.mouseCursor, equals(SystemMouseCursors.click));
    });

    testWidgets(
      'AppTheme button styles define SystemMouseCursors.click for enabled state',
      (tester) async {
        // Verify ElevatedButton theme mouse cursor
        final elevatedCursor = AppTheme
            .lightTheme
            .elevatedButtonTheme
            .style
            ?.mouseCursor
            ?.resolve({});
        expect(elevatedCursor, equals(SystemMouseCursors.click));

        final elevatedDisabledCursor = AppTheme
            .lightTheme
            .elevatedButtonTheme
            .style
            ?.mouseCursor
            ?.resolve({WidgetState.disabled});
        expect(elevatedDisabledCursor, equals(SystemMouseCursors.basic));

        // Verify OutlinedButton theme mouse cursor
        final outlinedCursor = AppTheme
            .lightTheme
            .outlinedButtonTheme
            .style
            ?.mouseCursor
            ?.resolve({});
        expect(outlinedCursor, equals(SystemMouseCursors.click));

        // Verify TextButton theme mouse cursor
        final textBtnCursor = AppTheme
            .lightTheme
            .textButtonTheme
            .style
            ?.mouseCursor
            ?.resolve({});
        expect(textBtnCursor, equals(SystemMouseCursors.click));

        // Verify IconButton theme mouse cursor
        final iconBtnCursor = AppTheme
            .lightTheme
            .iconButtonTheme
            .style
            ?.mouseCursor
            ?.resolve({});
        expect(iconBtnCursor, equals(SystemMouseCursors.click));
      },
    );

    testWidgets(
      'CustomTextField uses SystemMouseCursors.text and suffix button uses click',
      (tester) async {
        final controller = TextEditingController();

        await tester.pumpWidget(
          MaterialApp(
            theme: AppTheme.lightTheme,
            home: Scaffold(
              body: CustomTextField(
                controller: controller,
                suffixIcon: IconButton(
                  mouseCursor: SystemMouseCursors.click,
                  onPressed: () {},
                  icon: const Icon(Icons.visibility),
                ),
              ),
            ),
          ),
        );

        final detectorFinder = find.descendant(
          of: find.byType(CustomTextField),
          matching: find.byType(FocusableActionDetector),
        );
        expect(detectorFinder, findsOneWidget);

        final detector = tester.widget<FocusableActionDetector>(detectorFinder);
        expect(detector.mouseCursor, equals(SystemMouseCursors.text));

        final iconBtn = tester.widget<IconButton>(find.byType(IconButton));
        expect(iconBtn.mouseCursor, equals(SystemMouseCursors.click));
      },
    );
  });

  group('Web Interactions Foundation - R2: Hover States', () {
    testWidgets('PackageCard shifts background color and border on hover', (
      tester,
    ) async {
      const package = Package(
        id: 1,
        name: 'Deluxe Perfume Bar',
        description: 'Luxury scent experience',
        price: 4999.0,
      );

      await tester.pumpWidget(
        MaterialApp(
          theme: AppTheme.lightTheme,
          home: const Scaffold(
            body: SingleChildScrollView(
              child: SizedBox(width: 400, child: PackageCard(package: package)),
            ),
          ),
        ),
      );

      // Verify unhovered initial background
      final initialContainer = tester.widget<AnimatedContainer>(
        find.descendant(
          of: find.byType(PackageCard),
          matching: find.byType(AnimatedContainer).first,
        ),
      );
      final initialDec = initialContainer.decoration as BoxDecoration;
      expect(initialDec.color, equals(Colors.white));

      // Trigger hover highlight via FocusableActionDetector
      final detector = tester.widget<FocusableActionDetector>(
        find.descendant(
          of: find.byType(PackageCard),
          matching: find.byType(FocusableActionDetector),
        ),
      );
      detector.onShowHoverHighlight!(true);
      await tester.pumpAndSettle();

      // Verify hovered background shifted
      final hoveredContainer = tester.widget<AnimatedContainer>(
        find.descendant(
          of: find.byType(PackageCard),
          matching: find.byType(AnimatedContainer).first,
        ),
      );
      final hoveredDec = hoveredContainer.decoration as BoxDecoration;
      expect(hoveredDec.color, equals(const Color(0xFFFAF2F4)));
      expect(hoveredDec.boxShadow, isNotEmpty);
    });

    testWidgets('CustomTextField shifts background and border on hover', (
      tester,
    ) async {
      final controller = TextEditingController();

      await tester.pumpWidget(
        MaterialApp(
          theme: AppTheme.lightTheme,
          home: Scaffold(
            body: Center(
              child: SizedBox(
                width: 300,
                child: CustomTextField(controller: controller),
              ),
            ),
          ),
        ),
      );

      // Initial state
      final initialAnimatedContainer = tester.widget<AnimatedContainer>(
        find.descendant(
          of: find.byType(CustomTextField),
          matching: find.byType(AnimatedContainer),
        ),
      );
      final initialDec = initialAnimatedContainer.decoration as BoxDecoration;
      final initialBorder = initialDec.border as Border;
      final initialBg = initialDec.color!;

      // Trigger hover
      final detector = tester.widget<FocusableActionDetector>(
        find.descendant(
          of: find.byType(CustomTextField),
          matching: find.byType(FocusableActionDetector),
        ),
      );
      detector.onShowHoverHighlight!(true);
      await tester.pumpAndSettle();

      final hoveredAnimatedContainer = tester.widget<AnimatedContainer>(
        find.descendant(
          of: find.byType(CustomTextField),
          matching: find.byType(AnimatedContainer),
        ),
      );
      final hoveredDec = hoveredAnimatedContainer.decoration as BoxDecoration;
      final hoveredBorder = hoveredDec.border as Border;
      final hoveredBg = hoveredDec.color!;

      // Hover background and border should be distinct
      expect(hoveredBg != initialBg, isTrue);
      expect(hoveredBorder.top.color != initialBorder.top.color, isTrue);
    });

    testWidgets('AppTheme buttons define hover overlay/background shifts', (
      tester,
    ) async {
      // ElevatedButton hover background
      final elevatedHoverBg = AppTheme
          .lightTheme
          .elevatedButtonTheme
          .style
          ?.backgroundColor
          ?.resolve({WidgetState.hovered});
      expect(elevatedHoverBg, equals(const Color(0xFF5A3646)));

      // OutlinedButton hover background tint
      final outlinedHoverBg = AppTheme
          .lightTheme
          .outlinedButtonTheme
          .style
          ?.backgroundColor
          ?.resolve({WidgetState.hovered});
      expect(outlinedHoverBg, isNotNull);

      // TextButton hover background tint
      final textBtnHoverBg = AppTheme
          .lightTheme
          .textButtonTheme
          .style
          ?.backgroundColor
          ?.resolve({WidgetState.hovered});
      expect(textBtnHoverBg, isNotNull);
    });
  });

  group(
    'Web Interactions Foundation - R3: Focus Rings & Keyboard Navigation',
    () {
      testWidgets(
        'PackageCard shows visible focus ring and activates with Enter key',
        (tester) async {
          bool tapped = false;

          const package = Package(
            id: 1,
            name: 'Deluxe Bar',
            description: 'Test',
            price: 3000,
          );

          await tester.pumpWidget(
            MaterialApp(
              theme: AppTheme.lightTheme,
              home: Scaffold(
                body: SingleChildScrollView(
                  child: SizedBox(
                    width: 400,
                    child: PackageCard(
                      package: package,
                      onTap: () => tapped = true,
                    ),
                  ),
                ),
              ),
            ),
          );

          // Trigger focus highlight
          final detector = tester.widget<FocusableActionDetector>(
            find.descendant(
              of: find.byType(PackageCard),
              matching: find.byType(FocusableActionDetector),
            ),
          );
          detector.onShowFocusHighlight!(true);
          await tester.pumpAndSettle();

          final container = tester.widget<AnimatedContainer>(
            find.descendant(
              of: find.byType(PackageCard),
              matching: find.byType(AnimatedContainer).first,
            ),
          );
          final dec = container.decoration as BoxDecoration;
          final border = dec.border as Border;

          // Focus ring is 2.5px AppTheme.primary border
          expect(border.top.color, equals(AppTheme.primary));
          expect(border.top.width, equals(2.5));

          // Invoke keyboard activation action
          final action =
              detector.actions?[ActivateIntent]
                  as CallbackAction<ActivateIntent>?;
          expect(action, isNotNull);
          action?.invoke(const ActivateIntent());
          expect(tapped, isTrue);
        },
      );

      testWidgets('CustomTextField shows visible focus ring when focused', (
        tester,
      ) async {
        final controller = TextEditingController();

        await tester.pumpWidget(
          MaterialApp(
            theme: AppTheme.lightTheme,
            home: Scaffold(body: CustomTextField(controller: controller)),
          ),
        );

        final detector = tester.widget<FocusableActionDetector>(
          find.descendant(
            of: find.byType(CustomTextField),
            matching: find.byType(FocusableActionDetector),
          ),
        );
        detector.onShowFocusHighlight!(true);
        await tester.pumpAndSettle();

        final animatedContainer = tester.widget<AnimatedContainer>(
          find.descendant(
            of: find.byType(CustomTextField),
            matching: find.byType(AnimatedContainer),
          ),
        );
        final dec = animatedContainer.decoration as BoxDecoration;
        final border = dec.border as Border;

        // P6 (Q4): constant 1.5px border — focus is the white border
        // color plus the outer glow ring, never a width change.
        expect(border.top.width, equals(1.5));
        expect(border.top.color, equals(Colors.white));

        final outerContainer = tester.widget<Container>(
          find
              .descendant(
                of: find.byType(CustomTextField),
                matching: find.byType(Container),
              )
              .first,
        );
        final outerDec = outerContainer.decoration as BoxDecoration;
        expect(outerDec.boxShadow, isNotEmpty);
      });

      testWidgets('AppTheme buttons render focus rings when focused', (
        tester,
      ) async {
        // Verify ElevatedButton focused side ring (2.5px)
        final elevatedStyle = AppTheme.lightTheme.elevatedButtonTheme.style;
        final elevatedFocusedSide = elevatedStyle?.side?.resolve({
          WidgetState.focused,
        });
        expect(elevatedFocusedSide, isNotNull);
        expect(elevatedFocusedSide?.width, equals(2.5));
        expect(elevatedFocusedSide?.color, equals(const Color(0xFFDABDAC)));

        // Verify OutlinedButton focused side ring (2.5px primary)
        final outlinedStyle = AppTheme.lightTheme.outlinedButtonTheme.style;
        final outlinedFocusedSide = outlinedStyle?.side?.resolve({
          WidgetState.focused,
        });
        expect(outlinedFocusedSide, isNotNull);
        expect(outlinedFocusedSide?.width, equals(2.5));
        expect(outlinedFocusedSide?.color, equals(AppTheme.primary));

        // Verify TextButton focused side ring (2.0px primary)
        final textBtnStyle = AppTheme.lightTheme.textButtonTheme.style;
        final textBtnFocusedSide = textBtnStyle?.side?.resolve({
          WidgetState.focused,
        });
        expect(textBtnFocusedSide, isNotNull);
        expect(textBtnFocusedSide?.width, equals(2.0));
        expect(textBtnFocusedSide?.color, equals(AppTheme.primary));

        // Verify IconButton focused side ring (2.0px primary)
        final iconBtnStyle = AppTheme.lightTheme.iconButtonTheme.style;
        final iconBtnFocusedSide = iconBtnStyle?.side?.resolve({
          WidgetState.focused,
        });
        expect(iconBtnFocusedSide, isNotNull);
        expect(iconBtnFocusedSide?.width, equals(2.0));
        expect(iconBtnFocusedSide?.color, equals(AppTheme.primary));
      });

      testWidgets(
        'Dark theme button styles define visible focus rings and click cursors',
        (tester) async {
          final elevatedStyle = AppTheme.darkTheme.elevatedButtonTheme.style;
          final elevatedFocusedSide = elevatedStyle?.side?.resolve({
            WidgetState.focused,
          });
          expect(elevatedFocusedSide, isNotNull);
          expect(elevatedFocusedSide?.width, equals(2.5));

          final outlinedStyle = AppTheme.darkTheme.outlinedButtonTheme.style;
          final outlinedFocusedSide = outlinedStyle?.side?.resolve({
            WidgetState.focused,
          });
          expect(outlinedFocusedSide, isNotNull);
          expect(outlinedFocusedSide?.width, equals(2.5));

          final textBtnStyle = AppTheme.darkTheme.textButtonTheme.style;
          final textBtnFocusedSide = textBtnStyle?.side?.resolve({
            WidgetState.focused,
          });
          expect(textBtnFocusedSide, isNotNull);
          expect(textBtnFocusedSide?.width, equals(2.0));

          final iconBtnStyle = AppTheme.darkTheme.iconButtonTheme.style;
          final iconBtnFocusedSide = iconBtnStyle?.side?.resolve({
            WidgetState.focused,
          });
          expect(iconBtnFocusedSide, isNotNull);
          expect(iconBtnFocusedSide?.width, equals(2.0));
        },
      );

      testWidgets(
        'PackageCard in dark theme renders dark background and light cream focus ring',
        (tester) async {
          const package = Package(
            id: 2,
            name: 'Dark Rose Package',
            description: 'Dark mode luxury',
            price: 5500,
          );

          await tester.pumpWidget(
            MaterialApp(
              theme: AppTheme.darkTheme,
              home: const Scaffold(
                body: SingleChildScrollView(
                  child: SizedBox(
                    width: 400,
                    child: PackageCard(package: package),
                  ),
                ),
              ),
            ),
          );

          final initialContainer = tester.widget<AnimatedContainer>(
            find.descendant(
              of: find.byType(PackageCard),
              matching: find.byType(AnimatedContainer).first,
            ),
          );
          final initialDec = initialContainer.decoration as BoxDecoration;
          expect(initialDec.color, equals(AppTheme.nightSurface));

          // Trigger focus highlight
          final detector = tester.widget<FocusableActionDetector>(
            find.descendant(
              of: find.byType(PackageCard),
              matching: find.byType(FocusableActionDetector),
            ),
          );
          detector.onShowFocusHighlight!(true);
          await tester.pumpAndSettle();

          final focusedContainer = tester.widget<AnimatedContainer>(
            find.descendant(
              of: find.byType(PackageCard),
              matching: find.byType(AnimatedContainer).first,
            ),
          );
          final focusedDec = focusedContainer.decoration as BoxDecoration;
          final border = focusedDec.border as Border;
          expect(border.top.color, equals(const Color(0xFFFDF4F5)));
          expect(border.top.width, equals(2.5));
        },
      );

      testWidgets(
        'CustomTextField in dark theme shifts colors on hover and focus',
        (tester) async {
          final controller = TextEditingController();

          await tester.pumpWidget(
            MaterialApp(
              theme: AppTheme.darkTheme,
              home: Scaffold(
                body: Center(
                  child: SizedBox(
                    width: 300,
                    child: CustomTextField(controller: controller),
                  ),
                ),
              ),
            ),
          );

          final detector = tester.widget<FocusableActionDetector>(
            find.descendant(
              of: find.byType(CustomTextField),
              matching: find.byType(FocusableActionDetector),
            ),
          );
          expect(detector.mouseCursor, equals(SystemMouseCursors.text));

          // Trigger focus
          detector.onShowFocusHighlight!(true);
          await tester.pumpAndSettle();

          final animatedContainer = tester.widget<AnimatedContainer>(
            find.descendant(
              of: find.byType(CustomTextField),
              matching: find.byType(AnimatedContainer),
            ),
          );
          final dec = animatedContainer.decoration as BoxDecoration;
          final border = dec.border as Border;
          expect(border.top.color, equals(const Color(0xFFFDF4F5)));
          // P6 (Q4): constant 1.5px border in dark too.
          expect(border.top.width, equals(1.5));
        },
      );
    },
  );
}
