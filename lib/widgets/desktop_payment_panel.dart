import 'package:flutter/material.dart';
import '../models/index.dart';
import 'card_surfaces.dart';

/// Desktop & Tablet Payment Panel for INEA Scents reservation flow.
///
/// Replaces the left (Calendar) and middle (Details) columns during the payment
/// step on wide viewports (>=1024px) via an in-place cross-fade transition.
///
/// C77: payment section carries method + reminder only. Contact editing lives
/// in step 3 (`_buildWebDetailsForm` / mobile fields); the rail owns amount +
/// CTA.
class DesktopPaymentPanel extends StatelessWidget {
  static const Color plum = Color(0xFF6A4053);
  static const Color mutedPlum = Color(0xFF99868C);
  static const Color cream = Color(0xFFFDF4F5);

  final Package package;
  final String? paymentMethod;
  final ValueChanged<String> onPaymentMethodSelected;
  // C6: onBackToReservation identifier kept for booking_screen call sites
  // (in-flow via _goToStep(3) — stepwise back to Details, never via the
  // router). C8: the redundant in-panel header + Edit Selection chip were
  // distilled; navigation now lives solely in the booking header Back
  // affordance (previousStep(), mobile parity).
  final VoidCallback? onBackToReservation;

  const DesktopPaymentPanel({
    super.key,
    required this.package,
    required this.paymentMethod,
    required this.onPaymentMethodSelected,
    this.onBackToReservation,
  });

