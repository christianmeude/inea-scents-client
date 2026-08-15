// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'get_api_availability_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$GetApiAvailabilityResponseImpl _$$GetApiAvailabilityResponseImplFromJson(
  Map<String, dynamic> json,
) => _$GetApiAvailabilityResponseImpl(
  date: json['date'] == null ? null : DateTime.parse(json['date'] as String),
  status: json['status'] as String?,
);

Map<String, dynamic> _$$GetApiAvailabilityResponseImplToJson(
  _$GetApiAvailabilityResponseImpl instance,
) => <String, dynamic>{
  'date': instance.date?.toIso8601String(),
  'status': instance.status,
};
