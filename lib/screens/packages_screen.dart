import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../providers/index.dart';
import '../widgets/index.dart';
import '../models/index.dart';

final packagesSearchQueryProvider = StateProvider<String>((ref) => '');
final packagesSortProvider = StateProvider<String>((ref) => 'none');
final packagesCategoryProvider = StateProvider<String>((ref) => 'All');

final filteredPackagesProvider = Provider<AsyncValue<List<Package>>>((ref) {
  final asyncPackages = ref.watch(packagesProvider);
  final query = ref.watch(packagesSearchQueryProvider).toLowerCase();
  final sort = ref.watch(packagesSortProvider);
  final category = ref.watch(packagesCategoryProvider);

  return asyncPackages.whenData((packages) {
    var filtered = packages.where((p) {
      final nameMatches = p.name?.toLowerCase().contains(query) ?? false;
      final categoryMatches =
          category == 'All' ||
          (p.name?.toLowerCase().contains(category.toLowerCase()) ?? false) ||
          (p.description?.toLowerCase().contains(category.toLowerCase()) ??
              false);
      return nameMatches && categoryMatches;
    }).toList();

    if (sort == 'price_asc') {
      filtered.sort((a, b) => (a.price ?? 0).compareTo(b.price ?? 0));
    } else if (sort == 'price_desc') {
      filtered.sort((a, b) => (b.price ?? 0).compareTo(a.price ?? 0));
    } else if (sort == 'rating_desc') {
      filtered.sort((a, b) => (b.rating ?? 0).compareTo(a.rating ?? 0));
    }

    return filtered;
  });
});

class PackagesScreen extends ConsumerStatefulWidget {
  /// Date carried from the calendar (`?date=`); forwarded with each card.
  final DateTime? initialDate;

  const PackagesScreen({super.key, this.initialDate});

  @override
  ConsumerState<PackagesScreen> createState() => _PackagesScreenState();
}

/// One selectable card on the packages grid. Packages with options expand to
/// one entry per headcount step ("50 PAX — ₱4,499"); packages without options
/// render as a single entry.
class _PackageEntry {
  final Package package;
  final PackageOption? option;

  const _PackageEntry(this.package, [this.option]);
}

List<_PackageEntry> _packageEntries(List<Package> packages) {
  final entries = <_PackageEntry>[];
  for (final package in packages) {
    final options = package.options;
    if (options.isEmpty) {
      entries.add(_PackageEntry(package));
    } else {
      for (final option in options) {
        entries.add(_PackageEntry(package, option));
      }
    }
  }
  return entries;
}

class _PackagesScreenState extends ConsumerState<PackagesScreen> {
  @override
  Widget build(BuildContext context) {
    final packagesAsync = ref.watch(filteredPackagesProvider);

    // ============================================================
    // COLORS (P7: flat theme background + dark-aware text)
    // ============================================================

    final textColor = CardSurfaces.title(context);
    final secondaryTextColor = CardSurfaces.body(context);

    // P7: no explicit color — the theme scaffold color (light cream /
    // dark night) is the background.
    return Scaffold(
      // ============================================================
      // APP BAR (Mobile only, Desktop uses TopNavBar in App Shell)
      // ============================================================
      appBar: MediaQuery.of(context).size.width < 768
          ? AppBar(
              backgroundColor: Colors.transparent,
              surfaceTintColor: Colors.transparent,
              elevation: 0,
              centerTitle: true,

              title: const _BrandName(),

              leading: const SizedBox(),

              actions: [
                Padding(
                  padding: const EdgeInsets.only(right: 16),
                  child: Container(
                    width: 42,
                    height: 42,
                    decoration: BoxDecoration(
                      color: CardSurfaces.chipBg(context),
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: Colors.white.withValues(alpha: 0.55),
                        width: 1,
                      ),
                    ),
                    child: IconButton(
                      padding: EdgeInsets.zero,
                      icon: Icon(
                        Icons.tune_rounded,
                        color: textColor,
                        size: 20,
                      ),
                      onPressed: () {
                        // Add filters later.
                      },
                    ),
                  ),
                ),
              ],
            )
          : null,

      // ============================================================
      // BODY (P7: flat theme background; decorative gradient removed)
      // ============================================================
      body: SafeArea(
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),

          padding: const EdgeInsets.fromLTRB(20, 12, 20, 24),

          child: Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 1200),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // ==================================================
                  // PAGE TITLE
                  // ==================================================
                  Text(
                    'Our Collections',
                    style: TextStyle(
                      color: textColor,
                      fontSize: 24,
                      fontWeight: FontWeight.w600,
                      letterSpacing: 0.2,
                    ),
                  ),

