import 'dart:async';

import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:url_launcher/url_launcher.dart';

import '../models/index.dart';
import '../providers/index.dart';
import '../src/utils/checkout_window.dart';
import '../widgets/index.dart';

/// Reservation and Booking Screen for INEA Scents.
///
/// Features:
/// - Desktop Split View (>1024px): 3-column layout (Left: Calendar, Middle: Packages/Times, Right: Sticky Order Summary).
/// - Tablet View (768px - 1024px): 2-column layout (Left: Calendar & Customization, Right: Order Summary).
/// - Mobile View (<768px): 1-column vertical step flow with timeline.
/// - Integrated seamlessly with [ResponsiveAppShell].
class BookingScreen extends ConsumerStatefulWidget {
  final int packageId;

  const BookingScreen({super.key, required this.packageId});

  @override
  ConsumerState<BookingScreen> createState() => _BookingScreenState();
}

class _BookingScreenState extends ConsumerState<BookingScreen> {
  static const Color plum = Color(0xFF6A4053);

  DateTime? _selectedDate;
  int? _selectedPax;
  String? _selectedTime;
  String? _paymentMethod = 'credit_card';
  final TextEditingController _customerNameController = TextEditingController();
  final TextEditingController _customerEmailController =
      TextEditingController();
  final TextEditingController _customerPhoneController =
      TextEditingController();
  final TextEditingController _venueAddressController = TextEditingController();

  /// Gesture-held checkout tab (web only). Opened synchronously in the
  /// Confirm tap so the browser grants the popup; navigated once the
  /// booking POST returns a checkout URL. Nulled after navigate/close —
  /// dispose only closes a tab we still own (never the PayMongo page).
  CheckoutWindow? _heldCheckoutTab;

  /// Re-entrancy guard: the provider's `isLoading` flips a frame after the
  /// tap, so a fast double-tap could otherwise POST two bookings.
  bool _submitting = false;

  int get _currentStep => ref.read(bookingFlowProvider).currentStep;

