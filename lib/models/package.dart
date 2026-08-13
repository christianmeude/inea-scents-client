import 'package:freezed_annotation/freezed_annotation.dart';
import 'scent.dart';

part 'package.freezed.dart';
part 'package.g.dart';

@freezed
class Package with _$Package {
  const factory Package({
    required int id,
    required String name,
    required String description,
    required List<String> inclusions,
    required List<int> pax_options,
    required List<String> freebies,
    required double price,
    required double rating,
    required int reviews_count,
    required List<String> images,
    required List<String> gallery_images,
    required List<Scent> scents,
    required String created_at,
    required String updated_at,
  }) = _Package;

  factory Package.fromJson(Map<String, dynamic> json) =>
      _$PackageFromJson(json);
}
