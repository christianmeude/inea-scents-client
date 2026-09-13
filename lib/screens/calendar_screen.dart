import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:table_calendar/table_calendar.dart';

import '../providers/index.dart';
import '../widgets/index.dart';

class CalendarScreen extends ConsumerStatefulWidget {
  const CalendarScreen({super.key});

  @override
  ConsumerState<CalendarScreen> createState() => _CalendarScreenState();
}

class _CalendarScreenState extends ConsumerState<CalendarScreen> {
  DateTime? _selectedDay;

  // ============================================================
  // INEA COLORS
  // ============================================================

  static const Color primary = Color(0xFF74445C);

  static const Color available = Color(0xFF6F927A);
  static const Color booked = Color(0xFFC28A52);

  @override
  Widget build(BuildContext context) {
    // P7: chrome resolves through the shared helper; brand accents
    // (selected day, markers) stay fixed in both modes.
    final surfaceBorder = CardSurfaces.cardBorder(context);
    final titleColor = CardSurfaces.title(context);
    final chipColor = CardSurfaces.chipBg(context);
    final availabilityAsync = ref.watch(availabilityProvider);

    // P7: no explicit color — flat theme scaffold background.
    return Scaffold(
      // ========================================================
      // APP BAR (Mobile only, Desktop uses TopNavBar in App Shell)
      // ========================================================
      appBar: MediaQuery.of(context).size.width < 768
          ? AppBar(
              backgroundColor: Colors.transparent,
              surfaceTintColor: Colors.transparent,
              elevation: 0,
              centerTitle: true,

              title: const _BrandName(),

              actions: [
                Padding(
                  padding: const EdgeInsets.only(right: 14),
                  child: Container(
                    width: 42,
                    height: 42,
                    decoration: BoxDecoration(
                      color: chipColor,
                      shape: BoxShape.circle,
                      border: Border.all(color: surfaceBorder),
                    ),
                    child: IconButton(
                      padding: EdgeInsets.zero,
                      icon: Icon(
                        Icons.refresh_rounded,
                        size: 20,
                        color: titleColor,
                      ),
                      onPressed: () {
                        ref.read(availabilityProvider.notifier).refresh();
                      },
                    ),
                  ),
                ),
              ],
            )
          : null,

      // ========================================================
      // BODY
      // ========================================================
      // P7: flat theme background; decorative gradient removed.
      body: SafeArea(
        child: availabilityAsync.when(
          loading: () {
            return Center(
              child: CircularProgressIndicator(
                strokeWidth: 2.5,
                color: titleColor,
              ),
            );
          },

          // P6 (Q6/Q8): shared friendly card; raw errors stay
          // in logs, never on screen.
          error: (error, _) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: ErrorStateCard(
                  title: 'Unable to load availability',
                  message:
                      "We couldn't load the calendar. "
                      'Check your connection and try again.',
                  onRetry: () {
                    ref.read(availabilityProvider.notifier).refresh();
                  },
                ),
              ),
            );
          },

          data: (availabilityState) {
            return _buildCalendar(availabilityState);
          },
        ),
      ),
    );
  }

  // ============================================================
  // CALENDAR CONTENT
  // ============================================================

  Widget _buildCalendar(AvailabilityState availabilityState) {
    // P7: content chrome resolves through the shared helper.
    final surface = CardSurfaces.cardBg(context);
    final surfaceBorder = CardSurfaces.cardBorder(context);
    final titleColor = CardSurfaces.title(context);
    final bodyColor = CardSurfaces.body(context);
    final availability = availabilityState.data;
    final now = DateTime.now();
    DateTime focusedDay = DateTime(
      availabilityState.year,
      availabilityState.month,
      1,
    );
    if (focusedDay.year == now.year && focusedDay.month == now.month) {
      focusedDay = now;
    }

    final dates = <DateTime, String>{
      for (final item in availability)
        if (item.date != null) _dayOnly(item.date!): item.status ?? 'available',
    };

    final selectedStatus = _selectedDay == null
        ? null
        : dates[_dayOnly(_selectedDay!)];

    return RefreshIndicator(
      color: titleColor,
      onRefresh: () async {
        ref.read(availabilityProvider.notifier).refresh();
      },

      child: ListView(
        physics: const BouncingScrollPhysics(),

        padding: const EdgeInsets.fromLTRB(20, 12, 20, 30),

        children: [
          // ====================================================
          // PAGE TITLE
          // ====================================================
          Text(
            'Availability',
            style: TextStyle(
              color: titleColor,
              fontSize: 26,
              fontWeight: FontWeight.w600,
              letterSpacing: 0.1,
            ),
          ),

          const SizedBox(height: 5),

          Text(
            'Choose a date for your scent experience.',
            style: TextStyle(
              color: bodyColor,
              fontSize: 13,
              fontWeight: FontWeight.w400,
            ),
          ),

          const SizedBox(height: 22),

          // ====================================================
          // CALENDAR CARD
          // ====================================================
          Container(
            decoration: BoxDecoration(
              color: surface,
              borderRadius: BorderRadius.circular(24),

              border: Border.all(color: surfaceBorder, width: 1),

              boxShadow: [
                BoxShadow(
                  color: primary.withValues(alpha: 0.10),
                  blurRadius: 22,
                  offset: const Offset(0, 10),
                ),
              ],
            ),

            child: Padding(
              padding: const EdgeInsets.fromLTRB(12, 14, 12, 14),

              child: TableCalendar<String>(
                firstDay: DateTime.now(),

                lastDay: DateTime(DateTime.now().year + 1, 12, 31),

                focusedDay: focusedDay,

                selectedDayPredicate: (day) {
                  return isSameDay(_selectedDay, day);
                },

                eventLoader: (day) {
                  final status = dates[_dayOnly(day)];

                  if (status == null) {
                    return const [];
                  }

                  return [status];
                },

                enabledDayPredicate: (day) {
                  final status = dates[_dayOnly(day)];

                  return status != null && _isAvailable(status);
                },

                onDaySelected: (selectedDay, focusedDay) {
                  final status = dates[_dayOnly(selectedDay)] ?? '';

                  if (!_isAvailable(status)) {
                    return;
                  }

                  setState(() {
                    _selectedDay = selectedDay;
                  });
                  ref
                      .read(availabilityProvider.notifier)
                      .setMonth(focusedDay.month, focusedDay.year);
                },

                onPageChanged: (newFocusedDay) {
                  setState(() {
                    _selectedDay = null;
                  });
                  ref
                      .read(availabilityProvider.notifier)
                      .setMonth(newFocusedDay.month, newFocusedDay.year);
                },

                // ==================================================
                // HEADER
                // ==================================================
                headerStyle: HeaderStyle(
                  titleCentered: true,

                  formatButtonVisible: false,

                  leftChevronIcon: Icon(
                    Icons.chevron_left_rounded,
                    color: titleColor,
                    size: 28,
                  ),

                  rightChevronIcon: Icon(
                    Icons.chevron_right_rounded,
                    color: titleColor,
                    size: 28,
                  ),

                  titleTextStyle: TextStyle(
                    color: titleColor,
                    fontSize: 17,
                    fontWeight: FontWeight.w700,
                  ),

                  headerPadding: EdgeInsets.only(bottom: 12, top: 2),
                ),

                // ==================================================
                // DAYS OF WEEK
                // ==================================================
                daysOfWeekStyle: DaysOfWeekStyle(
                  weekdayStyle: TextStyle(
                    color: bodyColor,
                    fontSize: 10,
                    fontWeight: FontWeight.w600,
                  ),

                  weekendStyle: TextStyle(
                    color: bodyColor,
                    fontSize: 10,
                    fontWeight: FontWeight.w600,
                  ),
                ),

                // ==================================================
                // CALENDAR STYLE
                // ==================================================
                calendarStyle: CalendarStyle(
                  outsideDaysVisible: false,

                  cellMargin: const EdgeInsets.all(3),

                  defaultTextStyle: TextStyle(
                    color: titleColor,
                    fontSize: 13,
                    fontWeight: FontWeight.w500,
                  ),

                  weekendTextStyle: TextStyle(
                    color: titleColor,
                    fontSize: 13,
                    fontWeight: FontWeight.w500,
                  ),

                  disabledTextStyle: const TextStyle(
                    color: Color(0xFFC9BBC0),
                    fontSize: 13,
                  ),

                  todayTextStyle: TextStyle(
                    color: titleColor,
                    fontSize: 13,
                    fontWeight: FontWeight.w700,
                  ),

                  selectedTextStyle: const TextStyle(
                    color: Colors.white,
                    fontSize: 13,
                    fontWeight: FontWeight.w700,
                  ),

                  // Brand accent stays plum in both modes (white
                  // day number keeps full contrast on it).
                  selectedDecoration: const BoxDecoration(
                    color: primary,
                    shape: BoxShape.circle,
                  ),

                  todayDecoration: BoxDecoration(
                    color: primary.withValues(alpha: 0.13),
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: primary.withValues(alpha: 0.35),
                      width: 1,
                    ),
                  ),

                  markerDecoration: const BoxDecoration(
                    color: available,
                    shape: BoxShape.circle,
                  ),

                  markersMaxCount: 1,

                  markerSize: 5,

                  markerMargin: const EdgeInsets.only(top: 2),
                ),

                // ==================================================
                // CUSTOM DATE CELLS
                // ==================================================
                calendarBuilders: CalendarBuilders(
                  defaultBuilder: (context, day, focusedDay) {
                    final status = dates[_dayOnly(day)];

                    return _CalendarDay(
                      day: day,
                      status: status,
                      isToday: isSameDay(day, DateTime.now()),
                    );
                  },

                  disabledBuilder: (context, day, focusedDay) {
                    return _CalendarDay(day: day, status: null, disabled: true);
                  },

                  todayBuilder: (context, day, focusedDay) {
                    final status = dates[_dayOnly(day)];

                    return _CalendarDay(
                      day: day,
                      status: status,
                      isToday: true,
                    );
                  },

                  selectedBuilder: (context, day, focusedDay) {
                    return _CalendarDay(
                      day: day,
                      status: dates[_dayOnly(day)],
                      selected: true,
                    );
                  },
                ),
              ),
            ),
          ),

          const SizedBox(height: 20),

          // Legend + selection agenda: stacked on mobile, side by
          // side on web (P7 impeccable adapt).
          _buildAgendaColumn(selectedStatus),

          const SizedBox(height: 10),
        ],
      ),
    );
  }

  /// Legend + selected-date panel + continue action. Stacked on
  /// mobile, legend | selection side-by-side on web.
  Widget _buildAgendaColumn(String? selectedStatus) {
    final surface = CardSurfaces.cardBg(context);
    final surfaceBorder = CardSurfaces.cardBorder(context);
    final titleColor = CardSurfaces.title(context);
    final bodyColor = CardSurfaces.body(context);
    final chipColor = CardSurfaces.chipBg(context);
    final legendCard = Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),

      decoration: BoxDecoration(
        color: chipColor,
        borderRadius: BorderRadius.circular(18),

        border: Border.all(color: surfaceBorder),
      ),

      child: const Row(
        children: [
          Expanded(
            child: _Legend(color: available, label: 'Available'),
          ),

          Expanded(
            child: _Legend(color: booked, label: 'Booked'),
          ),
        ],
      ),
    );

    final selection = Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // ====================================================
        // SELECTED DATE
        // ====================================================
        if (_selectedDay != null) ...[
          const SizedBox(height: 18),

          Container(
            padding: const EdgeInsets.all(17),

            decoration: BoxDecoration(
              color: surface,
              borderRadius: BorderRadius.circular(20),

              border: Border.all(color: available.withValues(alpha: 0.25)),

              boxShadow: [
                BoxShadow(
                  color: primary.withValues(alpha: 0.07),
                  blurRadius: 16,
                  offset: const Offset(0, 7),
                ),
              ],
            ),

            child: Row(
              children: [
                Container(
                  width: 46,
                  height: 46,

                  decoration: BoxDecoration(
                    color: chipColor,
                    borderRadius: BorderRadius.circular(14),
                  ),

                  child: const Icon(
                    Icons.event_available_rounded,
                    color: available,
                    size: 23,
                  ),
                ),

                const SizedBox(width: 13),

                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'SELECTED DATE',
                        style: TextStyle(
                          color: bodyColor,
                          fontSize: 9,
                          fontWeight: FontWeight.w700,
                          letterSpacing: 1,
                        ),
                      ),

                      const SizedBox(height: 4),

                      Text(
                        _formatDate(_selectedDay!),
                        style: TextStyle(
                          color: titleColor,
                          fontSize: 15,
                          fontWeight: FontWeight.w700,
                        ),
                      ),

                      const SizedBox(height: 2),

                      Text(
                        selectedStatus ?? 'Available',
                        style: const TextStyle(
                          color: available,
                          fontSize: 11,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 12),
          SizedBox(
            width: double.infinity,
            height: 48,
            child: ElevatedButton.icon(
              onPressed: () {
                final d = _selectedDay!;
                final dateStr =
                    '${d.year}-${d.month.toString().padLeft(2, '0')}-${d.day.toString().padLeft(2, '0')}';
                ref.read(bookingFlowProvider.notifier).setSelectedDate(d);
                context.push('/packages?date=$dateStr');
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(
                      'Selected $dateStr — choose a package to book',
                    ),
                  ),
                );
              },
              icon: const Icon(Icons.arrow_forward_rounded, size: 18),
              label: Text('Continue with ${_formatDate(_selectedDay!)}'),
              // P7: theme ElevatedButton drives both modes.
              style: ElevatedButton.styleFrom(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(9999),
                ),
              ),
            ),
          ),
        ],
      ],
    );

    // P7 impeccable adapt: stacked on mobile, legend | selection
    // side-by-side on web.
    final wide =
        MediaQuery.of(context).size.width > ResponsiveAppShell.tabletBreakpoint;
    if (!wide) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [legendCard, const SizedBox(height: 20), selection],
      );
    }
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(child: legendCard),
        const SizedBox(width: 16),
        Expanded(child: selection),
      ],
    );
  }

  // ============================================================
  // HELPERS
  // ============================================================

  bool _isAvailable(String status) {
    return status.toLowerCase() == 'available';
  }

  DateTime _dayOnly(DateTime date) {
    return DateTime(date.year, date.month, date.day);
  }

  String _formatDate(DateTime date) {
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

    return '${months[date.month - 1]} '
        '${date.day}, '
        '${date.year}';
  }
}

