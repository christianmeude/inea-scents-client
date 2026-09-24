import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

import 'responsive_app_shell.dart';

/// C58: calendar loading skeleton — mirrors the Availability card +
/// agenda column so loading never flashes a spinner or stale chrome.
/// C83: teases the real layout — radius24 calendarCard (pads 12,14,12,14)
/// with month-nav chrome + weekday header + month grid, desktop 7:4
/// calendar|agenda Row, agenda ending in the 48px Continue pill CTA.
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

    Widget navButton() {
      return Shimmer.fromColors(
        baseColor: base,
        highlightColor: highlight,
        child: Container(
          width: 28,
          height: 28,
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
            // Month-nav chrome mirror: back / title-bar / forward.
            Row(
              key: const Key('skeleton_month_nav'),
              children: [
                navButton(),
                Expanded(
                  child: Center(child: bar(height: 14, width: 140, radius: 7)),
                ),
                navButton(),
              ],
            ),
            const SizedBox(height: 8),
            // Weekday header mirror: 7 labels.
            Row(
              key: const Key('skeleton_weekday_header'),
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [for (int i = 0; i < 7; i++) weekdayLabel()],
            ),
            const SizedBox(height: 6),
            for (int row = 0; row < 5; row++) ...[
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [for (int i = 0; i < 7; i++) dayCell()],
              ),
              if (row < 4) const SizedBox(height: 10),
            ],
          ],
        ),
      );
    }

    Widget agendaColumn() {
      return Column(
        key: const Key('skeleton_agenda'),
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          bar(height: 16, width: 180),
          const SizedBox(height: 8),
          bar(height: 12, width: 220),
          const SizedBox(height: 12),
          // Continue pill CTA tease: full-width 48px pill.
          Shimmer.fromColors(
            key: const Key('skeleton_agenda_pill'),
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
      );
    }

    return Column(
      key: const Key('skeleton_calendar'),
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        LayoutBuilder(
          builder: (context, constraints) {
            final isDesktop = constraints.maxWidth >=
                ResponsiveAppShell.tabletBreakpoint;
            if (isDesktop) {
              return Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(flex: 7, child: calendarCard()),
                  const SizedBox(width: 24),
                  Expanded(flex: 4, child: agendaColumn()),
                ],
              );
            }
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                calendarCard(),
                const SizedBox(height: 20),
                agendaColumn(),
              ],
            );
          },
        ),
      ],
    );
  }
}
