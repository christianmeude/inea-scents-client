import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../models/index.dart';
import '../config/theme.dart';

class PackageCard extends StatelessWidget {
  final Package package;

  const PackageCard({super.key, required this.package});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => context.push('/package-details/${package.id}'),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: AppTheme.primary.withValues(alpha: 0.05),
              blurRadius: 10,
              offset: const Offset(0, 5),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Image area
            Stack(
              children: [
                ClipRRect(
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(20),
                    topRight: Radius.circular(20),
                  ),
                  child: AspectRatio(
                    aspectRatio: 1.15,
                    child: Container(
                      width: double.infinity,
                      color: AppTheme.neutralBg,
                      child: (package.images != null && package.images!.isNotEmpty)
                          ? Image.network(
                              package.images![0],
                              fit: BoxFit.cover,
                              errorBuilder: (context, error, stackTrace) {
                                return Center(
                                  child: Text(
                                    package.name ?? '',
                                    textAlign: TextAlign.center,
                                    style: const TextStyle(fontSize: 12, color: AppTheme.primary),
                                  ),
                                );
                              },
                            )
                          : Center(
                              child: Text(
                                package.name ?? '',
                                textAlign: TextAlign.center,
                                style: const TextStyle(fontSize: 12, color: AppTheme.primary),
                              ),
                            ),
                    ),
                  ),
                ),
                Positioned(
                  top: 0,
                  right: 0,
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                    decoration: const BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.only(
                        topRight: Radius.circular(20),
                        bottomLeft: Radius.circular(10),
                      ),
                    ),
                    child: const Text(
                      'View Package',
                      style: TextStyle(
                        fontSize: 10,
                        color: AppTheme.primary, // Plum color
                      ),
                    ),
                  ),
                ),
              ],
            ),
            // Content
            Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    package.name ?? '',
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: AppTheme.primary,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 6),
                  Row(
                    children: [
                      const Icon(Icons.star, size: 14, color: Colors.amber),
                      const SizedBox(width: 4),
                      Text(
                        '${package.rating ?? 4.5}',
                        style: const TextStyle(fontSize: 13, color: AppTheme.primary),
                      ),
                      const SizedBox(width: 4),
                      Expanded(
                        child: Text(
                          '(${package.reviewsCount ?? 232} reviews)',
                          style: const TextStyle(fontSize: 13, color: AppTheme.secondary),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Text(
                    package.description ?? 'Perfect for intimate celebrations and small gatherings.',
                    style: const TextStyle(
                      fontSize: 12,
                      color: AppTheme.secondary,
                      height: 1.3,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'Php. ${(package.price ?? 4499.0).toStringAsFixed(2)}',
                    style: const TextStyle(
                      fontSize: 15,
                      color: AppTheme.primary, // Plum
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
