// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'booking.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$BookingImpl _$$BookingImplFromJson(Map<String, dynamic> json) =>
    _$BookingImpl(
      id: (json['id'] as num).toInt(),
      booking_reference: json['booking_reference'] as String,
      user_id: (json['user_id'] as num).toInt(),
      customer_name: json['customer_name'] as String,
      customer_email: json['customer_email'] as String?,
      customer_phone: json['customer_phone'] as String?,
      pax: (json['pax'] as num?)?.toInt(),
      status: json['status'] as String,
      event_date: json['event_date'] as String,
      event_time: json['event_time'] as String?,
      venue_address: json['venue_address'] as String?,
      payment_method: json['payment_method'] as String,
      package: Package.fromJson(json['package'] as Map<String, dynamic>),
      scents: (json['scents'] as List<dynamic>)
          .map((e) => Scent.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$$BookingImplToJson(_$BookingImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'booking_reference': instance.booking_reference,
      'user_id': instance.user_id,
      'customer_name': instance.customer_name,
      'customer_email': instance.customer_email,
      'customer_phone': instance.customer_phone,
      'pax': instance.pax,
      'status': instance.status,
      'event_date': instance.event_date,
      'event_time': instance.event_time,
      'venue_address': instance.venue_address,
      'payment_method': instance.payment_method,
      'package': instance.package,
      'scents': instance.scents,
    };
