// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'scent.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$ScentImpl _$$ScentImplFromJson(Map<String, dynamic> json) => _$ScentImpl(
  id: (json['id'] as num).toInt(),
  name: json['name'] as String,
  description: json['description'] as String,
  image_url: json['image_url'] as String,
  is_available: json['is_available'] as bool,
  created_at: json['created_at'] as String,
  updated_at: json['updated_at'] as String,
);

Map<String, dynamic> _$$ScentImplToJson(_$ScentImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'description': instance.description,
      'image_url': instance.image_url,
      'is_available': instance.is_available,
      'created_at': instance.created_at,
      'updated_at': instance.updated_at,
    };
