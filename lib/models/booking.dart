import 'package:freezed_annotation/freezed_annotation.dart';
import 'package.dart';
import 'scent.dart';

part 'booking.freezed.dart';
part 'booking.g.dart';

@freezed
class Booking with _$Booking {
  const factory Booking({
    required int id,
    required String booking_reference,
    required int user_id,
    required String customer_name,
    required String? customer_email,
    required String? customer_phone,
    required int? pax,
    required String status,
    required String event_date,
    required String? event_time,
    required String? venue_address,
    required String payment_method,
    required Package package,
    required List<Scent> scents,
  }) = _Booking;

  factory Booking.fromJson(Map<String, dynamic> json) =>
      _$BookingFromJson(json);
}
