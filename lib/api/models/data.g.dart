// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'data.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_Data _$DataFromJson(Map<String, dynamic> json) => _Data(
  id: (json['id'] as num?)?.toInt(),
  bookingReference: json['booking_reference'] as String?,
  userId: (json['user_id'] as num?)?.toInt(),
  customerName: json['customer_name'] as String?,
  status: json['status'] as String?,
  eventDate: json['event_date'] == null
      ? null
      : DateTime.parse(json['event_date'] as String),
  paymentMethod: json['payment_method'] as String?,
  package: json['package'] == null
      ? null
      : Package.fromJson(json['package'] as Map<String, dynamic>),
  scents: (json['scents'] as List<dynamic>?)
      ?.map((e) => Scent.fromJson(e as Map<String, dynamic>))
      .toList(),
);

Map<String, dynamic> _$DataToJson(_Data instance) => <String, dynamic>{
  'id': instance.id,
  'booking_reference': instance.bookingReference,
  'user_id': instance.userId,
  'customer_name': instance.customerName,
  'status': instance.status,
  'event_date': instance.eventDate?.toIso8601String(),
  'payment_method': instance.paymentMethod,
  'package': instance.package,
  'scents': instance.scents,
};
