import 'package:freezed_annotation/freezed_annotation.dart';

part 'scent.freezed.dart';
part 'scent.g.dart';

@freezed
class Scent with _$Scent {
  const factory Scent({
    required int id,
    required String name,
    required String description,
    required String image_url,
    required bool is_available,
    required String created_at,
    required String updated_at,
  }) = _Scent;

  factory Scent.fromJson(Map<String, dynamic> json) => _$ScentFromJson(json);
}
