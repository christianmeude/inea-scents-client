import 'package:flutter/material.dart';

/// Shared friendly error card (P6 Q6/Q8): one look for every load failure —
/// solid Elegant Concierge card, plain-language message, a single Try Again
/// action. Raw error text is never rendered; it stays in logs only.
class ErrorStateCard extends StatelessWidget {
  final String title;
  final String message;
  final VoidCallback onRetry;
  final String retryLabel;
  final IconData icon;

  const ErrorStateCard({
    super.key,
    required this.title,
    required this.message,
    required this.onRetry,
    this.retryLabel = 'Try Again',
    this.icon = Icons.cloud_off_rounded,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    const plum = Color(0xFF74445C);
    final titleColor =
        isDark ? const Color(0xFFFDF4F5) : const Color(0xFF633E50);
    final bodyColor =
        isDark ? const Color(0xFFC4ACAC) : const Color(0xFF765867);

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
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
      child: Stack(
        children: [
          Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 64,
                height: 64,
                decoration: BoxDecoration(
                  color: isDark
                      ? const Color(0xFF36222C)
                      : const Color(0xFFF5E8EC),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  icon,
                  size: 32,
                  color: isDark ? const Color(0xFFFDF4F5) : plum,
                ),
              ),
              const SizedBox(height: 14),
              SelectableText(
                title,
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: titleColor,
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 6),
              SelectableText(
                message,
                textAlign: TextAlign.center,
                style: TextStyle(color: bodyColor, fontSize: 13, height: 1.4),
              ),
              const SizedBox(height: 18),
              OutlinedButton(
                onPressed: onRetry,
                child: Text(retryLabel),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
