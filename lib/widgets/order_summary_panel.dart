import 'package:flutter/material.dart';
import '../models/index.dart';
import '../config/offering.dart';
import '../utils/peso.dart';
import 'card_surfaces.dart';
import 'inclusions_list.dart';

/// Distilled booking side-panel (P7 C + grill rounds 1-3, 2026-09-15):
/// `Your Booking` heading (Booking avoids `order` per CONTEXT.md),
/// proper-noun package line, PAX-tier context line (tiers are a lookup —
/// no fictional base+increment math), full weekday date + venue rows,
/// `₱`-canonical total, amount-in-CTA. The `{pax} PAX · {date} · {time}`
/// one-liner is kept verbatim (test-pinned).
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

  /// Venue as entered at checkout; null/empty renders `Not yet provided`.
  final String? venueAddress;

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
    this.venueAddress,
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

  /// Explicit contract date: `Saturday, September 26, 2026`.
  String _formatFullDate(DateTime date) {
    const weekdays = [
      'Monday',
      'Tuesday',
      'Wednesday',
      'Thursday',
      'Friday',
      'Saturday',
      'Sunday',
    ];
    const months = [
      'January',
      'February',
      'March',
      'April',
      'May',
      'June',
      'July',
      'August',
      'September',
      'October',
      'November',
      'December',
    ];
    return '${weekdays[date.weekday - 1]}, ${months[date.month - 1]} ${date.day}, ${date.year}';
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
    final displayFreebies = freebies.isNotEmpty ? freebies : Offering.freebies;

    final oneLiner =
        '${selectedPax ?? 50} PAX · ${_formatDate(selectedDate)} · ${TimeSlot.display(selectedTime)}';

    // Tier context: truthful one-liner about the lookup model — the total
    // is the server-side tier for the chosen PAX, `from` is the floor.
    final tierOptions = package.options;
    final tierFloor = tierOptions.isEmpty
        ? (package.price ?? 4500.0)
        : tierOptions.map((t) => t.price).reduce((a, b) => a < b ? a : b);
    final tierLine = 'Priced by PAX tier · from ${formatPeso(tierFloor)}';

    final venue = (venueAddress ?? '').trim();
    final venueLine = venue.isEmpty
        ? 'Venue — Not yet provided'
        : 'Venue · $venue';

    // Amount-in-CTA (grill Q5): only the default submit text carries it.
    final ctaText = actionButtonText == 'Confirm & Pay'
        ? 'Confirm & Pay ${formatPeso(effectivePrice)}'
        : actionButtonText;

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
                  'Your Booking',
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

          // Proper-noun package line + tier context (grill Q3a/Q4).
          Text(
            package.name ?? 'Perfume Bar',
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w700,
              color: titleColor,
              height: 1.3,
            ),
            softWrap: true,
          ),
          const SizedBox(height: 2),
          Text(
            tierLine,
            style: TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w500,
              color: CardSurfaces.body(context),
              height: 1.3,
            ),
            softWrap: true,
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

          // Explicit contract rows (grill critique #3).
          if (selectedDate != null) ...[
            const SizedBox(height: 2),
            Text(
              _formatFullDate(selectedDate!),
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: titleColor,
                height: 1.3,
              ),
              softWrap: true,
            ),
          ],
          if (selectedTime != null) ...[
            const SizedBox(height: 2),
            Text(
              '${TimeSlot.display(selectedTime)} · 3–4 hrs',
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w500,
                color: CardSurfaces.body(context),
                height: 1.3,
              ),
              softWrap: true,
            ),
          ],
          const SizedBox(height: 2),
          Text(
            venueLine,
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w500,
              color: CardSurfaces.body(context),
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
                  formatPeso(effectivePrice),
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
                      ctaText,
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
