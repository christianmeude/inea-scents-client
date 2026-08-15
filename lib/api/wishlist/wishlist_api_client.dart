// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_import, invalid_annotation_target, unnecessary_import

import 'package:dio/dio.dart';
import 'package:retrofit/retrofit.dart';

import '../models/api_wishlist_toggle_request_body.dart';
import '../models/get_api_wishlist_response.dart';
import '../models/post_api_wishlist_toggle_response.dart';

part 'wishlist_api_client.g.dart';

@RestApi()
abstract class WishlistApiClient {
  factory WishlistApiClient(Dio dio, {String? baseUrl}) = _WishlistApiClient;

  /// Get user's wishlist
  @GET('/api/wishlist')
  Future<GetApiWishlistResponse> getApiWishlist();

  /// Toggle package in wishlist
  @POST('/api/wishlist/toggle')
  Future<PostApiWishlistToggleResponse> postApiWishlistToggle({
    @Body() required ApiWishlistToggleRequestBody body,
  });
}
