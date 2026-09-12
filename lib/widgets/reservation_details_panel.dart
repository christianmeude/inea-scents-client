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
    final options = package.options;
    final paxList = options.isNotEmpty
        ? options.map((t) => t.pax).toList()
        : (package.paxOptions ?? const <int>[]);

    String? optionPriceLabel(int pax) {
      if (options.isEmpty) return null;
      return '₱${package.priceForPax(pax).toStringAsFixed(0)}';
    }

    // Customer-facing methods only: Online (PayMongo) or Cash.
    final paymentMethods = [
      {
        'id': 'credit_card',
        'label': 'Online',
        'color': const Color(0xFFEB001B),
      },
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
              if (package.description != null &&
                  package.description!.isNotEmpty) ...[
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
                  final price = optionPriceLabel(pax);
                  return InkWell(
                    onTap: () => onPaxSelected(pax),
                    borderRadius: BorderRadius.circular(9999),
                    mouseCursor: SystemMouseCursors.click,
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 200),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 14,
                        vertical: 8,
                      ),
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
                            isSelected
                                ? Icons.check_circle_rounded
                                : Icons.person_rounded,
                            size: 13,
                            color: isSelected ? Colors.white : plum,
                          ),
                          const SizedBox(width: 5),
                          Text(
                            price == null ? '$pax PAX' : '$pax PAX · $price',
                            style: TextStyle(
                              fontSize: 11,
                              fontWeight: isSelected
                                  ? FontWeight.w700
                                  : FontWeight.w600,
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
                      '3. Choose Event Time',
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
              const SizedBox(height: 4),
              const Text(
                'One booking lasts 3–4 hrs.',
                style: TextStyle(fontSize: 12, color: mutedPlum),
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
                    color: cream.withValues(alpha: 0.5),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: const Color(0x3399868C)),
                  ),
                  child: Row(
                    children: [
                      const Icon(Icons.schedule_rounded, size: 16, color: plum),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          selectedTime == null
                              ? 'Select time'
                              : TimeSlot.display(selectedTime),
                          style: const TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w600,
                            color: plum,
                          ),
                        ),
                      ),
                      const Icon(
                        Icons.access_time_rounded,
                        size: 16,
                        color: mutedPlum,
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
              LayoutBuilder(
                builder: (context, constraints) {
                  final cardW = (constraints.maxWidth - 6) / 2;
                  return Wrap(
                    spacing: 6,
                    runSpacing: 6,
                    children: paymentMethods.map((method) {
                      final isSelected =
                          (paymentMethod ?? 'credit_card') == method['id'];
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
                              color: isSelected ? cream : Colors.white,
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(
                                color: isSelected
                                    ? plum
                                    : const Color(0x3399868C),
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
