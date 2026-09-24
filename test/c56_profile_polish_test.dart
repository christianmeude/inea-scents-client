import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:inea_scents_client/config/theme.dart';
import 'package:inea_scents_client/screens/profile_screen.dart';
import 'package:inea_scents_client/src/providers/core_providers.dart';
import 'package:inea_scents_client/widgets/index.dart';

import 'helpers/fake_api.dart';

/// C56: profile polish — 1200 shell cap, enlarged footer logo, toggle renders.
void main() {
  setUpAll(() {
    GoogleFonts.config.allowRuntimeFetching = false;
  });

  Future<void> pumpProfile(WidgetTester tester, Size size) async {
    tester.view.physicalSize = size;
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
  }

  testWidgets('desktop profile renders single column', (tester) async {
    await pumpProfile(tester, const Size(1280, 800));
    final rows = tester.widgetList<Row>(find.byType(Row));
    final twoExpanded = rows.where(
      (r) => r.children.whereType<Expanded>().length == 2,
    );
    expect(twoExpanded, isEmpty);
    expect(find.text('My Profile'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });

  testWidgets('footer logo enlarged + toggle renders', (tester) async {
    await pumpProfile(tester, const Size(360, 800));
    final sized = tester.widget<SizedBox>(
      find.ancestor(of: find.byType(AppLogo), matching: find.byType(SizedBox)).first,
    );
    expect(sized.width, 180);
    expect(find.text('Dark theme'), findsOneWidget);
    expect(find.byType(Switch), findsOneWidget);
    expect(tester.takeException(), isNull);
  });
}
