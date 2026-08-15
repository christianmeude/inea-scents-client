// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_import, invalid_annotation_target, unnecessary_import

import 'package:freezed_annotation/freezed_annotation.dart';

import 'scent.dart';

part 'package.freezed.dart';
part 'package.g.dart';

/// Package model
@Freezed()
class Package with _$Package {
  const factory Package({
    int? id,
    String? name,
    String? description,
    List<String>? inclusions,
    @JsonKey(name: 'pax_options')
    List<int>? paxOptions,
    List<String>? freebies,
    double? price,
    double? rating,
    @JsonKey(name: 'reviews_count')
    int? reviewsCount,
    List<String>? images,
    @JsonKey(name: 'gallery_images')
    List<String>? galleryImages,
    List<Scent>? scents,
    @JsonKey(name: 'created_at')
    DateTime? createdAt,
    @JsonKey(name: 'updated_at')
    DateTime? updatedAt,
  }) = _Package;
  
  factory Package.fromJson(Map<String, Object?> json) => _$PackageFromJson(json);
}
