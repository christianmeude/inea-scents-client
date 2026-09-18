import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../models/index.dart';
import '../config/theme.dart';
import '../providers/index.dart';

class PackageCard extends ConsumerStatefulWidget {
  final Package package;
  final VoidCallback? onTap;

  /// Tier override: renders this card as one selectable headcount step
  /// ("50 Guests — ₱4,499") instead of the whole package.
  final int? tierPax;
  final double? tierPrice;

  const PackageCard({
    super.key,
    required this.package,
    this.onTap,
    this.tierPax,
    this.tierPrice,
  });

  @override
  ConsumerState<PackageCard> createState() => _PackageCardState();
}

class _PackageCardState extends ConsumerState<PackageCard> {
  bool _isHovered = false;
  bool _isFocused = false;
  bool _isTogglingWishlist = false;

  void _handleTap() {
    if (widget.onTap != null) {
      widget.onTap!();
    } else {
      final tier = widget.tierPax;
      final id = widget.package.id;
      context.push(
        tier == null
            ? '/package-details/$id'
            : '/package-details/$id?pax=$tier',
      );
    }
  }

  bool _isWishlisted(AsyncValue<List<Package>> wishlist) {
    return wishlist.valueOrNull?.any((item) => item.id == widget.package.id) ??
        false;
  }

  Future<void> _toggleWishlist() async {
    final packageId = widget.package.id;
    if (packageId == null || _isTogglingWishlist) return;

    setState(() => _isTogglingWishlist = true);
    try {
      await ref.read(wishlistProvider.notifier).toggle(packageId);
    } catch (_) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Unable to update your wishlist.')),
      );
    } finally {
      if (mounted) setState(() => _isTogglingWishlist = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final package = widget.package;
    final isWishlisted = _isWishlisted(ref.watch(wishlistProvider));
    final isDark = Theme.of(context).brightness == Brightness.dark;

    final cardBg = isDark
        ? (_isHovered ? AppTheme.nightBorder : AppTheme.nightSurface)
        : (_isHovered ? const Color(0xFFFAF2F4) : Colors.white);
    final focusBorderColor = isDark
        ? const Color(0xFFFDF4F5)
        : AppTheme.primary;
    final primaryTextColor = isDark
        ? const Color(0xFFFDF4F5)
        : AppTheme.primary;
    final secondaryTextColor = isDark
        ? const Color(0xFFC4ACAC)
        : AppTheme.secondary;
    final badgeBg = isDark
        ? (_isHovered ? AppTheme.nightBorder : AppTheme.nightSurface)
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
                        color: isDark ? AppTheme.night : AppTheme.neutralBg,
                        child:
                            (package.images != null &&
                                package.images!.isNotEmpty)
                            ? Image.network(
                                package.images![0],
                                fit: BoxFit.cover,
                                errorBuilder: (context, error, stackTrace) {
                                  return Center(
                                    child: Text(
                                      package.name ?? '',
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                        fontSize: 12,
                                        color: primaryTextColor,
                                      ),
                                    ),
                                  );
                                },
                              )
                            : Center(
                                child: Text(
                                  package.name ?? '',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: primaryTextColor,
                                  ),
                                ),
                              ),
                      ),
                    ),
                  ),
                  Positioned(
                    top: 0,
                    right: 0,
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          tooltip: isWishlisted
                              ? 'Remove from wishlist'
                              : 'Add to wishlist',
                          onPressed: _isTogglingWishlist
                              ? null
                              : _toggleWishlist,
                          icon: Icon(
                            _isTogglingWishlist
                                ? Icons.sync_rounded
                                : isWishlisted
                                ? Icons.favorite
                                : Icons.favorite_border,
                            color: isWishlisted
                                ? const Color(0xFF9A4F5D)
                                : primaryTextColor,
                            size: 20,
                          ),
                          style: IconButton.styleFrom(
                            backgroundColor: badgeBg,
                            shape: const RoundedRectangleBorder(
                              borderRadius: BorderRadius.only(
                                topRight: Radius.circular(18),
                                bottomLeft: Radius.circular(10),
                              ),
                            ),
                          ),
                        ),
                        AnimatedContainer(
                          duration: const Duration(milliseconds: 200),
                          padding: const EdgeInsets.symmetric(
                            horizontal: 10,
                            vertical: 6,
                          ),
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
                      ],
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
                      widget.tierPax != null
                          ? '${widget.tierPax} Guests'
                          : package.name ?? '',
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
                          style: TextStyle(
                            fontSize: 13,
                            color: primaryTextColor,
                          ),
                        ),
                        const SizedBox(width: 4),
                        Expanded(
                          child: Text(
                            '(${package.reviewsCount ?? 232} reviews)',
                            style: TextStyle(
                              fontSize: 13,
                              color: secondaryTextColor,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    Text(
                      package.description ??
                          'Perfect for intimate celebrations and small gatherings.',
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
                      'Php. ${(widget.tierPrice ?? package.price ?? 4499.0).toStringAsFixed(2)}',
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
