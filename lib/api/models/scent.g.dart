// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'scent.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$ScentImpl _$$ScentImplFromJson(Map<String, dynamic> json) => _$ScentImpl(
  id: (json['id'] as num?)?.toInt(),
  name: json['name'] as String?,
  description: json['description'] as String?,
  imageUrl: json['image_url'] as String?,
  isAvailable: json['is_available'] as bool?,
  createdAt: json['created_at'] == null
      ? null
      : DateTime.parse(json['created_at'] as String),
  updatedAt: json['updated_at'] == null
      ? null
      : DateTime.parse(json['updated_at'] as String),
);

Map<String, dynamic> _$$ScentImplToJson(_$ScentImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'description': instance.description,
      'image_url': instance.imageUrl,
      'is_available': instance.isAvailable,
      'created_at': instance.createdAt?.toIso8601String(),
      'updated_at': instance.updatedAt?.toIso8601String(),
    };
