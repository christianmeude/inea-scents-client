// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'get_api_bookings_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_GetApiBookingsResponse _$GetApiBookingsResponseFromJson(
  Map<String, dynamic> json,
) => _GetApiBookingsResponse(
  data: (json['data'] as List<dynamic>?)
      ?.map((e) => Data.fromJson(e as Map<String, dynamic>))
      .toList(),
);

Map<String, dynamic> _$GetApiBookingsResponseToJson(
  _GetApiBookingsResponse instance,
) => <String, dynamic>{'data': instance.data};
