// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'get_api_packages_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$GetApiPackagesResponseImpl _$$GetApiPackagesResponseImplFromJson(
  Map<String, dynamic> json,
) => _$GetApiPackagesResponseImpl(
  data: (json['data'] as List<dynamic>?)
      ?.map((e) => Package.fromJson(e as Map<String, dynamic>))
      .toList(),
);

Map<String, dynamic> _$$GetApiPackagesResponseImplToJson(
  _$GetApiPackagesResponseImpl instance,
) => <String, dynamic>{'data': instance.data};
