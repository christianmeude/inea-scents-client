import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../providers/index.dart';

class PackageDetailScreen extends ConsumerWidget {
  final int packageId;

  const PackageDetailScreen({super.key, required this.packageId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final packageAsync = ref.watch(packageDetailsProvider(packageId));
    final wishlist = ref.watch(wishlistProvider);
    return Scaffold(
      body: packageAsync.when(
        data: (package) {
          return CustomScrollView(
            slivers: [
              // AppBar with back button
              SliverAppBar(
                expandedHeight: 250,
                pinned: true,
                leading: GestureDetector(
                  onTap: () => context.pop(),
                  child: Container(
                    margin: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: const Icon(
                      Icons.arrow_back,
                      color: Color(0xFF8B6B7C),
                    ),
                  ),
                ),
                flexibleSpace: FlexibleSpaceBar(
                  background: (package.images != null && package.images!.isNotEmpty)
                      ? Image.network(
                          package.images![0],
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) {
                            return Container(
                              color: Colors.grey[300],
                              child: Center(child: Text(package.name ?? '')),
                            );
                          },
                        )
                      : Container(
                          color: Colors.grey[300],
                          child: Center(child: Text(package.name ?? '')),
                        ),
                ),
                actions: [
                  Container(
                    margin: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: IconButton(
                      icon: const Icon(Icons.message),
                      color: const Color(0xFF8B6B7C),
                      onPressed: () {},
                    ),
                  ),
                  Container(
                    margin: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: IconButton(
                      icon: Icon(
                        wishlist.when(
                          data: (items) => items.any((p) => p.id == packageId)
                              ? Icons.bookmark
                              : Icons.bookmark_border,
                          loading: () => Icons.bookmark_border,
                          error: (error, stackTrace) => Icons.bookmark_border,
                        ),
                      ),
                      color: const Color(0xFF8B6B7C),
                      onPressed: () {
                        ref.read(wishlistProvider.notifier).toggle(packageId);
                      },
                    ),
                  ),
                ],
              ),
              // Content
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Package name and rating
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: Text(
                              package.name ?? '',
                              style: const TextStyle(
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          Row(
                            children: [
                              const Icon(
                                Icons.star,
                                size: 18,
                                color: Colors.amber,
                              ),
                              const SizedBox(width: 4),
                              Text(
                                '${package.rating}',
                                style: const TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                      Text(
                        '${package.reviewsCount ?? 0} reviews',
                        style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                      ),
                      const SizedBox(height: 12),
                      Text(
                        package.description ?? '',
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.grey[700],
                          height: 1.5,
                        ),
                      ),
                      const SizedBox(height: 24),
                      // Inclusions section
                      const Text(
                        'Includes:',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 8),
                      ...(package.inclusions ?? []).map((inclusion) {
                        return Padding(
                          padding: const EdgeInsets.only(bottom: 8),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                '• ',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Expanded(child: Text(inclusion)),
                            ],
                          ),
                        );
                      }),
                      const SizedBox(height: 16),
                      // Freebies section
                      if (package.freebies != null && package.freebies!.isNotEmpty) ...[
                        const Text(
                          'Free:',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 8),
                        ...package.freebies!.map((freebie) {
                          return Padding(
                            padding: const EdgeInsets.only(bottom: 8),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text(
                                  '• ',
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                Expanded(child: Text(freebie)),
                              ],
                            ),
                          );
                        }),
                        const SizedBox(height: 16),
                      ],
                      // Price
                      Container(
                        decoration: BoxDecoration(
                          color: Colors.grey[100],
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: Colors.grey[300]!),
                        ),
                        padding: const EdgeInsets.all(16),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text(
                              'Starting at',
                              style: TextStyle(
                                fontSize: 14,
                                color: Color(0xFF8B6B7C),
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Text(
                              'Php. ${(package.price ?? 0).toStringAsFixed(2)}',
                              style: const TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: Color(0xFF8B6B7C),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 16),
                      // Gallery
                      if (package.galleryImages != null && package.galleryImages!.isNotEmpty) ...[
                        const Text(
                          'Gallery',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 8),
                        SizedBox(
                          height: 120,
                          child: ListView.builder(
                            scrollDirection: Axis.horizontal,
                            itemCount: package.galleryImages!.length,
                            itemBuilder: (context, index) {
                              return Container(
                                margin: const EdgeInsets.only(right: 8),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(8),
                                  image: DecorationImage(
                                    image: NetworkImage(
                                      package.galleryImages![index],
                                    ),
                                    fit: BoxFit.cover,
                                  ),
                                ),
                                width: 120,
                              );
                            },
                          ),
                        ),
                        const SizedBox(height: 16),
                      ],
                      // Other packages section
                      const Text(
                        'Other Packages',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 8),
                    ],
                  ),
                ),
              ),
            ],
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stack) => Center(child: Text('Error: $error')),
      ),
      bottomNavigationBar: packageAsync.when(
        data: (package) {
          return Padding(
            padding: const EdgeInsets.all(20),
            child: SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  ref.read(bookingFlowProvider.notifier).reset();
                  ref
                      .read(bookingFlowProvider.notifier)
                      .setSelectedPackage(package);
                  context.push('/booking/${package.id}');
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF8B6B7C),
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: const Text(
                  'Book Now',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          );
        },
        loading: () => const SizedBox.shrink(),
        error: (error, stack) => const SizedBox.shrink(),
      ),
    );
  }
}
