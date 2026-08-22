// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_import, invalid_annotation_target, unnecessary_import

import 'package:freezed_annotation/freezed_annotation.dart';

part 'get_api_user_response.freezed.dart';
part 'get_api_user_response.g.dart';

@Freezed()
class GetApiUserResponse with _$GetApiUserResponse {
  const factory GetApiUserResponse({
    int? id,
    String? name,
    String? email,
    @JsonKey(name: 'is_admin')
    bool? isAdmin,
  }) = _GetApiUserResponse;
  
  factory GetApiUserResponse.fromJson(Map<String, Object?> json) => _$GetApiUserResponseFromJson(json);
}
