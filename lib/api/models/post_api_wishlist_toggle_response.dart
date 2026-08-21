// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_import, invalid_annotation_target, unnecessary_import

import 'package:freezed_annotation/freezed_annotation.dart';

part 'post_api_wishlist_toggle_response.freezed.dart';
part 'post_api_wishlist_toggle_response.g.dart';

@Freezed()
abstract class PostApiWishlistToggleResponse with _$PostApiWishlistToggleResponse {
  const factory PostApiWishlistToggleResponse({
    bool? attached,
    String? message,
  }) = _PostApiWishlistToggleResponse;
  
  factory PostApiWishlistToggleResponse.fromJson(Map<String, Object?> json) => _$PostApiWishlistToggleResponseFromJson(json);
}
