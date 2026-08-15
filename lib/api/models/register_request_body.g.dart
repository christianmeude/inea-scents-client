// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'register_request_body.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$RegisterRequestBodyImpl _$$RegisterRequestBodyImplFromJson(
  Map<String, dynamic> json,
) => _$RegisterRequestBodyImpl(
  name: json['name'] as String,
  email: json['email'] as String,
  password: json['password'] as String,
);

Map<String, dynamic> _$$RegisterRequestBodyImplToJson(
  _$RegisterRequestBodyImpl instance,
) => <String, dynamic>{
  'name': instance.name,
  'email': instance.email,
  'password': instance.password,
};
