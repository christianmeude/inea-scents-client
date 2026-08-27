import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

/// Reusable text input field styled with frosted glassmorphism, subtle hover state,
/// and visible focus ring for keyboard and mouse navigation on web and desktop.
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
        ? const Color(0xFF6A4053).withValues(alpha: 0.65)
        : const Color(0xFF8B5D76).withValues(alpha: 0.90);

    final baseBorder = isDark
        ? Colors.white.withValues(alpha: 0.10)
        : Colors.white.withValues(alpha: 0.20);
    final hoverBorder = isDark
        ? Colors.white.withValues(alpha: 0.25)
        : Colors.white.withValues(alpha: 0.40);
    final focusBorder = isDark ? const Color(0xFFFDF4F5) : Colors.white;

    final currentBg = _isFocused
        ? focusBg
        : (_isHovered ? hoverBg : baseBg);
    final currentBorder = _isFocused
        ? focusBorder
        : (_isHovered ? hoverBorder : baseBorder);
    final borderWidth = _isFocused ? 2.0 : 1.0;

    return FocusableActionDetector(
      mouseCursor: widget.enabled ? SystemMouseCursors.text : SystemMouseCursors.basic,
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
          borderRadius: BorderRadius.circular(30),
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
              BoxShadow(
                color: isDark
                    ? const Color(0xFFFDF4F5).withValues(alpha: 0.25)
                    : Colors.white.withValues(alpha: 0.35),
                blurRadius: 8,
                spreadRadius: 1,
              ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(30),
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 12, sigmaY: 12),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              decoration: BoxDecoration(
                color: currentBg,
                borderRadius: BorderRadius.circular(30),
                border: Border.all(
                  color: currentBorder,
                  width: borderWidth,
                ),
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
                      borderRadius: BorderRadius.circular(30),
                      borderSide: BorderSide.none,
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(30),
                      borderSide: BorderSide.none,
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(30),
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
