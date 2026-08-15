// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'get_api_wishlist_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$GetApiWishlistResponseImpl _$$GetApiWishlistResponseImplFromJson(
  Map<String, dynamic> json,
) => _$GetApiWishlistResponseImpl(
  data: (json['data'] as List<dynamic>?)
      ?.map((e) => Package.fromJson(e as Map<String, dynamic>))
      .toList(),
);

Map<String, dynamic> _$$GetApiWishlistResponseImplToJson(
  _$GetApiWishlistResponseImpl instance,
) => <String, dynamic>{'data': instance.data};
