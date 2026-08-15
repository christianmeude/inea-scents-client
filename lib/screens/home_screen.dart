import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../providers/index.dart';
import '../widgets/index.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  // ============================================================
  // INEA COLORS
  // ============================================================

  static const Color backgroundTop = Color(0xFFF8E9DF);
  static const Color backgroundMiddle = Color(0xFFD8B0BA);
  static const Color backgroundBottom = Color(0xFFB78C9C);

  static const Color primaryColor = Color(0xFF74445C);
  static const Color primaryLight = Color(0xFF95647E);
  static const Color textColor = Color(0xFF633E50);
  static const Color secondaryTextColor = Color(0xFF765867);

  static const Color cardColor = Colors.white;
  static const Color borderColor = Color(0xFFE4CBD2);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final packagesAsync = ref.watch(packagesProvider);

    return Scaffold(
      backgroundColor: backgroundTop,

      body: Stack(
        children: [
          // ============================================================
          // GRADIENT BACKGROUND
          // ============================================================
          Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [backgroundTop, backgroundMiddle, backgroundBottom],
                stops: [0.0, 0.52, 1.0],
              ),
            ),
          ),

          // ============================================================
          // TOP LEFT GLOW
          // ============================================================
          Positioned(
            top: -130,
            left: -120,
            child: _SoftCircle(
              size: 390,
              color: const Color(0xFFEBC9B8).withValues(alpha: 0.72),
            ),
          ),

          // ============================================================
          // TOP RIGHT GLOW
          // ============================================================
          Positioned(
            top: 80,
            right: -145,
            child: _SoftCircle(
              size: 370,
              color: const Color(0xFFD3A4AF).withValues(alpha: 0.68),
            ),
          ),

          // ============================================================
          // CENTER LIGHT GLOW
          // ============================================================
          Positioned(
            top: 260,
            left: 80,
            child: _SoftCircle(
              size: 390,
              color: Colors.white.withValues(alpha: 0.25),
            ),
          ),

          // ============================================================
          // BOTTOM LEFT GLOW
          // ============================================================
          Positioned(
            bottom: -180,
            left: -130,
            child: _SoftCircle(
              size: 430,
              color: const Color(0xFF9C8491).withValues(alpha: 0.42),
            ),
          ),

          // ============================================================
          // BOTTOM RIGHT GLOW
          // ============================================================
          Positioned(
            bottom: -160,
            right: -120,
            child: _SoftCircle(
              size: 430,
              color: const Color(0xFF69384F).withValues(alpha: 0.28),
            ),
          ),

          // ============================================================
          // MAIN CONTENT
          // ============================================================
          SafeArea(
            child: SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              padding: const EdgeInsets.only(bottom: 25),
              child: Column(
                children: [
                  const SizedBox(height: 8),

                  // ======================================================
                  // HEADER
                  // ======================================================
                  Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 20,
                      vertical: 10,
                    ),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        const Expanded(child: _BrandName()),

                        _HeaderIconButton(
                          icon: Icons.person_outline_rounded,
                          onPressed: () {
                            context.go('/profile');
                          },
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 12),

                  // ======================================================
                  // WELCOME SECTION
                  // ======================================================
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Find your signature scent',
                            style: TextStyle(
                              color: textColor,
                              fontSize: 25,
                              fontWeight: FontWeight.w600,
                              letterSpacing: -0.5,
                            ),
                          ),
                          const SizedBox(height: 6),
                          Text(
                            'Discover fragrances made for every moment.',
                            style: TextStyle(
                              color: secondaryTextColor,
                              fontSize: 13,
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),

                  const SizedBox(height: 20),

                  // ======================================================
                  // SEARCH BAR
                  // ======================================================
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: const _SearchBar(),
                  ),

                  const SizedBox(height: 16),

                  // ======================================================
                  // QUICK ACTIONS
                  // ======================================================
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Row(
                      children: [
                        Expanded(
                          child: _QuickActionCard(
                            icon: Icons.chat_bubble_outline_rounded,
                            label: 'Messages',
                            onTap: () {},
                          ),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: _QuickActionCard(
                            icon: Icons.favorite_border_rounded,
                            label: 'Wishlist',
                            onTap: () {
                              context.go('/wishlist');
                            },
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 23),

                  // ======================================================
                  // FEATURED BANNER
                  // ======================================================
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: const _FeaturedBanner(),
                  ),

                  const SizedBox(height: 30),

                  // ======================================================
                  // POPULAR PACKAGES
                  // ======================================================
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Popular Packages',
                                    style: TextStyle(
                                      color: textColor,
                                      fontSize: 20,
                                      fontWeight: FontWeight.w600,
                                      letterSpacing: -0.2,
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    'Our most loved fragrance experiences',
                                    style: TextStyle(
                                      color: secondaryTextColor,
                                      fontSize: 12,
                                    ),
                                  ),
                                ],
                              ),
                            ),

                            GestureDetector(
                              onTap: () {
                                context.go('/packages');
                              },
                              child: Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 13,
                                  vertical: 8,
                                ),
                                decoration: BoxDecoration(
                                  color: Colors.white.withValues(alpha: 0.60),
                                  borderRadius: BorderRadius.circular(20),
                                  border: Border.all(color: borderColor),
                                ),
                                child: Text(
                                  'View all',
                                  style: TextStyle(
                                    color: primaryColor,
                                    fontSize: 11,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),

                        const SizedBox(height: 17),

                        // ==================================================
                        // PACKAGE DATA
                        // ==================================================
                        packagesAsync.when(
                          data: (packages) {
                            if (packages.isEmpty) {
                              return const _EmptyPackages();
                            }

                            return GridView.builder(
                              shrinkWrap: true,
                              physics: const NeverScrollableScrollPhysics(),
                              gridDelegate:
                                  const SliverGridDelegateWithFixedCrossAxisCount(
                                    crossAxisCount: 2,
                                    childAspectRatio: 0.70,
                                    crossAxisSpacing: 12,
                                    mainAxisSpacing: 14,
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
                          loading: () => const SizedBox(
                            height: 300,
                            child: Center(
                              child: CircularProgressIndicator(
                                color: primaryColor,
                                strokeWidth: 2.5,
                              ),
                            ),
                          ),

                          // ==================================================
                          // ERROR
                          // ==================================================
                          error: (error, stack) {
                            return _ErrorPackages(message: error.toString());
                          },
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 25),
                ],
              ),
            ),
          ),
        ],
      ),

      // ============================================================
      // BOTTOM NAVIGATION
      // ============================================================
      bottomNavigationBar: const BottomNavBar(),
    );
  }
}

