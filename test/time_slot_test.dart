import 'package:flutter_test/flutter_test.dart';
import 'package:inea_scents_client/models/time_slot.dart';

void main() {
  group('TimeSlot', () {
    test('startTimeForLabel returns HH:mm:ss for valid labels', () {
      expect(TimeSlot.startTimeForLabel('10:00 AM - 1:00 PM'), '10:00:00');
      expect(TimeSlot.startTimeForLabel('2:00 PM - 5:00 PM'), '14:00:00');
      expect(TimeSlot.startTimeForLabel('6:00 PM - 9:00 PM'), '18:00:00');
    });

    test('startTimeForLabel returns null for unknown label', () {
      expect(TimeSlot.startTimeForLabel('Invalid Slot'), isNull);
      expect(TimeSlot.startTimeForLabel(null), isNull);
    });

    test('available slots has exactly 3 entries', () {
      expect(TimeSlot.available.length, 3);
    });

    test('all startTime values are in HH:mm:ss format', () {
      final regex = RegExp(r'^\d{2}:\d{2}:\d{2}$');
      for (final slot in TimeSlot.available) {
        expect(
          regex.hasMatch(slot.startTime),
          isTrue,
          reason: '${slot.label} startTime ${slot.startTime} is not HH:mm:ss',
        );
      }
    });
  });
}
