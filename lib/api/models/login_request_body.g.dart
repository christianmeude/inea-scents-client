// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'login_request_body.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_LoginRequestBody _$LoginRequestBodyFromJson(Map<String, dynamic> json) =>
    _LoginRequestBody(
      email: json['email'] as String,
      password: json['password'] as String,
    );

Map<String, dynamic> _$LoginRequestBodyToJson(_LoginRequestBody instance) =>
    <String, dynamic>{'email': instance.email, 'password': instance.password};
