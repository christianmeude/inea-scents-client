// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'get_api_packages_package_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_GetApiPackagesPackageResponse _$GetApiPackagesPackageResponseFromJson(
  Map<String, dynamic> json,
) => _GetApiPackagesPackageResponse(
  data: json['data'] == null
      ? null
      : Package.fromJson(json['data'] as Map<String, dynamic>),
);

Map<String, dynamic> _$GetApiPackagesPackageResponseToJson(
  _GetApiPackagesPackageResponse instance,
) => <String, dynamic>{'data': instance.data};
