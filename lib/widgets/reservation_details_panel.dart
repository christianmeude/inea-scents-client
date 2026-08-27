import 'package:flutter/material.dart';
import '../models/index.dart';

/// Middle Column / Panel for INEA Scents reservation flow on desktop.
/// Handles Package variation overview, Pax selection, Time slot selection,
/// Inclusions preview, and Payment Method selection.
class ReservationDetailsPanel extends StatelessWidget {
  static const Color plum = Color(0xFF6A4053);
  static const Color mutedPlum = Color(0xFF99868C);
  static const Color cream = Color(0xFFFDF4F5);

  final Package package;
  final int? selectedPax;
  final ValueChanged<int> onPaxSelected;
  final String? selectedTime;
  final ValueChanged<String> onTimeSelected;
  final String? paymentMethod;
  final ValueChanged<String> onPaymentMethodSelected;

  const ReservationDetailsPanel({
    super.key,
    required this.package,
    required this.selectedPax,
    required this.onPaxSelected,
    required this.selectedTime,
    required this.onTimeSelected,
    required this.paymentMethod,
    required this.onPaymentMethodSelected,
  });

  @override
  Widget build(BuildContext context) {
    final paxList = (package.paxOptions != null && package.paxOptions!.isNotEmpty)
        ? package.paxOptions!
        : [20, 30, 50, 75, 100];

    final timeSlots = [
      '10:00 AM - 1:00 PM',
      '2:00 PM - 5:00 PM',
      '6:00 PM - 9:00 PM',
    ];

    final paymentMethods = [
      {'id': 'gcash', 'label': 'GCash', 'color': const Color(0xFF007DFE)},
      {'id': 'card', 'label': 'VISA / MC', 'color': const Color(0xFFEB001B)},
      {'id': 'maya', 'label': 'Maya', 'color': const Color(0xFF00B14F)},
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // ========================================================
        // 1. PACKAGE SUMMARY CARD
        // ========================================================
        Container(
          width: double.infinity,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: const Color(0x4D99868C), width: 1.0),
            boxShadow: [
              BoxShadow(
                color: plum.withValues(alpha: 0.06),
                blurRadius: 18,
                offset: const Offset(0, 6),
              ),
            ],
          ),
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: cream,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: const Icon(
                      Icons.card_giftcard_rounded,
                      color: plum,
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
                          style: const TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w700,
                            color: plum,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 2),
                        Text(
                          'Starting at ₱${(package.price ?? 4500.0).toStringAsFixed(2)}',
                          style: const TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                            color: mutedPlum,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              if (package.description != null && package.description!.isNotEmpty) ...[
                const SizedBox(height: 10),
                Text(
                  package.description!,
                  style: const TextStyle(
                    fontSize: 12,
                    color: Color(0xDE6A4053),
                    height: 1.35,
                  ),
                ),
              ],
            ],
          ),
        ),

        const SizedBox(height: 14),

        // ========================================================
        // 2. CHOOSE AVAILABLE PAX
        // ========================================================
        Container(
          width: double.infinity,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: const Color(0x4D99868C), width: 1.0),
            boxShadow: [
              BoxShadow(
                color: plum.withValues(alpha: 0.06),
                blurRadius: 18,
                offset: const Offset(0, 6),
              ),
            ],
          ),
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: cream,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: const Icon(
                      Icons.people_outline_rounded,
                      color: plum,
                      size: 20,
                    ),
                  ),
                  const SizedBox(width: 10),
                  const Flexible(
                    child: Text(
                      '2. Choose Available Pax',
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w700,
                        color: plum,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: paxList.map((pax) {
                  final isSelected = selectedPax == pax;
                  return InkWell(
                    onTap: () => onPaxSelected(pax),
                    borderRadius: BorderRadius.circular(9999),
                    mouseCursor: SystemMouseCursors.click,
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 200),
                      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                      decoration: BoxDecoration(
                        color: isSelected ? plum : cream,
                        borderRadius: BorderRadius.circular(9999),
                        border: Border.all(
                          color: isSelected ? plum : const Color(0x4D99868C),
                          width: isSelected ? 1.5 : 1.0,
                        ),
                        boxShadow: isSelected
                            ? [
                                BoxShadow(
                                  color: plum.withValues(alpha: 0.25),
                                  blurRadius: 6,
                                  offset: const Offset(0, 2),
                                ),
                              ]
                            : null,
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            isSelected ? Icons.check_circle_rounded : Icons.person_rounded,
                            size: 13,
                            color: isSelected ? Colors.white : plum,
                          ),
                          const SizedBox(width: 5),
                          Text(
                            '$pax Pax',
                            style: TextStyle(
                              fontSize: 11,
                              fontWeight: isSelected ? FontWeight.w700 : FontWeight.w600,
                              color: isSelected ? Colors.white : plum,
                            ),
                          ),
                        ],
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
        // 3. SELECT TIME SLOT
        // ========================================================
        Container(
          width: double.infinity,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: const Color(0x4D99868C), width: 1.0),
            boxShadow: [
              BoxShadow(
                color: plum.withValues(alpha: 0.06),
                blurRadius: 18,
                offset: const Offset(0, 6),
              ),
            ],
          ),
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: cream,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: const Icon(
                      Icons.schedule_rounded,
                      color: plum,
                      size: 20,
                    ),
                  ),
                  const SizedBox(width: 10),
                  const Flexible(
                    child: Text(
                      '3. Select Time Slot',
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w700,
                        color: plum,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Column(
                children: timeSlots.map((time) {
                  final isSelected = selectedTime == time;
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 6),
                    child: InkWell(
                      onTap: () => onTimeSelected(time),
                      borderRadius: BorderRadius.circular(12),
                      mouseCursor: SystemMouseCursors.click,
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 200),
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                        decoration: BoxDecoration(
                          color: isSelected
                              ? plum.withValues(alpha: 0.08)
                              : cream.withValues(alpha: 0.5),
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color: isSelected ? plum : const Color(0x3399868C),
                            width: isSelected ? 1.5 : 1.0,
                          ),
                        ),
                        child: Row(
                          children: [
                            Icon(
                              isSelected
                                  ? Icons.radio_button_checked_rounded
                                  : Icons.radio_button_unchecked_rounded,
                              size: 16,
                              color: isSelected ? plum : mutedPlum,
                            ),
                            const SizedBox(width: 8),
                            Expanded(
                              child: Text(
                                time,
                                style: TextStyle(
                                  fontSize: 12,
                                  fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
                                  color: plum,
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                            if (isSelected)
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                                decoration: BoxDecoration(
                                  color: plum,
                                  borderRadius: BorderRadius.circular(9999),
                                ),
                                child: const Text(
                                  'Selected',
                                  style: TextStyle(
                                    fontSize: 9,
                                    fontWeight: FontWeight.w600,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                          ],
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
        // 4. CHOOSE PAYMENT METHOD
        // ========================================================
        Container(
          width: double.infinity,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: const Color(0x4D99868C), width: 1.0),
            boxShadow: [
              BoxShadow(
                color: plum.withValues(alpha: 0.06),
                blurRadius: 18,
                offset: const Offset(0, 6),
              ),
            ],
          ),
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: cream,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: const Icon(
                      Icons.payment_rounded,
                      color: plum,
                      size: 20,
                    ),
                  ),
                  const SizedBox(width: 10),
                  const Flexible(
                    child: Text(
                      '4. Payment Method',
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w700,
                        color: plum,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Row(
                children: paymentMethods.map((method) {
                  final isSelected = (paymentMethod ?? 'gcash') == method['id'];
                  return Expanded(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 3),
                      child: InkWell(
                        onTap: () => onPaymentMethodSelected(method['id'] as String),
                        borderRadius: BorderRadius.circular(12),
                        mouseCursor: SystemMouseCursors.click,
                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 200),
                          padding: const EdgeInsets.symmetric(vertical: 10),
                          decoration: BoxDecoration(
                            color: isSelected ? cream : Colors.white,
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(
                              color: isSelected ? plum : const Color(0x3399868C),
                              width: isSelected ? 1.5 : 1.0,
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
                    ),
                  );
                }).toList(),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
