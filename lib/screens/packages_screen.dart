import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../providers/index.dart';
import '../widgets/index.dart';
import '../models/index.dart';

class PackagesScreen extends ConsumerStatefulWidget {
  /// Date carried from the calendar (`?date=`); forwarded with each card.
  final DateTime? initialDate;

  const PackagesScreen({super.key, this.initialDate});

  @override
  ConsumerState<PackagesScreen> createState() => _PackagesScreenState();
}

/// C17: one Offering renders one hero plus one row per Pax Choice.
/// Packages without an option map fall back to a single row at the
/// scalar price so the list never renders empty.

class _PackagesScreenState extends ConsumerState<PackagesScreen> {
  @override
  Widget build(BuildContext context) {
    final packagesAsync = ref.watch(packagesProvider);

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
                  // C17: single Offering hero + Pax Choice rows
                  // ==================================================
                  packagesAsync.when(
                    data: (packages) {
                      if (packages.isEmpty) {
                        return _EmptyPackages();
                      }

                      final offering = packages.first;
                      final opts = offering.options;
                      final choices = opts.isEmpty
                          ? [
                              PackageOption(
                                offering.paxOptions?.firstOrNull ?? 50,
                                offering.priceForPax(null),
                              ),
                            ]
                          : opts;

                      return LayoutBuilder(
                        builder: (context, constraints) {
                          // C21: compact hero (200 mobile / 240 desktop)
                          // + full Pax Choice list below. Desktop fills
                          // the 1200 cap with a 2-column grid; mobile
                          // stays single-column (360px safe).
                          final wide = constraints.maxWidth >= 768;
                          final rows = <Widget>[
                            for (final choice in choices) ...[
                              PaxChoiceRow(
                                packageId: offering.id,
                                pax: choice.pax,
                                price: choice.price,
                                initialDate: widget.initialDate,
                              ),
                            ],
                          ];
                          return Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              PackageOfferingHero(package: offering),
                              const SizedBox(height: 20),
                              Text(
                                'Choose your Pax Choice',
                                style: TextStyle(
                                  color: textColor,
                                  fontSize: 18,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              const SizedBox(height: 12),
                              if (!wide) ...[
                                for (int i = 0; i < rows.length; i++) ...[
                                  rows[i],
                                  if (i < rows.length - 1)
                                    const SizedBox(height: 10),
                                ],
                              ] else
                                GridView.builder(
                                  shrinkWrap: true,
                                  physics:
                                      const NeverScrollableScrollPhysics(),
                                  gridDelegate:
                                      const SliverGridDelegateWithFixedCrossAxisCount(
                                    crossAxisCount: 2,
                                    crossAxisSpacing: 12,
                                    mainAxisSpacing: 12,
                                    // Roomy rows: ~76px tall at 1200 cap.
                                    mainAxisExtent: 78,
                                  ),
                                  itemCount: rows.length,
                                  itemBuilder: (context, i) => rows[i],
                                ),
                            ],
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
