// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'get_api_user_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_GetApiUserResponse _$GetApiUserResponseFromJson(Map<String, dynamic> json) =>
    _GetApiUserResponse(
      id: (json['id'] as num?)?.toInt(),
      name: json['name'] as String?,
      email: json['email'] as String?,
      isAdmin: json['is_admin'] as bool?,
    );

Map<String, dynamic> _$GetApiUserResponseToJson(_GetApiUserResponse instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'email': instance.email,
      'is_admin': instance.isAdmin,
    };
