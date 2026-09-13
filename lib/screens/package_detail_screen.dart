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
    // P7: surfaces resolve through the shared helper.
    final surface = CardSurfaces.cardBg(context);
    final surfaceBorder = CardSurfaces.cardBorder(context);
    final titleColor = CardSurfaces.title(context);
    final bodyColor = CardSurfaces.body(context);

    // P7: no explicit color — flat theme scaffold background.
    return Scaffold(
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
                        icon: Icon(
                          Icons.arrow_back,
                          color: titleColor,
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
                            color: surface,
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(color: surfaceBorder),
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
                              Text(
                                'Search "Perfume" here',
                                style: TextStyle(
                                  color: bodyColor,
                                  fontSize: 14,
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

                // Content (P7 impeccable adapt: stacked card on
                // mobile, gallery + facts side-by-side on web)
                Expanded(
                  child: SingleChildScrollView(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: LayoutBuilder(
                        builder: (context, constraints) {
                          final wide = constraints.maxWidth >
                              ResponsiveAppShell.tabletBreakpoint;
                          final cardDecoration = BoxDecoration(
                            color: surface,
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(color: surfaceBorder),
                          );
                          if (!wide) {
                            return Container(
                              decoration: cardDecoration,
                              child: Column(
                                crossAxisAlignment:
                                    CrossAxisAlignment.start,
                                children: [
                                  // Banner
                                  ClipRRect(
                                    borderRadius:
                                        const BorderRadius.only(
                                      topLeft: Radius.circular(20),
                                      topRight: Radius.circular(20),
                                    ),
                                    child: _buildGalleryVisual(
                                        context, package),
                                  ),

                            Padding(
                              padding: const EdgeInsets.all(20),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    package.name ?? '',
                                    style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.w500,
                                      color: titleColor,
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
                                        style: TextStyle(
                                          fontSize: 14,
                                          color: titleColor,
                                        ),
                                      ),
                                      const SizedBox(width: 4),
                                      Text(
                                        '(${package.reviewsCount ?? 232} reviews)',
                                        style: TextStyle(
                                          fontSize: 14,
                                          color: bodyColor,
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 20),
                                  Text(
                                    package.description ??
                                        'Perfect for intimate celebrations...',
                                    style: TextStyle(
                                      fontSize: 13,
                                      color: bodyColor,
                                      height: 1.4,
                                    ),
                                  ),
                                  const SizedBox(height: 20),
                                  Text(
                                    'Includes:',
                                    style: TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w500,
                                      color: titleColor,
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
                                              style: TextStyle(
                                                fontSize: 13,
                                                color: titleColor,
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
                                    Text(
                                      'Free:',
                                      style: TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.w500,
                                        color: titleColor,
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
                                                  color: titleColor,
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
                      );
                      }

                      // Web: gallery + facts side by side in the page scroll.
                      return Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            child: Container(
                              decoration: cardDecoration,
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(20),
                                child: _buildGalleryVisual(
                                    context, package),
                              ),
                            ),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            flex: 2,
                            child: Container(
                              decoration: cardDecoration,
                              child: _buildInfoColumn(context, package),
                            ),
                          ),
                        ],
                      );
                        },
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
                    color: surface,
                    border: Border(
                      top: BorderSide(color: surfaceBorder),
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
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w500,
                                  color: titleColor,
                                ),
                              ),
                              Text(
                                'One booking lasts 3–4 hrs.',
                                style: TextStyle(
                                  fontSize: 12,
                                  color: bodyColor,
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
                          // P7: no explicit colors — the theme ElevatedButton
                          // (plum/white light, cream/night dark) drives both.
                          style: ElevatedButton.styleFrom(
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

  /// Gallery visual shared by the stacked (mobile) and side-by-side
  /// (web) compositions. Callers own the clipping.
  Widget _buildGalleryVisual(BuildContext context, Package package) {
    return AspectRatio(
      aspectRatio: 1.4,
      child: Container(
        color: CardSurfaces.chipBg(context),
        child: (package.images != null && package.images!.isNotEmpty)
            ? Image.network(
                package.images![0],
                fit: BoxFit.cover,
              )
            : const Center(
                child: Text(
                  'Package Image Placeholder',
                ),
              ),
      ),
    );
  }

  /// Facts column shared by both compositions.
  Widget _buildInfoColumn(BuildContext context, Package package) {
    final titleColor = CardSurfaces.title(context);
    final bodyColor = CardSurfaces.body(context);
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            package.name ?? '',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w500,
              color: titleColor,
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
                style: TextStyle(
                  fontSize: 14,
                  color: titleColor,
                ),
              ),
              const SizedBox(width: 4),
              Text(
                '(${package.reviewsCount ?? 232} reviews)',
                style: TextStyle(
                  fontSize: 14,
                  color: bodyColor,
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          Text(
            package.description ??
                'Perfect for intimate celebrations...',
            style: TextStyle(
              fontSize: 13,
              color: bodyColor,
              height: 1.4,
            ),
          ),
          const SizedBox(height: 20),
          Text(
            'Includes:',
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w500,
              color: titleColor,
            ),
          ),
          const SizedBox(height: 8),
          ...(package.inclusions ?? []).map(
            (inclusion) => Padding(
              padding: const EdgeInsets.only(bottom: 4),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
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
                      style: TextStyle(
                        fontSize: 13,
                        color: titleColor,
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
            Text(
              'Free:',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color: titleColor,
              ),
            ),
            const SizedBox(height: 8),
            ...package.freebies!.map(
              (freebie) => Padding(
                padding: const EdgeInsets.only(
                  bottom: 4,
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
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
                          color: titleColor,
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
    );
  }
}
