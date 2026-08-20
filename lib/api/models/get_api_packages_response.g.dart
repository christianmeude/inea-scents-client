// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'get_api_packages_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_GetApiPackagesResponse _$GetApiPackagesResponseFromJson(
  Map<String, dynamic> json,
) => _GetApiPackagesResponse(
  data: (json['data'] as List<dynamic>?)
      ?.map((e) => Package.fromJson(e as Map<String, dynamic>))
      .toList(),
);

Map<String, dynamic> _$GetApiPackagesResponseToJson(
  _GetApiPackagesResponse instance,
) => <String, dynamic>{'data': instance.data};
