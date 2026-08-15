// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'api_bookings_request_body.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

ApiBookingsRequestBody _$ApiBookingsRequestBodyFromJson(
  Map<String, dynamic> json,
) {
  return _ApiBookingsRequestBody.fromJson(json);
}

/// @nodoc
mixin _$ApiBookingsRequestBody {
  @JsonKey(name: 'package_id')
  int get packageId => throw _privateConstructorUsedError;
  @JsonKey(name: 'customer_name')
  String get customerName => throw _privateConstructorUsedError;
  @JsonKey(name: 'event_date')
  DateTime get eventDate => throw _privateConstructorUsedError;
  @JsonKey(name: 'venue_address')
  String get venueAddress => throw _privateConstructorUsedError;
  @JsonKey(name: 'payment_method')
  String get paymentMethod => throw _privateConstructorUsedError;
  @JsonKey(name: 'customer_email')
  String? get customerEmail => throw _privateConstructorUsedError;
  @JsonKey(name: 'customer_phone')
  String? get customerPhone => throw _privateConstructorUsedError;
  int? get pax => throw _privateConstructorUsedError;
  @JsonKey(name: 'event_time')
  String? get eventTime => throw _privateConstructorUsedError;
  @JsonKey(name: 'scent_ids')
  List<int>? get scentIds => throw _privateConstructorUsedError;

  /// Serializes this ApiBookingsRequestBody to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of ApiBookingsRequestBody
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $ApiBookingsRequestBodyCopyWith<ApiBookingsRequestBody> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ApiBookingsRequestBodyCopyWith<$Res> {
  factory $ApiBookingsRequestBodyCopyWith(
    ApiBookingsRequestBody value,
    $Res Function(ApiBookingsRequestBody) then,
  ) = _$ApiBookingsRequestBodyCopyWithImpl<$Res, ApiBookingsRequestBody>;
  @useResult
  $Res call({
    @JsonKey(name: 'package_id') int packageId,
    @JsonKey(name: 'customer_name') String customerName,
    @JsonKey(name: 'event_date') DateTime eventDate,
    @JsonKey(name: 'venue_address') String venueAddress,
    @JsonKey(name: 'payment_method') String paymentMethod,
    @JsonKey(name: 'customer_email') String? customerEmail,
    @JsonKey(name: 'customer_phone') String? customerPhone,
    int? pax,
    @JsonKey(name: 'event_time') String? eventTime,
    @JsonKey(name: 'scent_ids') List<int>? scentIds,
  });
}

/// @nodoc
class _$ApiBookingsRequestBodyCopyWithImpl<
  $Res,
  $Val extends ApiBookingsRequestBody
>
    implements $ApiBookingsRequestBodyCopyWith<$Res> {
  _$ApiBookingsRequestBodyCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of ApiBookingsRequestBody
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? packageId = null,
    Object? customerName = null,
    Object? eventDate = null,
    Object? venueAddress = null,
    Object? paymentMethod = null,
    Object? customerEmail = freezed,
    Object? customerPhone = freezed,
    Object? pax = freezed,
    Object? eventTime = freezed,
    Object? scentIds = freezed,
  }) {
    return _then(
      _value.copyWith(
            packageId: null == packageId
                ? _value.packageId
                : packageId // ignore: cast_nullable_to_non_nullable
                      as int,
            customerName: null == customerName
                ? _value.customerName
                : customerName // ignore: cast_nullable_to_non_nullable
                      as String,
            eventDate: null == eventDate
                ? _value.eventDate
                : eventDate // ignore: cast_nullable_to_non_nullable
                      as DateTime,
            venueAddress: null == venueAddress
                ? _value.venueAddress
                : venueAddress // ignore: cast_nullable_to_non_nullable
                      as String,
            paymentMethod: null == paymentMethod
                ? _value.paymentMethod
                : paymentMethod // ignore: cast_nullable_to_non_nullable
                      as String,
            customerEmail: freezed == customerEmail
                ? _value.customerEmail
                : customerEmail // ignore: cast_nullable_to_non_nullable
                      as String?,
            customerPhone: freezed == customerPhone
                ? _value.customerPhone
                : customerPhone // ignore: cast_nullable_to_non_nullable
                      as String?,
            pax: freezed == pax
                ? _value.pax
                : pax // ignore: cast_nullable_to_non_nullable
                      as int?,
            eventTime: freezed == eventTime
                ? _value.eventTime
                : eventTime // ignore: cast_nullable_to_non_nullable
                      as String?,
            scentIds: freezed == scentIds
                ? _value.scentIds
                : scentIds // ignore: cast_nullable_to_non_nullable
                      as List<int>?,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$ApiBookingsRequestBodyImplCopyWith<$Res>
    implements $ApiBookingsRequestBodyCopyWith<$Res> {
  factory _$$ApiBookingsRequestBodyImplCopyWith(
    _$ApiBookingsRequestBodyImpl value,
    $Res Function(_$ApiBookingsRequestBodyImpl) then,
  ) = __$$ApiBookingsRequestBodyImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    @JsonKey(name: 'package_id') int packageId,
    @JsonKey(name: 'customer_name') String customerName,
    @JsonKey(name: 'event_date') DateTime eventDate,
    @JsonKey(name: 'venue_address') String venueAddress,
    @JsonKey(name: 'payment_method') String paymentMethod,
    @JsonKey(name: 'customer_email') String? customerEmail,
    @JsonKey(name: 'customer_phone') String? customerPhone,
    int? pax,
    @JsonKey(name: 'event_time') String? eventTime,
    @JsonKey(name: 'scent_ids') List<int>? scentIds,
  });
}

/// @nodoc
class __$$ApiBookingsRequestBodyImplCopyWithImpl<$Res>
    extends
        _$ApiBookingsRequestBodyCopyWithImpl<$Res, _$ApiBookingsRequestBodyImpl>
    implements _$$ApiBookingsRequestBodyImplCopyWith<$Res> {
  __$$ApiBookingsRequestBodyImplCopyWithImpl(
    _$ApiBookingsRequestBodyImpl _value,
    $Res Function(_$ApiBookingsRequestBodyImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of ApiBookingsRequestBody
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? packageId = null,
    Object? customerName = null,
    Object? eventDate = null,
    Object? venueAddress = null,
    Object? paymentMethod = null,
    Object? customerEmail = freezed,
    Object? customerPhone = freezed,
    Object? pax = freezed,
    Object? eventTime = freezed,
    Object? scentIds = freezed,
  }) {
    return _then(
      _$ApiBookingsRequestBodyImpl(
        packageId: null == packageId
            ? _value.packageId
            : packageId // ignore: cast_nullable_to_non_nullable
                  as int,
        customerName: null == customerName
            ? _value.customerName
            : customerName // ignore: cast_nullable_to_non_nullable
                  as String,
        eventDate: null == eventDate
            ? _value.eventDate
            : eventDate // ignore: cast_nullable_to_non_nullable
                  as DateTime,
        venueAddress: null == venueAddress
            ? _value.venueAddress
            : venueAddress // ignore: cast_nullable_to_non_nullable
                  as String,
        paymentMethod: null == paymentMethod
            ? _value.paymentMethod
            : paymentMethod // ignore: cast_nullable_to_non_nullable
                  as String,
        customerEmail: freezed == customerEmail
            ? _value.customerEmail
            : customerEmail // ignore: cast_nullable_to_non_nullable
                  as String?,
        customerPhone: freezed == customerPhone
            ? _value.customerPhone
            : customerPhone // ignore: cast_nullable_to_non_nullable
                  as String?,
        pax: freezed == pax
            ? _value.pax
            : pax // ignore: cast_nullable_to_non_nullable
                  as int?,
        eventTime: freezed == eventTime
            ? _value.eventTime
            : eventTime // ignore: cast_nullable_to_non_nullable
                  as String?,
        scentIds: freezed == scentIds
            ? _value._scentIds
            : scentIds // ignore: cast_nullable_to_non_nullable
                  as List<int>?,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$ApiBookingsRequestBodyImpl implements _ApiBookingsRequestBody {
  const _$ApiBookingsRequestBodyImpl({
    @JsonKey(name: 'package_id') required this.packageId,
    @JsonKey(name: 'customer_name') required this.customerName,
    @JsonKey(name: 'event_date') required this.eventDate,
    @JsonKey(name: 'venue_address') required this.venueAddress,
    @JsonKey(name: 'payment_method') required this.paymentMethod,
    @JsonKey(name: 'customer_email') this.customerEmail,
    @JsonKey(name: 'customer_phone') this.customerPhone,
    this.pax,
    @JsonKey(name: 'event_time') this.eventTime,
    @JsonKey(name: 'scent_ids') final List<int>? scentIds,
  }) : _scentIds = scentIds;

  factory _$ApiBookingsRequestBodyImpl.fromJson(Map<String, dynamic> json) =>
      _$$ApiBookingsRequestBodyImplFromJson(json);

  @override
  @JsonKey(name: 'package_id')
  final int packageId;
  @override
  @JsonKey(name: 'customer_name')
  final String customerName;
  @override
  @JsonKey(name: 'event_date')
  final DateTime eventDate;
  @override
  @JsonKey(name: 'venue_address')
  final String venueAddress;
  @override
  @JsonKey(name: 'payment_method')
  final String paymentMethod;
  @override
  @JsonKey(name: 'customer_email')
  final String? customerEmail;
  @override
  @JsonKey(name: 'customer_phone')
  final String? customerPhone;
  @override
  final int? pax;
  @override
  @JsonKey(name: 'event_time')
  final String? eventTime;
  final List<int>? _scentIds;
  @override
  @JsonKey(name: 'scent_ids')
  List<int>? get scentIds {
    final value = _scentIds;
    if (value == null) return null;
    if (_scentIds is EqualUnmodifiableListView) return _scentIds;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(value);
  }

  @override
  String toString() {
    return 'ApiBookingsRequestBody(packageId: $packageId, customerName: $customerName, eventDate: $eventDate, venueAddress: $venueAddress, paymentMethod: $paymentMethod, customerEmail: $customerEmail, customerPhone: $customerPhone, pax: $pax, eventTime: $eventTime, scentIds: $scentIds)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ApiBookingsRequestBodyImpl &&
            (identical(other.packageId, packageId) ||
                other.packageId == packageId) &&
            (identical(other.customerName, customerName) ||
                other.customerName == customerName) &&
            (identical(other.eventDate, eventDate) ||
                other.eventDate == eventDate) &&
            (identical(other.venueAddress, venueAddress) ||
                other.venueAddress == venueAddress) &&
            (identical(other.paymentMethod, paymentMethod) ||
                other.paymentMethod == paymentMethod) &&
            (identical(other.customerEmail, customerEmail) ||
                other.customerEmail == customerEmail) &&
            (identical(other.customerPhone, customerPhone) ||
                other.customerPhone == customerPhone) &&
            (identical(other.pax, pax) || other.pax == pax) &&
            (identical(other.eventTime, eventTime) ||
                other.eventTime == eventTime) &&
            const DeepCollectionEquality().equals(other._scentIds, _scentIds));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    packageId,
    customerName,
    eventDate,
    venueAddress,
    paymentMethod,
    customerEmail,
    customerPhone,
    pax,
    eventTime,
    const DeepCollectionEquality().hash(_scentIds),
  );

  /// Create a copy of ApiBookingsRequestBody
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$ApiBookingsRequestBodyImplCopyWith<_$ApiBookingsRequestBodyImpl>
  get copyWith =>
      __$$ApiBookingsRequestBodyImplCopyWithImpl<_$ApiBookingsRequestBodyImpl>(
        this,
        _$identity,
      );

  @override
  Map<String, dynamic> toJson() {
    return _$$ApiBookingsRequestBodyImplToJson(this);
  }
}

abstract class _ApiBookingsRequestBody implements ApiBookingsRequestBody {
  const factory _ApiBookingsRequestBody({
    @JsonKey(name: 'package_id') required final int packageId,
    @JsonKey(name: 'customer_name') required final String customerName,
    @JsonKey(name: 'event_date') required final DateTime eventDate,
    @JsonKey(name: 'venue_address') required final String venueAddress,
    @JsonKey(name: 'payment_method') required final String paymentMethod,
    @JsonKey(name: 'customer_email') final String? customerEmail,
    @JsonKey(name: 'customer_phone') final String? customerPhone,
    final int? pax,
    @JsonKey(name: 'event_time') final String? eventTime,
    @JsonKey(name: 'scent_ids') final List<int>? scentIds,
  }) = _$ApiBookingsRequestBodyImpl;

  factory _ApiBookingsRequestBody.fromJson(Map<String, dynamic> json) =
      _$ApiBookingsRequestBodyImpl.fromJson;

  @override
  @JsonKey(name: 'package_id')
  int get packageId;
  @override
  @JsonKey(name: 'customer_name')
  String get customerName;
  @override
  @JsonKey(name: 'event_date')
  DateTime get eventDate;
  @override
  @JsonKey(name: 'venue_address')
  String get venueAddress;
  @override
  @JsonKey(name: 'payment_method')
  String get paymentMethod;
  @override
  @JsonKey(name: 'customer_email')
  String? get customerEmail;
  @override
  @JsonKey(name: 'customer_phone')
  String? get customerPhone;
  @override
  int? get pax;
  @override
  @JsonKey(name: 'event_time')
  String? get eventTime;
  @override
  @JsonKey(name: 'scent_ids')
  List<int>? get scentIds;

  /// Create a copy of ApiBookingsRequestBody
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$ApiBookingsRequestBodyImplCopyWith<_$ApiBookingsRequestBodyImpl>
  get copyWith => throw _privateConstructorUsedError;
}
