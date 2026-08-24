import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'config/router.dart';
import 'config/theme.dart';
import 'providers/index.dart';

void main() {
  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends ConsumerWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final router = ref.watch(routerProvider);
    final themeMode = ref.watch(themeModeProvider);

    return MaterialApp.router(
      title: 'INEA Scents',
      themeMode: themeMode,
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.lightTheme, // Force light theme as there's no dark theme specified in DESIGN.md, or we can use the default with tweaked colors if we wanted. But DESIGN.md says 'The no-black rule', so forcing light theme or letting it be is fine.
      routerConfig: router,
    );
  }
}
