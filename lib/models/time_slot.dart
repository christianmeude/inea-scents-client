class TimeSlot {
  final String label;
  final String startTime;

  const TimeSlot(this.label, this.startTime);

  /// Legacy fixed labels. The booking flow is freeform now (any clock
  /// time); these remain for display fallback only.
  static const List<TimeSlot> available = [
    TimeSlot('10:00 AM - 1:00 PM', '10:00:00'),
    TimeSlot('2:00 PM - 5:00 PM', '14:00:00'),
    TimeSlot('6:00 PM - 9:00 PM', '18:00:00'),
  ];

  static String? startTimeForLabel(String? label) {
    if (label == null) return null;
    for (final slot in available) {
      if (slot.label == label) return slot.startTime;
    }
    return null;
  }

  /// Normalizes whatever the schedule step stored into a `H:i:s` value
  /// for the API, or null when there is nothing usable. Accepts legacy
  /// labels, `H:i:s`, and `H:i`. Mirrors backend `EventTime::normalize`.
  static String? toEventTime(String? value) {
    if (value == null) return null;
    final trimmed = value.trim();
    if (trimmed.isEmpty) return null;
    final fromLabel = startTimeForLabel(trimmed);
    if (fromLabel != null) return fromLabel;
    if (RegExp(r'^\d{2}:\d{2}:\d{2}$').hasMatch(trimmed)) return trimmed;
    final hm = RegExp(r'^(\d{1,2}):(\d{2})$').firstMatch(trimmed);
    if (hm != null) {
      final h = int.tryParse(hm.group(1)!);
      final m = int.tryParse(hm.group(2)!);
      if (h != null && m != null && h >= 0 && h < 24 && m >= 0 && m < 60) {
        return '${h.toString().padLeft(2, '0')}:${m.toString().padLeft(2, '0')}:00';
      }
    }
    return null;
  }

  /// Human display for a stored value: `14:00:00` -> `2:00 PM`.
  static String display(String? value) {
    final eventTime = toEventTime(value);
    if (eventTime == null) return value ?? '—';
    final parts = eventTime.split(':');
    final h = int.parse(parts[0]);
    final m = parts[1];
    final suffix = h >= 12 ? 'PM' : 'AM';
    final h12 = h % 12 == 0 ? 12 : h % 12;
    return '$h12:$m $suffix';
  }
}
