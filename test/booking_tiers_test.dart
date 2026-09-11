import 'package:flutter_test/flutter_test.dart';
import 'package:inea_scents_client/api/models/package.dart';
import 'package:inea_scents_client/models/package_tiers.dart';
import 'package:inea_scents_client/models/package_parsers.dart';
import 'package:inea_scents_client/models/time_slot.dart';

Package _tieredPackage() => Package(
      id: 1,
      name: 'Essential 10ml Perfume Bar',
      price: 4499,
      paxOptions: const [50, 70, 100, 150],
      paxPrices: const {50: 4499.0, 70: 6399.0, 100: 8799.0, 150: 13119.0},
    );

void main() {
  group('TimeSlot.toEventTime', () {
    test('converts legacy labels', () {
      expect(TimeSlot.toEventTime('2:00 PM - 5:00 PM'), '14:00:00');
      expect(TimeSlot.toEventTime('10:00 AM - 1:00 PM'), '10:00:00');
    });

    test('passes through H:i:s and pads H:i', () {
      expect(TimeSlot.toEventTime('14:00:00'), '14:00:00');
      expect(TimeSlot.toEventTime('9:05'), '09:05:00');
    });

    test('returns null for blank or garbage', () {
      expect(TimeSlot.toEventTime(null), isNull);
      expect(TimeSlot.toEventTime(''), isNull);
      expect(TimeSlot.toEventTime('sometime-ish'), isNull);
      expect(TimeSlot.toEventTime('25:00'), isNull);
    });
  });

  group('TimeSlot.display', () {
    test('formats 24h times for humans', () {
      expect(TimeSlot.display('14:00:00'), '2:00 PM');
      expect(TimeSlot.display('10:00:00'), '10:00 AM');
      expect(TimeSlot.display('2:00 PM - 5:00 PM'), '2:00 PM');
    });
  });

  group('PackageTiers', () {
    test('tiers sorts by pax with titles and labels', () {
      final tiers = _tieredPackage().tiers;
      expect(tiers.map((t) => t.pax).toList(), [50, 70, 100, 150]);
      expect(tiers.first.title, '50 Guests');
      expect(tiers.first.priceLabel, '₱4499');
    });

    test('priceForPax follows the tier map with scalar fallback', () {
      final pkg = _tieredPackage();
      expect(pkg.priceForPax(70), 6399.0);
      expect(pkg.priceForPax(51), 4499.0);
      expect(
        const Package(id: 2, price: 100).priceForPax(2),
        100.0,
      );
      expect(const Package(id: 3).priceForPax(null), 4500.0);
    });

    test('startsAtLabel uses the cheapest tier', () {
      expect(_tieredPackage().startsAtLabel, 'Starts at ₱4499');
    });
  });

  group('parsePaxPrices', () {
    test('coerces string keys and prices, drops junk', () {
      expect(
        parsePaxPrices({'50': 4499, '70': '6399.5', 'x': 1, '-5': 10}),
        {50: 4499.0, 70: 6399.5},
      );
      expect(parsePaxPrices(null), isNull);
      expect(parsePaxPrices('nope'), <int, double>{});
    });
  });
}
