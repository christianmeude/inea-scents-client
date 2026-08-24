import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../providers/index.dart';
import '../widgets/index.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final packagesAsync = ref.watch(packagesProvider);

    return Scaffold(
      backgroundColor: const Color(0xFFFAF6F3), // Off-white cream color
      body: SafeArea(
        child: Column(
          children: [
            // ============================================================
            // HEADER
            // ============================================================
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
              child: Stack(
                alignment: Alignment.center,
                children: [
                  Center(
                    child: SizedBox(
                      width: 140,
                      height: 45,
                      child: Stack(
                        alignment: Alignment.center,
                        children: [
                          Positioned(
                            top: 0,
                            left: 0,
                            child: const Text(
                              'INEA',
                              style: TextStyle(
                                fontSize: 32,
                                fontWeight: FontWeight.bold,
                                letterSpacing: 2,
                                height: 1,
                                color: Color(0xFF5E3A52),
                              ),
                            ),
                          ),
                          Positioned(
                            bottom: 0,
                            right: 0,
                            child: Text(
                              'Scents',
                              style: const TextStyle(
                                fontFamily: 'GreatVibes',
                                fontSize: 32,
                                height: 1,
                                color: Color(0xFF5E3A52),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
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
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(8),
                                border: Border.all(color: Colors.grey.withValues(alpha: 0.4)),
                              ),
                              child: Row(
                                children: [
                                  const SizedBox(width: 12),
                                  Icon(Icons.search, color: Colors.grey[400], size: 20),
                                  const SizedBox(width: 12),
                                  Expanded(
                                    child: Text(
                                      'Search "Perfume" here',
                                      style: TextStyle(
                                        color: Colors.grey[400],
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
                          const Icon(Icons.chat_bubble_rounded, color: Color(0xFF5E3A52)),
                          const SizedBox(width: 15),
                          const Icon(Icons.calendar_today_rounded, color: Color(0xFF5E3A52)),
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
                          borderRadius: BorderRadius.circular(15),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withValues(alpha: 0.05),
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
                                      Icon(Icons.local_florist, size: 24, color: Color(0xFFC0A062)),
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
                    const Padding(
                      padding: EdgeInsets.symmetric(horizontal: 20),
                      child: Text(
                        'Popular Packages',
                        style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.w500,
                          color: Colors.black,
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
                            return const Center(child: Text("No packages available"));
                          }

                          return GridView.builder(
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 2,
                              childAspectRatio: 0.52, // Adjusted for card height to prevent overflow
                              crossAxisSpacing: 15,
                              mainAxisSpacing: 15,
                            ),
                            itemCount: packages.length,
                            itemBuilder: (context, index) {
                              return PackageCard(package: packages[index]);
                            },
                          );
                        },
                        loading: () => const Center(
                          child: CircularProgressIndicator(color: Color(0xFF5E3A52)),
                        ),
                        error: (err, stack) => Center(child: Text(err.toString())),
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
      bottomNavigationBar: const BottomNavBar(),
    );
  }
}
