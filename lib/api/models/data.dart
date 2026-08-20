// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_import, invalid_annotation_target, unnecessary_import

import 'package:freezed_annotation/freezed_annotation.dart';

import 'package.dart';
import 'scent.dart';

part 'data.freezed.dart';
part 'data.g.dart';

@Freezed()
abstract class Data with _$Data {
  const factory Data({
    int? id,
    @JsonKey(name: 'booking_reference')
    String? bookingReference,
    @JsonKey(name: 'user_id')
    int? userId,
    @JsonKey(name: 'customer_name')
    String? customerName,
    String? status,
    @JsonKey(name: 'event_date')
    DateTime? eventDate,
    @JsonKey(name: 'payment_method')
    String? paymentMethod,
    Package? package,
    List<Scent>? scents,
  }) = _Data;
  
  factory Data.fromJson(Map<String, Object?> json) => _$DataFromJson(json);
}
