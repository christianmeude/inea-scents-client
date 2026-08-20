// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'get_api_wishlist_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_GetApiWishlistResponse _$GetApiWishlistResponseFromJson(
  Map<String, dynamic> json,
) => _GetApiWishlistResponse(
  data: (json['data'] as List<dynamic>?)
      ?.map((e) => Package.fromJson(e as Map<String, dynamic>))
      .toList(),
);

Map<String, dynamic> _$GetApiWishlistResponseToJson(
  _GetApiWishlistResponse instance,
) => <String, dynamic>{'data': instance.data};
