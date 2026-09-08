// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_import, invalid_annotation_target, unnecessary_import

import 'package:freezed_annotation/freezed_annotation.dart';

import '../../models/package_parsers.dart';
import 'scent.dart';

part 'package.freezed.dart';
part 'package.g.dart';

/// Package model.
/// Tolerant `fromJson` parsers live in hand-owned
/// `lib/models/package_parsers.dart` (see file header).
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
