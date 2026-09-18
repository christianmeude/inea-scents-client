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
    final titleColor = CardSurfaces.title(context);

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
                child: Center(
                  child: ConstrainedBox(
                    constraints: const BoxConstraints(maxWidth: 1200),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // C1: concierge next step — date-first entry into
                        // the booking flow (P4 order), above the fold.
                        // ============================================================
                        const Padding(
                          padding: EdgeInsets.symmetric(horizontal: 20),
                          child: NextStepCard(),
                        ),

                        const SizedBox(height: 24),

                        // POPULAR PACKAGES TITLE
                        // ============================================================
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 20),
                          child: Text(
                            'Our Packages',
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
                                        ResponsiveAppShell.homeGridDelegateForWidth(
                                          constraints.maxWidth,
                                        ),
                                    itemCount: packages.length,
                                    itemBuilder: (context, index) {
                                      return PackageCard(
                                        package: packages[index],
                                      );
                                    },
                                  );
                                },
                              );
                            },
                            // C1 (Q10): skeleton grid unifies Home loading
                            // with Packages — no raw spinner divergence.
                            loading: () => LayoutBuilder(
                              builder: (context, constraints) {
                                return GridView.builder(
                                  shrinkWrap: true,
                                  physics:
                                      const NeverScrollableScrollPhysics(),
                                  gridDelegate:
                                      ResponsiveAppShell.homeGridDelegateForWidth(
                                        constraints.maxWidth,
                                      ),
                                  itemCount: 4,
                                  itemBuilder: (context, index) {
                                    return const SkeletonPackageCard();
                                  },
                                );
                              },
                            ),
                            // P6 (Q6/Q8): shared friendly card; raw
                            // errors stay in logs, never on screen.
                            error: (err, stack) => Padding(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 20,
                              ),
                              child: ErrorStateCard(
                                title: 'Unable to load packages',
                                message:
                                    "We couldn't load the packages. Check your connection and try again.",
                                onRetry: () => ref.invalidate(packagesProvider),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 40),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