  @override
  void initState() {
    super.initState();
    // Fresh flow per package entry: drops a previous success/cancelled
    // screen or another package's state. In-flight same-package checkout
    // polling is preserved. Deferred post-frame: Riverpod forbids provider
    // writes inside initState; registered before _loadPackage's callback
    // so the reset lands before the new package is set.
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      ref
          .read(bookingFlowProvider.notifier)
          .ensureFreshForPackage(widget.packageId);
    });
    _selectedDate = DateTime.now().add(const Duration(days: 3));
    _selectedTime = '2:00 PM - 5:00 PM';
    _selectedPax = 50;
    _loadPackage();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      _prefillFromUser();
    });
  }

  @override
  void dispose() {
    _heldCheckoutTab?.close();
    _heldCheckoutTab = null;
    _customerNameController.dispose();
    _customerEmailController.dispose();
    _customerPhoneController.dispose();
    _venueAddressController.dispose();
    super.dispose();
  }

  void _prefillFromUser() {
    final user = ref.read(authProvider).user;
    if (user == null) return;
    _customerNameController.text = user.name ?? '';
    _customerEmailController.text = user.email ?? '';
    ref.read(bookingFlowProvider.notifier).prefillFromUser(user);
  }

  Future<void> _handleConfirmAndPay() async {
    if (_submitting) return;
    _submitting = true;
    try {
      final notifier = ref.read(bookingFlowProvider.notifier);
      // Web popup rule: window.open only survives inside the tap gesture.
      // The booking POST resolves seconds later, so hold a branded
      // placeholder tab now (online methods only) and navigate it below.
      // Null on mobile (url_launcher path) or when the open was blocked —
      // both fall back to _launchCheckoutUrl plus the recovery button.
      final online = isOnlinePaymentString(
        ref.read(bookingFlowProvider).paymentMethod,
      );
      _heldCheckoutTab?.close();
      _heldCheckoutTab = (kIsWeb && online) ? openCheckoutWindow() : null;
      final booking = await notifier.submitBooking();
      if (booking == null) {
        _heldCheckoutTab?.close();
        _heldCheckoutTab = null;
        final state = ref.read(bookingFlowProvider);
        if (state.errorMessage != null && mounted) {
          ScaffoldMessenger.of(context)
            ..clearSnackBars()
            ..showSnackBar(SnackBar(content: Text(state.errorMessage!)));
        }
        return;
      }
      final status = ref.read(bookingFlowProvider).checkoutStatus;
      notifier.goToStep(5);
      if (status == BookingCheckoutStatus.awaitingPayment) {
        final checkoutUrl = booking.checkoutUrl;
        if (checkoutUrl != null && checkoutUrl.isNotEmpty) {
          final held = _heldCheckoutTab;
          _heldCheckoutTab = null;
          if (held != null) {
            held.navigateTo(checkoutUrl);
          } else {
            unawaited(_launchCheckoutUrl(checkoutUrl));
          }
        } else {
          _heldCheckoutTab?.close();
          _heldCheckoutTab = null;
        }
        unawaited(notifier.startPolling());
      } else {
        // Offline methods never need the held tab.
        _heldCheckoutTab?.close();
        _heldCheckoutTab = null;
      }
    } finally {
      _submitting = false;
    }
  }

  /// Opens [checkoutUrl] in a new browser tab (external application), so
  /// the app — and its payment polling — stays alive underneath.
  /// Returns true when the platform accepted the launch. Never throws:
  /// a failure surfaces as a SnackBar with a copy-link action instead of
  /// stranding the user on the processing screen.
  Future<bool> _launchCheckoutUrl(String checkoutUrl) async {
    final uri = Uri.tryParse(checkoutUrl);
    if (uri == null || (!uri.isScheme('http') && !uri.isScheme('https'))) {
      _showCheckoutLaunchFailure(checkoutUrl);
      return false;
    }
    try {
      final launched = await launchUrl(
        uri,
        mode: LaunchMode.externalApplication,
      );
      if (!launched) _showCheckoutLaunchFailure(checkoutUrl);
      return launched;
    } catch (_) {
      _showCheckoutLaunchFailure(checkoutUrl);
      return false;
    }
  }

  void _showCheckoutLaunchFailure(String checkoutUrl) {
    if (!mounted) return;
    ScaffoldMessenger.of(context)
      ..clearSnackBars()
      ..showSnackBar(
        SnackBar(
          content: const Text(
            'Checkout did not open automatically. Use the button below.',
          ),
          action: SnackBarAction(
            label: 'Copy link',
            onPressed: () =>
                Clipboard.setData(ClipboardData(text: checkoutUrl)),
          ),
        ),
      );
  }

  /// Re-opens the stored checkout link for the in-flight booking, if any.
  Future<void> _openCheckoutFromState() async {
    final checkoutUrl = ref.read(bookingFlowProvider).booking?.checkoutUrl;
    if (checkoutUrl == null || checkoutUrl.isEmpty) {
      if (!mounted) return;
      ScaffoldMessenger.of(context)
        ..clearSnackBars()
        ..showSnackBar(
          const SnackBar(
            content: Text('Checkout link is unavailable. Please rebook.'),
          ),
        );
      return;
    }
    await _launchCheckoutUrl(checkoutUrl);
  }

  void _loadPackage() async {
    final packageAsync = ref.read(packageDetailsProvider(widget.packageId));
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      packageAsync.whenData((package) {
        ref.read(bookingFlowProvider.notifier).setSelectedPackage(package);
        _syncNotifierDefaults();
        if (_selectedDate != null) {
          ref
              .read(bookingFlowProvider.notifier)
              .setSelectedDate(_selectedDate!);
        }
        if (_selectedTime != null) {
          ref
              .read(bookingFlowProvider.notifier)
              .setSelectedTime(_selectedTime!);
        }
        if (package.paxOptions != null && package.paxOptions!.isNotEmpty) {
          setState(() {
            _selectedPax = package.paxOptions!.first;
          });
          ref
              .read(bookingFlowProvider.notifier)
              .setSelectedPax(package.paxOptions!.first);
        }
      });
    });
  }

  /// Pushes UI defaults into the booking flow notifier so submission has a
  /// complete state even when the user never touched a control.
  void _syncNotifierDefaults() {
    final state = ref.read(bookingFlowProvider);
    final notifier = ref.read(bookingFlowProvider.notifier);
    if (state.paymentMethod == null && _paymentMethod != null) {
      notifier.setPaymentMethod(_paymentMethod!);
    }
  }

  void _goToStep(int step) {
    ref.read(bookingFlowProvider.notifier).goToStep(step);
  }

  @override
  Widget build(BuildContext context) {
    ref.watch(bookingFlowProvider);
    ref.listen<AsyncValue<Package>>(packageDetailsProvider(widget.packageId), (
      prev,
      next,
    ) {
      next.whenData((package) {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          if (!mounted) return;
          ref.read(bookingFlowProvider.notifier).setSelectedPackage(package);
          _syncNotifierDefaults();
          if (_selectedDate != null) {
            ref
                .read(bookingFlowProvider.notifier)
                .setSelectedDate(_selectedDate!);
          }
          if (_selectedTime != null) {
            ref
                .read(bookingFlowProvider.notifier)
                .setSelectedTime(_selectedTime!);
          }
          if (package.paxOptions != null && package.paxOptions!.isNotEmpty) {
            if (_selectedPax == null ||
                !package.paxOptions!.contains(_selectedPax)) {
              setState(() {
                _selectedPax = package.paxOptions!.first;
              });
              ref
                  .read(bookingFlowProvider.notifier)
                  .setSelectedPax(package.paxOptions!.first);
            }
          }
        });
      });
    });

    final packageAsync = ref.watch(packageDetailsProvider(widget.packageId));

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: SafeArea(
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 1200),
            child: packageAsync.when(
              data: (package) {
                if (_currentStep == 5) {
                  return _buildCheckoutScreen();
                }

                return LayoutBuilder(
                  builder: (context, constraints) {
                    final width = constraints.maxWidth;

                    if (width > ResponsiveAppShell.tabletBreakpoint) {
                      // Desktop 3-Column Split View (>1024px)
                      return _buildDesktopThreeColumnLayout(package);
                    } else if (width >= ResponsiveAppShell.mobileBreakpoint) {
                      // Tablet 2-Column Layout (768px - 1024px)
                      return _buildTabletTwoColumnLayout(package);
                    } else {
                      // Mobile 1-Column Layout (<768px)
                      return _buildMobileLayout(package);
                    }
                  },
                );
              },
              loading: () =>
                  const Center(child: CircularProgressIndicator(color: plum)),
              error: (e, s) => Center(
                child: Padding(
                  padding: const EdgeInsets.all(24.0),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(
                        Icons.error_outline_rounded,
                        size: 48,
                        color: plum,
                      ),
                      const SizedBox(height: 12),
                      Text(
                        'Error loading package: $e',
                        textAlign: TextAlign.center,
                        style: const TextStyle(color: plum),
                      ),
                      const SizedBox(height: 16),
                      ElevatedButton(
                        onPressed: () => ref.refresh(
                          packageDetailsProvider(widget.packageId),
                        ),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: plum,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(9999),
                          ),
                        ),
                        child: const Text(
                          'Retry',
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  // ==========================================================================
  // DESKTOP 3-COLUMN SPLIT VIEW (>1024px)
  // ==========================================================================

  Widget _buildDesktopThreeColumnLayout(Package package) {
    final isPayment = _currentStep == 4;

    return Column(
      children: [
        _buildDesktopHeader(package),
        Expanded(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // ------------------------------------------------------
              // COLUMNS 1 & 2 (LEFT & MIDDLE): IN-PLACE CROSS-FADE
              // ------------------------------------------------------
              Expanded(
                flex: 2,
                child: AnimatedSwitcher(
                  duration: const Duration(milliseconds: 300),
                  switchInCurve: Curves.easeInOut,
                  switchOutCurve: Curves.easeInOut,
                  layoutBuilder:
                      (Widget? currentChild, List<Widget> previousChildren) {
                        return Stack(
                          alignment: Alignment.topLeft,
                          children: <Widget>[
                            ...previousChildren,
                            ?currentChild,
                          ],
                        );
                      },
                  transitionBuilder: (child, animation) {
                    return FadeTransition(opacity: animation, child: child);
                  },
                  child: isPayment
                      ? DesktopPaymentPanel(
                          key: const ValueKey('desktop_payment_panel_view'),
                          package: package,
                          selectedDate: _selectedDate,
                          selectedTime: _selectedTime,
                          selectedPax: _selectedPax,
                          paymentMethod: _paymentMethod,
                          customerName: _customerNameController.text,
                          customerEmail: _customerEmailController.text,
                          customerPhone: _customerPhoneController.text,
                          venueAddress: _venueAddressController.text,
                          onCustomerNameChanged: (v) {
                            _customerNameController.text = v;
                            ref
                                .read(bookingFlowProvider.notifier)
                                .setCustomerName(v);
                          },
                          onCustomerEmailChanged: (v) {
                            _customerEmailController.text = v;
                            ref
                                .read(bookingFlowProvider.notifier)
                                .setCustomerEmail(v);
                          },
                          onCustomerPhoneChanged: (v) {
                            _customerPhoneController.text = v;
                            ref
                                .read(bookingFlowProvider.notifier)
                                .setCustomerPhone(v);
                          },
                          onVenueAddressChanged: (v) {
                            _venueAddressController.text = v;
                            ref
                                .read(bookingFlowProvider.notifier)
                                .setVenueAddress(v);
                          },
                          onPaymentMethodSelected: (method) {
                            setState(() {
                              _paymentMethod = method;
                            });
                            ref
                                .read(bookingFlowProvider.notifier)
                                .setPaymentMethod(method);
                          },
                          onBackToReservation: () {
                            _goToStep(2);
                          },
                        )
                      : Row(
                          key: const ValueKey(
                            'desktop_reservation_columns_view',
                          ),
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // COLUMN 1 (LEFT): CALENDAR
                            Expanded(
                              flex: 1,
                              child: SingleChildScrollView(
                                key: const Key('desktop_calendar_scroll_view'),
                                physics: const BouncingScrollPhysics(),
                                padding: const EdgeInsets.fromLTRB(
                                  16,
                                  8,
                                  8,
                                  16,
                                ),
                                child: ReservationCalendarPanel(
                                  key: const Key('reservation_calendar_panel'),
                                  selectedDate: _selectedDate,
                                  onDateSelected: (date) {
                                    setState(() {
                                      _selectedDate = date;
                                    });
                                    ref
                                        .read(bookingFlowProvider.notifier)
                                        .setSelectedDate(date);
                                  },
                                ),
                              ),
                            ),

                            // COLUMN 2 (MIDDLE): PACKAGES / TIMES / CUSTOMIZATION
                            Expanded(
                              flex: 1,
                              child: SingleChildScrollView(
                                key: const Key('desktop_middle_scroll_view'),
                                physics: const BouncingScrollPhysics(),
                                padding: const EdgeInsets.fromLTRB(8, 8, 8, 16),
                                child: ReservationDetailsPanel(
                                  key: const Key('reservation_details_panel'),
                                  package: package,
                                  selectedPax: _selectedPax,
                                  onPaxSelected: (pax) {
                                    setState(() {
                                      _selectedPax = pax;
                                    });
                                    ref
                                        .read(bookingFlowProvider.notifier)
                                        .setSelectedPax(pax);
                                  },
                                  selectedTime: _selectedTime,
                                  onTimeSelected: (time) {
                                    setState(() {
                                      _selectedTime = time;
                                    });
                                    ref
                                        .read(bookingFlowProvider.notifier)
                                        .setSelectedTime(time);
                                  },
                                  paymentMethod: _paymentMethod,
                                  onPaymentMethodSelected: (method) {
                                    setState(() {
                                      _paymentMethod = method;
                                    });
                                    ref
                                        .read(bookingFlowProvider.notifier)
                                        .setPaymentMethod(method);
                                  },
                                ),
                              ),
                            ),
                          ],
                        ),
                ),
              ),

              // ------------------------------------------------------
              // COLUMN 3 (RIGHT): STICKY FLOATING ORDER SUMMARY
              // ------------------------------------------------------
              Expanded(
                flex: 1,
                child: SingleChildScrollView(
                  key: const Key('desktop_summary_scroll_view'),
                  physics: const BouncingScrollPhysics(),
                  padding: const EdgeInsets.fromLTRB(8, 8, 16, 16),
                  child: OrderSummaryPanel(
                    key: const Key('order_summary_side_panel'),
                    package: package,
                    selectedDate: _selectedDate,
                    selectedTime: _selectedTime,
                    selectedPax: _selectedPax,
                    paymentMethod: _paymentMethod,
                    actionButtonText: isPayment
                        ? 'Confirm & Pay'
                        : 'Proceed to Payment',
                    isLoading: ref.watch(bookingFlowProvider).isLoading,
                    isSticky: true,
                    onProceed: () {
                      final notifier = ref.read(bookingFlowProvider.notifier);
                      if (_currentStep == 4) {
                        _handleConfirmAndPay();
                      } else {
                        final localOk =
                            _selectedDate != null &&
                            _selectedPax != null &&
                            _selectedTime != null;
                        if (!notifier.canProceedFromSchedule() && !localOk) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text(
                                'Please select date, pax and time slot',
                              ),
                            ),
                          );
                          return;
                        }
                        if (_selectedDate != null) {
                          notifier.setSelectedDate(_selectedDate!);
                        }
                        if (_selectedPax != null) {
                          notifier.setSelectedPax(_selectedPax!);
                        }
                        if (_selectedTime != null) {
                          notifier.setSelectedTime(_selectedTime!);
                        }
                        _goToStep(4);
                      }
                    },
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  // ==========================================================================
  // TABLET 2-COLUMN LAYOUT (768px - 1024px)
  // ==========================================================================

  Widget _buildTabletTwoColumnLayout(Package package) {
    final isPayment = _currentStep == 4;

    return Column(
      children: [
        _buildDesktopHeader(package),
        Expanded(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Left Column: Calendar & Customization / Payment (Scrollable & Cross-Faded)
              Expanded(
                flex: 1,
                child: AnimatedSwitcher(
                  duration: const Duration(milliseconds: 300),
                  switchInCurve: Curves.easeInOut,
                  switchOutCurve: Curves.easeInOut,
                  layoutBuilder:
                      (Widget? currentChild, List<Widget> previousChildren) {
                        return Stack(
                          alignment: Alignment.topLeft,
                          children: <Widget>[
                            ...previousChildren,
                            ?currentChild,
                          ],
                        );
                      },
                  transitionBuilder: (child, animation) {
                    return FadeTransition(opacity: animation, child: child);
                  },
                  child: isPayment
                      ? DesktopPaymentPanel(
                          key: const ValueKey('tablet_payment_panel_view'),
                          package: package,
                          selectedDate: _selectedDate,
                          selectedTime: _selectedTime,
                          selectedPax: _selectedPax,
                          paymentMethod: _paymentMethod,
                          customerName: _customerNameController.text,
                          customerEmail: _customerEmailController.text,
                          customerPhone: _customerPhoneController.text,
                          venueAddress: _venueAddressController.text,
                          onCustomerNameChanged: (v) {
                            _customerNameController.text = v;
                            ref
                                .read(bookingFlowProvider.notifier)
                                .setCustomerName(v);
                          },
                          onCustomerEmailChanged: (v) {
                            _customerEmailController.text = v;
                            ref
                                .read(bookingFlowProvider.notifier)
                                .setCustomerEmail(v);
                          },
                          onCustomerPhoneChanged: (v) {
                            _customerPhoneController.text = v;
                            ref
                                .read(bookingFlowProvider.notifier)
                                .setCustomerPhone(v);
                          },
                          onVenueAddressChanged: (v) {
                            _venueAddressController.text = v;
                            ref
                                .read(bookingFlowProvider.notifier)
                                .setVenueAddress(v);
                          },
                          onPaymentMethodSelected: (method) {
                            setState(() {
                              _paymentMethod = method;
                            });
                            ref
                                .read(bookingFlowProvider.notifier)
                                .setPaymentMethod(method);
                          },
                          onBackToReservation: () {
                            _goToStep(2);
                          },
                        )
                      : SingleChildScrollView(
                          key: const Key('tablet_left_scroll_view'),
                          physics: const BouncingScrollPhysics(),
                          padding: const EdgeInsets.fromLTRB(16, 8, 8, 16),
                          child: Column(
                            children: [
                              ReservationCalendarPanel(
                                key: const Key('tablet_calendar_panel'),
                                selectedDate: _selectedDate,
                                onDateSelected: (date) {
                                  setState(() {
                                    _selectedDate = date;
                                  });
                                  ref
                                      .read(bookingFlowProvider.notifier)
                                      .setSelectedDate(date);
                                },
                              ),
                              const SizedBox(height: 14),
                              ReservationDetailsPanel(
                                key: const Key('tablet_details_panel'),
                                package: package,
                                selectedPax: _selectedPax,
                                onPaxSelected: (pax) {
                                  setState(() {
                                    _selectedPax = pax;
                                  });
                                  ref
                                      .read(bookingFlowProvider.notifier)
                                      .setSelectedPax(pax);
                                },
                                selectedTime: _selectedTime,
                                onTimeSelected: (time) {
                                  setState(() {
                                    _selectedTime = time;
                                  });
                                  ref
                                      .read(bookingFlowProvider.notifier)
                                      .setSelectedTime(time);
                                },
                                paymentMethod: _paymentMethod,
                                onPaymentMethodSelected: (method) {
                                  setState(() {
                                    _paymentMethod = method;
                                  });
                                  ref
                                      .read(bookingFlowProvider.notifier)
                                      .setPaymentMethod(method);
                                },
                              ),
                            ],
                          ),
                        ),
                ),
              ),

              // Right Column: Order Summary (Sticky side-panel)
              Expanded(
                flex: 1,
                child: SingleChildScrollView(
                  key: const Key('tablet_right_scroll_view'),
                  physics: const BouncingScrollPhysics(),
                  padding: const EdgeInsets.fromLTRB(8, 8, 16, 16),
                  child: OrderSummaryPanel(
                    key: const Key('tablet_order_summary_panel'),
                    package: package,
                    selectedDate: _selectedDate,
                    selectedTime: _selectedTime,
                    selectedPax: _selectedPax,
                    paymentMethod: _paymentMethod,
                    actionButtonText: isPayment
                        ? 'Confirm & Pay'
                        : 'Proceed to Payment',
                    isLoading: ref.watch(bookingFlowProvider).isLoading,
                    isSticky: true,
                    onProceed: () {
                      final notifier = ref.read(bookingFlowProvider.notifier);
                      if (_currentStep == 4) {
                        _handleConfirmAndPay();
                      } else {
                        final localOk =
                            _selectedDate != null &&
                            _selectedPax != null &&
                            _selectedTime != null;
                        if (!notifier.canProceedFromSchedule() && !localOk) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text(
                                'Please select date, pax and time slot',
                              ),
                            ),
                          );
                          return;
                        }
                        if (_selectedDate != null) {
                          notifier.setSelectedDate(_selectedDate!);
                        }
                        if (_selectedPax != null) {
                          notifier.setSelectedPax(_selectedPax!);
                        }
                        if (_selectedTime != null) {
                          notifier.setSelectedTime(_selectedTime!);
                        }
                        _goToStep(4);
                      }
                    },
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  // ==========================================================================
  // MOBILE 1-COLUMN LAYOUT (<768px)
  // ==========================================================================

  Widget _buildMobileLayout(Package package) {
    final submitting = ref.watch(bookingFlowProvider).isLoading;
    return Column(
      children: [
        _buildHeader(showBack: true),
        _buildTimeline(),
        Expanded(
          child: SingleChildScrollView(
            key: const Key('mobile_step_scroll_view'),
            padding: const EdgeInsets.all(20),
            child: _buildCurrentStep(package),
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(20),
          child: SizedBox(
            width: double.infinity,
            height: 50,
            child: ElevatedButton(
              onPressed: submitting
                  ? null
                  : () {
                      final notifier = ref.read(bookingFlowProvider.notifier);
                      if (_currentStep == 4) {
                        _handleConfirmAndPay();
                      } else if (_currentStep == 2) {
                        final localOk =
                            _selectedDate != null &&
                            _selectedPax != null &&
                            _selectedTime != null;
                        if (!notifier.canProceedFromSchedule() && !localOk) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text(
                                'Please select date, pax and time slot',
                              ),
                            ),
                          );
                          return;
                        }
                        // Ensure provider has local values before advancing
                        if (_selectedDate != null) {
                          notifier.setSelectedDate(_selectedDate!);
                        }
                        if (_selectedPax != null) {
                          notifier.setSelectedPax(_selectedPax!);
                        }
                        if (_selectedTime != null) {
                          notifier.setSelectedTime(_selectedTime!);
                        }
                        notifier.nextStep();
                      } else if (_currentStep == 3) {
                        if (!notifier.canProceedFromDetails()) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text(
                                'Please fill name, email and venue',
                              ),
                            ),
                          );
                          return;
                        }
                        notifier.nextStep();
                      } else {
                        notifier.nextStep();
                      }
                    },
              style: ElevatedButton.styleFrom(
                backgroundColor: plum,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(9999),
                ),
              ),
              child: submitting
                  ? const SizedBox(
                      width: 22,
                      height: 22,
                      child: CircularProgressIndicator(
                        strokeWidth: 2.5,
                        color: Colors.white,
                      ),
                    )
                  : Text(
                      _currentStep == 4
                          ? 'Confirm & Pay'
                          : _currentStep == 3
                          ? 'Proceed to Payment'
                          : 'Next',
                      style: const TextStyle(color: Colors.white, fontSize: 16),
                    ),
            ),
          ),
        ),
      ],
    );
  }

  // ==========================================================================
  // DESKTOP / TABLET HEADER
  // ==========================================================================

  Widget _buildDesktopHeader(Package package) {
    final isPayment = _currentStep == 4;

    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 14, 20, 6),
      child: Row(
        children: [
          TextButton.icon(
            onPressed: () {
              if (_currentStep > 2) {
                _goToStep(2);
              } else if (context.canPop()) {
                context.pop();
              } else {
                try {
                  context.go('/home');
                } catch (_) {}
              }
            },
            icon: const Icon(Icons.arrow_back_rounded, color: plum, size: 20),
            label: const Text(
              'Back',
              style: TextStyle(
                color: plum,
                fontSize: 14,
                fontWeight: FontWeight.w600,
              ),
            ),
            style: TextButton.styleFrom(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
            ),
          ),
          const SizedBox(width: 8),
          Container(height: 18, width: 1, color: const Color(0x3399868C)),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              isPayment
                  ? 'Payment & Checkout — ${package.name ?? "Custom Experience"}'
                  : 'Reservation — ${package.name ?? "Custom Experience"}',
              style: const TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w700,
                color: plum,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),
          const SizedBox(width: 10),
          Flexible(
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(9999),
                border: Border.all(color: const Color(0x3399868C)),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    isPayment
                        ? Icons.lock_outline_rounded
                        : Icons.check_circle_rounded,
                    size: 13,
                    color: isPayment ? plum : const Color(0xFF16A34A),
                  ),
                  const SizedBox(width: 5),
                  Flexible(
                    child: Text(
                      isPayment
                          ? 'Secure In-Place Checkout'
                          : (MediaQuery.of(context).size.width >
                                    ResponsiveAppShell.tabletBreakpoint
                                ? '3-Column Reservation Flow'
                                : '2-Column Reservation Flow'),
                      style: const TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.w600,
                        color: plum,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ==========================================================================
  // CHECKOUT STATUS SCREEN
  // ==========================================================================

  String _bookingReference() {
    return ref.read(bookingFlowProvider).booking?.bookingReference ?? '—';
  }

  Widget _buildCheckoutScreen() {
    final flowState = ref.watch(bookingFlowProvider);
    final status = flowState.checkoutStatus;
    final reference = _bookingReference();

    final Widget content;
    if (status == BookingCheckoutStatus.confirmed) {
      content = _buildCheckoutCard(
        iconData: Icons.check_rounded,
        iconColor: const Color(0xFF22C55E),
        title: 'Payment Successful',
        messageLines: [
          'Thank you for your booking.',
          '',
          'Booking reference: $reference',
          'To check your status go to your booking settings.',
        ],
        buttonLabel: 'Done',
        buttonIcon: Icons.arrow_forward_rounded,
        onPressed: () {
          ref.read(bookingFlowProvider.notifier).reset();
          try {
            if (context.canPop()) {
              context.pop();
            } else {
              context.go('/home');
            }
          } catch (_) {}
        },
      );
    } else if (status == BookingCheckoutStatus.awaitingAdmin) {
      content = _buildCheckoutCard(
        iconData: Icons.schedule_rounded,
        iconColor: const Color(0xFFC28A52),
        title: 'Awaiting Admin Confirmation',
        messageLines: [
          'Your booking has been received.',
          '',
          'Booking reference: $reference',
          'Our team will confirm once your ${flowState.paymentMethod == 'cash' ? 'cash payment' : 'bank transfer'} is processed.',
        ],
        buttonLabel: 'Check Status',
        buttonIcon: Icons.refresh_rounded,
        onPressed: () {
          ref.read(bookingFlowProvider.notifier).checkStatusImmediate();
        },
      );
    } else if (status == BookingCheckoutStatus.cancelled) {
      content = _buildCheckoutCard(
        iconData: Icons.cancel_rounded,
        iconColor: const Color(0xFFC28A52),
        title: 'Booking Not Completed',
        messageLines: [
          'The payment link expired or the booking was cancelled.',
          '',
          'You can create a fresh booking to try again.',
        ],
        buttonLabel: 'Rebook',
        buttonIcon: Icons.restart_alt_rounded,
        onPressed: () {
          ref.read(bookingFlowProvider.notifier).rebook();
          _goToStep(2);
        },
      );
    } else if (status == BookingCheckoutStatus.awaitingPayment) {
      content = _buildCheckoutCard(
        iconData: Icons.hourglass_top_rounded,
        iconColor: plum,
        title: 'Processing Your Payment',
        messageLines: [
          'A secure checkout page should have opened in a new tab.',
          'If it did not, tap below to open it.',
          '',
          'Booking reference: $reference',
          'We are waiting for payment confirmation.',
        ],
        buttonLabel: 'Open Checkout Page',
        buttonIcon: Icons.open_in_new_rounded,
        onPressed: () {
          unawaited(_openCheckoutFromState());
        },
        secondaryLabel: 'Recheck status',
        secondaryIcon: Icons.refresh_rounded,
        secondaryOnPressed: () {
          ref.read(bookingFlowProvider.notifier).checkStatusImmediate();
        },
        showSpinner: true,
      );
    } else {
      final error = flowState.errorMessage;
      if (error != null && error.isNotEmpty) {
        content = _buildCheckoutCard(
          iconData: Icons.error_outline_rounded,
          iconColor: const Color(0xFFC28A52),
          title: 'Unable to Submit Booking',
          messageLines: [error],
          buttonLabel: 'Try Again',
          buttonIcon: Icons.refresh_rounded,
          onPressed: () {
            _goToStep(4);
          },
        );
      } else {
        content = _buildCheckoutCard(
          iconData: Icons.check_rounded,
          iconColor: const Color(0xFF22C55E),
          title: 'Booking Submitted',
          messageLines: ['Your booking is being processed.'],
          buttonLabel: 'Done',
          buttonIcon: Icons.arrow_forward_rounded,
          onPressed: () {
            ref.read(bookingFlowProvider.notifier).reset();
            try {
              if (context.canPop()) {
                context.pop();
              } else {
                context.go('/home');
              }
            } catch (_) {}
          },
        );
      }
    }

    return Column(
      children: [
        if (MediaQuery.of(context).size.width < 768)
          _buildHeader(showBack: false),
        Expanded(
          child: Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(vertical: 16),
              child: content,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildCheckoutCard({
    required IconData iconData,
    required Color iconColor,
    required String title,
    required List<String> messageLines,
    required String buttonLabel,
    required IconData buttonIcon,
    required VoidCallback? onPressed,
    String? secondaryLabel,
    IconData? secondaryIcon,
    VoidCallback? secondaryOnPressed,
    bool showSpinner = false,
  }) {
    return Container(
      constraints: const BoxConstraints(maxWidth: 480),
      margin: const EdgeInsets.symmetric(horizontal: 30, vertical: 10),
      padding: const EdgeInsets.symmetric(vertical: 40, horizontal: 30),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: const Color(0x4D99868C)),
        boxShadow: [
          BoxShadow(
            color: plum.withValues(alpha: 0.08),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(color: iconColor, shape: BoxShape.circle),
            child: Icon(iconData, color: Colors.white, size: 40),
          ),
          const SizedBox(height: 20),
          Text(
            title,
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w700,
              color: plum,
            ),
          ),
          const SizedBox(height: 18),
          ...messageLines.map(
            (line) => Padding(
              padding: const EdgeInsets.symmetric(vertical: 2),
              child: Text(
                line,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 14,
                  color: Color(0x8A6A4053),
                  height: 1.4,
                ),
              ),
            ),
          ),
          const SizedBox(height: 28),
          if (showSpinner) ...[
            const SizedBox(
              width: 42,
              height: 42,
              child: CircularProgressIndicator(strokeWidth: 3, color: plum),
            ),
            const SizedBox(height: 20),
          ],
          SizedBox(
            width: double.infinity,
            height: 48,
            child: ElevatedButton.icon(
              onPressed: onPressed,
              icon: Icon(buttonIcon, size: 18),
              label: Text(buttonLabel),
              style: ElevatedButton.styleFrom(
                backgroundColor: plum,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(9999),
                ),
              ),
            ),
          ),
          if (secondaryLabel != null) ...[
            const SizedBox(height: 8),
            SizedBox(
              width: double.infinity,
              height: 48,
              child: TextButton.icon(
                onPressed: secondaryOnPressed,
                icon: Icon(secondaryIcon ?? Icons.refresh_rounded, size: 18),
                label: Text(secondaryLabel),
                style: TextButton.styleFrom(
                  foregroundColor: plum,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(9999),
                  ),
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }

  // ==========================================================================
  // MOBILE SUB-WIDGETS
  // ==========================================================================

  Widget _buildHeader({required bool showBack}) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 15),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          if (showBack)
            TextButton.icon(
              onPressed: () {
                if (_currentStep > 2) {
                  ref.read(bookingFlowProvider.notifier).previousStep();
                } else {
                  if (context.canPop()) {
                    context.pop();
                  } else {
                    try {
                      context.go('/home');
                    } catch (_) {}
                  }
                }
              },
              icon: const Icon(Icons.arrow_back, color: plum, size: 20),
              label: const Text(
                'Back',
                style: TextStyle(color: plum, fontSize: 14),
              ),
              style: TextButton.styleFrom(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              ),
            )
          else
            const SizedBox(width: 60),

          // Logo
          SizedBox(
            width: 140,
            height: 45,
            child: Stack(
              alignment: Alignment.center,
              children: const [
                Positioned(
                  top: 0,
                  left: 0,
                  child: Text(
                    'INEA',
                    style: TextStyle(
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 2,
                      height: 1,
                      color: plum,
                    ),
                  ),
                ),
                Positioned(
                  bottom: 0,
                  right: 0,
                  child: Text(
                    'Scents',
                    style: TextStyle(
                      fontFamily: 'GreatVibes',
                      fontSize: 32,
                      height: 1,
                      color: plum,
                    ),
                  ),
                ),
              ],
            ),
          ),

          if (showBack)
            Row(
              children: const [
                Icon(Icons.chat_bubble_rounded, color: plum),
                SizedBox(width: 15),
                Icon(Icons.calendar_today_rounded, color: plum),
              ],
            )
          else
            const SizedBox(width: 60),
        ],
      ),
    );
  }

  Widget _buildTimeline() {
    final steps = ['Package', 'Scents', 'Schedule', 'Details', 'Payment'];
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 25),
      child: Row(
        children: List.generate(steps.length, (index) {
          final isPast = index < _currentStep;
          final isCurrent = index == _currentStep;
          return Expanded(
            child: Column(
              children: [
                Row(
                  children: [
                    if (index == 0)
                      const Expanded(child: SizedBox())
                    else
                      Expanded(
                        child: Container(
                          height: 3,
                          color: isPast || isCurrent
                              ? plum
                              : const Color(0xFF99868C),
                        ),
                      ),
                    Semantics(
                      selected: isCurrent,
                      label: steps[index],
                      child: Container(
                        width: 22,
                        height: 22,
                        decoration: BoxDecoration(
                          color: isPast || isCurrent
                              ? plum
                              : const Color(0xFF99868C),
                          shape: BoxShape.circle,
                        ),
                        child: isPast || isCurrent
                            ? const Icon(
                                Icons.check,
                                size: 12,
                                color: Colors.white,
                              )
                            : null,
                      ),
                    ),
                    if (index == steps.length - 1)
                      const Expanded(child: SizedBox())
                    else
                      Expanded(
                        child: Container(
                          height: 3,
                          color: index < _currentStep
                              ? plum
                              : const Color(0xFF99868C),
                        ),
                      ),
                  ],
                ),
                const SizedBox(height: 6),
                Text(
                  steps[index],
                  style: TextStyle(
                    fontSize: 10,
                    color: isCurrent ? plum : const Color(0xFF99868C),
                    fontWeight: isCurrent ? FontWeight.bold : FontWeight.normal,
                  ),
                ),
              ],
            ),
          );
        }),
      ),
    );
  }

  Widget _buildCurrentStep(Package package) {
    if (_currentStep == 2) {
      // Schedule Step
      final timeSlots = TimeSlot.available.map((s) => s.label).toList();

      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Please Choose Available Schedule',
            style: TextStyle(fontSize: 13, color: plum),
          ),
          const SizedBox(height: 15),
          IneaCalendar(
            key: const Key('mobile_inea_calendar'),
            selectedDate: _selectedDate,
            onDateSelected: (date) {
              setState(() {
                _selectedDate = date;
              });
              ref.read(bookingFlowProvider.notifier).setSelectedDate(date);
            },
          ),
          const SizedBox(height: 25),
          const Text(
            'Please Choose Available Pax',
            style: TextStyle(fontSize: 13, color: plum),
          ),
          const SizedBox(height: 10),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(15),
              border: Border.all(color: const Color(0x4D99868C)),
            ),
            child: Wrap(
              spacing: 8,
              runSpacing: 8,
              children: (package.paxOptions ?? [20, 30, 50, 75, 100]).map((
                pax,
              ) {
                final isSelected = _selectedPax == pax;
                return ChoiceChip(
                  label: Text('$pax Pax'),
                  selected: isSelected,
                  selectedColor: plum,
                  labelStyle: TextStyle(
                    color: isSelected ? Colors.white : plum,
                    fontWeight: isSelected
                        ? FontWeight.bold
                        : FontWeight.normal,
                  ),
                  onSelected: (selected) {
                    if (selected) {
                      setState(() => _selectedPax = pax);
                      ref
                          .read(bookingFlowProvider.notifier)
                          .setSelectedPax(pax);
                    }
                  },
                );
              }).toList(),
            ),
          ),
          const SizedBox(height: 25),
          const Text(
            'Please Choose Available Time Slot',
            style: TextStyle(fontSize: 13, color: plum),
          ),
          const SizedBox(height: 10),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(15),
              border: Border.all(color: const Color(0x4D99868C)),
            ),
            child: Wrap(
              spacing: 8,
              runSpacing: 8,
              children: timeSlots.map((time) {
                final isSelected = _selectedTime == time;
                return ChoiceChip(
                  label: Text(time),
                  selected: isSelected,
                  selectedColor: plum,
                  labelStyle: TextStyle(
                    color: isSelected ? Colors.white : plum,
                    fontWeight: isSelected
                        ? FontWeight.bold
                        : FontWeight.normal,
                  ),
                  onSelected: (selected) {
                    if (selected) {
                      setState(() => _selectedTime = time);
                      ref
                          .read(bookingFlowProvider.notifier)
                          .setSelectedTime(time);
                    }
                  },
                );
              }).toList(),
            ),
          ),
        ],
      );
    } else if (_currentStep == 3) {
      // Details Step
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Order Details',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: plum,
            ),
          ),
          const SizedBox(height: 15),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                flex: 3,
                child: Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(15),
                    border: Border.all(color: const Color(0x4D99868C)),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Details',
                        style: TextStyle(
                          fontSize: 14,
                          color: Color(0xFF6A4053),
                        ),
                      ),
                      const SizedBox(height: 15),
                      Text(
                        'Package Variation: ${package.name}',
                        style: const TextStyle(
                          fontSize: 13,
                          color: Color(0x8A6A4053),
                        ),
                      ),
                      const SizedBox(height: 15),
                      const Text(
                        'Inclusion/s:',
                        style: TextStyle(
                          fontSize: 13,
                          color: Color(0x8A6A4053),
                        ),
                      ),
                      const SizedBox(height: 5),
                      ...(package.inclusions ?? []).map(
                        (e) => Text(
                          '• $e',
                          style: const TextStyle(
                            fontSize: 12,
                            color: Color(0xFF6A4053),
                          ),
                        ),
                      ),
                      const SizedBox(height: 15),
                      const Text(
                        'Free:',
                        style: TextStyle(
                          fontSize: 13,
                          color: Color(0x8A6A4053),
                        ),
                      ),
                      const SizedBox(height: 5),
                      ...(package.freebies ?? []).map(
                        (e) => Text(
                          '• $e',
                          style: const TextStyle(
                            fontSize: 12,
                            color: Color(0xFF6A4053),
                          ),
                        ),
                      ),
                      const SizedBox(height: 15),
                      const Text(
                        'Selected Date:',
                        style: TextStyle(
                          fontSize: 13,
                          color: Color(0x8A6A4053),
                        ),
                      ),
                      const SizedBox(height: 5),
                      Text(
                        _selectedDate != null
                            ? '${_selectedDate!.year}-${_selectedDate!.month.toString().padLeft(2, '0')}-${_selectedDate!.day.toString().padLeft(2, '0')}'
                            : 'Not selected',
                        style: const TextStyle(fontSize: 13, color: plum),
                      ),
                      const SizedBox(height: 15),
                      const Text(
                        'Selected Time:',
                        style: TextStyle(
                          fontSize: 13,
                          color: Color(0x8A6A4053),
                        ),
                      ),
                      const SizedBox(height: 5),
                      Text(
                        _selectedTime ?? '2:00 PM - 5:00 PM',
                        style: const TextStyle(fontSize: 13, color: plum),
                      ),
                      const SizedBox(height: 15),
                      const Text(
                        'Selected Pax:',
                        style: TextStyle(
                          fontSize: 13,
                          color: Color(0x8A6A4053),
                        ),
                      ),
                      const SizedBox(height: 5),
                      Text(
                        '${_selectedPax ?? 50} Pax',
                        style: const TextStyle(fontSize: 13, color: plum),
                      ),
                      const SizedBox(height: 15),
                      const Text(
                        'Total Cost:',
                        style: TextStyle(
                          fontSize: 13,
                          color: Color(0x8A6A4053),
                        ),
                      ),
                      const SizedBox(height: 5),
                      Text(
                        'Php. ${(package.price ?? 4500).toStringAsFixed(2)}',
                        style: const TextStyle(fontSize: 13, color: plum),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(width: 15),
              Expanded(
                flex: 2,
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(15),
                    border: Border.all(color: const Color(0x4D99868C)),
                  ),
                  child: Column(
                    children: [
                      ClipRRect(
                        borderRadius: const BorderRadius.only(
                          topLeft: Radius.circular(15),
                          topRight: Radius.circular(15),
                        ),
                        child: Container(
                          height: 100,
                          width: double.infinity,
                          color: const Color(0xFFF3EBE1),
                          child:
                              (package.images != null &&
                                  package.images!.isNotEmpty)
                              ? Image.network(
                                  package.images![0],
                                  fit: BoxFit.cover,
                                  errorBuilder: (context, error, stackTrace) =>
                                      const Icon(
                                        Icons.local_florist,
                                        color: plum,
                                        size: 32,
                                      ),
                                )
                              : const Icon(
                                  Icons.local_florist,
                                  color: plum,
                                  size: 32,
                                ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(12),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              package.name ?? '',
                              style: const TextStyle(
                                fontSize: 13,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              package.description ?? '',
                              maxLines: 3,
                              style: const TextStyle(
                                fontSize: 10,
                                color: Color(0xFF99868C),
                              ),
                            ),
                            const SizedBox(height: 12),
                            Text(
                              'Php. ${(package.price ?? 4499.0).toStringAsFixed(2)}',
                              style: const TextStyle(fontSize: 13, color: plum),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          const Text(
            'Your Contact Details',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: plum,
            ),
          ),
          const SizedBox(height: 15),
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(15),
              border: Border.all(color: const Color(0x4D99868C)),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildMobileContactField(
                  controller: _customerNameController,
                  keyName: 'mobile_customer_name',
                  label: 'Full Name',
                  hint: 'Customer Name',
                  icon: Icons.person_outline_rounded,
                  textInputType: TextInputType.name,
                  onChanged: (v) =>
                      ref.read(bookingFlowProvider.notifier).setCustomerName(v),
                ),
                const SizedBox(height: 12),
                _buildMobileContactField(
                  controller: _customerEmailController,
                  keyName: 'mobile_customer_email',
                  label: 'Email Address',
                  hint: 'name@example.com',
                  icon: Icons.email_outlined,
                  textInputType: TextInputType.emailAddress,
                  onChanged: (v) => ref
                      .read(bookingFlowProvider.notifier)
                      .setCustomerEmail(v),
                ),
                const SizedBox(height: 12),
                _buildMobileContactField(
                  controller: _customerPhoneController,
                  keyName: 'mobile_customer_phone',
                  label: 'Contact Phone',
                  hint: '+63 9XX XXX XXXX',
                  icon: Icons.phone_outlined,
                  textInputType: TextInputType.phone,
                  onChanged: (v) => ref
                      .read(bookingFlowProvider.notifier)
                      .setCustomerPhone(v),
                ),
                const SizedBox(height: 12),
                _buildMobileContactField(
                  controller: _venueAddressController,
                  keyName: 'mobile_venue_address',
                  label: 'Event Venue / Address',
                  hint: 'e.g. Grand Ballroom, Makati',
                  icon: Icons.location_on_outlined,
                  textInputType: TextInputType.streetAddress,
                  onChanged: (v) =>
                      ref.read(bookingFlowProvider.notifier).setVenueAddress(v),
                ),
              ],
            ),
          ),
        ],
      );
    } else if (_currentStep == 4) {
      // Payment Step
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Price Details',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: plum,
            ),
          ),
          const SizedBox(height: 15),
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(15),
              border: Border.all(color: const Color(0x4D99868C)),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  package.name ?? '',
                  style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w500,
                    color: plum,
                  ),
                ),
                const SizedBox(height: 15),
                const Text(
                  'Inclusion/s:',
                  style: TextStyle(fontSize: 12, color: Color(0xFF99868C)),
                ),
                const SizedBox(height: 10),
                ...[
                  {'label': 'Featuring your logo', 'val': '300'},
                  {'label': '4 Inspired scents', 'val': '800'},
                  {'label': 'Perfume Bar Setup', 'val': '1500'},
                  {'label': 'Claim Stub', 'val': '150'},
                  {'label': 'Duration: 3-4 Hrs', 'val': '0.00'},
                  {'label': '2 staff members', 'val': '1000'},
                  {'label': 'Selfie Mirror', 'val': '0.00'},
                  {'label': '1 Gift for Celebrant', 'val': '0.00'},
                ].map((item) {
                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 3),
                    child: Row(
                      children: [
                        Flexible(
                          flex: 4,
                          child: Text(
                            '• ${item['label']}',
                            style: const TextStyle(
                              fontSize: 12,
                              color: Color(0xFF6A4053),
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        Expanded(
                          flex: 2,
                          child: LayoutBuilder(
                            builder: (context, constraints) {
                              final count = (constraints.maxWidth / 8)
                                  .floor()
                                  .clamp(1, 20);
                              return Padding(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 5,
                                ),
                                child: Text(
                                  '- ' * count,
                                  maxLines: 1,
                                  overflow: TextOverflow.clip,
                                  style: const TextStyle(
                                    color: Color(0xFF99868C),
                                  ),
                                ),
                              );
                            },
                          ),
                        ),
                        Text(
                          item['val']!,
                          style: const TextStyle(
                            fontSize: 12,
                            color: Color(0xFF6A4053),
                          ),
                        ),
                      ],
                    ),
                  );
                }),
                const SizedBox(height: 20),
                Align(
                  alignment: Alignment.centerRight,
                  child: Text(
                    'Total: Php. ${(package.price ?? 4500.0).toStringAsFixed(2)}',
                    style: const TextStyle(
                      fontSize: 13,
                      color: Color(0xFF99868C),
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(15),
              border: Border.all(color: const Color(0x4D99868C)),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Choose Payment Method',
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w500,
                    color: plum,
                  ),
                ),
                const SizedBox(height: 16),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children:
                      [
                        {
                          'id': 'credit_card',
                          'label': 'VISA / MC',
                          'color': const Color(0xFFEB001B),
                        },
                        {
                          'id': 'cash',
                          'label': 'Cash',
                          'color': const Color(0xFF16A34A),
                        },
                        {
                          'id': 'bank_transfer',
                          'label': 'Bank Transfer',
                          'color': const Color(0xFF475569),
                        },
                      ].map((m) {
                        final isSel = _paymentMethod == m['id'];
                        return SizedBox(
                          width: (MediaQuery.of(context).size.width - 138) / 2,
                          child: InkWell(
                            onTap: () {
                              setState(
                                () => _paymentMethod = m['id'] as String,
                              );
                              ref
                                  .read(bookingFlowProvider.notifier)
                                  .setPaymentMethod(m['id'] as String);
                            },
                            borderRadius: BorderRadius.circular(8),
                            child: Container(
                              padding: const EdgeInsets.symmetric(vertical: 8),
                              alignment: Alignment.center,
                              decoration: BoxDecoration(
                                color: isSel
                                    ? (m['color'] as Color).withValues(
                                        alpha: 0.15,
                                      )
                                    : Colors.transparent,
                                borderRadius: BorderRadius.circular(8),
                                border: Border.all(
                                  color: isSel
                                      ? (m['color'] as Color)
                                      : const Color(0x3399868C),
                                  width: isSel ? 1.5 : 1.0,
                                ),
                              ),
                              child: Text(
                                m['label'] as String,
                                style: TextStyle(
                                  color: m['color'] as Color,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 13,
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
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

    return Center(child: Text('Step $_currentStep details here'));
  }

  Widget _buildMobileContactField({
    required TextEditingController controller,
    required String keyName,
    required String label,
    required String hint,
    required IconData icon,
    required TextInputType textInputType,
    required ValueChanged<String> onChanged,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(fontSize: 13, color: Color(0xFF6A4053)),
        ),
        const SizedBox(height: 6),
        TextField(
          key: ValueKey(keyName),
          controller: controller,
          keyboardType: textInputType,
          onChanged: onChanged,
          style: const TextStyle(fontSize: 14, color: Color(0xFF6A4053)),
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: const TextStyle(fontSize: 13, color: Color(0x8A6A4053)),
            prefixIcon: Icon(icon, size: 20, color: const Color(0x8A6A4053)),
            isDense: true,
            contentPadding: const EdgeInsets.symmetric(
              vertical: 14,
              horizontal: 12,
            ),
            filled: true,
            fillColor: const Color(0xFFFDF9F5),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: const BorderSide(color: Color(0x3399868C)),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: const BorderSide(color: plum, width: 1.5),
            ),
          ),
        ),
      ],
    );
  }
}
