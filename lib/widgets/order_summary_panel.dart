import 'package:flutter/material.dart';
import '../models/index.dart';

/// A sticky floating Order Summary side-panel designed for desktop (3-column)
/// and tablet (2-column) reservation flows in INEA Scents.
class OrderSummaryPanel extends StatelessWidget {
  static const Color plum = Color(0xFF6A4053);
  static const Color mutedPlum = Color(0xFF99868C);
  static const Color cream = Color(0xFFFDF4F5);

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

  static String _paymentMethodLabel(String id) {
    return switch (id) {
      'credit_card' => 'CARD',
      'cash' => 'CASH',
      'bank_transfer' => 'BANK TRANSFER',
      _ => id.toUpperCase(),
    };
  }

  @override
  Widget build(BuildContext context) {
    final effectivePrice = package.priceForPax(selectedPax);

    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: const Color(0x4D99868C), width: 1.0),
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
          // ========================================================
          // PANEL HEADER
          // ========================================================
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: cream,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const Icon(
                  Icons.receipt_long_rounded,
                  color: plum,
                  size: 20,
                ),
              ),
              const SizedBox(width: 8),
              const Expanded(
                child: Text(
                  'Order Summary',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                    color: plum,
                    letterSpacing: 0.2,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              const SizedBox(width: 6),
              Flexible(
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 3,
                  ),
                  decoration: BoxDecoration(
                    color: const Color(0xFF22C55E).withValues(alpha: 0.12),
                    borderRadius: BorderRadius.circular(9999),
                  ),
                  child: const Text(
                    'Live Preview',
                    style: TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF16A34A),
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 12),

          // ========================================================
          // PACKAGE CARD PREVIEW
          // ========================================================
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: cream.withValues(alpha: 0.6),
              borderRadius: BorderRadius.circular(14),
              border: Border.all(color: const Color(0x2699868C)),
            ),
            child: Row(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: Container(
                    width: 48,
                    height: 48,
                    color: const Color(0xFFF3EBE1),
                    child:
                        (package.images != null && package.images!.isNotEmpty)
                        ? Image.network(
                            package.images!.first,
                            fit: BoxFit.cover,
                            errorBuilder: (context, error, stackTrace) =>
                                const Icon(
                                  Icons.local_florist,
                                  color: plum,
                                  size: 24,
                                ),
                          )
                        : const Icon(
                            Icons.local_florist,
                            color: plum,
                            size: 24,
                          ),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        package.name ?? 'Perfume Package',
                        style: const TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w700,
                          color: plum,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 2),
                      Row(
                        children: [
                          const Icon(
                            Icons.star_rounded,
                            size: 13,
                            color: Colors.amber,
                          ),
                          const SizedBox(width: 3),
                          Expanded(
                            child: Text(
                              '${package.rating ?? 4.8} (${package.reviewsCount ?? 140})',
                              style: const TextStyle(
                                fontSize: 11,
                                color: mutedPlum,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 2),
                      Text(
                        '₱${effectivePrice.toStringAsFixed(2)}',
                        style: const TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w700,
                          color: plum,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 12),

          // ========================================================
          // SELECTED SCHEDULE / DETAILS BADGES
          // ========================================================
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: const Color(0x3399868C)),
            ),
            child: Column(
              children: [
                _buildDetailRow(
                  icon: Icons.calendar_today_rounded,
                  label: 'Date',
                  value: _formatDate(selectedDate),
                  isEmphasized: selectedDate != null,
                ),
                const Divider(color: Color(0x1F99868C), height: 8),
                _buildDetailRow(
                  icon: Icons.access_time_rounded,
                  label: 'Time',
                  value: TimeSlot.display(selectedTime),
                  isEmphasized: selectedTime != null,
                ),
                const Divider(color: Color(0x1F99868C), height: 8),
                _buildDetailRow(
                  icon: Icons.people_outline_rounded,
                  label: 'Capacity',
                  value: '${selectedPax ?? 50} Pax',
                  isEmphasized: selectedPax != null,
                ),
              ],
            ),
          ),

          const SizedBox(height: 12),

          // ========================================================
          // BREAKDOWN LINE ITEMS (DOTTED LEADERS)
          // ========================================================
          const Text(
            'Price Breakdown',
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w600,
              color: plum,
            ),
          ),
          _buildDottedLineItem(
            'Base Package',
            '₱${effectivePrice.toStringAsFixed(2)}',
          ),
          if (package.inclusions != null && package.inclusions!.isNotEmpty)
            ...package.inclusions!.map(
              (inc) => _buildDottedLineItem(inc, 'Included'),
            )
          else ...[
            _buildDottedLineItem('Customized Logo', 'Included'),
            _buildDottedLineItem('4 Signature Scents', 'Included'),
            _buildDottedLineItem('2 Event Staff', 'Included'),
          ],
          if (package.freebies != null && package.freebies!.isNotEmpty)
            ...package.freebies!.map((fb) => _buildDottedLineItem(fb, 'Free'))
          else
            _buildDottedLineItem('Selfie Mirror', 'Free'),

          const Padding(
            padding: EdgeInsets.symmetric(vertical: 8),
            child: Divider(color: Color(0x3399868C), thickness: 1),
          ),

          // ========================================================
          // PAYMENT METHOD PREVIEW
          // ========================================================
          if (paymentMethod != null) ...[
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Flexible(
                  child: Text(
                    'Payment:',
                    style: TextStyle(fontSize: 12, color: mutedPlum),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                const SizedBox(width: 8),
                Flexible(
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 2,
                    ),
                    decoration: BoxDecoration(
                      color: cream,
                      borderRadius: BorderRadius.circular(6),
                      border: Border.all(color: const Color(0x3399868C)),
                    ),
                    child: Text(
                      _paymentMethodLabel(paymentMethod!),
                      style: const TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.w700,
                        color: plum,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
          ],

          // ========================================================
          // TOTAL AMOUNT ROW
          // ========================================================
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Flexible(
                child: Text(
                  'Total Amount',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                    color: plum,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              const SizedBox(width: 8),
              Flexible(
                child: Text(
                  'Php. ${effectivePrice.toStringAsFixed(2)}',
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w800,
                    color: plum,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),

          const SizedBox(height: 14),

          // ========================================================
          // ACTION BUTTON (STICKY CTA)
          // ========================================================
          SizedBox(
            width: double.infinity,
            height: 46,
            child: ElevatedButton(
              onPressed: isLoading ? null : onProceed,
              style: ElevatedButton.styleFrom(
                backgroundColor: plum,
                foregroundColor: Colors.white,
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

  Widget _buildDetailRow({
    required IconData icon,
    required String label,
    required String value,
    required bool isEmphasized,
  }) {
    return Row(
      children: [
        Icon(icon, size: 14, color: isEmphasized ? plum : mutedPlum),
        const SizedBox(width: 6),
        Text(label, style: const TextStyle(fontSize: 11, color: mutedPlum)),
        const SizedBox(width: 8),
        Expanded(
          child: Text(
            value,
            textAlign: TextAlign.end,
            style: TextStyle(
              fontSize: 11,
              fontWeight: isEmphasized ? FontWeight.w600 : FontWeight.normal,
              color: isEmphasized ? plum : mutedPlum,
            ),
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }

  Widget _buildDottedLineItem(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2.5),
      child: Row(
        children: [
          Flexible(
            flex: 6,
            child: Text(
              '• $label',
              style: const TextStyle(fontSize: 11, color: plum),
              overflow: TextOverflow.ellipsis,
            ),
          ),
          const SizedBox(width: 4),
          Expanded(
            flex: 3,
            child: LayoutBuilder(
              builder: (context, constraints) {
                final count = (constraints.maxWidth / 10).floor().clamp(1, 30);
                return ClipRect(
                  child: Text(
                    '. ' * count,
                    maxLines: 1,
                    overflow: TextOverflow.clip,
                    style: const TextStyle(
                      color: Color(0x5999868C),
                      fontSize: 9,
                    ),
                  ),
                );
              },
            ),
          ),
          const SizedBox(width: 4),
          Flexible(
            flex: 3,
            child: Text(
              value,
              textAlign: TextAlign.end,
              style: const TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.w500,
                color: plum,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }
}
