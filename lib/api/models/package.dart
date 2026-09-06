// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_import, invalid_annotation_target, unnecessary_import

import 'package:freezed_annotation/freezed_annotation.dart';

import 'scent.dart';

part 'package.freezed.dart';
part 'package.g.dart';

/// Tolerant list parsers: a single corrupt element (null, "", wrong type)
/// must never kill the whole packages list. Drop invalid entries, coerce
/// numeric strings ("12" -> 12), never throw.
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

/// Package model
@Freezed()
abstract class Package with _$Package {
  const factory Package({
    @JsonKey(fromJson: parseIntTolerant) int? id,
    String? name,
    String? description,
    @JsonKey(fromJson: parseStringList) List<String>? inclusions,
    @JsonKey(name: 'pax_options', fromJson: parseIntList)
    List<int>? paxOptions,
    @JsonKey(fromJson: parseStringList) List<String>? freebies,
    @JsonKey(fromJson: parseDoubleTolerant) double? price,
    @JsonKey(fromJson: parseDoubleTolerant) double? rating,
    @JsonKey(name: 'reviews_count', fromJson: parseIntTolerant)
    int? reviewsCount,
    @JsonKey(fromJson: parseStringList) List<String>? images,
    @JsonKey(name: 'gallery_images', fromJson: parseStringList)
    List<String>? galleryImages,
    @JsonKey(fromJson: parseScentList) List<Scent>? scents,
    @JsonKey(name: 'created_at') DateTime? createdAt,
    @JsonKey(name: 'updated_at') DateTime? updatedAt,
  }) = _Package;

  factory Package.fromJson(Map<String, Object?> json) =>
      _$PackageFromJson(json);
}
