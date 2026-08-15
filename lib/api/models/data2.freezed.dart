// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'data2.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

Data2 _$Data2FromJson(Map<String, dynamic> json) {
  return _Data2.fromJson(json);
}

/// @nodoc
mixin _$Data2 {
  int? get id => throw _privateConstructorUsedError;
  @JsonKey(name: 'booking_reference')
  String? get bookingReference => throw _privateConstructorUsedError;
  @JsonKey(name: 'user_id')
  int? get userId => throw _privateConstructorUsedError;
  @JsonKey(name: 'customer_name')
  String? get customerName => throw _privateConstructorUsedError;
  String? get status => throw _privateConstructorUsedError;
  @JsonKey(name: 'event_date')
  DateTime? get eventDate => throw _privateConstructorUsedError;
  @JsonKey(name: 'payment_method')
  String? get paymentMethod => throw _privateConstructorUsedError;
  Package? get package => throw _privateConstructorUsedError;
  List<Scent>? get scents => throw _privateConstructorUsedError;

  /// Serializes this Data2 to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of Data2
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $Data2CopyWith<Data2> get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $Data2CopyWith<$Res> {
  factory $Data2CopyWith(Data2 value, $Res Function(Data2) then) =
      _$Data2CopyWithImpl<$Res, Data2>;
  @useResult
  $Res call({
    int? id,
    @JsonKey(name: 'booking_reference') String? bookingReference,
    @JsonKey(name: 'user_id') int? userId,
    @JsonKey(name: 'customer_name') String? customerName,
    String? status,
    @JsonKey(name: 'event_date') DateTime? eventDate,
    @JsonKey(name: 'payment_method') String? paymentMethod,
    Package? package,
    List<Scent>? scents,
  });

  $PackageCopyWith<$Res>? get package;
}

/// @nodoc
class _$Data2CopyWithImpl<$Res, $Val extends Data2>
    implements $Data2CopyWith<$Res> {
  _$Data2CopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of Data2
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = freezed,
    Object? bookingReference = freezed,
    Object? userId = freezed,
    Object? customerName = freezed,
    Object? status = freezed,
    Object? eventDate = freezed,
    Object? paymentMethod = freezed,
    Object? package = freezed,
    Object? scents = freezed,
  }) {
    return _then(
      _value.copyWith(
            id: freezed == id
                ? _value.id
                : id // ignore: cast_nullable_to_non_nullable
                      as int?,
            bookingReference: freezed == bookingReference
                ? _value.bookingReference
                : bookingReference // ignore: cast_nullable_to_non_nullable
                      as String?,
            userId: freezed == userId
                ? _value.userId
                : userId // ignore: cast_nullable_to_non_nullable
                      as int?,
            customerName: freezed == customerName
                ? _value.customerName
                : customerName // ignore: cast_nullable_to_non_nullable
                      as String?,
            status: freezed == status
                ? _value.status
                : status // ignore: cast_nullable_to_non_nullable
                      as String?,
            eventDate: freezed == eventDate
                ? _value.eventDate
                : eventDate // ignore: cast_nullable_to_non_nullable
                      as DateTime?,
            paymentMethod: freezed == paymentMethod
                ? _value.paymentMethod
                : paymentMethod // ignore: cast_nullable_to_non_nullable
                      as String?,
            package: freezed == package
                ? _value.package
                : package // ignore: cast_nullable_to_non_nullable
                      as Package?,
            scents: freezed == scents
                ? _value.scents
                : scents // ignore: cast_nullable_to_non_nullable
                      as List<Scent>?,
          )
          as $Val,
    );
  }

  /// Create a copy of Data2
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $PackageCopyWith<$Res>? get package {
    if (_value.package == null) {
      return null;
    }

    return $PackageCopyWith<$Res>(_value.package!, (value) {
      return _then(_value.copyWith(package: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$Data2ImplCopyWith<$Res> implements $Data2CopyWith<$Res> {
  factory _$$Data2ImplCopyWith(
    _$Data2Impl value,
    $Res Function(_$Data2Impl) then,
  ) = __$$Data2ImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    int? id,
    @JsonKey(name: 'booking_reference') String? bookingReference,
    @JsonKey(name: 'user_id') int? userId,
    @JsonKey(name: 'customer_name') String? customerName,
    String? status,
    @JsonKey(name: 'event_date') DateTime? eventDate,
    @JsonKey(name: 'payment_method') String? paymentMethod,
    Package? package,
    List<Scent>? scents,
  });

  @override
  $PackageCopyWith<$Res>? get package;
}

/// @nodoc
class __$$Data2ImplCopyWithImpl<$Res>
    extends _$Data2CopyWithImpl<$Res, _$Data2Impl>
    implements _$$Data2ImplCopyWith<$Res> {
  __$$Data2ImplCopyWithImpl(
    _$Data2Impl _value,
    $Res Function(_$Data2Impl) _then,
  ) : super(_value, _then);

  /// Create a copy of Data2
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = freezed,
    Object? bookingReference = freezed,
    Object? userId = freezed,
    Object? customerName = freezed,
    Object? status = freezed,
    Object? eventDate = freezed,
    Object? paymentMethod = freezed,
    Object? package = freezed,
    Object? scents = freezed,
  }) {
    return _then(
      _$Data2Impl(
        id: freezed == id
            ? _value.id
            : id // ignore: cast_nullable_to_non_nullable
                  as int?,
        bookingReference: freezed == bookingReference
            ? _value.bookingReference
            : bookingReference // ignore: cast_nullable_to_non_nullable
                  as String?,
        userId: freezed == userId
            ? _value.userId
            : userId // ignore: cast_nullable_to_non_nullable
                  as int?,
        customerName: freezed == customerName
            ? _value.customerName
            : customerName // ignore: cast_nullable_to_non_nullable
                  as String?,
        status: freezed == status
            ? _value.status
            : status // ignore: cast_nullable_to_non_nullable
                  as String?,
        eventDate: freezed == eventDate
            ? _value.eventDate
            : eventDate // ignore: cast_nullable_to_non_nullable
                  as DateTime?,
        paymentMethod: freezed == paymentMethod
            ? _value.paymentMethod
            : paymentMethod // ignore: cast_nullable_to_non_nullable
                  as String?,
        package: freezed == package
            ? _value.package
            : package // ignore: cast_nullable_to_non_nullable
                  as Package?,
        scents: freezed == scents
            ? _value._scents
            : scents // ignore: cast_nullable_to_non_nullable
                  as List<Scent>?,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$Data2Impl implements _Data2 {
  const _$Data2Impl({
    this.id,
    @JsonKey(name: 'booking_reference') this.bookingReference,
    @JsonKey(name: 'user_id') this.userId,
    @JsonKey(name: 'customer_name') this.customerName,
    this.status,
    @JsonKey(name: 'event_date') this.eventDate,
    @JsonKey(name: 'payment_method') this.paymentMethod,
    this.package,
    final List<Scent>? scents,
  }) : _scents = scents;

  factory _$Data2Impl.fromJson(Map<String, dynamic> json) =>
      _$$Data2ImplFromJson(json);

  @override
  final int? id;
  @override
  @JsonKey(name: 'booking_reference')
  final String? bookingReference;
  @override
  @JsonKey(name: 'user_id')
  final int? userId;
  @override
  @JsonKey(name: 'customer_name')
  final String? customerName;
  @override
  final String? status;
  @override
  @JsonKey(name: 'event_date')
  final DateTime? eventDate;
  @override
  @JsonKey(name: 'payment_method')
  final String? paymentMethod;
  @override
  final Package? package;
  final List<Scent>? _scents;
  @override
  List<Scent>? get scents {
    final value = _scents;
    if (value == null) return null;
    if (_scents is EqualUnmodifiableListView) return _scents;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(value);
  }

  @override
  String toString() {
    return 'Data2(id: $id, bookingReference: $bookingReference, userId: $userId, customerName: $customerName, status: $status, eventDate: $eventDate, paymentMethod: $paymentMethod, package: $package, scents: $scents)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$Data2Impl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.bookingReference, bookingReference) ||
                other.bookingReference == bookingReference) &&
            (identical(other.userId, userId) || other.userId == userId) &&
            (identical(other.customerName, customerName) ||
                other.customerName == customerName) &&
            (identical(other.status, status) || other.status == status) &&
            (identical(other.eventDate, eventDate) ||
                other.eventDate == eventDate) &&
            (identical(other.paymentMethod, paymentMethod) ||
                other.paymentMethod == paymentMethod) &&
            (identical(other.package, package) || other.package == package) &&
            const DeepCollectionEquality().equals(other._scents, _scents));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    id,
    bookingReference,
    userId,
    customerName,
    status,
    eventDate,
    paymentMethod,
    package,
    const DeepCollectionEquality().hash(_scents),
  );

  /// Create a copy of Data2
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$Data2ImplCopyWith<_$Data2Impl> get copyWith =>
      __$$Data2ImplCopyWithImpl<_$Data2Impl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$Data2ImplToJson(this);
  }
}

abstract class _Data2 implements Data2 {
  const factory _Data2({
    final int? id,
    @JsonKey(name: 'booking_reference') final String? bookingReference,
    @JsonKey(name: 'user_id') final int? userId,
    @JsonKey(name: 'customer_name') final String? customerName,
    final String? status,
    @JsonKey(name: 'event_date') final DateTime? eventDate,
    @JsonKey(name: 'payment_method') final String? paymentMethod,
    final Package? package,
    final List<Scent>? scents,
  }) = _$Data2Impl;

  factory _Data2.fromJson(Map<String, dynamic> json) = _$Data2Impl.fromJson;

  @override
  int? get id;
  @override
  @JsonKey(name: 'booking_reference')
  String? get bookingReference;
  @override
  @JsonKey(name: 'user_id')
  int? get userId;
  @override
  @JsonKey(name: 'customer_name')
  String? get customerName;
  @override
  String? get status;
  @override
  @JsonKey(name: 'event_date')
  DateTime? get eventDate;
  @override
  @JsonKey(name: 'payment_method')
  String? get paymentMethod;
  @override
  Package? get package;
  @override
  List<Scent>? get scents;

  /// Create a copy of Data2
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$Data2ImplCopyWith<_$Data2Impl> get copyWith =>
      throw _privateConstructorUsedError;
}
