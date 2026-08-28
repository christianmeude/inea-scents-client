import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:table_calendar/table_calendar.dart';

import '../models/index.dart';
import '../providers/index.dart';
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
  static final DateTime _firstCalendarDay = DateTime.utc(2020, 1, 1);
  static final DateTime _lastCalendarDay = DateTime.utc(2035, 12, 31);

  DateTime _clampDay(DateTime day) {
    if (day.isBefore(_firstCalendarDay)) return _firstCalendarDay;
    if (day.isAfter(_lastCalendarDay)) return _lastCalendarDay;
    return day;
  }

  int currentStep = 2; // Default to Schedule based on prototype
  DateTime? _selectedDate;
  int? _selectedPax;
  String? _selectedTime;
  String? _paymentMethod = 'gcash';

  @override
  void initState() {
    super.initState();
    _selectedDate = DateTime.now().add(const Duration(days: 3));
    _selectedTime = '2:00 PM - 5:00 PM';
    _selectedPax = 50;
    _loadPackage();
  }

  void _loadPackage() async {
    final packageAsync = ref.read(packageDetailsProvider(widget.packageId));
    WidgetsBinding.instance.addPostFrameCallback((_) {
      packageAsync.whenData((package) {
        ref.read(bookingFlowProvider.notifier).setSelectedPackage(package);
        if (_selectedDate != null) {
          ref.read(bookingFlowProvider.notifier).setSelectedDate(_selectedDate!);
        }
        if (_selectedTime != null) {
          ref.read(bookingFlowProvider.notifier).setSelectedTime(_selectedTime!);
        }
        if (package.paxOptions != null && package.paxOptions!.isNotEmpty) {
          setState(() {
            _selectedPax = package.paxOptions!.first;
          });
          ref.read(bookingFlowProvider.notifier).setSelectedPax(package.paxOptions!.first);
        }
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    ref.listen<AsyncValue<Package>>(packageDetailsProvider(widget.packageId), (prev, next) {
      next.whenData((package) {
        ref.read(bookingFlowProvider.notifier).setSelectedPackage(package);
        if (_selectedDate != null) {
          ref.read(bookingFlowProvider.notifier).setSelectedDate(_selectedDate!);
        }
        if (_selectedTime != null) {
          ref.read(bookingFlowProvider.notifier).setSelectedTime(_selectedTime!);
        }
        if (package.paxOptions != null && package.paxOptions!.isNotEmpty) {
          if (_selectedPax == null || !package.paxOptions!.contains(_selectedPax)) {
            setState(() {
              _selectedPax = package.paxOptions!.first;
            });
            ref.read(bookingFlowProvider.notifier).setSelectedPax(package.paxOptions!.first);
          }
        }
      });
    });

    final packageAsync = ref.watch(packageDetailsProvider(widget.packageId));

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: SafeArea(
        child: packageAsync.when(
          data: (package) {
            if (currentStep == 5) {
              return _buildSuccessScreen();
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
          loading: () => const Center(
            child: CircularProgressIndicator(color: plum),
          ),
          error: (e, s) => Center(
            child: Padding(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(Icons.error_outline_rounded, size: 48, color: plum),
                  const SizedBox(height: 12),
                  Text(
                    'Error loading package: $e',
                    textAlign: TextAlign.center,
                    style: const TextStyle(color: plum),
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () => ref.refresh(packageDetailsProvider(widget.packageId)),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: plum,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(9999),
                      ),
                    ),
                    child: const Text('Retry', style: TextStyle(color: Colors.white)),
                  ),
                ],
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
    final isPayment = currentStep == 4;

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
                  layoutBuilder: (Widget? currentChild, List<Widget> previousChildren) {
                    return Stack(
                      alignment: Alignment.topLeft,
                      children: <Widget>[
                        ...previousChildren,
                        ?currentChild,
                      ],
                    );
                  },
                  transitionBuilder: (child, animation) {
                    return FadeTransition(
                      opacity: animation,
                      child: child,
                    );
                  },
                  child: isPayment
                      ? DesktopPaymentPanel(
                          key: const ValueKey('desktop_payment_panel_view'),
                          package: package,
                          selectedDate: _selectedDate,
                          selectedTime: _selectedTime,
                          selectedPax: _selectedPax,
                          paymentMethod: _paymentMethod,
                          onPaymentMethodSelected: (method) {
                            setState(() {
                              _paymentMethod = method;
                            });
                            ref.read(bookingFlowProvider.notifier).setPaymentMethod(method);
                          },
                          onBackToReservation: () {
                            setState(() {
                              currentStep = 2;
                            });
                          },
                        )
                      : Row(
                          key: const ValueKey('desktop_reservation_columns_view'),
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // COLUMN 1 (LEFT): CALENDAR
                            Expanded(
                              flex: 1,
                              child: SingleChildScrollView(
                                key: const Key('desktop_calendar_scroll_view'),
                                physics: const BouncingScrollPhysics(),
                                padding: const EdgeInsets.fromLTRB(16, 8, 8, 16),
                                child: ReservationCalendarPanel(
                                  key: const Key('reservation_calendar_panel'),
                                  selectedDate: _selectedDate,
                                  onDateSelected: (date) {
                                    setState(() {
                                      _selectedDate = date;
                                    });
                                    ref.read(bookingFlowProvider.notifier).setSelectedDate(date);
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
                                    ref.read(bookingFlowProvider.notifier).setSelectedPax(pax);
                                  },
                                  selectedTime: _selectedTime,
                                  onTimeSelected: (time) {
                                    setState(() {
                                      _selectedTime = time;
                                    });
                                    ref.read(bookingFlowProvider.notifier).setSelectedTime(time);
                                  },
                                  paymentMethod: _paymentMethod,
                                  onPaymentMethodSelected: (method) {
                                    setState(() {
                                      _paymentMethod = method;
                                    });
                                    ref.read(bookingFlowProvider.notifier).setPaymentMethod(method);
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
                    actionButtonText: isPayment ? 'Confirm & Pay' : 'Proceed to Payment',
                    isSticky: true,
                    onProceed: () {
                      setState(() {
                        if (currentStep == 4) {
                          currentStep = 5;
                        } else {
                          currentStep = 4;
                        }
                      });
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
    final isPayment = currentStep == 4;

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
                  layoutBuilder: (Widget? currentChild, List<Widget> previousChildren) {
                    return Stack(
                      alignment: Alignment.topLeft,
                      children: <Widget>[
                        ...previousChildren,
                        ?currentChild,
                      ],
                    );
                  },
                  transitionBuilder: (child, animation) {
                    return FadeTransition(
                      opacity: animation,
                      child: child,
                    );
                  },
                  child: isPayment
                      ? DesktopPaymentPanel(
                          key: const ValueKey('tablet_payment_panel_view'),
                          package: package,
                          selectedDate: _selectedDate,
                          selectedTime: _selectedTime,
                          selectedPax: _selectedPax,
                          paymentMethod: _paymentMethod,
                          onPaymentMethodSelected: (method) {
                            setState(() {
                              _paymentMethod = method;
                            });
                            ref.read(bookingFlowProvider.notifier).setPaymentMethod(method);
                          },
                          onBackToReservation: () {
                            setState(() {
                              currentStep = 2;
                            });
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
                                  ref.read(bookingFlowProvider.notifier).setSelectedDate(date);
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
                                  ref.read(bookingFlowProvider.notifier).setSelectedPax(pax);
                                },
                                selectedTime: _selectedTime,
                                onTimeSelected: (time) {
                                  setState(() {
                                    _selectedTime = time;
                                  });
                                  ref.read(bookingFlowProvider.notifier).setSelectedTime(time);
                                },
                                paymentMethod: _paymentMethod,
                                onPaymentMethodSelected: (method) {
                                  setState(() {
                                    _paymentMethod = method;
                                  });
                                  ref.read(bookingFlowProvider.notifier).setPaymentMethod(method);
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
                    actionButtonText: isPayment ? 'Confirm & Pay' : 'Proceed to Payment',
                    isSticky: true,
                    onProceed: () {
                      setState(() {
                        if (currentStep == 4) {
                          currentStep = 5;
                        } else {
                          currentStep = 4;
                        }
                      });
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
              onPressed: () {
                setState(() {
                  if (currentStep < 5) currentStep++;
                });
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: plum,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(9999)),
              ),
              child: Text(
                currentStep == 4
                    ? 'Confirm & Pay'
                    : currentStep == 3
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
    final isPayment = currentStep == 4;

    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 14, 20, 6),
      child: Row(
        children: [
          TextButton.icon(
            onPressed: () {
              if (currentStep > 2) {
                setState(() => currentStep = 2);
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
          Container(
            height: 18,
            width: 1,
            color: const Color(0x3399868C),
          ),
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
                    isPayment ? Icons.lock_outline_rounded : Icons.check_circle_rounded,
                    size: 13,
                    color: isPayment ? plum : const Color(0xFF16A34A),
                  ),
                  const SizedBox(width: 5),
                  Flexible(
                    child: Text(
                      isPayment
                          ? 'Secure In-Place Checkout'
                          : (MediaQuery.of(context).size.width > ResponsiveAppShell.tabletBreakpoint
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
  // PAYMENT SUCCESSFUL SCREEN
  // ==========================================================================

  Widget _buildSuccessScreen() {
    return Column(
      children: [
        if (MediaQuery.of(context).size.width < 768)
          _buildHeader(showBack: false),
        Expanded(
          child: Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(vertical: 16),
              child: Container(
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
                      decoration: const BoxDecoration(
                        color: Color(0xFF22C55E),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(Icons.check_rounded, color: Colors.white, size: 40),
                    ),
                    const SizedBox(height: 20),
                    const Text(
                      'Payment Successful',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w700,
                        color: plum,
                      ),
                    ),
                    const SizedBox(height: 18),
                    const Text(
                      'Thank you for your booking.',
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 14, color: Color(0x8A6A4053)),
                    ),
                    const SizedBox(height: 4),
                    const Text(
                      'To check your status go to your\nbooking settings.',
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 14, color: Color(0x8A6A4053), height: 1.4),
                    ),
                    const SizedBox(height: 28),
                    SizedBox(
                      width: double.infinity,
                      height: 48,
                      child: ElevatedButton(
                        onPressed: () {
                          if (context.canPop()) {
                            context.pop();
                          } else {
                            try {
                              context.go('/home');
                            } catch (_) {}
                          }
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: plum,
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(9999)),
                        ),
                        child: const Text('Done', style: TextStyle(color: Colors.white, fontSize: 16)),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ],
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
                if (currentStep > 2) {
                  setState(() => currentStep--);
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
              label: const Text('Back', style: TextStyle(color: plum, fontSize: 14)),
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
          final isPast = index <= currentStep;
          final isCurrent = index == currentStep;
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
                          color: isPast ? plum : const Color(0xFF99868C),
                        ),
                      ),
                    Container(
                      width: 16,
                      height: 16,
                      decoration: BoxDecoration(
                        color: isPast ? plum : const Color(0xFF99868C),
                        shape: BoxShape.circle,
                      ),
                    ),
                    if (index == steps.length - 1)
                      const Expanded(child: SizedBox())
                    else
                      Expanded(
                        child: Container(
                          height: 3,
                          color: index < currentStep ? plum : const Color(0xFF99868C),
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
    if (currentStep == 2) {
      // Schedule Step
      final timeSlots = [
        '10:00 AM - 1:00 PM',
        '2:00 PM - 5:00 PM',
        '6:00 PM - 9:00 PM',
      ];

      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Wrap(
            spacing: 8,
            runSpacing: 6,
            alignment: WrapAlignment.spaceBetween,
            crossAxisAlignment: WrapCrossAlignment.center,
            children: [
              const Text('Please Choose Available Schedule', style: TextStyle(fontSize: 13, color: plum)),
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(width: 6, height: 6, decoration: const BoxDecoration(color: Colors.amber, shape: BoxShape.circle)),
                  const SizedBox(width: 4),
                  const Text('Booked', style: TextStyle(fontSize: 11, color: plum)),
                  const SizedBox(width: 12),
                  Container(width: 6, height: 6, decoration: const BoxDecoration(color: plum, shape: BoxShape.circle)),
                  const SizedBox(width: 4),
                  const Text('Available', style: TextStyle(fontSize: 11, color: plum)),
                ],
              ),
            ],
          ),
          const SizedBox(height: 15),
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(15),
              border: Border.all(color: const Color(0x4D99868C)),
            ),
            child: TableCalendar(
              firstDay: _firstCalendarDay,
              lastDay: _lastCalendarDay,
              focusedDay: _clampDay(_selectedDate ?? DateTime.now()),
              headerStyle: const HeaderStyle(
                formatButtonVisible: false,
                titleCentered: true,
                leftChevronVisible: false,
                rightChevronVisible: false,
                titleTextStyle: TextStyle(fontSize: 0),
              ),
              calendarStyle: const CalendarStyle(
                todayDecoration: BoxDecoration(color: Colors.transparent),
                todayTextStyle: TextStyle(color: Color(0xFF6A4053)),
                selectedDecoration: BoxDecoration(
                  color: plum,
                  shape: BoxShape.circle,
                ),
                selectedTextStyle: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
              ),
              selectedDayPredicate: (day) => _selectedDate != null && isSameDay(_selectedDate, day),
              onDaySelected: (selectedDay, focusedDay) {
                setState(() {
                  _selectedDate = selectedDay;
                });
                ref.read(bookingFlowProvider.notifier).setSelectedDate(selectedDay);
              },
            ),
          ),
          const SizedBox(height: 25),
          const Text('Please Choose Available Pax', style: TextStyle(fontSize: 13, color: plum)),
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
              children: (package.paxOptions ?? [20, 30, 50, 75, 100]).map((pax) {
                final isSelected = _selectedPax == pax;
                return ChoiceChip(
                  label: Text('$pax Pax'),
                  selected: isSelected,
                  selectedColor: plum,
                  labelStyle: TextStyle(
                    color: isSelected ? Colors.white : plum,
                    fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                  ),
                  onSelected: (selected) {
                    if (selected) {
                      setState(() => _selectedPax = pax);
                      ref.read(bookingFlowProvider.notifier).setSelectedPax(pax);
                    }
                  },
                );
              }).toList(),
            ),
          ),
          const SizedBox(height: 25),
          const Text('Please Choose Available Time Slot', style: TextStyle(fontSize: 13, color: plum)),
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
                    fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                  ),
                  onSelected: (selected) {
                    if (selected) {
                      setState(() => _selectedTime = time);
                      ref.read(bookingFlowProvider.notifier).setSelectedTime(time);
                    }
                  },
                );
              }).toList(),
            ),
          ),
        ],
      );
    } else if (currentStep == 3) {
      // Details Step
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Order Details', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: plum)),
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
                      const Text('Details', style: TextStyle(fontSize: 14, color: Color(0xFF6A4053))),
                      const SizedBox(height: 15),
                      Text('Package Variation: ${package.name}', style: const TextStyle(fontSize: 13, color: Color(0x8A6A4053))),
                      const SizedBox(height: 15),
                      const Text('Inclusion/s:', style: TextStyle(fontSize: 13, color: Color(0x8A6A4053))),
                      const SizedBox(height: 5),
                      ...(package.inclusions ?? []).map((e) => Text('• $e', style: const TextStyle(fontSize: 12, color: Color(0xFF6A4053)))),
                      const SizedBox(height: 15),
                      const Text('Free:', style: TextStyle(fontSize: 13, color: Color(0x8A6A4053))),
                      const SizedBox(height: 5),
                      ...(package.freebies ?? []).map((e) => Text('• $e', style: const TextStyle(fontSize: 12, color: Color(0xFF6A4053)))),
                      const SizedBox(height: 15),
                      const Text('Selected Date:', style: TextStyle(fontSize: 13, color: Color(0x8A6A4053))),
                      const SizedBox(height: 5),
                      Text(
                        _selectedDate != null
                            ? '${_selectedDate!.year}-${_selectedDate!.month.toString().padLeft(2, '0')}-${_selectedDate!.day.toString().padLeft(2, '0')}'
                            : 'Not selected',
                        style: const TextStyle(fontSize: 13, color: plum),
                      ),
                      const SizedBox(height: 15),
                      const Text('Selected Time:', style: TextStyle(fontSize: 13, color: Color(0x8A6A4053))),
                      const SizedBox(height: 5),
                      Text(
                        _selectedTime ?? '2:00 PM - 5:00 PM',
                        style: const TextStyle(fontSize: 13, color: plum),
                      ),
                      const SizedBox(height: 15),
                      const Text('Selected Pax:', style: TextStyle(fontSize: 13, color: Color(0x8A6A4053))),
                      const SizedBox(height: 5),
                      Text(
                        '${_selectedPax ?? 50} Pax',
                        style: const TextStyle(fontSize: 13, color: plum),
                      ),
                      const SizedBox(height: 15),
                      const Text('Total Cost:', style: TextStyle(fontSize: 13, color: Color(0x8A6A4053))),
                      const SizedBox(height: 5),
                      Text('Php. ${(package.price ?? 4500).toStringAsFixed(2)}', style: const TextStyle(fontSize: 13, color: plum)),
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
                        borderRadius: const BorderRadius.only(topLeft: Radius.circular(15), topRight: Radius.circular(15)),
                        child: Container(
                          height: 100,
                          width: double.infinity,
                          color: const Color(0xFFF3EBE1),
                          child: (package.images != null && package.images!.isNotEmpty)
                              ? Image.network(
                                  package.images![0],
                                  fit: BoxFit.cover,
                                  errorBuilder: (context, error, stackTrace) => const Icon(
                                    Icons.local_florist,
                                    color: plum,
                                    size: 32,
                                  ),
                                )
                              : const Icon(Icons.local_florist, color: plum, size: 32),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(12),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(package.name ?? '', style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w500)),
                            const SizedBox(height: 8),
                            Text(package.description ?? '', maxLines: 3, style: const TextStyle(fontSize: 10, color: Color(0xFF99868C))),
                            const SizedBox(height: 12),
                            Text('Php. ${(package.price ?? 4499.0).toStringAsFixed(2)}', style: const TextStyle(fontSize: 13, color: plum)),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ],
      );
    } else if (currentStep == 4) {
      // Payment Step
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Price Details', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: plum)),
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
                Text(package.name ?? '', style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w500, color: plum)),
                const SizedBox(height: 15),
                const Text('Inclusion/s:', style: TextStyle(fontSize: 12, color: Color(0xFF99868C))),
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
                            style: const TextStyle(fontSize: 12, color: Color(0xFF6A4053)),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        Expanded(
                          flex: 2,
                          child: LayoutBuilder(
                            builder: (context, constraints) {
                              final count = (constraints.maxWidth / 8).floor().clamp(1, 20);
                              return Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 5),
                                child: Text(
                                  '- ' * count,
                                  maxLines: 1,
                                  overflow: TextOverflow.clip,
                                  style: const TextStyle(color: Color(0xFF99868C)),
                                ),
                              );
                            },
                          ),
                        ),
                        Text(item['val']!, style: const TextStyle(fontSize: 12, color: Color(0xFF6A4053))),
                      ],
                    ),
                  );
                }),
                const SizedBox(height: 20),
                Align(
                  alignment: Alignment.centerRight,
                  child: Text('Total: Php. ${(package.price ?? 4500.0).toStringAsFixed(2)}', style: const TextStyle(fontSize: 13, color: Color(0xFF99868C))),
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
                const Text('Choose Payment Method', style: TextStyle(fontSize: 15, fontWeight: FontWeight.w500, color: plum)),
                const SizedBox(height: 16),
                Row(
                  children: [
                    {'id': 'gcash', 'label': 'GCash', 'color': Colors.blue},
                    {'id': 'card', 'label': 'VISA / MC', 'color': Colors.orange},
                    {'id': 'maya', 'label': 'maya', 'color': Colors.green},
                  ].map((m) {
                    final isSel = _paymentMethod == m['id'];
                    return Expanded(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 3),
                        child: InkWell(
                          onTap: () {
                            setState(() => _paymentMethod = m['id'] as String);
                            ref.read(bookingFlowProvider.notifier).setPaymentMethod(m['id'] as String);
                          },
                          borderRadius: BorderRadius.circular(8),
                          child: Container(
                            padding: const EdgeInsets.symmetric(vertical: 8),
                            alignment: Alignment.center,
                            decoration: BoxDecoration(
                              color: isSel ? (m['color'] as Color).withValues(alpha: 0.15) : Colors.transparent,
                              borderRadius: BorderRadius.circular(8),
                              border: Border.all(
                                color: isSel ? (m['color'] as Color) : const Color(0x3399868C),
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

    return Center(child: Text('Step $currentStep details here'));
  }
}
