// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'api_login_request_body.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_ApiLoginRequestBody _$ApiLoginRequestBodyFromJson(Map<String, dynamic> json) =>
    _ApiLoginRequestBody(
      email: json['email'] as String,
      password: json['password'] as String,
    );

Map<String, dynamic> _$ApiLoginRequestBodyToJson(
  _ApiLoginRequestBody instance,
) => <String, dynamic>{'email': instance.email, 'password': instance.password};
