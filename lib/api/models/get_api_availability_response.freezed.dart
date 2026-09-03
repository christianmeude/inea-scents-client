// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'get_api_availability_response.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$GetApiAvailabilityResponse {

 DateTime? get date; String? get status;
/// Create a copy of GetApiAvailabilityResponse
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$GetApiAvailabilityResponseCopyWith<GetApiAvailabilityResponse> get copyWith => _$GetApiAvailabilityResponseCopyWithImpl<GetApiAvailabilityResponse>(this as GetApiAvailabilityResponse, _$identity);

  /// Serializes this GetApiAvailabilityResponse to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is GetApiAvailabilityResponse&&(identical(other.date, date) || other.date == date)&&(identical(other.status, status) || other.status == status));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,date,status);

@override
String toString() {
  return 'GetApiAvailabilityResponse(date: $date, status: $status)';
}


}

/// @nodoc
abstract mixin class $GetApiAvailabilityResponseCopyWith<$Res>  {
  factory $GetApiAvailabilityResponseCopyWith(GetApiAvailabilityResponse value, $Res Function(GetApiAvailabilityResponse) _then) = _$GetApiAvailabilityResponseCopyWithImpl;
@useResult
$Res call({
 DateTime? date, String? status
});




}
/// @nodoc
class _$GetApiAvailabilityResponseCopyWithImpl<$Res>
    implements $GetApiAvailabilityResponseCopyWith<$Res> {
  _$GetApiAvailabilityResponseCopyWithImpl(this._self, this._then);

  final GetApiAvailabilityResponse _self;
  final $Res Function(GetApiAvailabilityResponse) _then;

/// Create a copy of GetApiAvailabilityResponse
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? date = freezed,Object? status = freezed,}) {
  return _then(_self.copyWith(
date: freezed == date ? _self.date : date // ignore: cast_nullable_to_non_nullable
as DateTime?,status: freezed == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [GetApiAvailabilityResponse].
extension GetApiAvailabilityResponsePatterns on GetApiAvailabilityResponse {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _GetApiAvailabilityResponse value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _GetApiAvailabilityResponse() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _GetApiAvailabilityResponse value)  $default,){
final _that = this;
switch (_that) {
case _GetApiAvailabilityResponse():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _GetApiAvailabilityResponse value)?  $default,){
final _that = this;
switch (_that) {
case _GetApiAvailabilityResponse() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( DateTime? date,  String? status)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _GetApiAvailabilityResponse() when $default != null:
return $default(_that.date,_that.status);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( DateTime? date,  String? status)  $default,) {final _that = this;
switch (_that) {
case _GetApiAvailabilityResponse():
return $default(_that.date,_that.status);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( DateTime? date,  String? status)?  $default,) {final _that = this;
switch (_that) {
case _GetApiAvailabilityResponse() when $default != null:
return $default(_that.date,_that.status);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _GetApiAvailabilityResponse implements GetApiAvailabilityResponse {
  const _GetApiAvailabilityResponse({this.date, this.status});
  factory _GetApiAvailabilityResponse.fromJson(Map<String, dynamic> json) => _$GetApiAvailabilityResponseFromJson(json);

@override final  DateTime? date;
@override final  String? status;

/// Create a copy of GetApiAvailabilityResponse
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$GetApiAvailabilityResponseCopyWith<_GetApiAvailabilityResponse> get copyWith => __$GetApiAvailabilityResponseCopyWithImpl<_GetApiAvailabilityResponse>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$GetApiAvailabilityResponseToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _GetApiAvailabilityResponse&&(identical(other.date, date) || other.date == date)&&(identical(other.status, status) || other.status == status));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,date,status);

@override
String toString() {
  return 'GetApiAvailabilityResponse(date: $date, status: $status)';
}


}

/// @nodoc
abstract mixin class _$GetApiAvailabilityResponseCopyWith<$Res> implements $GetApiAvailabilityResponseCopyWith<$Res> {
  factory _$GetApiAvailabilityResponseCopyWith(_GetApiAvailabilityResponse value, $Res Function(_GetApiAvailabilityResponse) _then) = __$GetApiAvailabilityResponseCopyWithImpl;
@override @useResult
$Res call({
 DateTime? date, String? status
});




}
/// @nodoc
class __$GetApiAvailabilityResponseCopyWithImpl<$Res>
    implements _$GetApiAvailabilityResponseCopyWith<$Res> {
  __$GetApiAvailabilityResponseCopyWithImpl(this._self, this._then);

  final _GetApiAvailabilityResponse _self;
  final $Res Function(_GetApiAvailabilityResponse) _then;

/// Create a copy of GetApiAvailabilityResponse
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? date = freezed,Object? status = freezed,}) {
  return _then(_GetApiAvailabilityResponse(
date: freezed == date ? _self.date : date // ignore: cast_nullable_to_non_nullable
as DateTime?,status: freezed == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}

// dart format on
