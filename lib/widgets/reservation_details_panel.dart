import 'package:flutter/material.dart';
import '../config/offering.dart';
import '../models/index.dart';
import '../utils/peso.dart';
import 'card_surfaces.dart';
import 'inclusions_list.dart';

/// Middle Column / Panel for INEA Scents reservation flow on desktop.
/// Handles Package variation overview, the locked Pax summary (P6: the
/// headcount step is chosen on the packages grid, never re-picked here),
/// Time slot selection, Inclusions preview, and Payment Method selection.
class ReservationDetailsPanel extends StatelessWidget {
  static const Color plum = Color(0xFF6A4053);
  static const Color mutedPlum = Color(0xFF99868C);
  static const Color cream = Color(0xFFFDF4F5);

  final Package package;
  final int? selectedPax;

  /// Returns to package details so the customer can pick another
  /// headcount step. Null hides the Change action.
  final VoidCallback? onChangePax;
  final String? selectedTime;
  final ValueChanged<String> onTimeSelected;
  final String? paymentMethod;
  final ValueChanged<String> onPaymentMethodSelected;

  const ReservationDetailsPanel({
    super.key,
    required this.package,
    required this.selectedPax,
    required this.onChangePax,
    required this.selectedTime,
    required this.onTimeSelected,
    required this.paymentMethod,
    required this.onPaymentMethodSelected,
  });

