// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'package.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$PackageImpl _$$PackageImplFromJson(Map<String, dynamic> json) =>
    _$PackageImpl(
      id: (json['id'] as num).toInt(),
      name: json['name'] as String,
      description: json['description'] as String,
      inclusions: (json['inclusions'] as List<dynamic>)
          .map((e) => e as String)
          .toList(),
      pax_options: (json['pax_options'] as List<dynamic>)
          .map((e) => (e as num).toInt())
          .toList(),
      freebies: (json['freebies'] as List<dynamic>)
          .map((e) => e as String)
          .toList(),
      price: (json['price'] as num).toDouble(),
      rating: (json['rating'] as num).toDouble(),
      reviews_count: (json['reviews_count'] as num).toInt(),
      images: (json['images'] as List<dynamic>)
          .map((e) => e as String)
          .toList(),
      gallery_images: (json['gallery_images'] as List<dynamic>)
          .map((e) => e as String)
          .toList(),
      scents: (json['scents'] as List<dynamic>)
          .map((e) => Scent.fromJson(e as Map<String, dynamic>))
          .toList(),
      created_at: json['created_at'] as String,
      updated_at: json['updated_at'] as String,
    );

Map<String, dynamic> _$$PackageImplToJson(_$PackageImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'description': instance.description,
      'inclusions': instance.inclusions,
      'pax_options': instance.pax_options,
      'freebies': instance.freebies,
      'price': instance.price,
      'rating': instance.rating,
      'reviews_count': instance.reviews_count,
      'images': instance.images,
      'gallery_images': instance.gallery_images,
      'scents': instance.scents,
      'created_at': instance.created_at,
      'updated_at': instance.updated_at,
    };
