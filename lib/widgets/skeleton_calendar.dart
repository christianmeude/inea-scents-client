import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

/// C58: calendar loading skeleton — mirrors the Availability card +
/// agenda column so loading never flashes a spinner or stale chrome.
class SkeletonCalendar extends StatelessWidget {
  const SkeletonCalendar({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final base = isDark
        ? const Color(0xFF36222C)
        : const Color(0xFF99868C);
    final highlight = isDark
        ? const Color(0xFF5A4450)
        : const Color(0xFFE8DEE2);

    Widget bar({
      required double height,
      required double width,
      double radius = 6,
    }) {
      return Shimmer.fromColors(
        baseColor: base,
        highlightColor: highlight,
        child: Container(
          height: height,
          width: width,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(radius),
          ),
        ),
      );
    }

    Widget dayCell() {
      return Shimmer.fromColors(
        baseColor: base,
        highlightColor: highlight,
        child: Container(
          width: 36,
          height: 36,
          decoration: const BoxDecoration(
            color: Colors.white,
            shape: BoxShape.circle,
          ),
        ),
      );
    }

    return Column(
      key: const Key('skeleton_calendar'),
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: double.infinity,
          padding: const EdgeInsets.fromLTRB(12, 14, 12, 14),
          decoration: BoxDecoration(
            color: isDark ? const Color(0xFF1C1618) : Colors.white,
            borderRadius: BorderRadius.circular(24),
            border: Border.all(
              color: isDark
                  ? const Color(0xFF36222C)
                  : const Color(0x4D99868C),
            ),
          ),
          child: Column(
            children: [
              bar(height: 14, width: 140, radius: 7),
              const SizedBox(height: 12),
              for (int row = 0; row < 5; row++) ...[
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [for (int i = 0; i < 7; i++) dayCell()],
                ),
                if (row < 4) const SizedBox(height: 10),
              ],
            ],
          ),
        ),
        const SizedBox(height: 20),
        bar(height: 16, width: 180),
        const SizedBox(height: 8),
        bar(height: 12, width: 220),
      ],
    );
  }
}
