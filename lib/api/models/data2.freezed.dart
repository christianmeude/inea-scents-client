// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'data2.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$Data2 {

 int? get id;@JsonKey(name: 'booking_reference') String? get bookingReference;@JsonKey(name: 'user_id') int? get userId;@JsonKey(name: 'customer_name') String? get customerName; String? get status;@JsonKey(name: 'event_date') DateTime? get eventDate;@JsonKey(name: 'payment_method') String? get paymentMethod; Package? get package; List<Scent>? get scents;
/// Create a copy of Data2
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$Data2CopyWith<Data2> get copyWith => _$Data2CopyWithImpl<Data2>(this as Data2, _$identity);

  /// Serializes this Data2 to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is Data2&&(identical(other.id, id) || other.id == id)&&(identical(other.bookingReference, bookingReference) || other.bookingReference == bookingReference)&&(identical(other.userId, userId) || other.userId == userId)&&(identical(other.customerName, customerName) || other.customerName == customerName)&&(identical(other.status, status) || other.status == status)&&(identical(other.eventDate, eventDate) || other.eventDate == eventDate)&&(identical(other.paymentMethod, paymentMethod) || other.paymentMethod == paymentMethod)&&(identical(other.package, package) || other.package == package)&&const DeepCollectionEquality().equals(other.scents, scents));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,bookingReference,userId,customerName,status,eventDate,paymentMethod,package,const DeepCollectionEquality().hash(scents));

@override
String toString() {
  return 'Data2(id: $id, bookingReference: $bookingReference, userId: $userId, customerName: $customerName, status: $status, eventDate: $eventDate, paymentMethod: $paymentMethod, package: $package, scents: $scents)';
}


}

/// @nodoc
abstract mixin class $Data2CopyWith<$Res>  {
  factory $Data2CopyWith(Data2 value, $Res Function(Data2) _then) = _$Data2CopyWithImpl;
@useResult
$Res call({
 int? id,@JsonKey(name: 'booking_reference') String? bookingReference,@JsonKey(name: 'user_id') int? userId,@JsonKey(name: 'customer_name') String? customerName, String? status,@JsonKey(name: 'event_date') DateTime? eventDate,@JsonKey(name: 'payment_method') String? paymentMethod, Package? package, List<Scent>? scents
});


$PackageCopyWith<$Res>? get package;

}
/// @nodoc
class _$Data2CopyWithImpl<$Res>
    implements $Data2CopyWith<$Res> {
  _$Data2CopyWithImpl(this._self, this._then);

  final Data2 _self;
  final $Res Function(Data2) _then;

/// Create a copy of Data2
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = freezed,Object? bookingReference = freezed,Object? userId = freezed,Object? customerName = freezed,Object? status = freezed,Object? eventDate = freezed,Object? paymentMethod = freezed,Object? package = freezed,Object? scents = freezed,}) {
  return _then(_self.copyWith(
id: freezed == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int?,bookingReference: freezed == bookingReference ? _self.bookingReference : bookingReference // ignore: cast_nullable_to_non_nullable
as String?,userId: freezed == userId ? _self.userId : userId // ignore: cast_nullable_to_non_nullable
as int?,customerName: freezed == customerName ? _self.customerName : customerName // ignore: cast_nullable_to_non_nullable
as String?,status: freezed == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as String?,eventDate: freezed == eventDate ? _self.eventDate : eventDate // ignore: cast_nullable_to_non_nullable
as DateTime?,paymentMethod: freezed == paymentMethod ? _self.paymentMethod : paymentMethod // ignore: cast_nullable_to_non_nullable
as String?,package: freezed == package ? _self.package : package // ignore: cast_nullable_to_non_nullable
as Package?,scents: freezed == scents ? _self.scents : scents // ignore: cast_nullable_to_non_nullable
as List<Scent>?,
  ));
}
/// Create a copy of Data2
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$PackageCopyWith<$Res>? get package {
    if (_self.package == null) {
    return null;
  }

  return $PackageCopyWith<$Res>(_self.package!, (value) {
    return _then(_self.copyWith(package: value));
  });
}
}


