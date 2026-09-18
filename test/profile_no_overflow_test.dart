import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:inea_scents_client/config/theme.dart';
import 'package:inea_scents_client/screens/profile_screen.dart';
import 'package:inea_scents_client/src/providers/core_providers.dart';
import 'package:inea_scents_client/widgets/index.dart';

import 'helpers/fake_api.dart';

/// C9: ProfileScreen fits 360x800 with no scroll/overflow; muted logo stays
/// optically centered in the card-edge-to-screen-bottom zone.
void main() {
  setUpAll(() {
    GoogleFonts.config.allowRuntimeFetching = false;
  });

  testWidgets('ProfileScreen fits 360x800 with no scroll or overflow', (
    WidgetTester tester,
  ) async {
    tester.view.physicalSize = const Size(360, 800);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          apiClientProvider.overrideWithValue(
            buildFakeRestClient(FakeApiBackend()),
          ),
        ],
        child: MaterialApp(
          theme: AppTheme.lightTheme,
          home: const ProfileScreen(),
        ),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.byType(ProfileScreen), findsOneWidget);
    expect(find.text('My Profile'), findsOneWidget);
    // No scrollable may remain on the profile page.
    expect(find.byType(SingleChildScrollView), findsNothing);
    expect(find.byType(Scrollable), findsNothing);
    // Muted footer mark still renders, centered in the bottom zone.
    expect(find.byType(AppLogo), findsOneWidget);
    expect(
      find.ancestor(
        of: find.byType(AppLogo),
        matching: find.byType(Expanded),
      ),
      findsOneWidget,
    );
    // No overflow / layout exception was reported.
    expect(tester.takeException(), isNull);
  });
}
