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

    return Scaffold(
      backgroundColor: const Color(0xFFFAF6F3),
      body: SafeArea(
        child: packageAsync.when(
          data: (package) {
            return Column(
              children: [
                // Top App Bar Area
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 15),
                  child: Row(
                    children: [
                      GestureDetector(
                        onTap: () => context.pop(),
                        child: const Icon(Icons.arrow_back, color: Color(0xFF5E3A52)),
                      ),
                      const SizedBox(width: 15),
                      Expanded(
                        child: Container(
                          height: 40,
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
                              Text(
                                'Search "Perfume" here',
                                style: TextStyle(
                                  color: Colors.grey[400],
                                  fontSize: 14,
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
                
                // Content
                Expanded(
                  child: SingleChildScrollView(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(color: Colors.grey.withValues(alpha: 0.3)),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Banner
                            ClipRRect(
                              borderRadius: const BorderRadius.only(
                                topLeft: Radius.circular(20),
                                topRight: Radius.circular(20),
                              ),
                              child: AspectRatio(
                                aspectRatio: 1.4,
                                child: Container(
                                  color: const Color(0xFFF3EBE1),
                                  child: (package.images != null && package.images!.isNotEmpty)
                                      ? Image.network(package.images![0], fit: BoxFit.cover)
                                      : const Center(child: Text("Package Image Placeholder")),
                                ),
                              ),
                            ),
                            
                            Padding(
                              padding: const EdgeInsets.all(20),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    package.name ?? '',
                                    style: const TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.w500,
                                      color: Colors.black87,
                                    ),
                                  ),
                                  const SizedBox(height: 8),
                                  Row(
                                    children: [
                                      const Icon(Icons.star, size: 16, color: Colors.amber),
                                      const SizedBox(width: 4),
                                      Text(
                                        '${package.rating ?? 4.5}',
                                        style: const TextStyle(fontSize: 14, color: Colors.black87),
                                      ),
                                      const SizedBox(width: 4),
                                      Text(
                                        '(${package.reviewsCount ?? 232} reviews)',
                                        style: TextStyle(fontSize: 14, color: Colors.grey[400]),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 20),
                                  Text(
                                    package.description ?? 'Perfect for intimate celebrations...',
                                    style: TextStyle(
                                      fontSize: 13,
                                      color: Colors.grey[500],
                                      height: 1.4,
                                    ),
                                  ),
                                  const SizedBox(height: 20),
                                  const Text(
                                    'Includes:',
                                    style: TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w500,
                                      color: Colors.black87,
                                    ),
                                  ),
                                  const SizedBox(height: 8),
                                  ...(package.inclusions ?? []).map((inclusion) => Padding(
                                    padding: const EdgeInsets.only(bottom: 4),
                                    child: Row(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        const Text('•  ', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                                        Expanded(
                                          child: Text(
                                            inclusion,
                                            style: TextStyle(
                                              fontSize: 13,
                                              color: Colors.black87,
                                              height: 1.3,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  )),
                                  const SizedBox(height: 15),
                                  // Free items if any
                                  if (package.freebies != null && package.freebies!.isNotEmpty) ...[
                                    const Text(
                                      'Free:',
                                      style: TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.w500,
                                        color: Colors.black87,
                                      ),
                                    ),
                                    const SizedBox(height: 8),
                                    ...package.freebies!.map((freebie) => Padding(
                                      padding: const EdgeInsets.only(bottom: 4),
                                      child: Row(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          const Text('•  ', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                                          Expanded(
                                            child: Text(
                                              freebie,
                                              style: TextStyle(
                                                fontSize: 13,
                                                color: Colors.black87,
                                                height: 1.3,
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    )),
                                  ]
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
                
                // Sticky Bottom Bar
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    border: Border(top: BorderSide(color: Colors.grey.withValues(alpha: 0.2))),
                  ),
                  child: SafeArea(
                    top: false,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Starting at ₱${(package.price ?? 4499.0).toStringAsFixed(0)}',
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                            color: Color(0xFF5E3A52),
                          ),
                        ),
                        ElevatedButton(
                          onPressed: () => context.push('/calendar', extra: package.id),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF5E3A52), // Plum
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 12),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                          child: const Text(
                            'Book Now',
                            style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            );
          },
          loading: () => const Center(child: CircularProgressIndicator(color: Color(0xFF5E3A52))),
          error: (error, stack) => Center(child: Text('Error: $error')),
        ),
      ),
    );
  }
}
