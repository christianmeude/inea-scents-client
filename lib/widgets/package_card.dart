import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../models/index.dart';
import '../config/theme.dart';

class PackageCard extends StatefulWidget {
  final Package package;
  final VoidCallback? onTap;

  const PackageCard({super.key, required this.package, this.onTap});

  @override
  State<PackageCard> createState() => _PackageCardState();
}

class _PackageCardState extends State<PackageCard> {
  bool _isHovered = false;
  bool _isFocused = false;

  void _handleTap() {
    if (widget.onTap != null) {
      widget.onTap!();
    } else {
      context.push('/package-details/${widget.package.id}');
    }
  }

  @override
  Widget build(BuildContext context) {
    final package = widget.package;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    final cardBg = isDark
        ? (_isHovered ? const Color(0xFF4A2D3C) : const Color(0xFF3B232F))
        : (_isHovered ? const Color(0xFFFAF2F4) : Colors.white);
    final focusBorderColor = isDark ? const Color(0xFFFDF4F5) : AppTheme.primary;
    final primaryTextColor = isDark ? const Color(0xFFFDF4F5) : AppTheme.primary;
    final secondaryTextColor = isDark ? const Color(0xFFC4ACAC) : AppTheme.secondary;
    final badgeBg = isDark
        ? (_isHovered ? const Color(0xFF5A3646) : const Color(0xFF4A2D3C))
        : (_isHovered ? const Color(0xFFFAF2F4) : Colors.white);

    return FocusableActionDetector(
      mouseCursor: SystemMouseCursors.click,
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
      actions: <Type, Action<Intent>>{
        ActivateIntent: CallbackAction<ActivateIntent>(
          onInvoke: (_) => _handleTap(),
        ),
      },
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: _handleTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          curve: Curves.easeInOut,
          decoration: BoxDecoration(
            color: cardBg,
            borderRadius: BorderRadius.circular(20),
            border: _isFocused
                ? Border.all(color: focusBorderColor, width: 2.5)
                : Border.all(
                    color: _isHovered
                        ? AppTheme.primary.withValues(alpha: 0.18)
                        : Colors.transparent,
                    width: 1.5,
                  ),
            boxShadow: [
              BoxShadow(
                color: _isHovered
                    ? AppTheme.primary.withValues(alpha: 0.10)
                    : AppTheme.primary.withValues(alpha: 0.05),
                blurRadius: _isHovered ? 16 : 10,
                offset: _isHovered ? const Offset(0, 6) : const Offset(0, 5),
              ),
              if (_isFocused)
                BoxShadow(
                  color: (isDark ? const Color(0xFFFDF4F5) : AppTheme.primary)
                      .withValues(alpha: 0.35),
                  blurRadius: 6,
                  spreadRadius: 2,
                ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Image area
              Stack(
                children: [
                  ClipRRect(
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(18),
                      topRight: Radius.circular(18),
                    ),
                    child: AspectRatio(
                      aspectRatio: 1.15,
                      child: Container(
                        width: double.infinity,
                        color: isDark ? const Color(0xFF2C1923) : AppTheme.neutralBg,
                        child: (package.images != null && package.images!.isNotEmpty)
                            ? Image.network(
                                package.images![0],
                                fit: BoxFit.cover,
                                errorBuilder: (context, error, stackTrace) {
                                  return Center(
                                    child: Text(
                                      package.name ?? '',
                                      textAlign: TextAlign.center,
                                      style: TextStyle(fontSize: 12, color: primaryTextColor),
                                    ),
                                  );
                                },
                              )
                            : Center(
                                child: Text(
                                  package.name ?? '',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(fontSize: 12, color: primaryTextColor),
                                ),
                              ),
                      ),
                    ),
                  ),
                  Positioned(
                    top: 0,
                    right: 0,
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 200),
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                      decoration: BoxDecoration(
                        color: badgeBg,
                        borderRadius: const BorderRadius.only(
                          topRight: Radius.circular(18),
                          bottomLeft: Radius.circular(10),
                        ),
                      ),
                      child: Text(
                        'View Package',
                        style: TextStyle(
                          fontSize: 10,
                          fontWeight: FontWeight.w600,
                          color: primaryTextColor,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              // Content
              Padding(
                padding: const EdgeInsets.all(12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      package.name ?? '',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: primaryTextColor,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 6),
                    Row(
                      children: [
                        const Icon(Icons.star, size: 14, color: Colors.amber),
                        const SizedBox(width: 4),
                        Text(
                          '${package.rating ?? 4.5}',
                          style: TextStyle(fontSize: 13, color: primaryTextColor),
                        ),
                        const SizedBox(width: 4),
                        Expanded(
                          child: Text(
                            '(${package.reviewsCount ?? 232} reviews)',
                            style: TextStyle(fontSize: 13, color: secondaryTextColor),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    Text(
                      package.description ?? 'Perfect for intimate celebrations and small gatherings.',
                      style: TextStyle(
                        fontSize: 12,
                        color: secondaryTextColor,
                        height: 1.3,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'Php. ${(package.price ?? 4499.0).toStringAsFixed(2)}',
                      style: TextStyle(
                        fontSize: 15,
                        color: primaryTextColor,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
