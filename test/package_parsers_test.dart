import 'package:flutter_test/flutter_test.dart';
import 'package:inea_scents_client/models/package_parsers.dart';

void main() {
  group('parseStringList converges with backend PackageSanitizer::strings', () {
    final cases = <String, Map<String, Object?>>{
      'null passthrough': {'input': null, 'expected': null},
      'clean passthrough': {
        'input': ['Pool', 'Setup'],
        'expected': ['Pool', 'Setup'],
      },
      'drops null/empty/whitespace, trims': {
        'input': [null, '', '   ', ' Pool ', 'Setup'],
        'expected': ['Pool', 'Setup'],
      },
      'drops non-strings': {
        'input': [12, 4.5, true, 'OK'],
        'expected': ['OK'],
      },
      'non-list': {
        'input': 'nope',
        'expected': <String>[],
      },
    };
    for (final entry in cases.entries) {
      test(entry.key, () {
        expect(parseStringList(entry.value['input']), entry.value['expected']);
      });
    }
  });

  group('parseIntList converges with backend PackageSanitizer::paxOptions', () {
    final cases = <String, Map<String, Object?>>{
      'null passthrough': {'input': null, 'expected': null},
      'clean passthrough': {
        'input': [20, 50],
        'expected': [20, 50],
      },
      'numeric strings coerce': {
        'input': ['12', ' 7 '],
        'expected': [12, 7],
      },
      'whole floats coerce': {
        'input': [12.0, 7.0],
        'expected': [12, 7],
      },
      'fractional floats drop': {
        'input': [12.5],
        'expected': <int>[],
      },
      'zero/negative/invalid drop': {
        'input': [0, -3, 'abc', '', null, '  '],
        'expected': <int>[],
      },
      'mixed row': {
        'input': [null, '20', 30, 40.0, 12.5, 0, 'x'],
        'expected': [20, 30, 40],
      },
      'non-list': {
        'input': 7,
        'expected': <int>[],
      },
    };
    for (final entry in cases.entries) {
      test(entry.key, () {
        expect(parseIntList(entry.value['input']), entry.value['expected']);
      });
    }
  });

  group('scalar tolerant parsers', () {
    test('parseDoubleTolerant coerces num and numeric strings', () {
      expect(parseDoubleTolerant(3500), 3500.0);
      expect(parseDoubleTolerant('3500.5'), 3500.5);
      expect(parseDoubleTolerant(null), isNull);
      expect(parseDoubleTolerant('x'), isNull);
    });

    test('parseIntTolerant coerces num and numeric strings', () {
      expect(parseIntTolerant('12'), 12);
      expect(parseIntTolerant(12), 12);
      expect(parseIntTolerant(null), isNull);
      expect(parseIntTolerant('x'), isNull);
    });
  });

  group('parseScentList skips bad entries', () {
    test('null passthrough, non-list empty, bad rows skipped', () {
      expect(parseScentList(null), isNull);
      expect(parseScentList('x'), isEmpty);
      expect(
        parseScentList([
          {'id': 1, 'name': 'Citrus'},
          'junk',
          {'id': 'bad', 'name': 42},
        ]),
        hasLength(1),
      );
    });
  });
}
