import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:table_calendar/table_calendar.dart';

import '../providers/index.dart';
import '../config/theme.dart';
import 'card_surfaces.dart';

/// Shared calendar module for booking flows.
///
/// Single interface behind which availability polling, booked-day disabling,
/// month navigation, and polished header/badge live. Used on desktop,
/// tablet, and mobile to guarantee uniform parity (ADR 0004).
class IneaCalendar extends ConsumerStatefulWidget {
  // C31: single-sourced via AppTheme (never per-screen hex).
  static const Color plum = AppTheme.primaryButtonBackground;
  static const Color mutedPlum = Color(0xFF99868C);
  static const Color availableGreen = Color(0xFF6F927A);
  static const Color bookedAmber = Color(0xFFC28A52);

  final DateTime? selectedDate;
  final ValueChanged<DateTime> onDateSelected;

  /// Day-only dates the grid may select. When non-null, only these days
  /// (and never past days) are enabled. When null, all future non-booked
  /// days are enabled (booking-flow behavior).
  final Set<DateTime>? enabledDays;

  /// When false, renders the month grid only — no "Select Date" header
  /// and no selection caption (the host screen owns that chrome). C28.
  final bool showChrome;

  /// Fired after month paging (selection is preserved). C28.
  final ValueChanged<DateTime>? onPageChanged;

