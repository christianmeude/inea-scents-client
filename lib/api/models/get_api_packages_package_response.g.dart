// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'get_api_packages_package_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$GetApiPackagesPackageResponseImpl
_$$GetApiPackagesPackageResponseImplFromJson(Map<String, dynamic> json) =>
    _$GetApiPackagesPackageResponseImpl(
      data: json['data'] == null
          ? null
          : Package.fromJson(json['data'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$$GetApiPackagesPackageResponseImplToJson(
  _$GetApiPackagesPackageResponseImpl instance,
) => <String, dynamic>{'data': instance.data};
