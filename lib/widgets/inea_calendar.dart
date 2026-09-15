import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:table_calendar/table_calendar.dart';

import '../providers/index.dart';
import 'card_surfaces.dart';

/// Shared calendar module for booking flows.
///
/// Single interface behind which availability polling, booked-day disabling,
/// month navigation, and polished header/badge live. Used on desktop,
/// tablet, and mobile to guarantee uniform parity (ADR 0004).
class IneaCalendar extends ConsumerStatefulWidget {
  static const Color plum = Color(0xFF6A4053);
  static const Color mutedPlum = Color(0xFF99868C);
  static const Color availableGreen = Color(0xFF6F927A);
  static const Color bookedAmber = Color(0xFFC28A52);

  final DateTime? selectedDate;
  final ValueChanged<DateTime> onDateSelected;

  const IneaCalendar({
    super.key,
    required this.selectedDate,
    required this.onDateSelected,
  });

  @override
  ConsumerState<IneaCalendar> createState() => _IneaCalendarState();
}

class _IneaCalendarState extends ConsumerState<IneaCalendar> {
  static final DateTime firstCalendarDay = DateTime.utc(2020, 1, 1);
  static final DateTime lastCalendarDay = DateTime.utc(2035, 12, 31);

  late DateTime _focusedDay;

  DateTime _clampDay(DateTime day) {
    if (day.isBefore(firstCalendarDay)) return firstCalendarDay;
    if (day.isAfter(lastCalendarDay)) return lastCalendarDay;
    return day;
  }

