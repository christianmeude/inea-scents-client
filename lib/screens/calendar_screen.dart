import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
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

  static const Color backgroundTop = Color(0xFFF8E9DF);
  static const Color backgroundMiddle = Color(0xFFD8B0BA);
  static const Color backgroundBottom = Color(0xFFB78C9C);

  static const Color primary = Color(0xFF74445C);
  static const Color primaryDark = Color(0xFF633E50);
  static const Color secondary = Color(0xFF765867);

  static const Color available = Color(0xFF6F927A);
  static const Color booked = Color(0xFFC28A52);

  @override
  Widget build(BuildContext context) {
    final availabilityAsync = ref.watch(availabilityProvider);

    return Scaffold(
      backgroundColor: backgroundTop,

      // ========================================================
      // APP BAR
      // ========================================================
      appBar: AppBar(
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
                color: Colors.white.withValues(alpha: 0.42),
                shape: BoxShape.circle,
                border: Border.all(color: Colors.white.withValues(alpha: 0.65)),
              ),
              child: IconButton(
                padding: EdgeInsets.zero,
                icon: const Icon(
                  Icons.refresh_rounded,
                  size: 20,
                  color: primaryDark,
                ),
                onPressed: () {
                  ref.read(availabilityProvider.notifier).refresh();
                },
              ),
            ),
          ),
        ],
      ),

      // ========================================================
      // BODY
      // ========================================================
      body: Stack(
        children: [
          // ----------------------------------------------------
          // BACKGROUND
          // ----------------------------------------------------
          Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [backgroundTop, backgroundMiddle, backgroundBottom],
              ),
            ),
          ),

          // ----------------------------------------------------
          // BACKGROUND GLOWS
          // ----------------------------------------------------
          Positioned(
            top: -130,
            left: -120,
            child: _BlurCircle(
              size: 390,
              color: const Color(0xFFEBC9B8).withValues(alpha: 0.72),
            ),
          ),

          Positioned(
            top: 100,
            right: -160,
            child: _BlurCircle(
              size: 360,
              color: const Color(0xFFD3A4AF).withValues(alpha: 0.60),
            ),
          ),

          Positioned(
            bottom: -180,
            left: -130,
            child: _BlurCircle(
              size: 430,
              color: const Color(0xFF9C8491).withValues(alpha: 0.48),
            ),
          ),

          // ----------------------------------------------------
          // CONTENT
          // ----------------------------------------------------
          SafeArea(
            child: availabilityAsync.when(
              loading: () {
                return const Center(
                  child: CircularProgressIndicator(
                    strokeWidth: 2.5,
                    color: primary,
                  ),
                );
              },

              error: (error, _) {
                return _CalendarError(
                  error: error.toString(),
                  onRetry: () {
                    ref.read(availabilityProvider.notifier).refresh();
                  },
                );
              },

              data: (availabilityState) {
                return _buildCalendar(availabilityState);
              },
            ),
          ),
        ],
      ),

      // ========================================================
      // BOTTOM NAVIGATION
      // ========================================================
      bottomNavigationBar: const BottomNavBar(),
    );
  }

  // ============================================================
  // CALENDAR CONTENT
  // ============================================================

  Widget _buildCalendar(AvailabilityState availabilityState) {
    final availability = availabilityState.data;
    final focusedDay = DateTime(availabilityState.year, availabilityState.month, 1);

    final dates = <DateTime, String>{
      for (final item in availability)
        if (item.date != null) _dayOnly(item.date!): item.status ?? 'available',
    };

    final selectedStatus = _selectedDay == null
        ? null
        : dates[_dayOnly(_selectedDay!)];

    return RefreshIndicator(
      color: primary,
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
          const Text(
            'Availability',
            style: TextStyle(
              color: primaryDark,
              fontSize: 26,
              fontWeight: FontWeight.w600,
              letterSpacing: 0.1,
            ),
          ),

          const SizedBox(height: 5),

          const Text(
            'Choose a date for your scent experience.',
            style: TextStyle(
              color: secondary,
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
              color: Colors.white.withValues(alpha: 0.93),
              borderRadius: BorderRadius.circular(24),

              border: Border.all(
                color: Colors.white.withValues(alpha: 0.85),
                width: 1,
              ),

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
                  ref.read(availabilityProvider.notifier).setMonth(focusedDay.month, focusedDay.year);
                },

                onPageChanged: (newFocusedDay) {
                  setState(() {
                    _selectedDay = null;
                  });
                  ref.read(availabilityProvider.notifier).setMonth(newFocusedDay.month, newFocusedDay.year);
                },

                // ==================================================
                // HEADER
                // ==================================================
                headerStyle: const HeaderStyle(
                  titleCentered: true,

                  formatButtonVisible: false,

                  leftChevronIcon: Icon(
                    Icons.chevron_left_rounded,
                    color: primary,
                    size: 28,
                  ),

                  rightChevronIcon: Icon(
                    Icons.chevron_right_rounded,
                    color: primary,
                    size: 28,
                  ),

                  titleTextStyle: TextStyle(
                    color: primaryDark,
                    fontSize: 17,
                    fontWeight: FontWeight.w700,
                  ),

                  headerPadding: EdgeInsets.only(bottom: 12, top: 2),
                ),

                // ==================================================
                // DAYS OF WEEK
                // ==================================================
                daysOfWeekStyle: const DaysOfWeekStyle(
                  weekdayStyle: TextStyle(
                    color: secondary,
                    fontSize: 10,
                    fontWeight: FontWeight.w600,
                  ),

                  weekendStyle: TextStyle(
                    color: secondary,
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

                  defaultTextStyle: const TextStyle(
                    color: primaryDark,
                    fontSize: 13,
                    fontWeight: FontWeight.w500,
                  ),

                  weekendTextStyle: const TextStyle(
                    color: primaryDark,
                    fontSize: 13,
                    fontWeight: FontWeight.w500,
                  ),

                  disabledTextStyle: const TextStyle(
                    color: Color(0xFFC9BBC0),
                    fontSize: 13,
                  ),

                  todayTextStyle: const TextStyle(
                    color: primary,
                    fontSize: 13,
                    fontWeight: FontWeight.w700,
                  ),

                  selectedTextStyle: const TextStyle(
                    color: Colors.white,
                    fontSize: 13,
                    fontWeight: FontWeight.w700,
                  ),

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

          // ====================================================
          // LEGEND
          // ====================================================
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),

            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.48),
              borderRadius: BorderRadius.circular(18),

              border: Border.all(color: Colors.white.withValues(alpha: 0.65)),
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
          ),

          // ====================================================
          // SELECTED DATE
          // ====================================================
          if (_selectedDay != null) ...[
            const SizedBox(height: 18),

            Container(
              padding: const EdgeInsets.all(17),

              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.92),
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
                      color: const Color(0xFFE5EFE8),
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
                        const Text(
                          'SELECTED DATE',
                          style: TextStyle(
                            color: Color(0xFF9A7A89),
                            fontSize: 9,
                            fontWeight: FontWeight.w700,
                            letterSpacing: 1,
                          ),
                        ),

                        const SizedBox(height: 4),

                        Text(
                          _formatDate(_selectedDay!),
                          style: const TextStyle(
                            color: primaryDark,
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
          ],

          const SizedBox(height: 10),
        ],
      ),
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
    const primaryDark = Color(0xFF633E50);
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
                  : primaryDark,

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
                  color: selected ? Colors.white.withValues(alpha: 0.9) : statusColor,
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
          style: const TextStyle(
            color: Color(0xFF765867),
            fontSize: 11,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }
}

// ============================================================================
// ERROR STATE
// ============================================================================

class _CalendarError extends StatelessWidget {
  final String error;
  final VoidCallback onRetry;

  const _CalendarError({required this.error, required this.onRetry});

  @override
  Widget build(BuildContext context) {
    const primary = Color(0xFF74445C);
    const textColor = Color(0xFF633E50);
    const secondary = Color(0xFF765867);

    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 30),

        child: Container(
          padding: const EdgeInsets.all(25),

          decoration: BoxDecoration(
            color: Colors.white.withValues(alpha: 0.90),
            borderRadius: BorderRadius.circular(24),

            border: Border.all(color: Colors.white.withValues(alpha: 0.85)),

            boxShadow: [
              BoxShadow(
                color: primary.withValues(alpha: 0.08),
                blurRadius: 20,
                offset: const Offset(0, 8),
              ),
            ],
          ),

          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 70,
                height: 70,

                decoration: const BoxDecoration(
                  color: Color(0xFFF5E8EC),
                  shape: BoxShape.circle,
                ),

                child: const Icon(
                  Icons.calendar_month_outlined,
                  size: 35,
                  color: primary,
                ),
              ),

              const SizedBox(height: 18),

              const Text(
                'Unable to load availability',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  color: textColor,
                ),
              ),

              const SizedBox(height: 8),

              Text(
                error,
                textAlign: TextAlign.center,
                maxLines: 3,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  color: secondary,
                  fontSize: 12,
                  height: 1.4,
                ),
              ),

              const SizedBox(height: 18),

              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: onRetry,

                  style: ElevatedButton.styleFrom(
                    backgroundColor: primary,
                    foregroundColor: Colors.white,

                    elevation: 0,

                    padding: const EdgeInsets.symmetric(vertical: 13),

                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                  ),

                  child: const Text(
                    'Try Again',
                    style: TextStyle(fontWeight: FontWeight.w600),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ============================================================================
// BLURRED BACKGROUND CIRCLE
// ============================================================================

class _BlurCircle extends StatelessWidget {
  final double size;
  final Color color;

  const _BlurCircle({required this.size, required this.color});

  @override
  Widget build(BuildContext context) {
    return ImageFiltered(
      imageFilter: const ColorFilter.matrix([
        1,
        0,
        0,
        0,
        0,
        0,
        1,
        0,
        0,
        0,
        0,
        0,
        1,
        0,
        0,
        0,
        0,
        0,
        1,
        0,
      ]),

      child: Container(
        width: size,
        height: size,

        decoration: BoxDecoration(shape: BoxShape.circle, color: color),
      ),
    );
  }
}
