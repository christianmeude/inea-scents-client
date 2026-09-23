import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:inea_scents_client/config/theme.dart';
import 'package:inea_scents_client/widgets/index.dart';

/// C52: inline errors per kind — field-level lines, in-card summaries,
/// transient-gated toast Retry, and no nav banner anywhere. All
/// wrapping surfaces are verified at 360px with long copy.
void main() {
  setUpAll(() {
    GoogleFonts.config.allowRuntimeFetching = false;
  });

  Widget wrap(Widget child, {Size size = const Size(360, 800)}) {
    return MediaQuery(
      data: MediaQueryData(size: size),
      child: MaterialApp(
        theme: AppTheme.lightTheme,
        home: Scaffold(body: SingleChildScrollView(child: child)),
      ),
    );
  }

  group('isTransientErrorMessage', () {
    test('flags connectivity/timeout/server copy', () {
      expect(isTransientErrorMessage('Could not connect to server'), isTrue);
      expect(isTransientErrorMessage('Request timed out, try again'), isTrue);
      expect(isTransientErrorMessage('Network error. Try again.'), isTrue);
      expect(
        isTransientErrorMessage('Server error. Nothing was charged.'),
        isTrue,
      );
      expect(
        isTransientErrorMessage(
          "We couldn't send the reset link. Check your connection and try again.",
        ),
        isTrue,
      );
    });

    test('passes validation copy through as non-transient', () {
      expect(isTransientErrorMessage('Please select date and time'), isFalse);
      expect(
        isTransientErrorMessage('Please fill name, email and venue'),
        isFalse,
      );
      expect(
        isTransientErrorMessage(
          'The selected date has passed. Please choose a new date.',
        ),
        isFalse,
      );
      expect(
        isTransientErrorMessage('Passwords do not match.'),
        isFalse,
      );
      expect(
        isTransientErrorMessage(
          "That didn't work. Check your details and try again.",
        ),
        isFalse,
      );
    });
  });

  group('InlineFieldError', () {
    testWidgets('null message renders nothing', (tester) async {
      await tester.pumpWidget(wrap(const InlineFieldError(message: null)));
      await tester.pumpAndSettle();

      expect(find.byType(InlineFieldError), findsOneWidget);
      expect(find.byIcon(Icons.error_outline_rounded), findsNothing);
      expect(tester.takeException(), isNull);
    });

    testWidgets('field error wraps at 360px without overflow', (tester) async {
      tester.view.physicalSize = const Size(360, 800);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);

      await tester.pumpWidget(
        wrap(
          const InlineFieldError(
            message:
                'New password must differ from the current password. '
                'Choose something you have not used here before. ',
          ),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.textContaining('must differ'), findsOneWidget);
      expect(tester.takeException(), isNull);
    });
  });

  group('FormErrorSummary', () {
    testWidgets('validation summary renders with no Retry', (tester) async {
      await tester.pumpWidget(
        wrap(FormErrorSummary(message: 'Please select date and time')),
      );
      await tester.pumpAndSettle();

      expect(find.byKey(const Key('form_error_summary')), findsOneWidget);
      expect(find.text('Please select date and time'), findsOneWidget);
      expect(find.byKey(const Key('form_error_retry')), findsNothing);
      expect(tester.takeException(), isNull);
    });

    testWidgets('transient summary carries Retry that fires', (tester) async {
      var retried = 0;
      await tester.pumpWidget(
        wrap(
          FormErrorSummary(
            message: 'Could not connect. Check your connection.',
            onRetry: () => retried++,
          ),
        ),
      );
      await tester.pumpAndSettle();

      await tester.tap(find.byKey(const Key('form_error_retry')));
      await tester.pumpAndSettle();

      expect(retried, 1);
      expect(tester.takeException(), isNull);
    });

    testWidgets('multi-message summary wraps at 360px', (tester) async {
      tester.view.physicalSize = const Size(360, 800);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);

      await tester.pumpWidget(
        wrap(
          FormErrorSummary(
            messages: const [
              'The selected date has passed. Please choose a new date. ',
              'Please fill name, email and venue before continuing. ',
            ],
            onRetry: () {},
          ),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.byKey(const Key('form_error_summary')), findsOneWidget);
      expect(find.byKey(const Key('form_error_retry')), findsOneWidget);
      expect(tester.takeException(), isNull);
    });
  });

  group('no nav banner', () {
    testWidgets('inline surfaces never build a MaterialBanner', (
      tester,
    ) async {
      await tester.pumpWidget(
        wrap(
          Column(
            children: [
              const InlineFieldError(message: 'Passwords do not match.'),
              FormErrorSummary(
                message: 'Could not connect. Check your connection.',
                onRetry: () {},
              ),
            ],
          ),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.byType(MaterialBanner), findsNothing);
      expect(tester.takeException(), isNull);
    });
  });
}
