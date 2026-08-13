// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'booking.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

Booking _$BookingFromJson(Map<String, dynamic> json) {
  return _Booking.fromJson(json);
}

/// @nodoc
mixin _$Booking {
  int get id => throw _privateConstructorUsedError;
  String get booking_reference => throw _privateConstructorUsedError;
  int get user_id => throw _privateConstructorUsedError;
  String get customer_name => throw _privateConstructorUsedError;
  String? get customer_email => throw _privateConstructorUsedError;
  String? get customer_phone => throw _privateConstructorUsedError;
  int? get pax => throw _privateConstructorUsedError;
  String get status => throw _privateConstructorUsedError;
  String get event_date => throw _privateConstructorUsedError;
  String? get event_time => throw _privateConstructorUsedError;
  String? get venue_address => throw _privateConstructorUsedError;
  String get payment_method => throw _privateConstructorUsedError;
  Package get package => throw _privateConstructorUsedError;
  List<Scent> get scents => throw _privateConstructorUsedError;

  /// Serializes this Booking to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of Booking
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $BookingCopyWith<Booking> get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $BookingCopyWith<$Res> {
  factory $BookingCopyWith(Booking value, $Res Function(Booking) then) =
      _$BookingCopyWithImpl<$Res, Booking>;
  @useResult
  $Res call({
    int id,
    String booking_reference,
    int user_id,
    String customer_name,
    String? customer_email,
    String? customer_phone,
    int? pax,
    String status,
    String event_date,
    String? event_time,
    String? venue_address,
    String payment_method,
    Package package,
    List<Scent> scents,
  });

  $PackageCopyWith<$Res> get package;
}

/// @nodoc
class _$BookingCopyWithImpl<$Res, $Val extends Booking>
    implements $BookingCopyWith<$Res> {
  _$BookingCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of Booking
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? booking_reference = null,
    Object? user_id = null,
    Object? customer_name = null,
    Object? customer_email = freezed,
    Object? customer_phone = freezed,
    Object? pax = freezed,
    Object? status = null,
    Object? event_date = null,
    Object? event_time = freezed,
    Object? venue_address = freezed,
    Object? payment_method = null,
    Object? package = null,
    Object? scents = null,
  }) {
    return _then(
      _value.copyWith(
            id: null == id
                ? _value.id
                : id // ignore: cast_nullable_to_non_nullable
                      as int,
            booking_reference: null == booking_reference
                ? _value.booking_reference
                : booking_reference // ignore: cast_nullable_to_non_nullable
                      as String,
            user_id: null == user_id
                ? _value.user_id
                : user_id // ignore: cast_nullable_to_non_nullable
                      as int,
            customer_name: null == customer_name
                ? _value.customer_name
                : customer_name // ignore: cast_nullable_to_non_nullable
                      as String,
            customer_email: freezed == customer_email
                ? _value.customer_email
                : customer_email // ignore: cast_nullable_to_non_nullable
                      as String?,
            customer_phone: freezed == customer_phone
                ? _value.customer_phone
                : customer_phone // ignore: cast_nullable_to_non_nullable
                      as String?,
            pax: freezed == pax
                ? _value.pax
                : pax // ignore: cast_nullable_to_non_nullable
                      as int?,
            status: null == status
                ? _value.status
                : status // ignore: cast_nullable_to_non_nullable
                      as String,
            event_date: null == event_date
                ? _value.event_date
                : event_date // ignore: cast_nullable_to_non_nullable
                      as String,
            event_time: freezed == event_time
                ? _value.event_time
                : event_time // ignore: cast_nullable_to_non_nullable
                      as String?,
            venue_address: freezed == venue_address
                ? _value.venue_address
                : venue_address // ignore: cast_nullable_to_non_nullable
                      as String?,
            payment_method: null == payment_method
                ? _value.payment_method
                : payment_method // ignore: cast_nullable_to_non_nullable
                      as String,
            package: null == package
                ? _value.package
                : package // ignore: cast_nullable_to_non_nullable
                      as Package,
            scents: null == scents
                ? _value.scents
                : scents // ignore: cast_nullable_to_non_nullable
                      as List<Scent>,
          )
          as $Val,
    );
  }

  /// Create a copy of Booking
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $PackageCopyWith<$Res> get package {
    return $PackageCopyWith<$Res>(_value.package, (value) {
      return _then(_value.copyWith(package: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$BookingImplCopyWith<$Res> implements $BookingCopyWith<$Res> {
  factory _$$BookingImplCopyWith(
    _$BookingImpl value,
    $Res Function(_$BookingImpl) then,
  ) = __$$BookingImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    int id,
    String booking_reference,
    int user_id,
    String customer_name,
    String? customer_email,
    String? customer_phone,
    int? pax,
    String status,
    String event_date,
    String? event_time,
    String? venue_address,
    String payment_method,
    Package package,
    List<Scent> scents,
  });

  @override
  $PackageCopyWith<$Res> get package;
}

/// @nodoc
class __$$BookingImplCopyWithImpl<$Res>
    extends _$BookingCopyWithImpl<$Res, _$BookingImpl>
    implements _$$BookingImplCopyWith<$Res> {
  __$$BookingImplCopyWithImpl(
    _$BookingImpl _value,
    $Res Function(_$BookingImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of Booking
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? booking_reference = null,
    Object? user_id = null,
    Object? customer_name = null,
    Object? customer_email = freezed,
    Object? customer_phone = freezed,
    Object? pax = freezed,
    Object? status = null,
    Object? event_date = null,
    Object? event_time = freezed,
    Object? venue_address = freezed,
    Object? payment_method = null,
    Object? package = null,
    Object? scents = null,
  }) {
    return _then(
      _$BookingImpl(
        id: null == id
            ? _value.id
            : id // ignore: cast_nullable_to_non_nullable
                  as int,
        booking_reference: null == booking_reference
            ? _value.booking_reference
            : booking_reference // ignore: cast_nullable_to_non_nullable
                  as String,
        user_id: null == user_id
            ? _value.user_id
            : user_id // ignore: cast_nullable_to_non_nullable
                  as int,
        customer_name: null == customer_name
            ? _value.customer_name
            : customer_name // ignore: cast_nullable_to_non_nullable
                  as String,
        customer_email: freezed == customer_email
            ? _value.customer_email
            : customer_email // ignore: cast_nullable_to_non_nullable
                  as String?,
        customer_phone: freezed == customer_phone
            ? _value.customer_phone
            : customer_phone // ignore: cast_nullable_to_non_nullable
                  as String?,
        pax: freezed == pax
            ? _value.pax
            : pax // ignore: cast_nullable_to_non_nullable
                  as int?,
        status: null == status
            ? _value.status
            : status // ignore: cast_nullable_to_non_nullable
                  as String,
        event_date: null == event_date
            ? _value.event_date
            : event_date // ignore: cast_nullable_to_non_nullable
                  as String,
        event_time: freezed == event_time
            ? _value.event_time
            : event_time // ignore: cast_nullable_to_non_nullable
                  as String?,
        venue_address: freezed == venue_address
            ? _value.venue_address
            : venue_address // ignore: cast_nullable_to_non_nullable
                  as String?,
        payment_method: null == payment_method
            ? _value.payment_method
            : payment_method // ignore: cast_nullable_to_non_nullable
                  as String,
        package: null == package
            ? _value.package
            : package // ignore: cast_nullable_to_non_nullable
                  as Package,
        scents: null == scents
            ? _value._scents
            : scents // ignore: cast_nullable_to_non_nullable
                  as List<Scent>,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$BookingImpl implements _Booking {
  const _$BookingImpl({
    required this.id,
    required this.booking_reference,
    required this.user_id,
    required this.customer_name,
    required this.customer_email,
    required this.customer_phone,
    required this.pax,
    required this.status,
    required this.event_date,
    required this.event_time,
    required this.venue_address,
    required this.payment_method,
    required this.package,
    required final List<Scent> scents,
  }) : _scents = scents;

  factory _$BookingImpl.fromJson(Map<String, dynamic> json) =>
      _$$BookingImplFromJson(json);

  @override
  final int id;
  @override
  final String booking_reference;
  @override
  final int user_id;
  @override
  final String customer_name;
  @override
  final String? customer_email;
  @override
  final String? customer_phone;
  @override
  final int? pax;
  @override
  final String status;
  @override
  final String event_date;
  @override
  final String? event_time;
  @override
  final String? venue_address;
  @override
  final String payment_method;
  @override
  final Package package;
  final List<Scent> _scents;
  @override
  List<Scent> get scents {
    if (_scents is EqualUnmodifiableListView) return _scents;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_scents);
  }

  @override
  String toString() {
    return 'Booking(id: $id, booking_reference: $booking_reference, user_id: $user_id, customer_name: $customer_name, customer_email: $customer_email, customer_phone: $customer_phone, pax: $pax, status: $status, event_date: $event_date, event_time: $event_time, venue_address: $venue_address, payment_method: $payment_method, package: $package, scents: $scents)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$BookingImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.booking_reference, booking_reference) ||
                other.booking_reference == booking_reference) &&
            (identical(other.user_id, user_id) || other.user_id == user_id) &&
            (identical(other.customer_name, customer_name) ||
                other.customer_name == customer_name) &&
            (identical(other.customer_email, customer_email) ||
                other.customer_email == customer_email) &&
            (identical(other.customer_phone, customer_phone) ||
                other.customer_phone == customer_phone) &&
            (identical(other.pax, pax) || other.pax == pax) &&
            (identical(other.status, status) || other.status == status) &&
            (identical(other.event_date, event_date) ||
                other.event_date == event_date) &&
            (identical(other.event_time, event_time) ||
                other.event_time == event_time) &&
            (identical(other.venue_address, venue_address) ||
                other.venue_address == venue_address) &&
            (identical(other.payment_method, payment_method) ||
                other.payment_method == payment_method) &&
            (identical(other.package, package) || other.package == package) &&
            const DeepCollectionEquality().equals(other._scents, _scents));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    id,
    booking_reference,
    user_id,
    customer_name,
    customer_email,
    customer_phone,
    pax,
    status,
    event_date,
    event_time,
    venue_address,
    payment_method,
    package,
    const DeepCollectionEquality().hash(_scents),
  );

  /// Create a copy of Booking
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$BookingImplCopyWith<_$BookingImpl> get copyWith =>
      __$$BookingImplCopyWithImpl<_$BookingImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$BookingImplToJson(this);
  }
}

abstract class _Booking implements Booking {
  const factory _Booking({
    required final int id,
    required final String booking_reference,
    required final int user_id,
    required final String customer_name,
    required final String? customer_email,
    required final String? customer_phone,
    required final int? pax,
    required final String status,
    required final String event_date,
    required final String? event_time,
    required final String? venue_address,
    required final String payment_method,
    required final Package package,
    required final List<Scent> scents,
  }) = _$BookingImpl;

  factory _Booking.fromJson(Map<String, dynamic> json) = _$BookingImpl.fromJson;

  @override
  int get id;
  @override
  String get booking_reference;
  @override
  int get user_id;
  @override
  String get customer_name;
  @override
  String? get customer_email;
  @override
  String? get customer_phone;
  @override
  int? get pax;
  @override
  String get status;
  @override
  String get event_date;
  @override
  String? get event_time;
  @override
  String? get venue_address;
  @override
  String get payment_method;
  @override
  Package get package;
  @override
  List<Scent> get scents;

  /// Create a copy of Booking
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$BookingImplCopyWith<_$BookingImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
