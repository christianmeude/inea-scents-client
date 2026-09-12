/// Shared `?date=` deep-link helpers (router + screens).
///
/// Mirrors the `?pax=` honor rule: a carried date applies only when it is a
/// strict `YYYY-MM-DD` calendar date that is not in the past (day precision).
/// Availability itself is enforced where the date originates (the calendar
/// only offers free days) and re-validated server-side at submit; anything
/// else falls back to the flow default.
library;

/// Formats [date] as `YYYY-MM-DD` for `?date=` links.
String formatDateParam(DateTime date) {
  final m = date.month.toString().padLeft(2, '0');
  final d = date.day.toString().padLeft(2, '0');
  return '${date.year}-$m-$d';
}

/// Parses a `?date=` value. Returns null for garbage or past dates.
DateTime? tryParseDateParam(String? value, {DateTime? now}) {
  if (value == null || value.isEmpty) return null;
  final match = RegExp(r'^(\d{4})-(\d{2})-(\d{2})$').firstMatch(value);
  if (match == null) return null;
  final parsed = DateTime.tryParse(value);
  if (parsed == null) return null;
  final today = now ?? DateTime.now();
  final todayDay = DateTime(today.year, today.month, today.day);
  final parsedDay = DateTime(parsed.year, parsed.month, parsed.day);
  // Reject overflow artifacts (e.g. month 13 normalized by DateTime).
  if (formatDateParam(parsedDay) != value) return null;
  if (parsedDay.isBefore(todayDay)) return null;
  return parsedDay;
}