/// Adds pattern-matching-related methods to [Data2].
extension Data2Patterns on Data2 {
/// A variant of `map` that fallback to returning `orElse`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _Data2 value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _Data2() when $default != null:
return $default(_that);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// Callbacks receives the raw object, upcasted.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case final Subclass2 value:
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _Data2 value)  $default,){
final _that = this;
switch (_that) {
case _Data2():
return $default(_that);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `map` that fallback to returning `null`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _Data2 value)?  $default,){
final _that = this;
switch (_that) {
case _Data2() when $default != null:
return $default(_that);case _:
  return null;

}
}
/// A variant of `when` that fallback to an `orElse` callback.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int? id, @JsonKey(name: 'booking_reference')  String? bookingReference, @JsonKey(name: 'user_id')  int? userId, @JsonKey(name: 'customer_name')  String? customerName,  String? status, @JsonKey(name: 'event_date')  DateTime? eventDate, @JsonKey(name: 'payment_method')  String? paymentMethod,  Package? package,  List<Scent>? scents)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _Data2() when $default != null:
return $default(_that.id,_that.bookingReference,_that.userId,_that.customerName,_that.status,_that.eventDate,_that.paymentMethod,_that.package,_that.scents);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// As opposed to `map`, this offers destructuring.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case Subclass2(:final field2):
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int? id, @JsonKey(name: 'booking_reference')  String? bookingReference, @JsonKey(name: 'user_id')  int? userId, @JsonKey(name: 'customer_name')  String? customerName,  String? status, @JsonKey(name: 'event_date')  DateTime? eventDate, @JsonKey(name: 'payment_method')  String? paymentMethod,  Package? package,  List<Scent>? scents)  $default,) {final _that = this;
switch (_that) {
case _Data2():
return $default(_that.id,_that.bookingReference,_that.userId,_that.customerName,_that.status,_that.eventDate,_that.paymentMethod,_that.package,_that.scents);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `when` that fallback to returning `null`
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int? id, @JsonKey(name: 'booking_reference')  String? bookingReference, @JsonKey(name: 'user_id')  int? userId, @JsonKey(name: 'customer_name')  String? customerName,  String? status, @JsonKey(name: 'event_date')  DateTime? eventDate, @JsonKey(name: 'payment_method')  String? paymentMethod,  Package? package,  List<Scent>? scents)?  $default,) {final _that = this;
switch (_that) {
case _Data2() when $default != null:
return $default(_that.id,_that.bookingReference,_that.userId,_that.customerName,_that.status,_that.eventDate,_that.paymentMethod,_that.package,_that.scents);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _Data2 implements Data2 {
  const _Data2({this.id, @JsonKey(name: 'booking_reference') this.bookingReference, @JsonKey(name: 'user_id') this.userId, @JsonKey(name: 'customer_name') this.customerName, this.status, @JsonKey(name: 'event_date') this.eventDate, @JsonKey(name: 'payment_method') this.paymentMethod, this.package, final  List<Scent>? scents}): _scents = scents;
  factory _Data2.fromJson(Map<String, dynamic> json) => _$Data2FromJson(json);

@override final  int? id;
@override@JsonKey(name: 'booking_reference') final  String? bookingReference;
@override@JsonKey(name: 'user_id') final  int? userId;
@override@JsonKey(name: 'customer_name') final  String? customerName;
@override final  String? status;
@override@JsonKey(name: 'event_date') final  DateTime? eventDate;
@override@JsonKey(name: 'payment_method') final  String? paymentMethod;
@override final  Package? package;
 final  List<Scent>? _scents;
@override List<Scent>? get scents {
  final value = _scents;
  if (value == null) return null;
  if (_scents is EqualUnmodifiableListView) return _scents;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(value);
}


/// Create a copy of Data2
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$Data2CopyWith<_Data2> get copyWith => __$Data2CopyWithImpl<_Data2>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$Data2ToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _Data2&&(identical(other.id, id) || other.id == id)&&(identical(other.bookingReference, bookingReference) || other.bookingReference == bookingReference)&&(identical(other.userId, userId) || other.userId == userId)&&(identical(other.customerName, customerName) || other.customerName == customerName)&&(identical(other.status, status) || other.status == status)&&(identical(other.eventDate, eventDate) || other.eventDate == eventDate)&&(identical(other.paymentMethod, paymentMethod) || other.paymentMethod == paymentMethod)&&(identical(other.package, package) || other.package == package)&&const DeepCollectionEquality().equals(other._scents, _scents));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,bookingReference,userId,customerName,status,eventDate,paymentMethod,package,const DeepCollectionEquality().hash(_scents));

@override
String toString() {
  return 'Data2(id: $id, bookingReference: $bookingReference, userId: $userId, customerName: $customerName, status: $status, eventDate: $eventDate, paymentMethod: $paymentMethod, package: $package, scents: $scents)';
}


}

/// @nodoc
abstract mixin class _$Data2CopyWith<$Res> implements $Data2CopyWith<$Res> {
  factory _$Data2CopyWith(_Data2 value, $Res Function(_Data2) _then) = __$Data2CopyWithImpl;
@override @useResult
$Res call({
 int? id,@JsonKey(name: 'booking_reference') String? bookingReference,@JsonKey(name: 'user_id') int? userId,@JsonKey(name: 'customer_name') String? customerName, String? status,@JsonKey(name: 'event_date') DateTime? eventDate,@JsonKey(name: 'payment_method') String? paymentMethod, Package? package, List<Scent>? scents
});


@override $PackageCopyWith<$Res>? get package;

}
/// @nodoc
class __$Data2CopyWithImpl<$Res>
    implements _$Data2CopyWith<$Res> {
  __$Data2CopyWithImpl(this._self, this._then);

  final _Data2 _self;
  final $Res Function(_Data2) _then;

/// Create a copy of Data2
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = freezed,Object? bookingReference = freezed,Object? userId = freezed,Object? customerName = freezed,Object? status = freezed,Object? eventDate = freezed,Object? paymentMethod = freezed,Object? package = freezed,Object? scents = freezed,}) {
  return _then(_Data2(
id: freezed == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int?,bookingReference: freezed == bookingReference ? _self.bookingReference : bookingReference // ignore: cast_nullable_to_non_nullable
as String?,userId: freezed == userId ? _self.userId : userId // ignore: cast_nullable_to_non_nullable
as int?,customerName: freezed == customerName ? _self.customerName : customerName // ignore: cast_nullable_to_non_nullable
as String?,status: freezed == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as String?,eventDate: freezed == eventDate ? _self.eventDate : eventDate // ignore: cast_nullable_to_non_nullable
as DateTime?,paymentMethod: freezed == paymentMethod ? _self.paymentMethod : paymentMethod // ignore: cast_nullable_to_non_nullable
as String?,package: freezed == package ? _self.package : package // ignore: cast_nullable_to_non_nullable
as Package?,scents: freezed == scents ? _self._scents : scents // ignore: cast_nullable_to_non_nullable
as List<Scent>?,
  ));
}

/// Create a copy of Data2
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$PackageCopyWith<$Res>? get package {
    if (_self.package == null) {
    return null;
  }

  return $PackageCopyWith<$Res>(_self.package!, (value) {
    return _then(_self.copyWith(package: value));
  });
}
}

// dart format on
