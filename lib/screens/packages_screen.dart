import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

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
      final categoryMatches = category == 'All' || 
          (p.name?.toLowerCase().contains(category.toLowerCase()) ?? false) || 
          (p.description?.toLowerCase().contains(category.toLowerCase()) ?? false);
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
  const PackagesScreen({super.key});

  @override
  ConsumerState<PackagesScreen> createState() => _PackagesScreenState();
}

class _PackagesScreenState extends ConsumerState<PackagesScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _checkFirstLaunch();
    });
  }

  Future<void> _checkFirstLaunch() async {
    final prefs = await SharedPreferences.getInstance();
    final isFirstLaunch = prefs.getBool('first_launch') ?? true;

    if (isFirstLaunch) {
      await prefs.setBool('first_launch', false);
      if (!mounted) return;
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) => const WelcomeModal(),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final packagesAsync = ref.watch(filteredPackagesProvider);

    // ============================================================
    // COLORS
    // ============================================================

    const backgroundTop = Color(0xFFF8E9DF);
    const backgroundMiddle = Color(0xFFD8B0BA);
    const backgroundBottom = Color(0xFFB78C9C);

    const primaryColor = Color(0xFF74445C);
    const textColor = Color(0xFF633E50);
    const secondaryTextColor = Color(0xFF765867);

    return Scaffold(
      backgroundColor: backgroundTop,

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
                      color: Colors.white.withValues(alpha: 0.35),
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: Colors.white.withValues(alpha: 0.55),
                        width: 1,
                      ),
                    ),
                    child: IconButton(
                      padding: EdgeInsets.zero,
                      icon: const Icon(
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
      // BODY
      // ============================================================
      body: Stack(
        children: [
          // ========================================================
          // GRADIENT BACKGROUND
          // ========================================================
          Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [backgroundTop, backgroundMiddle, backgroundBottom],
              ),
            ),
          ),

          // ========================================================
          // TOP-LEFT GLOW
          // ========================================================
          Positioned(
            top: -130,
            left: -120,
            child: _BlurCircle(
              size: 390,
              color: const Color(0xFFEBC9B8).withValues(alpha: 0.75),
            ),
          ),

          // ========================================================
          // TOP-RIGHT GLOW
          // ========================================================
          Positioned(
            top: 80,
            right: -150,
            child: _BlurCircle(
              size: 370,
              color: const Color(0xFFD3A4AF).withValues(alpha: 0.72),
            ),
          ),

          // ========================================================
          // BOTTOM-LEFT GLOW
          // ========================================================
          Positioned(
            bottom: -170,
            left: -130,
            child: _BlurCircle(
              size: 430,
              color: const Color(0xFF9C8491).withValues(alpha: 0.65),
            ),
          ),

          // ========================================================
          // BOTTOM-RIGHT GLOW
          // ========================================================
          Positioned(
            bottom: -150,
            right: -120,
            child: _BlurCircle(
              size: 420,
              color: const Color(0xFF69384F).withValues(alpha: 0.55),
            ),
          ),

          // ========================================================
          // CENTER SOFT GLOW
          // ========================================================
          Positioned(
            top: MediaQuery.of(context).size.height * 0.25,
            left: MediaQuery.of(context).size.width * 0.20,
            child: _BlurCircle(
              size: 420,
              color: Colors.white.withValues(alpha: 0.25),
            ),
          ),

          // ========================================================
          // MAIN CONTENT
          // ========================================================
          SafeArea(
            child: SingleChildScrollView(
              physics: const BouncingScrollPhysics(),

              padding: const EdgeInsets.fromLTRB(20, 12, 20, 24),

              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // ==================================================
                  // PAGE TITLE
                  // ==================================================
                  const Text(
                    'Our Collections',
                    style: TextStyle(
                      color: textColor,
                      fontSize: 24,
                      fontWeight: FontWeight.w600,
                      letterSpacing: 0.2,
                    ),
                  ),

                  const SizedBox(height: 5),

                  const Text(
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
                    onChanged: (val) => ref.read(packagesSearchQueryProvider.notifier).state = val,
                  ),

                  const SizedBox(height: 26),

                  // ==================================================
                  // CATEGORY CHIPS
                  // ==================================================
                  SizedBox(
                    height: 40,
                    child: ListView(
                      scrollDirection: Axis.horizontal,
                      children: ['All', 'Wedding', 'Birthday', 'Corporate'].map((cat) {
                        final isSelected = ref.watch(packagesCategoryProvider) == cat;
                        return Padding(
                          padding: const EdgeInsets.only(right: 12),
                          child: FilterChip(
                            mouseCursor: SystemMouseCursors.click,
                            label: Text(cat),
                            selected: isSelected,
                            onSelected: (val) {
                              ref.read(packagesCategoryProvider.notifier).state = cat;
                            },
                            backgroundColor: Colors.white.withValues(alpha: 0.3),
                            selectedColor: primaryColor,
                            labelStyle: TextStyle(
                              color: isSelected ? Colors.white : textColor,
                              fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                            ),
                            side: BorderSide(
                              color: isSelected ? primaryColor : Colors.white.withValues(alpha: 0.5),
                            ),
                          ),
                        );
                      }).toList(),
                    ),
                  ),

                  const SizedBox(height: 16),

                  // ==================================================
                  // SORT CHIPS
                  // ==================================================
                  SizedBox(
                    height: 40,
                    child: ListView(
                      scrollDirection: Axis.horizontal,
                      children: const [
                        _SortChip(label: 'Price: Low to High', value: 'price_asc'),
                        _SortChip(label: 'Price: High to Low', value: 'price_desc'),
                        _SortChip(label: 'Top Rated', value: 'rating_desc'),
                      ],
                    ),
                  ),

                  const SizedBox(height: 20),

                  // ==================================================
                  // SECTION HEADER
                  // ==================================================
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'All Packages',
                        style: TextStyle(
                          color: textColor,
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                        ),
                      ),

                      packagesAsync.when(
                        data: (packages) => Text(
                          '${packages.length} items',
                          style: const TextStyle(
                            color: secondaryTextColor,
                            fontSize: 12,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        loading: () => const SizedBox.shrink(),
                        error: (_, _) => const SizedBox.shrink(),
                      ),
                    ],
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

                      return GridView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),

                        gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 2,

                              // Slightly taller cards so they don't feel cramped.
                              childAspectRatio: 0.52,

                              crossAxisSpacing: 14,
                              mainAxisSpacing: 16,
                            ),

                        itemCount: packages.length,

                        itemBuilder: (context, index) {
                          final package = packages[index];

                          return PackageCard(package: package);
                        },
                      );
                    },

                    // ==================================================
                    // LOADING
                    // ==================================================
                    loading: () {
                      return GridView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          childAspectRatio: 0.52,
                          crossAxisSpacing: 14,
                          mainAxisSpacing: 16,
                        ),
                        itemCount: 4,
                        itemBuilder: (context, index) {
                          return const SkeletonPackageCard();
                        },
                      );
                    },

                    // ==================================================
                    // ERROR
                    // ==================================================
                    error: (error, stack) {
                      return _ErrorState(error: error);
                    },
                  ),

                  const SizedBox(height: 20),
                ],
              ),
            ),
          ),
        ],
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
    const textColor = Color(0xFF633E50);
    const secondaryTextColor = Color(0xFF765867);

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 55, horizontal: 25),

      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.28),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: Colors.white.withValues(alpha: 0.50)),
      ),

      child: const Column(
        children: [
          Icon(Icons.local_florist_outlined, size: 42, color: textColor),

          SizedBox(height: 14),

          Text(
            'No packages available',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: textColor,
              fontSize: 16,
              fontWeight: FontWeight.w600,
            ),
          ),

          SizedBox(height: 6),

          Text(
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
// ERROR STATE
// ============================================================================

class _ErrorState extends StatelessWidget {
  final Object error;

  const _ErrorState({required this.error});

  @override
  Widget build(BuildContext context) {
    const textColor = Color(0xFF633E50);
    const secondaryTextColor = Color(0xFF765867);
    const primaryColor = Color(0xFF74445C);

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),

      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.30),
        borderRadius: BorderRadius.circular(22),
        border: Border.all(color: Colors.white.withValues(alpha: 0.55)),
      ),

      child: Column(
        children: [
          const Icon(Icons.cloud_off_rounded, size: 42, color: textColor),

          const SizedBox(height: 12),

          const Text(
            'Unable to load packages',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: textColor,
              fontSize: 16,
              fontWeight: FontWeight.w600,
            ),
          ),

          const SizedBox(height: 6),

          Text(
            '$error',
            textAlign: TextAlign.center,
            maxLines: 3,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(color: secondaryTextColor, fontSize: 12),
          ),

          const SizedBox(height: 16),

          OutlinedButton(
            onPressed: () {
              // Riverpod will refresh naturally when appropriate.
            },

            style: OutlinedButton.styleFrom(
              foregroundColor: primaryColor,
              side: const BorderSide(color: primaryColor),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(9999),
              ),
            ),

            child: const Text('Try Again'),
          ),
        ],
      ),
    );
  }
}

