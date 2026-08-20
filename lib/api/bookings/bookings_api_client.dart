// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_import, invalid_annotation_target, unnecessary_import

import 'package:dio/dio.dart';
import 'package:retrofit/retrofit.dart';

import '../models/api_bookings_request_body.dart';
import '../models/get_api_bookings_response.dart';
import '../models/post_api_bookings_response.dart';

part 'bookings_api_client.g.dart';

@RestApi()
abstract class BookingsApiClient {
  factory BookingsApiClient(Dio dio, {String? baseUrl}) = _BookingsApiClient;

  /// Get user's bookings.
  ///
  /// Returns a list of all bookings for the authenticated user.
  ///
  /// [status] - Filter bookings by status.
  @GET('/api/bookings')
  Future<GetApiBookingsResponse> getApiBookings({
    @Query('status') String? status,
  });

  /// Create a new booking.
  ///
  /// Creates a new booking for the authenticated user.
  @POST('/api/bookings')
  Future<PostApiBookingsResponse> postApiBookings({
    @Body() required ApiBookingsRequestBody body,
  });
}