  @override
  Widget build(BuildContext context) {
    // P7: all surfaces resolve through the shared helper so the dark
    // toggle recolors every card, chip, and label.
    final surface = CardSurfaces.cardBg(context);
    final surfaceBorder = CardSurfaces.cardBorder(context);
    final titleColor = CardSurfaces.title(context);
    final bodyColor = CardSurfaces.body(context);
    final chipColor = CardSurfaces.chipBg(context);
    final options = package.options;
    final paxList = options.isNotEmpty
        ? options.map((t) => t.pax).toList()
        : (package.paxOptions ?? const <int>[]);

    String? optionPriceLabel(int pax) {
      if (options.isEmpty) return null;
      return formatPeso(package.priceForPax(pax));
    }

    // Customer-facing methods only: Online (PayMongo) or Cash.
    // Selected state is plum — red reads as error (grill critique #5).
    final paymentMethods = [
      {'id': 'online', 'label': 'Online', 'color': plum},
      {'id': 'cash', 'label': 'Cash', 'color': const Color(0xFF16A34A)},
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // ========================================================
        // 1. PACKAGE SUMMARY CARD
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
                      Icons.card_giftcard_rounded,
                      color: titleColor,
                      size: 20,
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          package.name ?? 'Luxury Experience Package',
                          style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w700,
                            color: titleColor,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 2),
                        Text(
                          'Starting at ${formatPeso(package.price ?? 4500.0)}',
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                            color: bodyColor,
                          ),
                        ),
                        const SizedBox(height: 6),
                        // Package facts (grill critique #7): headcount range
                        // + duration hint give the middle column weight.
                        // Staff lives in Inclusions below; no invented data.
                        if (paxList.isNotEmpty)
                          Text(
                            paxList.length > 1
                                ? '${paxList.first}–${paxList.last} PAX — 3–4 hrs'
                                : '${paxList.first} PAX — 3–4 hrs',
                            style: const TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w500,
                              color: Color(0xDE6A4053),
                              height: 1.35,
                            ),
                          ),
                      ],
                    ),
                  ),
                ],
              ),
              // Description lives on the package detail screen only
              // (grill Q3-final): no server-copy price echo here.
              Theme(
                data: Theme.of(
                  context,
                ).copyWith(dividerColor: Colors.transparent),
                child: ExpansionTile(
                  tilePadding: EdgeInsets.zero,
                  childrenPadding: EdgeInsets.zero,
                  leading: Icon(
                    Icons.spa_outlined,
                    size: 16,
                    color: titleColor,
                  ),
                  title: Text(
                    "What's included",
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w700,
                      color: titleColor,
                    ),
                  ),
                  iconColor: titleColor,
                  collapsedIconColor: titleColor,
                  children: [
                    Align(
                      alignment: Alignment.centerLeft,
                      child: InclusionsList(
                        inclusions: (package.inclusions?.isNotEmpty ?? false)
                            ? package.inclusions!
                            : Offering.inclusions,
                        freebies: (package.freebies?.isNotEmpty ?? false)
                            ? package.freebies!
                            : Offering.freebies,
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
        // 2. YOUR PACKAGE (P6: read-only — the headcount step was
        // chosen on the packages grid and travels via `?pax=`).
        // ========================================================
        Builder(
          builder: (context) {
            final effectivePax =
                selectedPax ?? (paxList.isNotEmpty ? paxList.first : null);
            final price = effectivePax == null
                ? null
                : optionPriceLabel(effectivePax);
            return Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // No generic label (grill Q3a) — the proper-noun card
                  // above already says what this is.
                  Container(
                    key: const Key('pax_readonly_row'),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 14,
                      vertical: 10,
                    ),
                    decoration: BoxDecoration(
                      color: chipColor,
                      borderRadius: BorderRadius.circular(9999),
                      border: Border.all(color: surfaceBorder, width: 1.0),
                    ),
                    child: Row(
                      children: [
                        Icon(
                          Icons.check_circle_rounded,
                          size: 14,
                          color: titleColor,
                        ),
                        const SizedBox(width: 6),
                        Expanded(
                          child: Text(
                            effectivePax == null
                                ? 'Headcount to be confirmed'
                                : (price == null
                                      ? '$effectivePax PAX'
                                      : '$effectivePax PAX · $price'),
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w700,
                              color: titleColor,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        if (onChangePax != null)
                          Flexible(
                            child: GestureDetector(
                              key: const Key('pax_change_link'),
                              onTap: onChangePax,
                              child: MouseRegion(
                                cursor: SystemMouseCursors.click,
                                child: Text(
                                  'Change',
                                  style: TextStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.w600,
                                    color: ReservationDetailsPanel.plum,
                                    decoration: TextDecoration.underline,
                                  ),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            ),
                          ),
                      ],
                    ),
                  ),
                ],
              ),
            );
          },
        ),

        const SizedBox(height: 14),

        // ========================================================
        // 3. SELECT TIME SLOT
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
                      Icons.schedule_rounded,
                      color: titleColor,
                      size: 20,
                    ),
                  ),
                  const SizedBox(width: 10),
                  Flexible(
                    child: Text(
                      'Choose Event Time',
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w700,
                        color: titleColor,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 4),
              Text(
                'One booking lasts 3–4 hrs.',
                style: TextStyle(fontSize: 12, color: bodyColor),
              ),
              const SizedBox(height: 12),
              InkWell(
                key: const Key('event_time_picker_button'),
                onTap: () async {
                  TimeOfDay initial = const TimeOfDay(hour: 14, minute: 0);
                  final current = TimeSlot.toEventTime(selectedTime);
                  if (current != null) {
                    final parts = current.split(':');
                    initial = TimeOfDay(
                      hour: int.parse(parts[0]),
                      minute: int.parse(parts[1]),
                    );
                  }
                  final picked = await showTimePicker(
                    context: context,
                    initialTime: initial,
                  );
                  if (picked == null) return;
                  onTimeSelected(
                    '${picked.hour.toString().padLeft(2, '0')}:${picked.minute.toString().padLeft(2, '0')}:00',
                  );
                },
                borderRadius: BorderRadius.circular(12),
                mouseCursor: SystemMouseCursors.click,
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 12,
                  ),
                  decoration: BoxDecoration(
                    color: chipColor.withValues(alpha: 0.5),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: surfaceBorder),
                  ),
                  child: Row(
                    children: [
                      Icon(Icons.schedule_rounded, size: 16, color: titleColor),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          selectedTime == null
                              ? 'Select time'
                              : TimeSlot.display(selectedTime),
                          style: TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w600,
                            color: titleColor,
                          ),
                        ),
                      ),
                      Icon(
                        Icons.access_time_rounded,
                        size: 16,
                        color: bodyColor,
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),

        const SizedBox(height: 14),

        // ========================================================
        // 4. CHOOSE PAYMENT METHOD
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
                      'Payment Method',
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w700,
                        color: titleColor,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              LayoutBuilder(
                builder: (context, constraints) {
                  final cardW = (constraints.maxWidth - 6) / 2;
                  return Wrap(
                    spacing: 6,
                    runSpacing: 6,
                    children: paymentMethods.map((method) {
                      final isSelected =
                          (paymentMethod ?? 'online') == method['id'];
                      return SizedBox(
                        width: cardW,
                        child: InkWell(
                          onTap: () =>
                              onPaymentMethodSelected(method['id'] as String),
                          borderRadius: BorderRadius.circular(12),
                          mouseCursor: SystemMouseCursors.click,
                          child: AnimatedContainer(
                            duration: const Duration(milliseconds: 200),
                            padding: const EdgeInsets.symmetric(vertical: 10),
                            decoration: BoxDecoration(
                              color: isSelected ? chipColor : surface,
                              borderRadius: BorderRadius.circular(12),
                              // P6 (Q4): constant border width — focus/selection
                              // never shifts layout; color alone signals state.
                              border: Border.all(
                                color: isSelected ? titleColor : surfaceBorder,
                                width: 1.0,
                              ),
                            ),
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text(
                                  method['label'] as String,
                                  style: TextStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.w700,
                                    color: method['color'] as Color,
                                  ),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                                const SizedBox(height: 4),
                                Icon(
                                  isSelected
                                      ? Icons.check_circle_rounded
                                      : Icons.circle_outlined,
                                  size: 14,
                                  color: isSelected ? plum : mutedPlum,
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    }).toList(),
                  );
                },
              ),
            ],
          ),
        ),
      ],
    );
  }
}
