import '../api/models/scent.dart';

/// Hand-owned tolerant Package parsers.
///
/// Lives outside `lib/api/` (which `swagger_parser` regenerates from
/// `api-docs.json`) so a contract regen can never wipe corrupt-payload
/// protection. `lib/api/models/package.dart` references these via
/// `@JsonKey(fromJson:)`; output shapes converge with the backend
/// `PackageSanitizer` rule: null/empty/whitespace elements drop,
/// numeric-string pax coerces, whole floats coerce, fractional/sub-1
/// entries drop, bad scent rows skip. Clean data parses identically.
/// Never throws.
List<String>? parseStringList(Object? json) {
  if (json == null) return null;
  if (json is! List) return <String>[];
  final cleaned = <String>[];
  for (final e in json) {
    if (e is String && e.trim().isNotEmpty) {
      cleaned.add(e.trim());
    }
  }
  return cleaned;
}

List<int>? parseIntList(Object? json) {
  if (json == null) return null;
  if (json is! List) return <int>[];
  final cleaned = <int>[];
  for (final e in json) {
    if (e is int && e >= 1) {
      cleaned.add(e);
    } else if (e is num && e.toInt() == e && e >= 1) {
      cleaned.add(e.toInt());
    } else if (e is String && e.trim().isNotEmpty) {
      final parsed = int.tryParse(e.trim());
      if (parsed != null && parsed >= 1) cleaned.add(parsed);
    }
  }
  return cleaned;
}

double? parseDoubleTolerant(Object? json) {
  if (json == null) return null;
  if (json is num) return json.toDouble();
  if (json is String && json.trim().isNotEmpty) {
    return double.tryParse(json.trim());
  }
  return null;
}

int? parseIntTolerant(Object? json) {
  if (json == null) return null;
  if (json is int) return json;
  if (json is num) return json.toInt();
  if (json is String && json.trim().isNotEmpty) {
    return int.tryParse(json.trim());
  }
  return null;
}

/// Skip-unparseable scents so one bad scent row never kills its package.
List<Scent>? parseScentList(Object? json) {
  if (json == null) return null;
  if (json is! List) return <Scent>[];
  final parsed = <Scent>[];
  for (final e in json) {
    if (e is! Map<String, dynamic>) continue;
    try {
      parsed.add(Scent.fromJson(e));
    } catch (_) {
      continue;
    }
  }
  return parsed;
}
