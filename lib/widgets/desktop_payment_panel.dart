import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../models/index.dart';

/// Desktop & Tablet Payment Panel for INEA Scents reservation flow.
///
/// Replaces the left (Calendar) and middle (Details) columns during the payment
/// step on wide viewports (>=1024px) via an in-place cross-fade transition.
class DesktopPaymentPanel extends StatefulWidget {
  static const Color plum = Color(0xFF6A4053);
  static const Color mutedPlum = Color(0xFF99868C);
  static const Color cream = Color(0xFFFDF4F5);

  final Package package;
  final DateTime? selectedDate;
  final String? selectedTime;
  final int? selectedPax;
  final String? paymentMethod;
  final ValueChanged<String> onPaymentMethodSelected;
  final VoidCallback? onBackToReservation;

  const DesktopPaymentPanel({
    super.key,
    required this.package,
    this.selectedDate,
    this.selectedTime,
    this.selectedPax,
    required this.paymentMethod,
    required this.onPaymentMethodSelected,
    this.onBackToReservation,
  });

  @override
  State<DesktopPaymentPanel> createState() => _DesktopPaymentPanelState();
}

class _DesktopPaymentPanelState extends State<DesktopPaymentPanel> {
  late TextEditingController _cardNumberController;
  late TextEditingController _cardHolderController;
  late TextEditingController _expiryController;
  late TextEditingController _cvvController;
  late TextEditingController _gcashPhoneController;
  late TextEditingController _gcashNameController;
  late TextEditingController _mayaPhoneController;
  late TextEditingController _mayaNameController;
  late TextEditingController _customerNameController;
  late TextEditingController _customerEmailController;
  late TextEditingController _customerPhoneController;
  late TextEditingController _venueAddressController;

  @override
  void initState() {
    super.initState();
    _cardNumberController = TextEditingController();
    _cardHolderController = TextEditingController();
    _expiryController = TextEditingController();
    _cvvController = TextEditingController();
    _gcashPhoneController = TextEditingController();
    _gcashNameController = TextEditingController();
    _mayaPhoneController = TextEditingController();
    _mayaNameController = TextEditingController();
    _customerNameController = TextEditingController();
    _customerEmailController = TextEditingController();
    _customerPhoneController = TextEditingController();
    _venueAddressController = TextEditingController();
  }

