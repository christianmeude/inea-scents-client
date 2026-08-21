// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'post_api_bookings_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_PostApiBookingsResponse _$PostApiBookingsResponseFromJson(
  Map<String, dynamic> json,
) => _PostApiBookingsResponse(
  data: json['data'] == null
      ? null
      : Data2.fromJson(json['data'] as Map<String, dynamic>),
);

Map<String, dynamic> _$PostApiBookingsResponseToJson(
  _PostApiBookingsResponse instance,
) => <String, dynamic>{'data': instance.data};