                  const SizedBox(height: 5),

                  Text(
                    'Discover your perfect scent.',
                    style: TextStyle(
                      color: secondaryTextColor,
                      fontSize: 13,
                      fontWeight: FontWeight.w400,
                    ),
                  ),

                  const SizedBox(height: 20),

                  // ==================================================
                  // SEARCH BAR
                  // ==================================================
                  _SearchBar(
                    onChanged: (val) =>
                        ref.read(packagesSearchQueryProvider.notifier).state =
                            val,
                  ),

                  const SizedBox(height: 26),

                  // ==================================================
                  // SECTION HEADER (P7: filter chips + item counter
                  // removed — search narrows the grid directly)
                  // ==================================================
                  Text(
                    'All Packages',
                    style: TextStyle(
                      color: textColor,
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                    ),
                  ),

                  const SizedBox(height: 16),

                  // ==================================================
                  // PACKAGES
                  // ==================================================
                  packagesAsync.when(
                    data: (packages) {
                      if (packages.isEmpty) {
                        return _EmptyPackages();
                      }

                      return LayoutBuilder(
                        builder: (context, constraints) {
                          return GridView.builder(
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),

                            // P6 (G2): 2 → 3 → 4 columns across
                            // mobile / tablet / desktop.
                            gridDelegate:
                                ResponsiveAppShell.gridDelegateForWidth(
                                  constraints.maxWidth,
                                ),

                            itemCount: _packageEntries(packages).length,

                            itemBuilder: (context, index) {
                              final entry = _packageEntries(packages)[index];

                              return PackageCard(
                                package: entry.package,
                                optionPax: entry.option?.pax,
                                initialDate: widget.initialDate,
                              );
                            },
                          );
                        },
                      );
                    },

                    // ==================================================
                    // LOADING
                    // ==================================================
                    loading: () {
                      return LayoutBuilder(
                        builder: (context, constraints) {
                          return GridView.builder(
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            gridDelegate:
                                ResponsiveAppShell.gridDelegateForWidth(
                                  constraints.maxWidth,
                                ),
                            itemCount: 4,
                            itemBuilder: (context, index) {
                              return const SkeletonPackageCard();
                            },
                          );
                        },
                      );
                    },

                    // ==================================================
                    // ERROR
                    // ==================================================
                    // P6 (Q6/Q8): shared friendly card; raw errors
                    // stay in logs, never on screen.
                    error: (error, stack) {
                      return ErrorStateCard(
                        title: 'Unable to load packages',
                        message:
                            "We couldn't load the packages. "
                            'Check your connection and try again.',
                        onRetry: () => ref.invalidate(packagesProvider),
                      );
                    },
                  ),

                  const SizedBox(height: 20),
                ],
              ),
            ),
          ),
        ),
      ),

      // ============================================================
      // BODY WRAPPER END
      // ============================================================
    );
  }
}

// ============================================================================
// INEA BRAND NAME
// ============================================================================

class _BrandName extends StatelessWidget {
  const _BrandName();

