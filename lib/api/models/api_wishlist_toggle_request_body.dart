// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_import, invalid_annotation_target, unnecessary_import

import 'package:freezed_annotation/freezed_annotation.dart';

part 'api_wishlist_toggle_request_body.freezed.dart';
part 'api_wishlist_toggle_request_body.g.dart';

@Freezed()
class ApiWishlistToggleRequestBody with _$ApiWishlistToggleRequestBody {
  const factory ApiWishlistToggleRequestBody({
    @JsonKey(name: 'package_id')
    required int packageId,
  }) = _ApiWishlistToggleRequestBody;
  
  factory ApiWishlistToggleRequestBody.fromJson(Map<String, Object?> json) => _$ApiWishlistToggleRequestBodyFromJson(json);
}
