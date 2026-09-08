import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:inea_scents_client/config/theme.dart';
import 'package:inea_scents_client/providers/index.dart';
import 'package:inea_scents_client/widgets/theme_toggle_button.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  test('dark nights match the canonical landing palette', () {
    expect(AppTheme.darkTheme.scaffoldBackgroundColor, const Color(0xFF151012));
    expect(
      AppTheme.darkTheme.colorScheme.surface,
      const Color(0xFF1C1618),
    );
  });

  testWidgets('toggle flips light to dark and persists the choice', (
    tester,
  ) async {
    SharedPreferences.setMockInitialValues({});
    await tester.pumpWidget(
      const ProviderScope(
        child: MaterialApp(
          home: Scaffold(body: ConnectedThemeToggleButton()),
        ),
      ),
    );

    expect(find.byIcon(Icons.dark_mode_outlined), findsOneWidget);
    await tester.tap(find.byType(ConnectedThemeToggleButton));
    await tester.pump();

    final container = ProviderScope.containerOf(
      tester.element(find.byType(ConnectedThemeToggleButton)),
    );
    expect(container.read(themeModeProvider), ThemeMode.dark);
    expect(find.byIcon(Icons.light_mode_outlined), findsOneWidget);

    final prefs = await SharedPreferences.getInstance();
    expect(prefs.getString('inea-theme'), 'dark');
  });
}
