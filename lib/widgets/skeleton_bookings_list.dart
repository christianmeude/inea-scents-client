import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

/// C79: bookings-list loading skeleton — teases the My Bookings layout
/// (TabHeader + booking cards) so loading never flashes a spinner.
///
/// Mirrors [_BookingCard] in my_bookings_screen.dart: top row (48px icon
/// box + reference bars + status pill), divider, 18px package line,
/// 3 detail rows (34px icon box + 2 text bars), price chip row.
/// C84: single parent Shimmer — children are plain Containers.
class SkeletonBookingsList extends StatelessWidget {
  /// Number of card placeholders to render.
  final int cardCount;

  const SkeletonBookingsList({super.key, this.cardCount = 2});

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
      return Container(
        height: height,
        width: width,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(radius),
        ),
      );
    }

    Widget box({required double width, required double height, double radius = 10}) {
      return Container(
        width: width,
        height: height,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(radius),
        ),
      );
    }

    Widget detailRow(int card, int row) {
      return Row(
        key: Key('skeleton_booking_card_${card}_detail_$row'),
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          box(width: 34, height: 34, radius: 10),
          const SizedBox(width: 11),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                bar(height: 9, width: 70, radius: 4),
                const SizedBox(height: 4),
                bar(height: 12, width: double.infinity, radius: 6),
              ],
            ),
          ),
        ],
      );
    }

    Widget bookingCard(int index) {
      return Container(
        key: Key('skeleton_booking_card_$index'),
        margin: const EdgeInsets.only(bottom: 24),
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: isDark ? const Color(0xFF1C1618) : Colors.white,
          borderRadius: BorderRadius.circular(22),
          border: Border.all(
            color: isDark
                ? const Color(0xFF36222C)
                : const Color(0x4D99868C),
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Top row: 48px icon box + reference bars + status pill.
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                box(width: 48, height: 48, radius: 15),
                const SizedBox(width: 13),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      bar(height: 9, width: 110, radius: 4),
                      const SizedBox(height: 6),
                      bar(height: 14, width: double.infinity, radius: 6),
                    ],
                  ),
                ),
                const SizedBox(width: 8),
                Container(
                  width: 72,
                  height: 26,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 18),
            // Divider.
            Container(height: 1, color: Colors.white),
            const SizedBox(height: 17),
            // Package name line (18px).
            bar(height: 18, width: double.infinity, radius: 6),
            const SizedBox(height: 18),
            // 3 detail rows.
            for (int row = 0; row < 3; row++) ...[
              detailRow(index, row),
              if (row < 2) const SizedBox(height: 11),
            ],
            const SizedBox(height: 18),
            // Price chip row (12px label + price bar).
            Container(
              padding:
                  const EdgeInsets.symmetric(horizontal: 15, vertical: 13),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(14),
              ),
              child: Row(
                children: [
                  Container(height: 12, width: 90, color: Colors.white),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Align(
                      alignment: Alignment.centerRight,
                      child: Container(
                        height: 16,
                        width: 80,
                        color: Colors.white,
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

    return Shimmer.fromColors(
      baseColor: base,
      highlightColor: highlight,
      child: Column(
        key: const Key('skeleton_bookings_list'),
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // TabHeader-height title bar (32px) + booking count line.
          bar(height: 32, width: 200, radius: 8),
          const SizedBox(height: 5),
          bar(height: 13, width: 100, radius: 6),
          const SizedBox(height: 20),
          for (int i = 0; i < cardCount; i++) bookingCard(i),
        ],
      ),
    );
  }
}
