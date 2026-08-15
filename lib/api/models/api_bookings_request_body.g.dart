// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'api_bookings_request_body.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$ApiBookingsRequestBodyImpl _$$ApiBookingsRequestBodyImplFromJson(
  Map<String, dynamic> json,
) => _$ApiBookingsRequestBodyImpl(
  packageId: (json['package_id'] as num).toInt(),
  customerName: json['customer_name'] as String,
  eventDate: DateTime.parse(json['event_date'] as String),
  venueAddress: json['venue_address'] as String,
  paymentMethod: json['payment_method'] as String,
  customerEmail: json['customer_email'] as String?,
  customerPhone: json['customer_phone'] as String?,
  pax: (json['pax'] as num?)?.toInt(),
  eventTime: json['event_time'] as String?,
  scentIds: (json['scent_ids'] as List<dynamic>?)
      ?.map((e) => (e as num).toInt())
      .toList(),
);

Map<String, dynamic> _$$ApiBookingsRequestBodyImplToJson(
  _$ApiBookingsRequestBodyImpl instance,
) => <String, dynamic>{
  'package_id': instance.packageId,
  'customer_name': instance.customerName,
  'event_date': instance.eventDate.toIso8601String(),
  'venue_address': instance.venueAddress,
  'payment_method': instance.paymentMethod,
  'customer_email': instance.customerEmail,
  'customer_phone': instance.customerPhone,
  'pax': instance.pax,
  'event_time': instance.eventTime,
  'scent_ids': instance.scentIds,
};