  @override
  void dispose() {
    _cardNumberController.dispose();
    _cardHolderController.dispose();
    _expiryController.dispose();
    _cvvController.dispose();
    _gcashPhoneController.dispose();
    _gcashNameController.dispose();
    _mayaPhoneController.dispose();
    _mayaNameController.dispose();
    _customerNameController.dispose();
    _customerEmailController.dispose();
    _customerPhoneController.dispose();
    _venueAddressController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final effectivePrice = widget.package.price ?? 4500.0;
    final activeMethod = widget.paymentMethod ?? 'gcash';

    final paymentMethods = [
      {
        'id': 'gcash',
        'label': 'GCash',
        'sublabel': 'E-Wallet',
        'color': const Color(0xFF007DFE),
        'icon': Icons.account_balance_wallet_rounded,
      },
      {
        'id': 'card',
        'label': 'Credit / Debit Card',
        'sublabel': 'VISA / Mastercard',
        'color': const Color(0xFFEB001B),
        'icon': Icons.credit_card_rounded,
      },
      {
        'id': 'maya',
        'label': 'Maya',
        'sublabel': 'Digital Bank',
        'color': const Color(0xFF00B14F),
        'icon': Icons.phone_android_rounded,
      },
    ];

    return LayoutBuilder(
      builder: (context, constraints) {
        final isNarrow = constraints.maxWidth < 480;

        return SingleChildScrollView(
          key: const Key('desktop_payment_scroll_view'),
          physics: const BouncingScrollPhysics(),
          padding: const EdgeInsets.fromLTRB(16, 8, 8, 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // ========================================================
              // 1. PAYMENT HEADER & NAVIGATION BANNER
              // ========================================================
              Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: const Color(0x4D99868C), width: 1.0),
                  boxShadow: [
                    BoxShadow(
                      color: DesktopPaymentPanel.plum.withValues(alpha: 0.06),
                      blurRadius: 18,
                      offset: const Offset(0, 6),
                    ),
                  ],
                ),
                padding: const EdgeInsets.all(16),
                child: isNarrow
                    ? Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Container(
                                padding: const EdgeInsets.all(10),
                                decoration: BoxDecoration(
                                  color: DesktopPaymentPanel.cream,
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: const Icon(
                                  Icons.lock_outline_rounded,
                                  color: DesktopPaymentPanel.plum,
                                  size: 22,
                                ),
                              ),
                              const SizedBox(width: 12),
                              const Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'Payment & Checkout Details',
                                      style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.w700,
                                        color: DesktopPaymentPanel.plum,
                                      ),
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                    SizedBox(height: 2),
                                    Text(
                                      'Select payment method and enter details to complete your reservation.',
                                      style: TextStyle(
                                        fontSize: 12,
                                        color: DesktopPaymentPanel.mutedPlum,
                                      ),
                                      maxLines: 2,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                          if (widget.onBackToReservation != null) ...[
                            const SizedBox(height: 10),
                            Align(
                              alignment: Alignment.centerRight,
                              child: OutlinedButton.icon(
                                onPressed: widget.onBackToReservation,
                                icon: const Icon(Icons.arrow_back_rounded, size: 15, color: DesktopPaymentPanel.plum),
                                label: const Text(
                                  'Edit Selection',
                                  style: TextStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.w600,
                                    color: DesktopPaymentPanel.plum,
                                  ),
                                ),
                                style: OutlinedButton.styleFrom(
                                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                                  side: const BorderSide(color: Color(0x4D99868C)),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(9999),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ],
                      )
                    : Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(10),
                            decoration: BoxDecoration(
                              color: DesktopPaymentPanel.cream,
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: const Icon(
                              Icons.lock_outline_rounded,
                              color: DesktopPaymentPanel.plum,
                              size: 22,
                            ),
                          ),
                          const SizedBox(width: 12),
                          const Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Payment & Checkout Details',
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w700,
                                    color: DesktopPaymentPanel.plum,
                                  ),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                                SizedBox(height: 2),
                                Text(
                                  'Select payment method and enter details to complete your reservation.',
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: DesktopPaymentPanel.mutedPlum,
                                  ),
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ],
                            ),
                          ),
                          if (widget.onBackToReservation != null) ...[
                            const SizedBox(width: 8),
                            OutlinedButton.icon(
                              onPressed: widget.onBackToReservation,
                              icon: const Icon(Icons.arrow_back_rounded, size: 15, color: DesktopPaymentPanel.plum),
                              label: const Text(
                                'Edit Selection',
                                style: TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w600,
                                  color: DesktopPaymentPanel.plum,
                                ),
                              ),
                              style: OutlinedButton.styleFrom(
                                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                                side: const BorderSide(color: Color(0x4D99868C)),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(9999),
                                ),
                              ),
                            ),
                          ],
                        ],
                      ),
              ),

              const SizedBox(height: 14),

              // ========================================================
              // 2. PAYMENT METHOD SELECTION
              // ========================================================
              Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: const Color(0x4D99868C), width: 1.0),
                  boxShadow: [
                    BoxShadow(
                      color: DesktopPaymentPanel.plum.withValues(alpha: 0.06),
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
                            color: DesktopPaymentPanel.cream,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: const Icon(
                            Icons.payment_rounded,
                            color: DesktopPaymentPanel.plum,
                            size: 20,
                          ),
                        ),
                        const SizedBox(width: 10),
                        const Expanded(
                          child: Text(
                            '1. Select Payment Method',
                            style: TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.w700,
                              color: DesktopPaymentPanel.plum,
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
                              onTap: () => widget.onPaymentMethodSelected(method['id'] as String),
                              borderRadius: BorderRadius.circular(14),
                              mouseCursor: SystemMouseCursors.click,
                              child: AnimatedContainer(
                                duration: const Duration(milliseconds: 200),
                                padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 6),
                                decoration: BoxDecoration(
                                  color: isSelected
                                      ? methodColor.withValues(alpha: 0.08)
                                      : DesktopPaymentPanel.cream.withValues(alpha: 0.4),
                                  borderRadius: BorderRadius.circular(14),
                                  border: Border.all(
                                    color: isSelected ? methodColor : const Color(0x3399868C),
                                    width: isSelected ? 2.0 : 1.0,
                                  ),
                                  boxShadow: isSelected
                                      ? [
                                          BoxShadow(
                                            color: methodColor.withValues(alpha: 0.18),
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
                                      color: isSelected ? methodColor : DesktopPaymentPanel.mutedPlum,
                                      size: 22,
                                    ),
                                    const SizedBox(height: 4),
                                    Text(
                                      method['label'] as String,
                                      style: TextStyle(
                                        fontSize: 11,
                                        fontWeight: FontWeight.w700,
                                        color: isSelected ? methodColor : DesktopPaymentPanel.plum,
                                      ),
                                      textAlign: TextAlign.center,
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                    const SizedBox(height: 2),
                                    Text(
                                      method['sublabel'] as String,
                                      style: const TextStyle(
                                        fontSize: 9,
                                        color: DesktopPaymentPanel.mutedPlum,
                                      ),
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                    const SizedBox(height: 4),
                                    Icon(
                                      isSelected
                                          ? Icons.check_circle_rounded
                                          : Icons.radio_button_unchecked_rounded,
                                      size: 14,
                                      color: isSelected ? methodColor : const Color(0x4D99868C),
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
              // 3. PAYMENT METHOD INPUT FIELDS
              // ========================================================
              Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: const Color(0x4D99868C), width: 1.0),
                  boxShadow: [
                    BoxShadow(
                      color: DesktopPaymentPanel.plum.withValues(alpha: 0.06),
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
                            color: DesktopPaymentPanel.cream,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: const Icon(
                            Icons.edit_note_rounded,
                            color: DesktopPaymentPanel.plum,
                            size: 20,
                          ),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: Text(
                            activeMethod == 'card'
                                ? '2. Card Details'
                                : activeMethod == 'gcash'
                                    ? '2. GCash Account Details'
                                    : '2. Maya Account Details',
                            style: const TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.w700,
                              color: DesktopPaymentPanel.plum,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 14),

                    if (activeMethod == 'card') ...[
                      _buildInputField(
                        label: 'Cardholder Full Name',
                        hint: 'e.g. Maria Santos',
                        controller: _cardHolderController,
                        keyName: 'payment_cardholder_name',
                        icon: Icons.person_outline_rounded,
                        textInputAction: TextInputAction.next,
                      ),
                      const SizedBox(height: 12),
                      _buildInputField(
                        label: 'Card Number',
                        hint: '4123 4567 8901 2345',
                        controller: _cardNumberController,
                        keyName: 'payment_card_number',
                        icon: Icons.credit_card_rounded,
                        keyboardType: TextInputType.number,
                        textInputAction: TextInputAction.next,
                        inputFormatters: [
                          FilteringTextInputFormatter.allow(RegExp(r'[0-9 ]')),
                          LengthLimitingTextInputFormatter(19),
                        ],
                      ),
                      const SizedBox(height: 12),
                      if (isNarrow) ...[
                        _buildInputField(
                          label: 'Expiration Date',
                          hint: 'MM / YY',
                          controller: _expiryController,
                          keyName: 'payment_card_expiry',
                          icon: Icons.calendar_today_outlined,
                          keyboardType: TextInputType.datetime,
                          textInputAction: TextInputAction.next,
                          inputFormatters: [
                            LengthLimitingTextInputFormatter(5),
                          ],
                        ),
                        const SizedBox(height: 12),
                        _buildInputField(
                          label: 'Security Code (CVV)',
                          hint: '123',
                          controller: _cvvController,
                          keyName: 'payment_card_cvv',
                          icon: Icons.lock_outline_rounded,
                          keyboardType: TextInputType.number,
                          textInputAction: TextInputAction.next,
                          obscureText: true,
                          inputFormatters: [
                            FilteringTextInputFormatter.digitsOnly,
                            LengthLimitingTextInputFormatter(4),
                          ],
                        ),
                      ] else
                        Row(
                          children: [
                            Expanded(
                              child: _buildInputField(
                                label: 'Expiration Date',
                                hint: 'MM / YY',
                                controller: _expiryController,
                                keyName: 'payment_card_expiry',
                                icon: Icons.calendar_today_outlined,
                                keyboardType: TextInputType.datetime,
                                textInputAction: TextInputAction.next,
                                inputFormatters: [
                                  LengthLimitingTextInputFormatter(5),
                                ],
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: _buildInputField(
                                label: 'Security Code (CVV)',
                                hint: '123',
                                controller: _cvvController,
                                keyName: 'payment_card_cvv',
                                icon: Icons.lock_outline_rounded,
                                keyboardType: TextInputType.number,
                                textInputAction: TextInputAction.next,
                                obscureText: true,
                                inputFormatters: [
                                  FilteringTextInputFormatter.digitsOnly,
                                  LengthLimitingTextInputFormatter(4),
                                ],
                              ),
                            ),
                          ],
                        ),
                    ] else if (activeMethod == 'gcash') ...[
                      _buildInputField(
                        label: 'GCash Mobile Number',
                        hint: '09XX XXX XXXX',
                        controller: _gcashPhoneController,
                        keyName: 'payment_gcash_phone',
                        icon: Icons.phone_android_rounded,
                        keyboardType: TextInputType.phone,
                        textInputAction: TextInputAction.next,
                        inputFormatters: [
                          FilteringTextInputFormatter.allow(RegExp(r'[0-9+\- ()]')),
                          LengthLimitingTextInputFormatter(20),
                        ],
                      ),
                      const SizedBox(height: 12),
                      _buildInputField(
                        label: 'Account Full Name',
                        hint: 'Registered GCash Account Name',
                        controller: _gcashNameController,
                        keyName: 'payment_gcash_name',
                        icon: Icons.person_outline_rounded,
                        textInputAction: TextInputAction.next,
                      ),
                      const SizedBox(height: 12),
                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: const Color(0xFF007DFE).withValues(alpha: 0.08),
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: const Color(0xFF007DFE).withValues(alpha: 0.25)),
                        ),
                        child: Row(
                          children: [
                            const Icon(Icons.info_outline_rounded, size: 18, color: Color(0xFF007DFE)),
                            const SizedBox(width: 10),
                            Expanded(
                              child: Text(
                                'You will receive an authorization prompt for ₱${effectivePrice.toStringAsFixed(2)} to complete this booking.',
                                style: const TextStyle(fontSize: 12, color: Color(0xFF007DFE), fontWeight: FontWeight.w500),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ] else ...[
                      _buildInputField(
                        label: 'Maya Mobile Number',
                        hint: '09XX XXX XXXX',
                        controller: _mayaPhoneController,
                        keyName: 'payment_maya_phone',
                        icon: Icons.phone_android_rounded,
                        keyboardType: TextInputType.phone,
                        textInputAction: TextInputAction.next,
                        inputFormatters: [
                          FilteringTextInputFormatter.allow(RegExp(r'[0-9+\- ()]')),
                          LengthLimitingTextInputFormatter(20),
                        ],
                      ),
                      const SizedBox(height: 12),
                      _buildInputField(
                        label: 'Account Full Name',
                        hint: 'Registered Maya Account Name',
                        controller: _mayaNameController,
                        keyName: 'payment_maya_name',
                        icon: Icons.person_outline_rounded,
                        textInputAction: TextInputAction.next,
                      ),
                      const SizedBox(height: 12),
                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: const Color(0xFF00B14F).withValues(alpha: 0.08),
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: const Color(0xFF00B14F).withValues(alpha: 0.25)),
                        ),
                        child: Row(
                          children: [
                            const Icon(Icons.info_outline_rounded, size: 18, color: Color(0xFF00B14F)),
                            const SizedBox(width: 10),
                            Expanded(
                              child: Text(
                                'You will receive a prompt in your Maya app to approve ₱${effectivePrice.toStringAsFixed(2)}.',
                                style: const TextStyle(fontSize: 12, color: Color(0xFF00B14F), fontWeight: FontWeight.w500),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ],
                ),
              ),

              const SizedBox(height: 14),

              // ========================================================
              // 4. BILLING & EVENT CONTACT INFORMATION
              // ========================================================
              Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: const Color(0x4D99868C), width: 1.0),
                  boxShadow: [
                    BoxShadow(
                      color: DesktopPaymentPanel.plum.withValues(alpha: 0.06),
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
                            color: DesktopPaymentPanel.cream,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: const Icon(
                            Icons.contacts_rounded,
                            color: DesktopPaymentPanel.plum,
                            size: 20,
                          ),
                        ),
                        const SizedBox(width: 10),
                        const Expanded(
                          child: Text(
                            '3. Contact & Venue Information',
                            style: TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.w700,
                              color: DesktopPaymentPanel.plum,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 14),
                    if (isNarrow) ...[
                      _buildInputField(
                        label: 'Full Name',
                        hint: 'Customer Name',
                        controller: _customerNameController,
                        keyName: 'payment_customer_name',
                        icon: Icons.person_outline_rounded,
                        textInputAction: TextInputAction.next,
                      ),
                      const SizedBox(height: 12),
                      _buildInputField(
                        label: 'Email Address',
                        hint: 'name@example.com',
                        controller: _customerEmailController,
                        keyName: 'payment_customer_email',
                        icon: Icons.email_outlined,
                        keyboardType: TextInputType.emailAddress,
                        textInputAction: TextInputAction.next,
                      ),
                      const SizedBox(height: 12),
                      _buildInputField(
                        label: 'Contact Phone',
                        hint: '+63 9XX XXX XXXX',
                        controller: _customerPhoneController,
                        keyName: 'payment_customer_phone',
                        icon: Icons.phone_outlined,
                        keyboardType: TextInputType.phone,
                        textInputAction: TextInputAction.next,
                        inputFormatters: [
                          FilteringTextInputFormatter.allow(RegExp(r'[0-9+\- ()]')),
                          LengthLimitingTextInputFormatter(20),
                        ],
                      ),
                      const SizedBox(height: 12),
                      _buildInputField(
                        label: 'Event Venue / Address',
                        hint: 'e.g. Grand Ballroom, Makati',
                        controller: _venueAddressController,
                        keyName: 'payment_venue_address',
                        icon: Icons.location_on_outlined,
                        textInputAction: TextInputAction.done,
                      ),
                    ] else ...[
                      Row(
                        children: [
                          Expanded(
                            child: _buildInputField(
                              label: 'Full Name',
                              hint: 'Customer Name',
                              controller: _customerNameController,
                              keyName: 'payment_customer_name',
                              icon: Icons.person_outline_rounded,
                              textInputAction: TextInputAction.next,
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: _buildInputField(
                              label: 'Email Address',
                              hint: 'name@example.com',
                              controller: _customerEmailController,
                              keyName: 'payment_customer_email',
                              icon: Icons.email_outlined,
                              keyboardType: TextInputType.emailAddress,
                              textInputAction: TextInputAction.next,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      Row(
                        children: [
                          Expanded(
                            child: _buildInputField(
                              label: 'Contact Phone',
                              hint: '+63 9XX XXX XXXX',
                              controller: _customerPhoneController,
                              keyName: 'payment_customer_phone',
                              icon: Icons.phone_outlined,
                              keyboardType: TextInputType.phone,
                              textInputAction: TextInputAction.next,
                              inputFormatters: [
                                FilteringTextInputFormatter.allow(RegExp(r'[0-9+\- ()]')),
                                LengthLimitingTextInputFormatter(20),
                              ],
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: _buildInputField(
                              label: 'Event Venue / Address',
                              hint: 'e.g. Grand Ballroom, Makati',
                              controller: _venueAddressController,
                              keyName: 'payment_venue_address',
                              icon: Icons.location_on_outlined,
                              textInputAction: TextInputAction.done,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ],
                ),
              ),

              const SizedBox(height: 14),

              // ========================================================
              // 5. SECURITY & TRUST BADGES
              // ========================================================
              Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                decoration: BoxDecoration(
                  color: DesktopPaymentPanel.cream,
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(color: const Color(0x3399868C)),
                ),
                child: const Wrap(
                  alignment: WrapAlignment.center,
                  spacing: 16,
                  runSpacing: 8,
                  crossAxisAlignment: WrapCrossAlignment.center,
                  children: [
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.shield_rounded, size: 16, color: Color(0xFF16A34A)),
                        SizedBox(width: 6),
                        Flexible(
                          child: Text(
                            '256-Bit SSL Encrypted',
                            style: TextStyle(
                              fontSize: 11,
                              fontWeight: FontWeight.w600,
                              color: DesktopPaymentPanel.plum,
                            ),
                          ),
                        ),
                      ],
                    ),
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.verified_user_rounded, size: 16, color: Color(0xFF16A34A)),
                        SizedBox(width: 6),
                        Flexible(
                          child: Text(
                            'Verified Merchant',
                            style: TextStyle(
                              fontSize: 11,
                              fontWeight: FontWeight.w600,
                              color: DesktopPaymentPanel.plum,
                            ),
                          ),
                        ),
                      ],
                    ),
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.lock_rounded, size: 16, color: Color(0xFF16A34A)),
                        SizedBox(width: 6),
                        Flexible(
                          child: Text(
                            '100% Secure Checkout',
                            style: TextStyle(
                              fontSize: 11,
                              fontWeight: FontWeight.w600,
                              color: DesktopPaymentPanel.plum,
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
      },
    );
  }

  Widget _buildInputField({
    required String label,
    required String hint,
    required TextEditingController controller,
    required String keyName,
    required IconData icon,
    TextInputType? keyboardType,
    TextInputAction? textInputAction = TextInputAction.next,
    List<TextInputFormatter>? inputFormatters,
    bool obscureText = false,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w600,
            color: DesktopPaymentPanel.plum,
          ),
        ),
        const SizedBox(height: 6),
        Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: const Color(0x3399868C)),
          ),
          child: TextField(
            key: Key(keyName),
            controller: controller,
            keyboardType: keyboardType,
            textInputAction: textInputAction,
            inputFormatters: inputFormatters,
            obscureText: obscureText,
            style: const TextStyle(
              fontSize: 13,
              color: DesktopPaymentPanel.plum,
              fontWeight: FontWeight.w500,
            ),
            decoration: InputDecoration(
              hintText: hint,
              hintStyle: const TextStyle(
                fontSize: 12,
                color: DesktopPaymentPanel.mutedPlum,
              ),
              prefixIcon: Icon(icon, size: 18, color: DesktopPaymentPanel.plum),
              border: InputBorder.none,
              contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
            ),
          ),
        ),
      ],
    );
  }
}