// ============================================================================
// BLURRED BACKGROUND CIRCLE
// ============================================================================

class _BlurCircle extends StatelessWidget {
  final double size;
  final Color color;

  const _BlurCircle({required this.size, required this.color});

  @override
  Widget build(BuildContext context) {
    return ImageFiltered(
      imageFilter: ImageFilter.blur(sigmaX: 70, sigmaY: 70),

      child: Container(
        width: size,
        height: size,

        decoration: BoxDecoration(shape: BoxShape.circle, color: color),
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
          border: Border.all(
            color: _isFocused
                ? Colors.white
                : Colors.white.withValues(alpha: _isHovered ? 0.95 : 0.80),
            width: _isFocused ? 2.0 : 1.1,
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
              hintStyle: TextStyle(
                color: Color(0xBFFFFFFF),
                fontSize: 14,
              ),
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

// ============================================================================
// SORT CHIP
// ============================================================================

class _SortChip extends ConsumerWidget {
  final String label;
  final String value;

  const _SortChip({required this.label, required this.value});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentSort = ref.watch(packagesSortProvider);
    final isSelected = currentSort == value;

    return Padding(
      padding: const EdgeInsets.only(right: 12),
      child: FilterChip(
        mouseCursor: SystemMouseCursors.click,
        label: Text(label),
        selected: isSelected,
        onSelected: (_) {
          ref.read(packagesSortProvider.notifier).state = isSelected ? 'none' : value;
        },
        backgroundColor: Colors.white.withValues(alpha: 0.3),
        selectedColor: const Color(0xFF95647E),
        labelStyle: TextStyle(
          color: isSelected ? Colors.white : const Color(0xFF633E50),
          fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
        ),
        side: BorderSide(
          color: isSelected ? const Color(0xFF95647E) : Colors.white.withValues(alpha: 0.5),
        ),
      ),
    );
  }
}