  @override
  Widget build(BuildContext context) {
    // P7: all surfaces resolve through the shared helper so the dark
    // toggle recolors the payment step.
    final surfaceBorder = CardSurfaces.cardBorder(context);
    final titleColor = CardSurfaces.title(context);
    final chipColor = CardSurfaces.chipBg(context);
    final activeMethod = paymentMethod ?? 'online';

    // Customer-facing methods: Online (PayMongo) or Cash (admin confirm).
    // bank_transfer is retired (owner Q14-B); the enum keeps it for
    // legacy payloads but no picker offers it.
    // C77: cash uses the same brand treatment as online (no green).
    final paymentMethods = [
      {
        'id': 'online',
        'label': 'Online',
        'sublabel': 'PayMongo secure checkout',
        'color': const Color(0xFF6A4053),
        'icon': Icons.qr_code_2,
      },
      {
        'id': 'cash',
        'label': 'Cash',
        'sublabel': 'Pay on event day · admin confirms',
        'color': const Color(0xFF6A4053),
        'icon': Icons.payments_rounded,
      },
    ];

    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 8, 8, 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ========================================================
          // 1. PAYMENT METHOD SELECTION
          // ========================================================
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: chipColor,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Icon(
                        Icons.payment_rounded,
                        color: titleColor,
                        size: 20,
                      ),
                    ),
                    const SizedBox(width: 10),
                    Flexible(
                      child: Text(
                        'Select Payment Method',
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w700,
                          color: titleColor,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 14),
                Row(
                  children: paymentMethods.map((method) {
                    final isSelected = activeMethod == method['id'];
                    final methodColor = method['color'] as Color;

                    return Expanded(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 3),
                        child: InkWell(
                          onTap: () => onPaymentMethodSelected(
                            method['id'] as String,
                          ),
                          borderRadius: BorderRadius.circular(14),
                          mouseCursor: SystemMouseCursors.click,
                          child: AnimatedContainer(
                            duration: const Duration(milliseconds: 200),
                            padding: const EdgeInsets.symmetric(
                              vertical: 10,
                              horizontal: 6,
                            ),
                            decoration: BoxDecoration(
                              color: isSelected
                                  ? methodColor.withValues(alpha: 0.08)
                                  : chipColor.withValues(alpha: 0.4),
                              borderRadius: BorderRadius.circular(14),
                              border: Border.all(
                                color: isSelected
                                    ? methodColor
                                    : const Color(0x3399868C),
                                width: isSelected ? 2.0 : 1.0,
                              ),
                              boxShadow: isSelected
                                  ? [
                                      BoxShadow(
                                        color: methodColor.withValues(
                                          alpha: 0.18,
                                        ),
                                        blurRadius: 8,
                                        offset: const Offset(0, 2),
                                      ),
                                    ]
                                  : null,
                            ),
                            child: Column(
                              children: [
                                Icon(
                                  method['icon'] as IconData,
                                  // C33: title token both states (AAA 4.5+).
                                  color: titleColor,
                                  size: 22,
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  method['label'] as String,
                                  style: TextStyle(
                                    fontSize: 11,
                                    fontWeight: FontWeight.w700,
                                    // C33: title token (AAA 4.5+ UI).
                                    color: titleColor,
                                  ),
                                  textAlign: TextAlign.center,
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                                const SizedBox(height: 2),
                                Text(
                                  method['sublabel'] as String,
                                  style: TextStyle(
                                    fontSize: 9,
                                    // C33: title token (AAA 7+ text).
                                    color: titleColor,
                                  ),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                                const SizedBox(height: 4),
                                Icon(
                                  isSelected
                                      ? Icons.check_circle_rounded
                                      : Icons
                                            .radio_button_unchecked_rounded,
                                  size: 14,
                                  // C33: title token (AAA 4.5+ UI).
                                  color: titleColor,
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    );
                  }).toList(),
                ),
              ],
            ),
          ),

          const SizedBox(height: 14),

          // ========================================================
          // 2. PAYMENT REMINDER (no header — C77)
          // ========================================================
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Online = PayMongo link flow: no card is captured here.
                // Tapping Confirm & Pay opens the secure checkout page.
                if (activeMethod == 'online')
                  Container(
                    key: const Key('online_checkout_explainer'),
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: const Color(
                        0xFF6A4053,
                      ).withValues(alpha: 0.06),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: const Color(
                          0xFF6A4053,
                        ).withValues(alpha: 0.25),
                      ),
                    ),
                    child: Row(
                      children: [
                        Icon(
                          Icons.lock_outline_rounded,
                          size: 18,
                          // C36: title token (AAA 7+ text both modes).
                          color: titleColor,
                        ),
                        SizedBox(width: 10),
                        Expanded(
                          child: Text(
                            'You will continue to PayMongo\u2019s secure checkout. '
                            'Your booking confirms automatically once payment succeeds — '
                            'no card details are entered here.',
                            style: TextStyle(
                              fontSize: 12,
                              // C36: title token (was plum 2.10 dark).
                              color: titleColor,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ],
                    ),
                  )
                else
                  Container(
                    key: const Key('cash_payment_explainer'),
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      // C77: same brand treatment as the online reminder.
                      color: const Color(
                        0xFF6A4053,
                      ).withValues(alpha: 0.06),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: const Color(
                          0xFF6A4053,
                        ).withValues(alpha: 0.25),
                      ),
                    ),
                    child: Row(
                      children: [
                        Icon(
                          Icons.info_outline_rounded,
                          size: 18,
                          // C36: title token (was green, fails dark).
                          color: titleColor,
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: Text(
                            'You will pay in cash on the event day. Our team will confirm your booking shortly.',
                            style: TextStyle(
                              fontSize: 12,
                              // C36: title token (was green, fails dark).
                              color: titleColor,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
              ],
            ),
          ),

          const SizedBox(height: 14),

          // ========================================================
          // 3. SECURITY & TRUST BADGES
          // ========================================================
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 12,
            ),
            decoration: BoxDecoration(
              color: chipColor,
              borderRadius: BorderRadius.circular(14),
              border: Border.all(color: surfaceBorder),
            ),
            child: Wrap(
              alignment: WrapAlignment.center,
              spacing: 16,
              runSpacing: 8,
              crossAxisAlignment: WrapCrossAlignment.center,
              children: [
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      Icons.shield_rounded,
                      size: 16,
                      // C36: title token (was green, fails dark).
                      color: titleColor,
                    ),
                    SizedBox(width: 6),
                    Flexible(
                      child: Text(
                        'Secure checkout via PayMongo. Complete your payment instantly using QRPh.',
                        style: TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.w600,
                          color: titleColor,
                        ),
                      ),
                    ),
                  ],
                ),
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      Icons.verified_user_rounded,
                      size: 16,
                      // C36: title token (was green, fails dark).
                      color: titleColor,
                    ),
                    SizedBox(width: 6),
                    Flexible(
                      child: Text(
                        'Verified Merchant',
                        style: TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.w600,
                          color: titleColor,
                        ),
                      ),
                    ),
                  ],
                ),
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      Icons.lock_rounded,
                      size: 16,
                      // C36: title token (was green, fails dark).
                      color: titleColor,
                    ),
                    SizedBox(width: 6),
                    Flexible(
                      child: Text(
                        'Payments processed by PayMongo',
                        style: TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.w600,
                          color: titleColor,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
