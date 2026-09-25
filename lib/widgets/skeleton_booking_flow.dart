import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

import 'responsive_app_shell.dart';

/// C79: booking-flow loading skeleton — teases the booking schedule step
/// (locked Pax header + calendar card + summary rail) so package loading
/// never flashes a spinner.
///
/// Calendar mirrors [SkeletonCalendar] (month-nav chrome + weekday row +
/// 5x7 36px circles), simplified; right rail teases the order-summary
/// block (5 rows + CTA bar). Wide viewports render a Row with the rail;
/// narrow viewports stack.
class SkeletonBookingFlow extends StatelessWidget {
  const SkeletonBookingFlow({super.key});

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

    Widget circle(double size) {
      return Shimmer.fromColors(
        baseColor: base,
        highlightColor: highlight,
        child: Container(
          width: size,
          height: size,
          decoration: const BoxDecoration(
            color: Colors.white,
            shape: BoxShape.circle,
          ),
        ),
      );
    }

    Widget weekdayLabel() {
      return Shimmer.fromColors(
        baseColor: base,
        highlightColor: highlight,
        child: Container(
          height: 10,
          width: 20,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(5),
          ),
        ),
      );
    }

    Widget calendarCard() {
      return Container(
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
            // Month-nav bar: back / title / forward.
            Row(
              key: const Key('skeleton_flow_month_nav'),
              children: [
                circle(28),
                Expanded(
                  child: Center(child: bar(height: 14, width: 140, radius: 7)),
                ),
                circle(28),
              ],
            ),
            const SizedBox(height: 8),
            // Weekday header: 7 labels.
            Row(
              key: const Key('skeleton_flow_weekday_header'),
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [for (int i = 0; i < 7; i++) weekdayLabel()],
            ),
            const SizedBox(height: 6),
            for (int row = 0; row < 5; row++) ...[
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [for (int i = 0; i < 7; i++) circle(36)],
              ),
              if (row < 4) const SizedBox(height: 10),
            ],
          ],
        ),
      );
    }

    Widget summaryRail() {
      return Container(
        key: const Key('skeleton_flow_summary'),
        width: double.infinity,
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: isDark ? const Color(0xFF1C1618) : Colors.white,
          borderRadius: BorderRadius.circular(15),
          border: Border.all(
            color: isDark
                ? const Color(0xFF36222C)
                : const Color(0x4D99868C),
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            bar(height: 16, width: 140, radius: 6),
            const SizedBox(height: 12),
            for (int i = 0; i < 5; i++) ...[
              Row(
                children: [
                  bar(height: 12, width: 72, radius: 6),
                  const SizedBox(width: 12),
                  Expanded(
                    child: bar(height: 13, width: double.infinity, radius: 6),
                  ),
                ],
              ),
              const SizedBox(height: 10),
            ],
            const SizedBox(height: 4),
            // CTA bar.
            Shimmer.fromColors(
              key: const Key('skeleton_flow_cta'),
              baseColor: base,
              highlightColor: highlight,
              child: Container(
                height: 48,
                width: double.infinity,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(9999),
                ),
              ),
            ),
          ],
        ),
      );
    }

    return Column(
      key: const Key('skeleton_booking_flow'),
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        // Pax header bar.
        Container(
          key: const Key('skeleton_flow_pax_header'),
          width: double.infinity,
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          decoration: BoxDecoration(
            color: isDark ? const Color(0xFF1C1618) : Colors.white,
            borderRadius: BorderRadius.circular(15),
            border: Border.all(
              color: isDark
                  ? const Color(0xFF36222C)
                  : const Color(0x4D99868C),
            ),
          ),
          child: Row(
            children: [
              circle(20),
              const SizedBox(width: 10),
              Expanded(
                child: bar(height: 18, width: double.infinity, radius: 6),
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),
        LayoutBuilder(
          builder: (context, constraints) {
            final isWide =
                constraints.maxWidth > ResponsiveAppShell.tabletBreakpoint;
            if (isWide) {
              return Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(flex: 2, child: calendarCard()),
                  const SizedBox(width: 16),
                  Expanded(flex: 1, child: summaryRail()),
                ],
              );
            }
            return Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                calendarCard(),
                const SizedBox(height: 16),
                summaryRail(),
              ],
            );
          },
        ),
      ],
    );
  }
}
