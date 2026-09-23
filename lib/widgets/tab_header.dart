import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../config/theme.dart';
import 'card_surfaces.dart';

/// C42: one shared two-slot tab header (C41 spec §1–§3, pairing B).
///
/// LEFT — title + count/subtitle. RIGHT — one reserved trailing slot that
/// renders empty until a future ticket wires an action (zero actions now).
/// Title 26px at/above [narrowBreakpoint], 22px below; count fixed 13px;
/// single-line ellipsis, step change only (no FittedBox).
class TabHeader extends StatelessWidget {
  /// Viewport breakpoint matching the existing `< 768` checks (C41 §3).
  static const double narrowBreakpoint = 768;
  static const double titleSizeWide = 26;
  static const double titleSizeNarrow = 22;
  static const double countSize = 13;
  static const double titleLetterSpacing = -0.3;

  /// C57: header title renders Josefin Sans (was Cormorant Garamond);
  /// fallback stack is the single-source [AppTheme.brandFontFallback].
  static const List<String> titleFallback = AppTheme.brandFontFallback;
  static const List<String> bodyFallback = [
    'Figtree',
    '-apple-system',
    'Segoe UI',
    'Roboto',
    'sans-serif',
  ];

  final String title;
  final String count;

  /// Reserved trailing-action slot. Empty until a future ticket claims it —
  /// never wire an action here without one.
  final Widget trailing;

  const TabHeader({
    super.key,
    required this.title,
    required this.count,
    this.trailing = const SizedBox.shrink(),
  });

  /// Title size for a viewport [width] (pure, testable).
  static double titleSizeFor(double width) =>
      width < narrowBreakpoint ? titleSizeNarrow : titleSizeWide;

  @override
  Widget build(BuildContext context) {
    // C41 §5 B: explicit fallback stacks hold with font-fetch disabled.
    // (copyWith AFTER the GoogleFonts call — the package overwrites
    // fontFamilyFallback internally.)
    final titleStyle = GoogleFonts.josefinSans(
      fontSize: titleSizeFor(MediaQuery.sizeOf(context).width),
      fontWeight: FontWeight.w600,
      letterSpacing: titleLetterSpacing,
      // Josefin's taller caps never wrap where the old serif fit.
      height: 1.15,
      color: CardSurfaces.title(context),
    ).copyWith(fontFamilyFallback: titleFallback);
    final countStyle = GoogleFonts.figtree(
      fontSize: countSize,
      fontWeight: FontWeight.w400,
      color: CardSurfaces.body(context),
    ).copyWith(fontFamilyFallback: bodyFallback);
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: titleStyle,
              ),
              const SizedBox(height: 5),
              Text(
                count,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: countStyle,
              ),
            ],
          ),
        ),
        trailing,
      ],
    );
  }
}
