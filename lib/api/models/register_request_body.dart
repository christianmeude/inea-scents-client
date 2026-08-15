// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_import, invalid_annotation_target, unnecessary_import

import 'package:freezed_annotation/freezed_annotation.dart';

part 'register_request_body.freezed.dart';
part 'register_request_body.g.dart';

@Freezed()
class RegisterRequestBody with _$RegisterRequestBody {
  const factory RegisterRequestBody({
    required String name,
    required String email,
    required String password,
  }) = _RegisterRequestBody;
  
  factory RegisterRequestBody.fromJson(Map<String, Object?> json) => _$RegisterRequestBodyFromJson(json);
}
