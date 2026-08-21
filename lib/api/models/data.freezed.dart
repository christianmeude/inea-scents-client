// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'data.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$Data {

 int? get id;@JsonKey(name: 'booking_reference') String? get bookingReference;@JsonKey(name: 'user_id') int? get userId;@JsonKey(name: 'customer_name') String? get customerName; String? get status;@JsonKey(name: 'event_date') DateTime? get eventDate;@JsonKey(name: 'payment_method') String? get paymentMethod; Package? get package; List<Scent>? get scents;
/// Create a copy of Data
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$DataCopyWith<Data> get copyWith => _$DataCopyWithImpl<Data>(this as Data, _$identity);

  /// Serializes this Data to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is Data&&(identical(other.id, id) || other.id == id)&&(identical(other.bookingReference, bookingReference) || other.bookingReference == bookingReference)&&(identical(other.userId, userId) || other.userId == userId)&&(identical(other.customerName, customerName) || other.customerName == customerName)&&(identical(other.status, status) || other.status == status)&&(identical(other.eventDate, eventDate) || other.eventDate == eventDate)&&(identical(other.paymentMethod, paymentMethod) || other.paymentMethod == paymentMethod)&&(identical(other.package, package) || other.package == package)&&const DeepCollectionEquality().equals(other.scents, scents));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,bookingReference,userId,customerName,status,eventDate,paymentMethod,package,const DeepCollectionEquality().hash(scents));

@override
String toString() {
  return 'Data(id: $id, bookingReference: $bookingReference, userId: $userId, customerName: $customerName, status: $status, eventDate: $eventDate, paymentMethod: $paymentMethod, package: $package, scents: $scents)';
}


}

/// @nodoc
abstract mixin class $DataCopyWith<$Res>  {
  factory $DataCopyWith(Data value, $Res Function(Data) _then) = _$DataCopyWithImpl;
@useResult
$Res call({
 int? id,@JsonKey(name: 'booking_reference') String? bookingReference,@JsonKey(name: 'user_id') int? userId,@JsonKey(name: 'customer_name') String? customerName, String? status,@JsonKey(name: 'event_date') DateTime? eventDate,@JsonKey(name: 'payment_method') String? paymentMethod, Package? package, List<Scent>? scents
});


$PackageCopyWith<$Res>? get package;

}
/// @nodoc
class _$DataCopyWithImpl<$Res>
    implements $DataCopyWith<$Res> {
  _$DataCopyWithImpl(this._self, this._then);

  final Data _self;
  final $Res Function(Data) _then;

/// Create a copy of Data
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = freezed,Object? bookingReference = freezed,Object? userId = freezed,Object? customerName = freezed,Object? status = freezed,Object? eventDate = freezed,Object? paymentMethod = freezed,Object? package = freezed,Object? scents = freezed,}) {
  return _then(Data(
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
/// Create a copy of Data
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


/// Adds pattern-matching-related methods to [Data].
extension DataPatterns on Data {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _Data value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _Data() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _Data value)  $default,){
final _that = this;
switch (_that) {
case _Data():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _Data value)?  $default,){
final _that = this;
switch (_that) {
case _Data() when $default != null:
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
case _Data() when $default != null:
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
case _Data():
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
case _Data() when $default != null:
return $default(_that.id,_that.bookingReference,_that.userId,_that.customerName,_that.status,_that.eventDate,_that.paymentMethod,_that.package,_that.scents);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _Data implements Data {
  const _Data({this.id, @JsonKey(name: 'booking_reference') this.bookingReference, @JsonKey(name: 'user_id') this.userId, @JsonKey(name: 'customer_name') this.customerName, this.status, @JsonKey(name: 'event_date') this.eventDate, @JsonKey(name: 'payment_method') this.paymentMethod, this.package,  List<Scent>? scents}): _scents = scents;
  factory _Data.fromJson(Map<String, dynamic> json) => _$DataFromJson(json);

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


/// Create a copy of Data
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$DataCopyWith<_Data> get copyWith => __$DataCopyWithImpl<_Data>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$DataToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _Data&&(identical(other.id, id) || other.id == id)&&(identical(other.bookingReference, bookingReference) || other.bookingReference == bookingReference)&&(identical(other.userId, userId) || other.userId == userId)&&(identical(other.customerName, customerName) || other.customerName == customerName)&&(identical(other.status, status) || other.status == status)&&(identical(other.eventDate, eventDate) || other.eventDate == eventDate)&&(identical(other.paymentMethod, paymentMethod) || other.paymentMethod == paymentMethod)&&(identical(other.package, package) || other.package == package)&&const DeepCollectionEquality().equals(other._scents, _scents));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,bookingReference,userId,customerName,status,eventDate,paymentMethod,package,const DeepCollectionEquality().hash(_scents));

@override
String toString() {
  return 'Data(id: $id, bookingReference: $bookingReference, userId: $userId, customerName: $customerName, status: $status, eventDate: $eventDate, paymentMethod: $paymentMethod, package: $package, scents: $scents)';
}


}

/// @nodoc
abstract mixin class _$DataCopyWith<$Res> implements $DataCopyWith<$Res> {
  factory _$DataCopyWith(_Data value, $Res Function(_Data) _then) = __$DataCopyWithImpl;
@override @useResult
$Res call({
 int? id,@JsonKey(name: 'booking_reference') String? bookingReference,@JsonKey(name: 'user_id') int? userId,@JsonKey(name: 'customer_name') String? customerName, String? status,@JsonKey(name: 'event_date') DateTime? eventDate,@JsonKey(name: 'payment_method') String? paymentMethod, Package? package, List<Scent>? scents
});


@override $PackageCopyWith<$Res>? get package;

}
/// @nodoc
class __$DataCopyWithImpl<$Res>
    implements _$DataCopyWith<$Res> {
  __$DataCopyWithImpl(this._self, this._then);

  final _Data _self;
  final $Res Function(_Data) _then;

/// Create a copy of Data
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = freezed,Object? bookingReference = freezed,Object? userId = freezed,Object? customerName = freezed,Object? status = freezed,Object? eventDate = freezed,Object? paymentMethod = freezed,Object? package = freezed,Object? scents = freezed,}) {
  return _then(_Data(
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

/// Create a copy of Data
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
