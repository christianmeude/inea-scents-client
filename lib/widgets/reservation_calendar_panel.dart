import 'package:flutter/material.dart';
import 'inea_calendar.dart';

/// Backward-compatible alias — delegates to shared [IneaCalendar].
/// Keeps existing tests and desktop/tablet layouts working.
// C6: Reservation* class name kept per ADR 0008 (zero-ripple rule);
// customer-facing copy uses Booking.
class ReservationCalendarPanel extends StatelessWidget {
  static const Color plum = IneaCalendar.plum;
  static const Color mutedPlum = IneaCalendar.mutedPlum;
  static const Color availableGreen = IneaCalendar.availableGreen;
  static const Color bookedAmber = IneaCalendar.bookedAmber;

  final DateTime? selectedDate;
  final ValueChanged<DateTime> onDateSelected;

  const ReservationCalendarPanel({
    super.key,
    required this.selectedDate,
    required this.onDateSelected,
  });

  @override
  Widget build(BuildContext context) {
    return IneaCalendar(
      selectedDate: selectedDate,
      onDateSelected: onDateSelected,
    );
  }
}