// ============================================================================
// BRAND NAME
// Matches Packages screen alignment
// ============================================================================

class _BrandName extends StatelessWidget {
  const _BrandName();

  @override
  Widget build(BuildContext context) {
    const brandColor = Color(0xFF6D3E55);

    return SizedBox(
      width: 130,
      height: 58,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            'INEA',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 25,
              fontWeight: FontWeight.w400,
              letterSpacing: 5.2,
              height: 0.85,
              color: brandColor,
              shadows: [
                Shadow(
                  color: Colors.white.withValues(alpha: 0.75),
                  blurRadius: 1.5,
                  offset: const Offset(1, 1),
                ),
              ],
            ),
          ),

          const SizedBox(height: 3),

          Text(
            'Scents',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 22,
              fontStyle: FontStyle.italic,
              fontWeight: FontWeight.w300,
              fontFamily: 'serif',
              letterSpacing: 0.3,
              height: 0.95,
              color: brandColor,
              shadows: [
                Shadow(
                  color: Colors.white.withValues(alpha: 0.75),
                  blurRadius: 1.5,
                  offset: const Offset(1, 1),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// ============================================================================
// CUSTOM CALENDAR DAY
// ============================================================================

class _CalendarDay extends StatelessWidget {
  final DateTime day;
  final String? status;
  final bool selected;
  final bool isToday;
  final bool disabled;

  const _CalendarDay({
    required this.day,
    this.status,
    this.selected = false,
    this.isToday = false,
    this.disabled = false,
  });

  @override
  Widget build(BuildContext context) {
    const primary = Color(0xFF74445C);
    const available = Color(0xFF6F927A);
    const booked = Color(0xFFC28A52);

    final hasStatus = status != null;

    final isAvailable = status?.toLowerCase() == 'available';

    final statusColor = isAvailable ? available : booked;

    return Container(
      margin: const EdgeInsets.all(3),

      decoration: BoxDecoration(
        color: selected
            ? primary
            : isToday
            ? primary.withValues(alpha: 0.10)
            : Colors.transparent,

        shape: BoxShape.circle,

        border: isToday && !selected
            ? Border.all(color: primary.withValues(alpha: 0.35), width: 1)
            : null,
      ),

      child: Stack(
        alignment: Alignment.center,

        children: [
          Text(
            '${day.day}',
            style: TextStyle(
              color: disabled
                  ? const Color(0xFFC9BBC0)
                  : selected
                  ? Colors.white
                  : CardSurfaces.title(context),

              fontSize: 13,

              fontWeight: selected || isToday
                  ? FontWeight.w700
                  : FontWeight.w500,
            ),
          ),

          if (hasStatus)
            Positioned(
              bottom: 5,
              child: Container(
                width: 5,
                height: 5,

                decoration: BoxDecoration(
                  color: selected
                      ? Colors.white.withValues(alpha: 0.9)
                      : statusColor,
                  shape: BoxShape.circle,
                ),
              ),
            ),
        ],
      ),
    );
  }
}

// ============================================================================
// LEGEND
// ============================================================================

class _Legend extends StatelessWidget {
  final Color color;
  final String label;

  const _Legend({required this.color, required this.label});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 10,
          height: 10,

          decoration: BoxDecoration(color: color, shape: BoxShape.circle),
        ),

        const SizedBox(width: 7),

        Text(
          label,
          style: TextStyle(
            color: CardSurfaces.body(context),
            fontSize: 11,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }
}

// NOTE (P6 Q6/Q8): the bespoke _CalendarError was retired; call sites use
// the shared ErrorStateCard from widgets/index.dart (friendly copy, dark-
// aware, raw errors never rendered).
