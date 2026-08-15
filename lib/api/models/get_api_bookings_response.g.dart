// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'get_api_bookings_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$GetApiBookingsResponseImpl _$$GetApiBookingsResponseImplFromJson(
  Map<String, dynamic> json,
) => _$GetApiBookingsResponseImpl(
  data: (json['data'] as List<dynamic>?)
      ?.map((e) => Data.fromJson(e as Map<String, dynamic>))
      .toList(),
);

Map<String, dynamic> _$$GetApiBookingsResponseImplToJson(
  _$GetApiBookingsResponseImpl instance,
) => <String, dynamic>{'data': instance.data};
