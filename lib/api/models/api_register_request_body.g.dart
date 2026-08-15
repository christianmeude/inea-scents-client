// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'api_register_request_body.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$ApiRegisterRequestBodyImpl _$$ApiRegisterRequestBodyImplFromJson(
  Map<String, dynamic> json,
) => _$ApiRegisterRequestBodyImpl(
  name: json['name'] as String,
  email: json['email'] as String,
  password: json['password'] as String,
);

Map<String, dynamic> _$$ApiRegisterRequestBodyImplToJson(
  _$ApiRegisterRequestBodyImpl instance,
) => <String, dynamic>{
  'name': instance.name,
  'email': instance.email,
  'password': instance.password,
};
