import 'package:flutter/material.dart';

import '../config/theme.dart';

/// Shared Elegant Concierge surfaces (P7): every card, chip, and title in
/// the app resolves through here so the dark toggle never leaves a
/// light-hardcoded surface behind. Light values preserve the established
/// look exactly; dark values follow the canonical nights
/// (`night #151012`, `surface #1C1618`, `border #36222C`).
class CardSurfaces {
  // C31: plum/cream resolve through AppTheme (single source).
  static const Color _plum = AppTheme.primaryButtonBackground;
  static const Color _mutedPlum = Color(0xFF99868C);
  static const Color _titleLight = Color(0xFF633E50);
  static const Color _bodyLight = Color(0xFF765867);
  static const Color _cream = AppTheme.onPrimaryButton;

  static const Color night = Color(0xFF151012);
  static const Color nightSurface = Color(0xFF1C1618);
  static const Color nightBorder = Color(0xFF36222C);
  static const Color nightText = Color(0xFFFDF4F5);
  static const Color nightBody = Color(0xFFC4ACAC);

  static bool isDark(BuildContext context) =>
      Theme.of(context).brightness == Brightness.dark;

  /// Solid card fill: surface white, or night surface.
  static Color cardBg(BuildContext context) =>
      isDark(context) ? nightSurface : Colors.white;

  /// Card outline: plum at 30%, or night border.
  static Color cardBorder(BuildContext context) => isDark(context)
      ? nightBorder
      : const Color(0x4D99868C);

  /// Primary text: deep plum, or warm cream.
  static Color title(BuildContext context) =>
      isDark(context) ? nightText : _titleLight;

  /// Secondary text: muted plum, or dusty rose.
  static Color body(BuildContext context) =>
      isDark(context) ? nightBody : _bodyLight;

  /// Soft chip fill: cream, or night border.
  static Color chipBg(BuildContext context) =>
      isDark(context) ? nightBorder : _cream;

  /// Icon on brand fills: plum, or cream.
  static Color onBrand(BuildContext context) =>
      isDark(context) ? nightText : _plum;

  static Color get plum => _plum;
  static Color get mutedPlum => _mutedPlum;
  static Color get cream => _cream;

  /// C31: primary-button token re-exports — AppTheme owns the values.
  static Color get primaryButtonBackground => AppTheme.primaryButtonBackground;
  static Color get onPrimaryButton => AppTheme.onPrimaryButton;
}