// ============================================================================
// BRAND NAME
// ============================================================================

class _BrandName extends StatelessWidget {
  const _BrandName();

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 70,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'INEA',
            style: const TextStyle(
              color: HomeScreen.primaryColor,
              fontSize: 29,
              fontWeight: FontWeight.w400,
              letterSpacing: 5.5,
              height: 0.85,
            ),
          ),

          const SizedBox(height: 4),

          Padding(
            padding: const EdgeInsets.only(left: 21),
            child: Text(
              'Scents',
              style: TextStyle(
                color: HomeScreen.primaryColor.withValues(alpha: 0.82),
                fontSize: 19,
                fontStyle: FontStyle.italic,
                fontWeight: FontWeight.w300,
                fontFamily: 'serif',
                letterSpacing: 0.5,
                height: 0.9,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ============================================================================
// HEADER ICON BUTTON
// ============================================================================

class _HeaderIconButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback onPressed;

  const _HeaderIconButton({required this.icon, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onPressed,
        borderRadius: BorderRadius.circular(16),
        child: Container(
          width: 47,
          height: 47,
          decoration: BoxDecoration(
            color: Colors.white.withValues(alpha: 0.62),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: HomeScreen.borderColor, width: 1),
            boxShadow: [
              BoxShadow(
                color: HomeScreen.primaryColor.withValues(alpha: 0.07),
                blurRadius: 12,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Icon(icon, color: HomeScreen.primaryColor, size: 22),
        ),
      ),
    );
  }
}

// ============================================================================
// SEARCH BAR
// ============================================================================

class _SearchBar extends StatelessWidget {
  const _SearchBar();

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 55,
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.72),
        borderRadius: BorderRadius.circular(29),
        border: Border.all(color: HomeScreen.borderColor, width: 1),
        boxShadow: [
          BoxShadow(
            color: HomeScreen.primaryColor.withValues(alpha: 0.08),
            blurRadius: 17,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: TextField(
        style: const TextStyle(color: HomeScreen.textColor, fontSize: 14),
        cursorColor: HomeScreen.primaryColor,
        decoration: InputDecoration(
          hintText: 'Search "Perfume" here',
          hintStyle: TextStyle(
            color: HomeScreen.secondaryTextColor.withValues(alpha: 0.65),
            fontSize: 13,
          ),
          prefixIcon: const Icon(
            Icons.search_rounded,
            color: HomeScreen.primaryLight,
            size: 22,
          ),
          suffixIcon: Container(
            width: 38,
            height: 38,
            margin: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: HomeScreen.primaryColor,
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                  color: HomeScreen.primaryColor.withValues(alpha: 0.20),
                  blurRadius: 7,
                  offset: const Offset(0, 3),
                ),
              ],
            ),
            child: const Icon(
              Icons.tune_rounded,
              color: Colors.white,
              size: 18,
            ),
          ),
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(
            vertical: 17,
            horizontal: 5,
          ),
        ),
      ),
    );
  }
}