  @override
  Widget build(BuildContext context) {
    const brandColor = Color(0xFF6D3E55);

    return SizedBox(
      width: 130,
      height: 58,

      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,

        children: [
          // ==========================================================
          // INEA
          // ==========================================================
          Text(
            'INEA',
            textAlign: TextAlign.center,

            style: TextStyle(
              fontSize: 25,
              fontWeight: FontWeight.w400,
              letterSpacing: 5.2,
              height: 0.85,
              color: brandColor,

              shadows: [
                Shadow(
                  color: Colors.white.withValues(alpha: 0.75),
                  blurRadius: 1.5,
                  offset: const Offset(1, 1),
                ),
              ],
            ),
          ),

          const SizedBox(height: 3),

          // ==========================================================
          // SCENTS
          // ==========================================================
          Text(
            'Scents',
            textAlign: TextAlign.center,

            style: TextStyle(
              fontSize: 22,
              fontStyle: FontStyle.italic,
              fontWeight: FontWeight.w300,
              fontFamily: 'serif',
              letterSpacing: 0.3,
              height: 0.95,
              color: brandColor,

              shadows: [
                Shadow(
                  color: Colors.white.withValues(alpha: 0.75),
                  blurRadius: 1.5,
                  offset: const Offset(1, 1),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// ============================================================================
// EMPTY PACKAGES
// ============================================================================

class _EmptyPackages extends StatelessWidget {
  const _EmptyPackages();

  @override
  Widget build(BuildContext context) {
    // P6 (Q1): solid + dark-aware, like every other state card.
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final textColor = isDark
        ? const Color(0xFFFDF4F5)
        : const Color(0xFF633E50);
    final secondaryTextColor = isDark
        ? const Color(0xFFC4ACAC)
        : const Color(0xFF765867);

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 55, horizontal: 25),

      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF1C1618) : Colors.white,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(
          color: isDark ? const Color(0xFF36222C) : const Color(0x4D99868C),
        ),
      ),

      child: Column(
        children: [
          Icon(Icons.local_florist_outlined, size: 42, color: textColor),

          const SizedBox(height: 14),

          SelectableText(
            'No packages available',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: textColor,
              fontSize: 16,
              fontWeight: FontWeight.w600,
            ),
          ),

          const SizedBox(height: 6),

          SelectableText(
            'Please check back again later.',
            textAlign: TextAlign.center,
            style: TextStyle(color: secondaryTextColor, fontSize: 13),
          ),
        ],
      ),
    );
  }
}

// ============================================================================
// SEARCH BAR (Interactive with hover and focus ring)
// ============================================================================

class _SearchBar extends StatefulWidget {
  final ValueChanged<String> onChanged;

  const _SearchBar({required this.onChanged});

  @override
  State<_SearchBar> createState() => _SearchBarState();
}

class _SearchBarState extends State<_SearchBar> {
  bool _isHovered = false;
  bool _isFocused = false;

  @override
  Widget build(BuildContext context) {
    const primaryColor = Color(0xFF74445C);
    const inputColor = Color(0xFF95647E);

    return FocusableActionDetector(
      mouseCursor: SystemMouseCursors.text,
      onShowHoverHighlight: (h) => setState(() => _isHovered = h),
      onShowFocusHighlight: (f) => setState(() => _isFocused = f),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        height: 54,
        decoration: BoxDecoration(
          color: _isFocused
              ? const Color(0xFFA5748E)
              : (_isHovered ? const Color(0xFF9E6D87) : inputColor),
          borderRadius: BorderRadius.circular(12),
          // P6 (Q4): constant width — the glow ring below signals
          // focus so neighbors never shift.
          border: Border.all(
            color: _isFocused
                ? Colors.white
                : Colors.white.withValues(alpha: _isHovered ? 0.95 : 0.80),
            width: 1.5,
          ),
          boxShadow: [
            BoxShadow(
              color: primaryColor.withValues(alpha: 0.12),
              blurRadius: 14,
              offset: const Offset(0, 6),
            ),
            if (_isFocused)
              BoxShadow(
                color: Colors.white.withValues(alpha: 0.35),
                blurRadius: 8,
                spreadRadius: 1,
              ),
          ],
        ),
        child: Focus(
          onFocusChange: (f) => setState(() => _isFocused = f),
          child: TextField(
            style: const TextStyle(color: Colors.white, fontSize: 14),
            cursorColor: Colors.white,
            onChanged: widget.onChanged,
            decoration: const InputDecoration(
              hintText: 'Search "Perfume" here',
              hintStyle: TextStyle(color: Color(0xBFFFFFFF), fontSize: 14),
              prefixIcon: Icon(
                Icons.search_rounded,
                color: Colors.white,
                size: 22,
              ),
              border: InputBorder.none,
              enabledBorder: InputBorder.none,
              focusedBorder: InputBorder.none,
              contentPadding: EdgeInsets.symmetric(
                horizontal: 18,
                vertical: 16,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
