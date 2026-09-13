import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/index.dart';
import '../widgets/index.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final packagesAsync = ref.watch(packagesProvider);
    // P7: surfaces resolve through the shared helper (banner art stays).
    final surface = CardSurfaces.cardBg(context);
    final surfaceBorder = CardSurfaces.cardBorder(context);
    final titleColor = CardSurfaces.title(context);
    final bodyColor = CardSurfaces.body(context);

    // P7: no explicit color — flat theme scaffold background.
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            // ============================================================
            // HEADER (Mobile only, Desktop uses TopNavBar in App Shell)
            // ============================================================
            if (MediaQuery.of(context).size.width < 768)
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 15,
                ),
                child: Stack(
                  alignment: Alignment.center,
                  children: [Center(child: AppLogo())],
                ),
              ),

            Expanded(
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // ============================================================
                    // SEARCH AND ACTIONS
                    // ============================================================
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: Row(
                        children: [
                          Expanded(
                            child: Container(
                              height: 45,
                              decoration: BoxDecoration(
                                color: surface,
                                borderRadius: BorderRadius.circular(8),
                                border: Border.all(
                                  color: surfaceBorder,
                                ),
                              ),
                              child: Row(
                                children: [
                                  const SizedBox(width: 12),
                                  Icon(
                                    Icons.search,
                                    color: bodyColor,
                                    size: 20,
                                  ),
                                  const SizedBox(width: 12),
                                  Expanded(
                                    child: Text(
                                      'Search "Perfume" here',
                                      style: TextStyle(
                                        color: bodyColor,
                                        fontSize: 14,
                                      ),
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          const SizedBox(width: 15),
                          Icon(
                            Icons.chat_bubble_rounded,
                            color: titleColor,
                          ),
                          const SizedBox(width: 15),
                          Icon(
                            Icons.calendar_today_rounded,
                            color: titleColor,
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 25),

                    // ============================================================
                    // BANNER
                    // ============================================================
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: Container(
                        height: 220,
                        width: double.infinity,
                        decoration: BoxDecoration(
                          color: const Color(0xFFF3EBE1),
                          borderRadius: BorderRadius.circular(20),
                          boxShadow: [
                            BoxShadow(
                              color: const Color(
                                0xFF6A4053,
                              ).withValues(alpha: 0.05),
                              blurRadius: 10,
                              offset: const Offset(0, 5),
                            ),
                          ],
                        ),
                        // Here normally would be an Image.asset with the beautiful banner
                        // As placeholder, we'll recreate the layout simply
                        child: Stack(
                          children: [
                            Positioned(
                              top: 20,
                              left: 20,
                              right: 20,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    children: [
                                      Icon(
                                        Icons.local_florist,
                                        size: 24,
                                        color: Color(0xFFC0A062),
                                      ),
                                      const SizedBox(width: 8),
                                      const Expanded(
                                        child: Text(
                                          'INEA SCENTS',
                                          style: TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.bold,
                                            letterSpacing: 1.5,
                                            color: Color(0xFFC0A062),
                                          ),
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                      ),
                                    ],
                                  ),
                                  const Text(
                                    '— PERFUME BAR —',
                                    style: TextStyle(
                                      fontSize: 10,
                                      letterSpacing: 2,
                                      color: Color(0xFFC0A062),
                                    ),
                                  ),
                                  const SizedBox(height: 15),
                                  const Text(
                                    'Make Every Moment\nUnforgettable',
                                    style: TextStyle(
                                      fontSize: 22,
                                      fontWeight: FontWeight.w600,
                                      color: Color(0xFF4A3424),
                                    ),
                                  ),
                                  const SizedBox(height: 10),
                                  const Text(
                                    'A personalized perfume experience\nfor your special celebrations.',
                                    style: TextStyle(
                                      fontSize: 12,
                                      color: Color(0xFF4A3424),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            // In a real app we would use the image from assets here.
                          ],
                        ),
                      ),
                    ),

                    const SizedBox(height: 30),

                    // ============================================================
                    // POPULAR PACKAGES TITLE
                    // ============================================================
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: Text(
                        'Popular Packages',
                        style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.w500,
                          color: titleColor,
                        ),
                      ),
                    ),

                    const SizedBox(height: 15),

                    // ============================================================
                    // PACKAGE GRID
                    // ============================================================
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: packagesAsync.when(
                        data: (packages) {
                          if (packages.isEmpty) {
                            return const Center(
                              child: Text("No packages available"),
                            );
                          }

                          return LayoutBuilder(
                            builder: (context, constraints) {
                              return GridView.builder(
                                shrinkWrap: true,
                                physics:
                                    const NeverScrollableScrollPhysics(),
                                gridDelegate:
                                    ResponsiveAppShell.gridDelegateForWidth(
                                  constraints.maxWidth,
                                  // Adjusted for card height to prevent overflow
                                  childAspectRatio: 0.52,
                                  crossAxisSpacing: 15,
                                  mainAxisSpacing: 15,
                                ),
                                itemCount: packages.length,
                                itemBuilder: (context, index) {
                                  return PackageCard(
                                      package: packages[index]);
                                },
                              );
                            },
                          );
                        },
                        loading: () => const Center(
                          child: CircularProgressIndicator(
                            color: Color(0xFF6A4053),
                          ),
                        ),
                        // P6 (Q6/Q8): shared friendly card; raw
                        // errors stay in logs, never on screen.
                        error: (err, stack) => Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 20),
                          child: ErrorStateCard(
                            title: 'Unable to load packages',
                            message:
                                "We couldn't load the packages. Check your connection and try again.",
                            onRetry: () =>
                                ref.invalidate(packagesProvider),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 40),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