  const IneaCalendar({
    super.key,
    required this.selectedDate,
    required this.onDateSelected,
    this.enabledDays,
    this.showChrome = true,
    this.onPageChanged,
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
    // C28: date-first entry opens on the earliest selectable day's month
    // so the grid and the allowlist agree on first paint.
    DateTime initial = widget.selectedDate ?? DateTime.now();
    final allow = widget.enabledDays;
    if (widget.selectedDate == null && allow != null && allow.isNotEmpty) {
      final now = DateTime.now();
      final today = DateTime(now.year, now.month, now.day);
      final upcoming = allow
          .map((d) => DateTime(d.year, d.month, d.day))
          .where((d) => !d.isBefore(today))
          .toList()
        ..sort();
      if (upcoming.isNotEmpty) initial = upcoming.first;
    }
    _focusedDay = _clampDay(initial);
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

  /// Selected-state caption: `Saturday, September 26` (grill critique #8 —
  /// say what the selection means instead of relying on the legend alone).
  String _formatWeekdayDate(DateTime date) {
    const weekdays = [
      'Monday',
      'Tuesday',
      'Wednesday',
      'Thursday',
      'Friday',
      'Saturday',
      'Sunday',
    ];
    return '${weekdays[date.weekday - 1]}, ${_formatFullDate(date)}';
  }

  DateTime _dayOnly(DateTime date) =>
      DateTime(date.year, date.month, date.day);

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
    final surfaceBorder = CardSurfaces.cardBorder(context);
    final titleColor = CardSurfaces.title(context);
    final bodyColor = CardSurfaces.body(context);
    final chipColor = CardSurfaces.chipBg(context);
    final availabilityAsync = ref.watch(availabilityProvider);
    final bookedDays = availabilityAsync.value != null
        ? _bookedDaysFor(_focusedDay)
        : const <DateTime>{};
    final isLoading = availabilityAsync.isLoading;
    // C28: allowlist normalized to day-only for cheap contains checks.
    final allowDays = widget.enabledDays == null
        ? null
        : {for (final d in widget.enabledDays!) _dayOnly(d)};

    bool isEnabled(DateTime day) {
      final now = DateTime.now();
      final today = DateTime(now.year, now.month, now.day);
      final cellDay = _dayOnly(day);
      if (cellDay.isBefore(today)) return false;
      if (allowDays != null) return allowDays.contains(cellDay);
      return !bookedDays.contains(cellDay);
    }

    final dayText = TextStyle(
      color: titleColor,
      fontSize: 11,
      // C54: available days stand out via contrast — opaque title, bolder
      // weight against the muted unavailable treatment below.
      fontWeight: FontWeight.w600,
    );

    final grid = Container(
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
        // C28: row height keeps every day-cell tap target ≥44px.
        rowHeight: 52,
        daysOfWeekHeight: 22,
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
            // C31: plum/cream token both modes.
            color: AppTheme.primaryButtonBackground,
            shape: BoxShape.circle,
          ),
          selectedTextStyle: const TextStyle(
            color: AppTheme.onPrimaryButton,
            fontSize: 11,
            fontWeight: FontWeight.w700,
          ),
        ),
        selectedDayPredicate: (day) {
          if (widget.selectedDate == null) return false;
          return isSameDay(widget.selectedDate, day);
        },
        calendarBuilders: CalendarBuilders(
          // C28: default cells keep a 44px-min height tap target.
          defaultBuilder: (context, day, focusedDay) {
            return Center(
              child: ConstrainedBox(
                constraints: const BoxConstraints(minHeight: 44),
                child: Center(child: Text('${day.day}', style: dayText)),
              ),
            );
          },
          // C28: today ring is a fixed 44px target.
          todayBuilder: (context, day, focusedDay) {
            return Center(
              child: Container(
                width: 44,
                height: 44,
                decoration: BoxDecoration(
                  color: IneaCalendar.plum.withValues(alpha: 0.12),
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: IneaCalendar.plum.withValues(alpha: 0.4),
                  ),
                ),
                alignment: Alignment.center,
                child: Text(
                  '${day.day}',
                  style: dayText.copyWith(fontWeight: FontWeight.w700),
                ),
              ),
            );
          },
          // C28: selection indicator is a fixed 44px target.
          selectedBuilder: (context, day, focusedDay) {
            return Center(
              child: Container(
                key: const Key('inea_selected_day'),
                width: 44,
                height: 44,
                decoration: const BoxDecoration(
                  color: IneaCalendar.plum,
                  shape: BoxShape.circle,
                ),
                alignment: Alignment.center,
                child: Text(
                  '${day.day}',
                  style: const TextStyle(
                    // C31: cream label on the plum token.
                    color: AppTheme.onPrimaryButton,
                    fontSize: 11,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            );
          },
          disabledBuilder: (context, day, focusedDay) {
            // C54: unavailable days are muted without strikethrough —
            // translucent body color, light weight, bare day number.
            // Disabled via enabledDayPredicate, so never tappable.
            return Center(
              child: ConstrainedBox(
                constraints: const BoxConstraints(minHeight: 44),
                child: Center(
                  child: Text(
                    '${day.day}',
                    style: TextStyle(
                      color: bodyColor.withValues(alpha: 0.5),
                      fontSize: 11,
                      fontWeight: FontWeight.w400,
                      decoration: TextDecoration.none,
                    ),
                  ),
                ),
              ),
            );
          },
        ),
        enabledDayPredicate: isEnabled,
        onDaySelected: (selectedDay, focusedDay) {
          setState(() {
            _focusedDay = focusedDay;
          });
          widget.onDateSelected(selectedDay);
        },
        // C28: paging keeps the selection; only the month refetches.
        onPageChanged: (focusedDay) {
          setState(() {
            _focusedDay = focusedDay;
          });
          ref
              .read(availabilityProvider.notifier)
              .setMonth(focusedDay.month, focusedDay.year);
          widget.onPageChanged?.call(focusedDay);
        },
      ),
    );

    Widget? loadingRow;
    if (isLoading) {
      loadingRow = const Padding(
        padding: EdgeInsets.only(top: 8),
        child: Align(
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
      );
    }

    // C28: bare mode — grid only, host screen owns title + agenda.
    if (!widget.showChrome) {
      return Column(
        mainAxisSize: MainAxisSize.min,
        children: [grid, ?loadingRow],
      );
    }

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
          const SizedBox(height: 12),
          grid,
          ?loadingRow,
          if (widget.selectedDate != null && !isLoading) ...[
            const SizedBox(height: 10),
            Text(
              _formatWeekdayDate(widget.selectedDate!),
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w700,
                color: titleColor,
                height: 1.3,
              ),
              softWrap: true,
            ),
            const SizedBox(height: 2),
            Text(
              'Available for your event',
              style: TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.w500,
                color: bodyColor,
                height: 1.3,
              ),
              softWrap: true,
            ),
          ],
        ],
      ),
    );
  }
}
