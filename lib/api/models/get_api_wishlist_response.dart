// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_import, invalid_annotation_target, unnecessary_import

import 'package:freezed_annotation/freezed_annotation.dart';

import 'package.dart';

part 'get_api_wishlist_response.freezed.dart';
part 'get_api_wishlist_response.g.dart';

@Freezed()
abstract class GetApiWishlistResponse with _$GetApiWishlistResponse {
  const factory GetApiWishlistResponse({List<Package>? data}) =
      _GetApiWishlistResponse;

  factory GetApiWishlistResponse.fromJson(Map<String, Object?> json) =>
      _$GetApiWishlistResponseFromJson(json);
}
