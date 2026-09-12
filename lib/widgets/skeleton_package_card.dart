import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class SkeletonPackageCard extends StatelessWidget {
  const SkeletonPackageCard({super.key});

  @override
  Widget build(BuildContext context) {
    // P6 (Q1): dark-aware shimmer so loading states never flash white.
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final base = isDark
        ? const Color(0xFF36222C)
        : const Color(0xFF99868C);
    final highlight = isDark
        ? const Color(0xFF5A4450)
        : const Color(0xFFE8DEE2);
    return Container(
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF1C1618) : Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: const Color(0x4D99868C),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Image skeleton
          Expanded(
            child: ClipRRect(
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(12),
                topRight: Radius.circular(12),
              ),
              child: Shimmer.fromColors(
                baseColor: base,
                highlightColor: highlight,
                child: Container(width: double.infinity, color: Colors.white),
              ),
            ),
          ),
          // Content skeleton
          Padding(
            padding: const EdgeInsets.all(12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Title
                Shimmer.fromColors(
                  baseColor: base,
                  highlightColor: highlight,
                  child: Container(
                    height: 16,
                    width: double.infinity,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 8),
                // Rating
                Shimmer.fromColors(
                  baseColor: base,
                  highlightColor: highlight,
                  child: Container(height: 14, width: 100, color: Colors.white),
                ),
                const SizedBox(height: 12),
                // Price
                Shimmer.fromColors(
                  baseColor: base,
                  highlightColor: highlight,
                  child: Container(height: 16, width: 80, color: Colors.white),
                ),
                const SizedBox(height: 12),
                // Button
                Shimmer.fromColors(
                  baseColor: base,
                  highlightColor: highlight,
                  child: Container(
                    height: 30,
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
