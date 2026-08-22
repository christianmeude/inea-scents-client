import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:inea_scents_client/src/app.dart';

void main() {
  testWidgets('App loads without error', (WidgetTester tester) async {
    await tester.pumpWidget(const ProviderScope(child: App()));

    expect(find.byType(App), findsOneWidget);
  });
}
