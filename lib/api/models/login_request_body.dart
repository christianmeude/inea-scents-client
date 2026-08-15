// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_import, invalid_annotation_target, unnecessary_import

import 'package:freezed_annotation/freezed_annotation.dart';

part 'login_request_body.freezed.dart';
part 'login_request_body.g.dart';

@Freezed()
class LoginRequestBody with _$LoginRequestBody {
  const factory LoginRequestBody({
    required String email,
    required String password,
  }) = _LoginRequestBody;
  
  factory LoginRequestBody.fromJson(Map<String, Object?> json) => _$LoginRequestBodyFromJson(json);
}
