// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_import, invalid_annotation_target, unnecessary_import

import 'package:freezed_annotation/freezed_annotation.dart';

part 'get_api_ping_response.freezed.dart';
part 'get_api_ping_response.g.dart';

@Freezed()
abstract class GetApiPingResponse with _$GetApiPingResponse {
  const factory GetApiPingResponse({
    String? message,
  }) = _GetApiPingResponse;
  
  factory GetApiPingResponse.fromJson(Map<String, Object?> json) => _$GetApiPingResponseFromJson(json);
}
