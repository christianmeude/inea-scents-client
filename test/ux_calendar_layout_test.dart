import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:inea_scents_client/screens/calendar_screen.dart';
import 'package:inea_scents_client/src/providers/core_providers.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'helpers/fake_api.dart';

void main() {
  testWidgets('CalendarScreen splits its layout properly when the viewport is forced to 1200x800',
      (WidgetTester tester) async {
    SharedPreferences.setMockInitialValues({'first_launch': false});
    tester.view.physicalSize = const Size(1200, 800);
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
        child: const MaterialApp(
          home: CalendarScreen(),
        ),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.byType(Row), findsWidgets);
    expect(find.text('Availability'), findsOneWidget);
  });
}
