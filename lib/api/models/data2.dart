// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_import, invalid_annotation_target, unnecessary_import

import 'package:freezed_annotation/freezed_annotation.dart';

import 'package.dart';
import 'scent.dart';

part 'data2.freezed.dart';
part 'data2.g.dart';

@Freezed()
class Data2 with _$Data2 {
  const factory Data2({
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
  }) = _Data2;
  
  factory Data2.fromJson(Map<String, Object?> json) => _$Data2FromJson(json);
}
