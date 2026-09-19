import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

/// C1 concierge recomposition: the Home next-step card. Date-first entry
/// into the booking flow (P4 order) — routes to the availability calendar,
/// where C4/C5 keep day states legible.
class NextStepCard extends StatelessWidget {
  const NextStepCard({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    const plum = Color(0xFF74445C);

    return Container(
      key: const Key('home_next_step_card'),
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF1C1618) : Colors.white,
        borderRadius: BorderRadius.circular(22),
        border: Border.all(
          color: isDark
              ? const Color(0xFF36222C)
              : const Color(0x4D99868C),
          width: 1.0,
        ),
        boxShadow: [
          BoxShadow(
            color: plum.withValues(alpha: isDark ? 0.20 : 0.08),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            width: 52,
            height: 52,
            decoration: BoxDecoration(
              color: isDark
                  ? const Color(0xFF36222C)
                  : const Color(0xFFF5E8EC),
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.calendar_month_rounded,
              size: 28,
              color: isDark ? const Color(0xFFFDF4F5) : plum,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'Your next step',
                  style: TextStyle(
                    color: isDark
                        ? const Color(0xFFFDF4F5)
                        : const Color(0xFF633E50),
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'Check availability for your date, then choose a Pax Choice.',
                  style: TextStyle(
                    color: isDark
                        ? const Color(0xFFC4ACAC)
                        : const Color(0xFF765867),
                    fontSize: 13,
                    height: 1.4,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 12),
          FilledButton(
            key: const Key('home_check_date_cta'),
            style: FilledButton.styleFrom(backgroundColor: plum),
            onPressed: () => context.push('/calendar'),
            child: const Text('Check date'),
          ),
        ],
      ),
    );
  }
}
