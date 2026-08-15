// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_import, invalid_annotation_target, unnecessary_import

import 'package:dio/dio.dart';
import 'package:retrofit/retrofit.dart';

import '../models/get_api_packages_package_response.dart';
import '../models/get_api_packages_response.dart';

part 'packages_api_client.g.dart';

@RestApi()
abstract class PackagesApiClient {
  factory PackagesApiClient(Dio dio, {String? baseUrl}) = _PackagesApiClient;

  /// Get list of packages.
  ///
  /// Returns list of available packages.
  @GET('/api/packages')
  Future<GetApiPackagesResponse> getApiPackages();

  /// Get package details.
  ///
  /// Returns full package details for a specific ID.
  ///
  /// [package] - ID of package to return.
  @GET('/api/packages/{package}')
  Future<GetApiPackagesPackageResponse> getApiPackagesPackage({
    @Path('package') required int package,
  });
}
