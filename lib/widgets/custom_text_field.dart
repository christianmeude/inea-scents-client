import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

/// Reusable text input field matching the admin TextInput tokens
/// (`resources/js/Components/TextInput.vue:39`): pill (rounded-full),
/// 1px translucent-white border, mauve `#8B5D76/70` fill (focus `/90`),
/// dark `brand-primary/40` (focus `/60`), `py-3 px-5`, focus ring
/// `white/30` (dark `brand-primary/40`), backdrop-blur, ambient shadow.
/// Hover tints are a client-only extra between the admin base/focus steps.
///
/// Contrast deltas vs the 5.7 budget (white copy on mauve fill —
/// REPORTED, never restyled): base `/70` fill ≈ 3.05, focus `/90` fill
/// ≈ 4.40, both below budget; the translucent border/ring pairs read
/// lower still. Dark cream copy on `brand-primary/40` over `#151012`
/// ≈ 13.5 (passes).
class CustomTextField extends StatefulWidget {
  final TextEditingController controller;
  final bool obscureText;
  final Widget? suffixIcon;
  final Widget? prefixIcon;
  final TextInputType? keyboardType;
  final TextInputAction? textInputAction;
  final Iterable<String>? autofillHints;
  final String? hintText;
  final ValueChanged<String>? onChanged;
  final ValueChanged<String>? onSubmitted;
  final FocusNode? focusNode;
  final bool enabled;
  final int maxLines;

  const CustomTextField({
    super.key,
    required this.controller,
    this.obscureText = false,
    this.suffixIcon,
    this.prefixIcon,
    this.keyboardType,
    this.textInputAction,
    this.autofillHints,
    this.hintText,
    this.onChanged,
    this.onSubmitted,
    this.focusNode,
    this.enabled = true,
    this.maxLines = 1,
  });

  @override
  State<CustomTextField> createState() => _CustomTextFieldState();
}

class _CustomTextFieldState extends State<CustomTextField> {
  bool _isHovered = false;
  bool _isFocused = false;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    final baseBg = isDark
        ? const Color(0xFF6A4053).withValues(alpha: 0.40)
        : const Color(0xFF8B5D76).withValues(alpha: 0.70);
    final hoverBg = isDark
        ? const Color(0xFF6A4053).withValues(alpha: 0.50)
        : const Color(0xFF8B5D76).withValues(alpha: 0.80);
    final focusBg = isDark
        ? const Color(0xFF6A4053).withValues(alpha: 0.60)
        : const Color(0xFF8B5D76).withValues(alpha: 0.90);

    final baseBorder = isDark
        ? Colors.white.withValues(alpha: 0.10)
        : Colors.white.withValues(alpha: 0.20);
    final hoverBorder = isDark
        ? Colors.white.withValues(alpha: 0.25)
        : Colors.white.withValues(alpha: 0.40);
    // C89 admin parity: light focus border white, dark focus border
    // brand-primary (TextInput.vue:39 dark:focus:border-brand-primary).
    final focusBorder = isDark ? const Color(0xFF6A4053) : Colors.white;

    final currentBg = _isFocused ? focusBg : (_isHovered ? hoverBg : baseBg);
    final currentBorder = _isFocused
        ? focusBorder
        : (_isHovered ? hoverBorder : baseBorder);
    // C89 admin parity: 1px border (TextInput `border`), constant width —
    // focus is signaled by the ring + fill change, never by growing the
    // border (which nudged siblings).
    const borderWidth = 1.0;
    // C89 admin pill (rounded-full): radius far above half-height so the
    // ends render fully round at any field height.
    const pillRadius = 999.0;

    return FocusableActionDetector(
      mouseCursor: widget.enabled
          ? SystemMouseCursors.text
          : SystemMouseCursors.basic,
      onShowHoverHighlight: (hovered) {
        if (_isHovered != hovered) {
          setState(() => _isHovered = hovered);
        }
      },
      onShowFocusHighlight: (focused) {
        if (_isFocused != focused) {
          setState(() => _isFocused = focused);
        }
      },
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(pillRadius),
          boxShadow: [
            const BoxShadow(
              color: Color(0x0D6A4053),
              offset: Offset(0, 10),
              blurRadius: 25,
              spreadRadius: -5,
            ),
            const BoxShadow(
              color: Color(0x056A4053),
              offset: Offset(0, 8),
              blurRadius: 10,
              spreadRadius: -6,
            ),
            if (_isFocused)
              // C89 admin focus ring: white/30 light,
              // brand-primary/40 dark (TextInput focus:ring tokens).
              BoxShadow(
                color: isDark
                    ? const Color(0xFF6A4053).withValues(alpha: 0.40)
                    : Colors.white.withValues(alpha: 0.30),
                blurRadius: 8,
                spreadRadius: 1,
              ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(pillRadius),
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 12, sigmaY: 12),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              decoration: BoxDecoration(
                color: currentBg,
                borderRadius: BorderRadius.circular(pillRadius),
                border: Border.all(color: currentBorder, width: borderWidth),
              ),
              child: Focus(
                onFocusChange: (hasFocus) {
                  if (_isFocused != hasFocus) {
                    setState(() => _isFocused = hasFocus);
                  }
                },
                child: TextField(
                  controller: widget.controller,
                  focusNode: widget.focusNode,
                  enabled: widget.enabled,
                  obscureText: widget.obscureText,
                  keyboardType: widget.keyboardType,
                  textInputAction: widget.textInputAction,
                  autofillHints: widget.autofillHints,
                  onChanged: widget.onChanged,
                  onSubmitted: widget.onSubmitted,
                  maxLines: widget.obscureText ? 1 : widget.maxLines,
                  style: GoogleFonts.figtree(
                    color: isDark ? const Color(0xFFFDF4F5) : Colors.white,
                    fontSize: 16,
                  ),
                  cursorColor: isDark ? const Color(0xFFFDF4F5) : Colors.white,
                  decoration: InputDecoration(
                    hintText: widget.hintText,
                    hintStyle: GoogleFonts.figtree(
                      color: (isDark ? const Color(0xFFFDF4F5) : Colors.white)
                          .withValues(alpha: 0.6),
                      fontSize: 16,
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(pillRadius),
                      borderSide: BorderSide.none,
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(pillRadius),
                      borderSide: BorderSide.none,
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(pillRadius),
                      borderSide: BorderSide.none,
                    ),
                    filled: true,
                    fillColor: Colors.transparent,
                    contentPadding: EdgeInsets.only(
                      top: 12,
                      bottom: 12,
                      left: widget.prefixIcon != null ? 8 : 20,
                      right: widget.suffixIcon != null ? 0 : 20,
                    ),
                    prefixIcon: widget.prefixIcon,
                    suffixIcon: widget.suffixIcon != null
                        ? Padding(
                            padding: const EdgeInsets.only(right: 4),
                            child: widget.suffixIcon,
                          )
                        : null,
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