// ============================================================================
// QUICK ACTION CARD
// ============================================================================

class _QuickActionCard extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;

  const _QuickActionCard({
    required this.icon,
    required this.label,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(17),
        child: Container(
          height: 60,
          decoration: BoxDecoration(
            color: Colors.white.withValues(alpha: 0.58),
            borderRadius: BorderRadius.circular(17),
            border: Border.all(color: HomeScreen.borderColor),
            boxShadow: [
              BoxShadow(
                color: HomeScreen.primaryColor.withValues(alpha: 0.05),
                blurRadius: 12,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: 35,
                height: 35,
                decoration: BoxDecoration(
                  color: HomeScreen.primaryColor.withValues(alpha: 0.10),
                  shape: BoxShape.circle,
                ),
                child: Icon(icon, color: HomeScreen.primaryColor, size: 18),
              ),

              const SizedBox(width: 9),

              Text(
                label,
                style: const TextStyle(
                  color: HomeScreen.textColor,
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ============================================================================
// FEATURED BANNER
// ============================================================================

class _FeaturedBanner extends StatelessWidget {
  const _FeaturedBanner();

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 230,
      clipBehavior: Clip.antiAlias,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(23),
        boxShadow: [
          BoxShadow(
            color: HomeScreen.primaryColor.withValues(alpha: 0.18),
            blurRadius: 24,
            offset: const Offset(0, 10),
          ),
        ],
        image: const DecorationImage(
          image: NetworkImage(
            'https://images.unsplash.com/photo-1594736797933-d0501ba2fe65?w=800&h=500&fit=crop',
          ),
          fit: BoxFit.cover,
        ),
      ),
      child: Stack(
        children: [
          // ================================================================
          // IMAGE OVERLAY
          // ================================================================
          Positioned.fill(
            child: DecoratedBox(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    const Color(0xFF5D3B46).withValues(alpha: 0.28),
                    const Color(0xFF3B1F2B).withValues(alpha: 0.82),
                  ],
                ),
              ),
            ),
          ),

          // ================================================================
          // DECORATIVE GLOW
          // ================================================================
          Positioned(
            right: -50,
            top: -60,
            child: Container(
              width: 170,
              height: 170,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white.withValues(alpha: 0.08),
              ),
            ),
          ),

          // ================================================================
          // BANNER CONTENT
          // ================================================================
          Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Brand
                Row(
                  children: [
                    Container(
                      width: 5,
                      height: 31,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(4),
                      ),
                    ),

                    const SizedBox(width: 10),

                    const Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'INEA SCENTS',
                          style: TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                            letterSpacing: 1.5,
                          ),
                        ),
                        SizedBox(height: 2),
                        Text(
                          'PERFUME BAR',
                          style: TextStyle(
                            fontSize: 9,
                            color: Colors.white70,
                            letterSpacing: 1.2,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),

                const Spacer(),

                const Text(
                  'Make Every Moment\nUnforgettable',
                  style: TextStyle(
                    fontSize: 20,
                    height: 1.15,
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                    letterSpacing: -0.2,
                  ),
                ),

                const SizedBox(height: 6),

                const Text(
                  'A personalized perfume experience\n'
                  'for your special celebrations.',
                  style: TextStyle(
                    fontSize: 10.5,
                    height: 1.4,
                    color: Colors.white70,
                  ),
                ),

                const SizedBox(height: 13),

                Row(
                  children: [
                    const _FeatureTag(
                      icon: Icons.local_drink_outlined,
                      text: '50 ml',
                    ),
                    const SizedBox(width: 7),
                    const _FeatureTag(
                      icon: Icons.auto_awesome_outlined,
                      text: 'Luxury',
                    ),
                    const SizedBox(width: 7),
                    const _FeatureTag(
                      icon: Icons.access_time_rounded,
                      text: '24 Hour',
                    ),
                    const SizedBox(width: 7),
                    const _FeatureTag(
                      icon: Icons.card_giftcard_outlined,
                      text: 'Gift',
                    ),
                  ],
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
// FEATURE TAG
// ============================================================================

class _FeatureTag extends StatelessWidget {
  final IconData icon;
  final String text;

  const _FeatureTag({required this.icon, required this.text});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        height: 34,
        decoration: BoxDecoration(
          color: Colors.white.withValues(alpha: 0.14),
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: Colors.white.withValues(alpha: 0.20)),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: Colors.white, size: 12),

            const SizedBox(height: 1),

            Text(
              text,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 7.5,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
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
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 45, horizontal: 20),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.55),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: HomeScreen.borderColor),
      ),
      child: Column(
        children: [
          Icon(
            Icons.local_florist_outlined,
            size: 40,
            color: HomeScreen.primaryLight.withValues(alpha: 0.65),
          ),

          const SizedBox(height: 12),

          const Text(
            'No packages available',
            style: TextStyle(
              color: HomeScreen.textColor,
              fontSize: 14,
              fontWeight: FontWeight.w600,
            ),
          ),

          const SizedBox(height: 4),

          Text(
            'Check back soon for new fragrances.',
            style: TextStyle(
              color: HomeScreen.secondaryTextColor,
              fontSize: 12,
            ),
          ),
        ],
      ),
    );
  }
}

// ============================================================================
// ERROR PACKAGES
// ============================================================================

class _ErrorPackages extends StatelessWidget {
  final String message;

  const _ErrorPackages({required this.message});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.55),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: HomeScreen.borderColor),
      ),
      child: Column(
        children: [
          const Icon(
            Icons.cloud_off_outlined,
            color: HomeScreen.primaryLight,
            size: 35,
          ),

          const SizedBox(height: 10),

          const Text(
            'Unable to load packages',
            style: TextStyle(
              color: HomeScreen.textColor,
              fontWeight: FontWeight.w600,
              fontSize: 14,
            ),
          ),

          const SizedBox(height: 5),

          Text(
            message,
            textAlign: TextAlign.center,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              color: HomeScreen.secondaryTextColor,
              fontSize: 11,
            ),
          ),
        ],
      ),
    );
  }
}

// ============================================================================
// SOFT BLURRED BACKGROUND CIRCLE
// ============================================================================

class _SoftCircle extends StatelessWidget {
  final double size;
  final Color color;

  const _SoftCircle({required this.size, required this.color});

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
