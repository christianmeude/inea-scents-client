// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'package.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_Package _$PackageFromJson(Map<String, dynamic> json) => _Package(
  id: parseIntTolerant(json['id']),
  name: json['name'] as String?,
  description: json['description'] as String?,
  inclusions: parseStringList(json['inclusions']),
  paxOptions: parseIntList(json['pax_options']),
  freebies: parseStringList(json['freebies']),
  price: parseDoubleTolerant(json['price']),
  rating: parseDoubleTolerant(json['rating']),
  reviewsCount: parseIntTolerant(json['reviews_count']),
  images: parseStringList(json['images']),
  galleryImages: parseStringList(json['gallery_images']),
  scents: parseScentList(json['scents']),
  createdAt: json['created_at'] == null
      ? null
      : DateTime.parse(json['created_at'] as String),
  updatedAt: json['updated_at'] == null
      ? null
      : DateTime.parse(json['updated_at'] as String),
);

Map<String, dynamic> _$PackageToJson(_Package instance) => <String, dynamic>{
  'id': instance.id,
  'name': instance.name,
  'description': instance.description,
  'inclusions': instance.inclusions,
  'pax_options': instance.paxOptions,
  'freebies': instance.freebies,
  'price': instance.price,
  'rating': instance.rating,
  'reviews_count': instance.reviewsCount,
  'images': instance.images,
  'gallery_images': instance.galleryImages,
  'scents': instance.scents,
  'created_at': instance.createdAt?.toIso8601String(),
  'updated_at': instance.updatedAt?.toIso8601String(),
};
