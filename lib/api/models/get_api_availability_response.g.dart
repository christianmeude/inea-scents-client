// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'get_api_availability_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_GetApiAvailabilityResponse _$GetApiAvailabilityResponseFromJson(
  Map<String, dynamic> json,
) => _GetApiAvailabilityResponse(
  date: json['date'] == null ? null : DateTime.parse(json['date'] as String),
  status: json['status'] as String?,
);

Map<String, dynamic> _$GetApiAvailabilityResponseToJson(
  _GetApiAvailabilityResponse instance,
) => <String, dynamic>{
  'date': instance.date?.toIso8601String(),
  'status': instance.status,
};
