import 'package:flutter/material.dart';
import '../models/index.dart';
import '../config/offering.dart';
import 'card_surfaces.dart';
import 'inclusions_list.dart';

/// Distilled Order Summary side-panel (P7 C):
/// header one-liner {pax} PAX · {date} · {time}, Inclusions + Free via
/// shared InclusionsList, no image/rating/Live chip/dot-leaders/payment
/// chip/total-name duplication, `₱` only, wrap-don't-truncate.
class OrderSummaryPanel extends StatelessWidget {
  static const Color plum = Color(0xFF6A4053);

  final Package package;
  final DateTime? selectedDate;
  final String? selectedTime;
  final int? selectedPax;
  final String? paymentMethod;
  final VoidCallback? onProceed;
  final String actionButtonText;
  final bool isLoading;
  final bool isSticky;

  const OrderSummaryPanel({
    super.key,
    required this.package,
    this.selectedDate,
    this.selectedTime,
    this.selectedPax,
    this.paymentMethod,
    this.onProceed,
    this.actionButtonText = 'Confirm & Pay',
    this.isLoading = false,
    this.isSticky = true,
  });

  String _formatDate(DateTime? date) {
    if (date == null) return 'Not selected';
    const months = [
      'Jan',
      'Feb',
      'Mar',
      'Apr',
      'May',
      'Jun',
      'Jul',
      'Aug',
      'Sep',
      'Oct',
      'Nov',
      'Dec',
    ];
    return '${months[date.month - 1]} ${date.day}, ${date.year}';
  }

  @override
  Widget build(BuildContext context) {
    final surface = CardSurfaces.cardBg(context);
    final surfaceBorder = CardSurfaces.cardBorder(context);
    final titleColor = CardSurfaces.title(context);
    final effectivePrice = package.priceForPax(selectedPax);
    final inclusions = package.inclusions ?? const <String>[];
    final freebies = package.freebies ?? const <String>[];

    // Fallback sample data when package carries null lists (mirrors
    // previous placeholder inclusions): keeps visual parity without
    // touching API contract.
    final displayInclusions = inclusions.isNotEmpty
        ? inclusions
        : Offering.inclusions;
    final displayFreebies =
        freebies.isNotEmpty ? freebies : Offering.freebies;

    final oneLiner =
        '${selectedPax ?? 50} PAX · ${_formatDate(selectedDate)} · ${TimeSlot.display(selectedTime)}';

    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: surface,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: surfaceBorder, width: 1.0),
        boxShadow: [
          BoxShadow(
            color: plum.withValues(alpha: 0.08),
            blurRadius: 18,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      padding: const EdgeInsets.all(16),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Panel header (no Live chip per C).
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: CardSurfaces.chipBg(context),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(
                  Icons.receipt_long_rounded,
                  color: titleColor,
                  size: 20,
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  'Order Summary',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                    color: titleColor,
                    letterSpacing: 0.2,
                  ),
                  softWrap: true,
                ),
              ),
            ],
          ),

          const SizedBox(height: 10),

          // Header one-liner {pax} PAX · {date} · {time} — wrap, don't truncate.
          Text(
            oneLiner,
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w600,
              color: titleColor,
              height: 1.3,
            ),
            softWrap: true,
          ),

          const SizedBox(height: 14),

          // Inclusions + Free via shared helper.
          InclusionsList(
            inclusions: displayInclusions,
            freebies: displayFreebies,
          ),

          Padding(
            padding: const EdgeInsets.symmetric(vertical: 10),
            child: Divider(color: surfaceBorder, thickness: 1),
          ),

          // Total — `₱` only, wrap-don't-truncate.
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Total',
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w700,
                  color: titleColor,
                ),
              ),
              const SizedBox(width: 8),
              Flexible(
                child: Text(
                  '₱${effectivePrice.toStringAsFixed(2)}',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w800,
                    color: titleColor,
                  ),
                  softWrap: true,
                  textAlign: TextAlign.end,
                ),
              ),
            ],
          ),

          const SizedBox(height: 14),

          // CTA.
          SizedBox(
            width: double.infinity,
            height: 46,
            child: ElevatedButton(
              onPressed: isLoading ? null : onProceed,
              style: ElevatedButton.styleFrom(
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(9999),
                ),
              ),
              child: isLoading
                  ? const SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        color: Colors.white,
                      ),
                    )
                  : Text(
                      actionButtonText,
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        letterSpacing: 0.3,
                      ),
                    ),
            ),
          ),
        ],
      ),
    );
  }
}
