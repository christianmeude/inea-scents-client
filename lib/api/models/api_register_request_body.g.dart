// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'api_register_request_body.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_ApiRegisterRequestBody _$ApiRegisterRequestBodyFromJson(
  Map<String, dynamic> json,
) => _ApiRegisterRequestBody(
  name: json['name'] as String,
  email: json['email'] as String,
  password: json['password'] as String,
);

Map<String, dynamic> _$ApiRegisterRequestBodyToJson(
  _ApiRegisterRequestBody instance,
) => <String, dynamic>{
  'name': instance.name,
  'email': instance.email,
  'password': instance.password,
};