  @override
  void initState() {
    super.initState();
    _focusedDay = _clampDay(widget.selectedDate ?? DateTime.now());
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref
          .read(availabilityProvider.notifier)
          .setMonth(_focusedDay.month, _focusedDay.year);
    });
  }

  @override
  void didUpdateWidget(covariant IneaCalendar oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.selectedDate != null &&
        widget.selectedDate != oldWidget.selectedDate) {
      _focusedDay = _clampDay(widget.selectedDate!);
      WidgetsBinding.instance.addPostFrameCallback((_) {
        ref
            .read(availabilityProvider.notifier)
            .setMonth(_focusedDay.month, _focusedDay.year);
      });
    }
  }

  String _formatFullDate(DateTime date) {
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
    return '${months[date.month - 1]} ${date.day}, ${date.year}';
  }

  Set<DateTime> _bookedDaysFor(DateTime focusedMonth) {
    final availability = ref.read(availabilityProvider).value;
    if (availability == null) return const {};
    final booked = <DateTime>{};
    for (final entry in availability.data) {
      final date = entry.date;
      if (date != null &&
          (entry.status ?? '').toLowerCase() == 'booked' &&
          date.month == focusedMonth.month &&
          date.year == focusedMonth.year) {
        booked.add(DateTime(date.year, date.month, date.day));
      }
    }
    return booked;
  }

  @override
  Widget build(BuildContext context) {
    // P7: chrome resolves through the shared helper; brand accents
    // (selected day, semantic dots) stay fixed in both modes.
    final surface = CardSurfaces.cardBg(context);
    final surfaceBorder = CardSurfaces.cardBorder(context);
    final titleColor = CardSurfaces.title(context);
    final bodyColor = CardSurfaces.body(context);
    final chipColor = CardSurfaces.chipBg(context);
    final availabilityAsync = ref.watch(availabilityProvider);
    final bookedDays = availabilityAsync.value != null
        ? _bookedDaysFor(_focusedDay)
        : const <DateTime>{};
    final isLoading = availabilityAsync.isLoading;

    return Container(
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
                  Icons.calendar_month_rounded,
                  color: titleColor,
                  size: 20,
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  'Select Date',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                    color: titleColor,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
          const SizedBox(height: 6),
          Wrap(
            spacing: 12,
            runSpacing: 4,
            children: [
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    width: 7,
                    height: 7,
                    decoration: const BoxDecoration(
                      color: IneaCalendar.availableGreen,
                      shape: BoxShape.circle,
                    ),
                  ),
                  const SizedBox(width: 4),
                  Text(
                    'Available',
                    style: TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.w500,
                      color: titleColor,
                    ),
                  ),
                ],
              ),
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    width: 7,
                    height: 7,
                    decoration: const BoxDecoration(
                      color: IneaCalendar.bookedAmber,
                      shape: BoxShape.circle,
                    ),
                  ),
                  const SizedBox(width: 4),
                  Text(
                    'Booked',
                    style: TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.w500,
                      color: titleColor,
                    ),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 12),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 6),
            decoration: BoxDecoration(
              color: chipColor.withValues(alpha: 0.5),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: surfaceBorder),
            ),
            child: TableCalendar(
              firstDay: firstCalendarDay,
              lastDay: lastCalendarDay,
              focusedDay: _focusedDay,
              currentDay: DateTime.now(),
              headerStyle: HeaderStyle(
                formatButtonVisible: false,
                titleCentered: true,
                leftChevronIcon: Icon(
                  Icons.chevron_left_rounded,
                  color: titleColor,
                  size: 20,
                ),
                rightChevronIcon: Icon(
                  Icons.chevron_right_rounded,
                  color: titleColor,
                  size: 20,
                ),
                titleTextStyle: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w700,
                  color: titleColor,
                ),
                headerPadding: const EdgeInsets.symmetric(vertical: 4),
              ),
              daysOfWeekStyle: DaysOfWeekStyle(
                weekdayStyle: TextStyle(
                  fontSize: 10,
                  fontWeight: FontWeight.w600,
                  color: bodyColor,
                ),
                weekendStyle: TextStyle(
                  fontSize: 10,
                  fontWeight: FontWeight.w600,
                  color: bodyColor,
                ),
              ),
              calendarStyle: CalendarStyle(
                outsideDaysVisible: false,
                cellMargin: const EdgeInsets.all(2),
                defaultTextStyle: TextStyle(
                  color: titleColor,
                  fontSize: 11,
                  fontWeight: FontWeight.w500,
                ),
                weekendTextStyle: TextStyle(
                  color: titleColor,
                  fontSize: 11,
                  fontWeight: FontWeight.w500,
                ),
                todayDecoration: BoxDecoration(
                  color: IneaCalendar.plum.withValues(alpha: 0.12),
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: IneaCalendar.plum.withValues(alpha: 0.4),
                  ),
                ),
                todayTextStyle: TextStyle(
                  color: titleColor,
                  fontSize: 11,
                  fontWeight: FontWeight.w700,
                ),
                selectedDecoration: const BoxDecoration(
                  color: IneaCalendar.plum,
                  shape: BoxShape.circle,
                ),
                selectedTextStyle: const TextStyle(
                  color: Colors.white,
                  fontSize: 11,
                  fontWeight: FontWeight.w700,
                ),
              ),
                            selectedDayPredicate: (day) {
                if (widget.selectedDate == null) return false;
                return isSameDay(widget.selectedDate, day);
              },
              calendarBuilders: CalendarBuilders(
                disabledBuilder: (context, day, focusedDay) {
                  final now = DateTime.now();
                  final today = DateTime(now.year, now.month, now.day);
                  final cellDay = DateTime(day.year, day.month, day.day);
                  final isPast = cellDay.isBefore(today);
                  final isFull = bookedDays.contains(cellDay);
                  
                  return Center(
                    child: FittedBox(
                      fit: BoxFit.scaleDown,
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          '${day.day}',
                          style: TextStyle(
                            color: titleColor.withValues(alpha: 0.3),
                            fontSize: 11,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        if (isFull && !isPast)
                          Text(
                            'Full',
                            style: TextStyle(
                              color: titleColor.withValues(alpha: 0.4),
                              fontSize: 8,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
              enabledDayPredicate: (day) {
                final now = DateTime.now();
                final today = DateTime(now.year, now.month, now.day);
                final cellDay = DateTime(day.year, day.month, day.day);
                if (cellDay.isBefore(today)) return false;
                return !bookedDays.contains(cellDay);
              },
              onDaySelected: (selectedDay, focusedDay) {
                setState(() {
                  _focusedDay = focusedDay;
                });
                widget.onDateSelected(selectedDay);
              },
              onPageChanged: (focusedDay) {
                setState(() {
                  _focusedDay = focusedDay;
                });
                ref
                    .read(availabilityProvider.notifier)
                    .setMonth(focusedDay.month, focusedDay.year);
              },
            ),
          ),
          if (isLoading) ...[
            const SizedBox(height: 8),
            const Align(
              alignment: Alignment.center,
              child: SizedBox(
                width: 16,
                height: 16,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  color: IneaCalendar.plum,
                ),
              ),
            ),
          ],

        ],
      ),
    );
  }
}
