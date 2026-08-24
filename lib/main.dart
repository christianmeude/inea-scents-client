import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'config/router.dart';
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
      theme: ThemeData(
        primarySwatch: Colors.purple,
        brightness: Brightness.light,
        useMaterial3: true,
        textTheme: GoogleFonts.figtreeTextTheme(),
      ),
      darkTheme: ThemeData(
        primarySwatch: Colors.purple,
        brightness: Brightness.dark,
        useMaterial3: true,
        textTheme: GoogleFonts.figtreeTextTheme(ThemeData.dark().textTheme),
      ),
      routerConfig: router,
    );
  }
}
