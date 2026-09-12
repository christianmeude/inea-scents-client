import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../providers/index.dart';
import '../models/index.dart';
import '../widgets/index.dart';

class PackageDetailScreen extends ConsumerWidget {
  final int packageId;

  /// Preselected headcount option carried from a package card (`?pax=`).
  /// Forwarded to the booking flow; ignored when not a valid option.
  final int? initialPax;

  /// Date carried from the calendar (`?date=`); forwarded to booking.
  final DateTime? initialDate;

  const PackageDetailScreen({
    super.key,
    required this.packageId,
    this.initialPax,
    this.initialDate,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final packageAsync = ref.watch(packageDetailsProvider(packageId));

    return Scaffold(
      backgroundColor: const Color(0xFFFDF4F5),
      body: SafeArea(
        child: packageAsync.when(
          data: (package) {
            return Column(
              children: [
                // Top App Bar Area
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 15,
                    vertical: 15,
                  ),
                  child: Row(
                    children: [
                      IconButton(
                        icon: const Icon(
                          Icons.arrow_back,
                          color: Color(0xFF6A4053),
                        ),
                        tooltip: 'Back',
                        mouseCursor: SystemMouseCursors.click,
                        onPressed: () => context.pop(),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Container(
                          height: 40,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(color: const Color(0x4D99868C)),
                          ),
                          child: Row(
                            children: [
                              const SizedBox(width: 12),
                              Icon(
                                Icons.search,
                                color: const Color(0xFF99868C),
                                size: 20,
                              ),
                              const SizedBox(width: 12),
                              Text(
                                'Search "Perfume" here',
                                style: TextStyle(
                                  color: const Color(0xFF99868C),
                                  fontSize: 14,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(width: 15),
                      const Icon(
                        Icons.chat_bubble_rounded,
                        color: Color(0xFF6A4053),
                      ),
                      const SizedBox(width: 15),
                      const Icon(
                        Icons.calendar_today_rounded,
                        color: Color(0xFF6A4053),
                      ),
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
                          border: Border.all(color: const Color(0x4D99868C)),
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
                                  child:
                                      (package.images != null &&
                                          package.images!.isNotEmpty)
                                      ? Image.network(
                                          package.images![0],
                                          fit: BoxFit.cover,
                                        )
                                      : const Center(
                                          child: Text(
                                            "Package Image Placeholder",
                                          ),
                                        ),
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
                                      color: Color(0xFF6A4053),
                                    ),
                                  ),
                                  const SizedBox(height: 8),
                                  Row(
                                    children: [
                                      const Icon(
                                        Icons.star,
                                        size: 16,
                                        color: Colors.amber,
                                      ),
                                      const SizedBox(width: 4),
                                      Text(
                                        '${package.rating ?? 4.5}',
                                        style: const TextStyle(
                                          fontSize: 14,
                                          color: Color(0xFF6A4053),
                                        ),
                                      ),
                                      const SizedBox(width: 4),
                                      Text(
                                        '(${package.reviewsCount ?? 232} reviews)',
                                        style: const TextStyle(
                                          fontSize: 14,
                                          color: Color(0xFF99868C),
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 20),
                                  Text(
                                    package.description ??
                                        'Perfect for intimate celebrations...',
                                    style: const TextStyle(
                                      fontSize: 13,
                                      color: Color(0xFF99868C),
                                      height: 1.4,
                                    ),
                                  ),
                                  const SizedBox(height: 20),
                                  const Text(
                                    'Includes:',
                                    style: TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w500,
                                      color: Color(0xFF6A4053),
                                    ),
                                  ),
                                  const SizedBox(height: 8),
                                  ...(package.inclusions ?? []).map(
                                    (inclusion) => Padding(
                                      padding: const EdgeInsets.only(bottom: 4),
                                      child: Row(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          const Text(
                                            '•  ',
                                            style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 16,
                                            ),
                                          ),
                                          Expanded(
                                            child: Text(
                                              inclusion,
                                              style: const TextStyle(
                                                fontSize: 13,
                                                color: Color(0xFF6A4053),
                                                height: 1.3,
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                  const SizedBox(height: 15),
                                  // Free items if any
                                  if (package.freebies != null &&
                                      package.freebies!.isNotEmpty) ...[
                                    const Text(
                                      'Free:',
                                      style: TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.w500,
                                        color: Color(0xFF6A4053),
                                      ),
                                    ),
                                    const SizedBox(height: 8),
                                    ...package.freebies!.map(
                                      (freebie) => Padding(
                                        padding: const EdgeInsets.only(
                                          bottom: 4,
                                        ),
                                        child: Row(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            const Text(
                                              '•  ',
                                              style: TextStyle(
                                                fontWeight: FontWeight.bold,
                                                fontSize: 16,
                                              ),
                                            ),
                                            Expanded(
                                              child: Text(
                                                freebie,
                                                style: TextStyle(
                                                  fontSize: 13,
                                                  color: const Color(
                                                    0xFF6A4053,
                                                  ),
                                                  height: 1.3,
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ],
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
                  padding: const EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: 15,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    border: Border(
                      top: BorderSide(color: const Color(0x4D99868C)),
                    ),
                  ),
                  child: SafeArea(
                    top: false,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                initialPax == null
                                    ? 'Starting at ₱${(package.price ?? 4499.0).toStringAsFixed(0)}'
                                    : '₱${package.priceForPax(initialPax).toStringAsFixed(0)} · $initialPax PAX',
                                style: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w500,
                                  color: Color(0xFF6A4053),
                                ),
                              ),
                              const Text(
                                'One booking lasts 3–4 hrs.',
                                style: TextStyle(
                                  fontSize: 12,
                                  color: Color(0xFF99868C),
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(width: 12),
                        ElevatedButton(
                          onPressed: () {
                            final id = package.id;
                            if (id == null) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text('Invalid package'),
                                ),
                              );
                              return;
                            }
                            final query = <String>[
                              if (initialPax != null) 'pax=$initialPax',
                              if (initialDate != null)
                                'date=${formatDateParam(initialDate!)}',
                            ];
                            context.push(
                              '/booking/$id${query.isEmpty ? '' : '?${query.join('&')}'}',
                            );
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF6A4053), // Plum
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(
                              horizontal: 25,
                              vertical: 12,
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(9999),
                            ),
                          ),
                          child: const Text(
                            'Book Now',
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            );
          },
          loading: () => const Center(
            child: CircularProgressIndicator(color: Color(0xFF6A4053)),
          ),
          // P6 (Q6/Q8): shared friendly card; raw errors stay
          // in logs, never on screen.
          error: (error, stack) => Center(
            child: Padding(
              padding: const EdgeInsets.all(24.0),
              child: ErrorStateCard(
                title: "We couldn't open this package",
                message: 'Check your connection and try again.',
                onRetry: () =>
                    ref.refresh(packageDetailsProvider(packageId)),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
