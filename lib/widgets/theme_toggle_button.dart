import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../config/theme.dart';
import '../providers/index.dart';

/// Landing-standard 2-state theme toggle (spec-standard, native Flutter).
///
/// Single circular Sun/Moon button, top-right of app chrome. Persists to
/// the shared `inea-theme` key. No System option: the OS preference applies
/// only on first launch (resolved once in `main`), exactly like landing.
/// Dumb landing-standard toggle: circular 2-state Sun/Moon button.
/// Provider-free so provider-less chrome (and tests) can render it.
class ThemeToggleButton extends StatelessWidget {
  final bool isDark;

  /// When true, renders cream-on-dark styling for dark chrome
  /// (e.g. the plum top nav bar). Shape, size, and icons stay identical.
  final bool inverted;
  final VoidCallback? onToggle;

  const ThemeToggleButton({
    super.key,
    required this.isDark,
    this.inverted = false,
    this.onToggle,
  });

  @override
  Widget build(BuildContext context) {
    final cream = inverted || isDark;

    return Semantics(
      button: true,
      label: isDark ? 'Switch to light theme' : 'Switch to dark theme',
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: onToggle,
        child: Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(
              color: cream
                  ? AppTheme.neutralBg.withValues(alpha: 0.2)
                  : AppTheme.primary.withValues(alpha: 0.2),
            ),
          ),
          child: Icon(
            isDark ? Icons.light_mode_outlined : Icons.dark_mode_outlined,
            size: 18,
            color: cream ? AppTheme.neutralBg : AppTheme.primary,
          ),
        ),
      ),
    );
  }
}

/// Provider-wired toggle for real screens: resolves the mode, flips it,
/// and persists to the shared `inea-theme` key.
class ConnectedThemeToggleButton extends ConsumerWidget {
  final bool inverted;

  const ConnectedThemeToggleButton({super.key, this.inverted = false});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final mode = ref.watch(themeModeProvider);
    final isDark =
        mode == ThemeMode.dark ||
        (mode == ThemeMode.system &&
            Theme.of(context).brightness == Brightness.dark);

    return ThemeToggleButton(
      isDark: isDark,
      inverted: inverted,
      onToggle: () => toggleTheme(ref, !isDark),
    );
  }
}

/// Flips the theme and persists the choice. Exported for tests.
Future<void> toggleTheme(WidgetRef ref, bool toDark) async {
  final next = toDark ? ThemeMode.dark : ThemeMode.light;
  ref.read(themeModeProvider.notifier).state = next;
  try {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(ineaThemeKey, toDark ? 'dark' : 'light');
  } catch (_) {
    // Private/restricted storage: theme simply won't persist.
  }
}
