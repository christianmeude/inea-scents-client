class TimeSlot {
  final String label;
  final String startTime;

  const TimeSlot(this.label, this.startTime);

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
}
