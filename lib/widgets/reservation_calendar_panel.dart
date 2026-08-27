import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';

/// Interactive Calendar Column / Panel for INEA Scents reservation flow.
class ReservationCalendarPanel extends StatefulWidget {
  static const Color plum = Color(0xFF6A4053);
  static const Color mutedPlum = Color(0xFF99868C);
  static const Color availableGreen = Color(0xFF6F927A);
  static const Color bookedAmber = Color(0xFFC28A52);

  final DateTime? selectedDate;
  final ValueChanged<DateTime> onDateSelected;

  const ReservationCalendarPanel({
    super.key,
    required this.selectedDate,
    required this.onDateSelected,
  });

  @override
  State<ReservationCalendarPanel> createState() => _ReservationCalendarPanelState();
}

class _ReservationCalendarPanelState extends State<ReservationCalendarPanel> {
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
  }

  @override
  void didUpdateWidget(covariant ReservationCalendarPanel oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.selectedDate != null && widget.selectedDate != oldWidget.selectedDate) {
      _focusedDay = _clampDay(widget.selectedDate!);
    }
  }

  String _formatFullDate(DateTime date) {
    const months = [
      'January', 'February', 'March', 'April', 'May', 'June',
      'July', 'August', 'September', 'October', 'November', 'December'
    ];
    return '${months[date.month - 1]} ${date.day}, ${date.year}';
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: const Color(0x4D99868C), width: 1.0),
        boxShadow: [
          BoxShadow(
            color: ReservationCalendarPanel.plum.withValues(alpha: 0.06),
            blurRadius: 18,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ========================================================
          // HEADER & LEGEND
          // ========================================================
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: const Color(0xFFFDF4F5),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const Icon(
                  Icons.calendar_month_rounded,
                  color: ReservationCalendarPanel.plum,
                  size: 20,
                ),
              ),
              const SizedBox(width: 8),
              const Expanded(
                child: Text(
                  '1. Select Date',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                    color: ReservationCalendarPanel.plum,
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
                      color: ReservationCalendarPanel.availableGreen,
                      shape: BoxShape.circle,
                    ),
                  ),
                  const SizedBox(width: 4),
                  const Text(
                    'Available',
                    style: TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.w500,
                      color: ReservationCalendarPanel.plum,
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
                      color: ReservationCalendarPanel.bookedAmber,
                      shape: BoxShape.circle,
                    ),
                  ),
                  const SizedBox(width: 4),
                  const Text(
                    'Booked',
                    style: TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.w500,
                      color: ReservationCalendarPanel.plum,
                    ),
                  ),
                ],
              ),
            ],
          ),

          const SizedBox(height: 12),

          // ========================================================
          // CALENDAR WIDGET
          // ========================================================
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 6),
            decoration: BoxDecoration(
              color: const Color(0xFFFDF4F5).withValues(alpha: 0.5),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: const Color(0x2699868C)),
            ),
            child: TableCalendar(
              firstDay: firstCalendarDay,
              lastDay: lastCalendarDay,
              focusedDay: _focusedDay,
              currentDay: DateTime.now(),
              headerStyle: const HeaderStyle(
                formatButtonVisible: false,
                titleCentered: true,
                leftChevronIcon: Icon(
                  Icons.chevron_left_rounded,
                  color: ReservationCalendarPanel.plum,
                  size: 20,
                ),
                rightChevronIcon: Icon(
                  Icons.chevron_right_rounded,
                  color: ReservationCalendarPanel.plum,
                  size: 20,
                ),
                titleTextStyle: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w700,
                  color: ReservationCalendarPanel.plum,
                ),
                headerPadding: EdgeInsets.symmetric(vertical: 4),
              ),
              daysOfWeekStyle: const DaysOfWeekStyle(
                weekdayStyle: TextStyle(
                  fontSize: 10,
                  fontWeight: FontWeight.w600,
                  color: ReservationCalendarPanel.mutedPlum,
                ),
                weekendStyle: TextStyle(
                  fontSize: 10,
                  fontWeight: FontWeight.w600,
                  color: ReservationCalendarPanel.mutedPlum,
                ),
              ),
              calendarStyle: CalendarStyle(
                outsideDaysVisible: false,
                cellMargin: const EdgeInsets.all(2),
                defaultTextStyle: const TextStyle(
                  color: ReservationCalendarPanel.plum,
                  fontSize: 11,
                  fontWeight: FontWeight.w500,
                ),
                weekendTextStyle: const TextStyle(
                  color: ReservationCalendarPanel.plum,
                  fontSize: 11,
                  fontWeight: FontWeight.w500,
                ),
                todayDecoration: BoxDecoration(
                  color: ReservationCalendarPanel.plum.withValues(alpha: 0.12),
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: ReservationCalendarPanel.plum.withValues(alpha: 0.4),
                  ),
                ),
                todayTextStyle: const TextStyle(
                  color: ReservationCalendarPanel.plum,
                  fontSize: 11,
                  fontWeight: FontWeight.w700,
                ),
                selectedDecoration: const BoxDecoration(
                  color: ReservationCalendarPanel.plum,
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
              },
            ),
          ),

          const SizedBox(height: 12),

          // ========================================================
          // SELECTED DATE BADGE
          // ========================================================
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: widget.selectedDate != null
                  ? const Color(0xFF22C55E).withValues(alpha: 0.08)
                  : const Color(0xFFFDF4F5),
              borderRadius: BorderRadius.circular(14),
              border: Border.all(
                color: widget.selectedDate != null
                    ? const Color(0xFF22C55E).withValues(alpha: 0.3)
                    : const Color(0x3399868C),
              ),
            ),
            child: Row(
              children: [
                Container(
                  width: 32,
                  height: 32,
                  decoration: BoxDecoration(
                    color: widget.selectedDate != null
                        ? const Color(0xFF22C55E).withValues(alpha: 0.15)
                        : Colors.white,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Icon(
                    widget.selectedDate != null
                        ? Icons.event_available_rounded
                        : Icons.event_note_rounded,
                    color: widget.selectedDate != null
                        ? const Color(0xFF16A34A)
                        : ReservationCalendarPanel.mutedPlum,
                    size: 18,
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        widget.selectedDate != null
                            ? 'SELECTED DATE'
                            : 'NO DATE SELECTED',
                        style: TextStyle(
                          fontSize: 9,
                          fontWeight: FontWeight.w700,
                          letterSpacing: 0.8,
                          color: widget.selectedDate != null
                              ? const Color(0xFF16A34A)
                              : ReservationCalendarPanel.mutedPlum,
                        ),
                      ),
                      const SizedBox(height: 1),
                      Text(
                        widget.selectedDate != null
                            ? _formatFullDate(widget.selectedDate!)
                            : 'Please choose a date from calendar',
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w700,
                          color: widget.selectedDate != null
                              ? ReservationCalendarPanel.plum
                              : ReservationCalendarPanel.mutedPlum,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
