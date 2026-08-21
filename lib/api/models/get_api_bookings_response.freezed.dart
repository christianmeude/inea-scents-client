// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'get_api_bookings_response.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$GetApiBookingsResponse {

 List<Data>? get data;
/// Create a copy of GetApiBookingsResponse
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$GetApiBookingsResponseCopyWith<GetApiBookingsResponse> get copyWith => _$GetApiBookingsResponseCopyWithImpl<GetApiBookingsResponse>(this as GetApiBookingsResponse, _$identity);

  /// Serializes this GetApiBookingsResponse to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is GetApiBookingsResponse&&const DeepCollectionEquality().equals(other.data, data));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(data));

@override
String toString() {
  return 'GetApiBookingsResponse(data: $data)';
}


}

/// @nodoc
abstract mixin class $GetApiBookingsResponseCopyWith<$Res>  {
  factory $GetApiBookingsResponseCopyWith(GetApiBookingsResponse value, $Res Function(GetApiBookingsResponse) _then) = _$GetApiBookingsResponseCopyWithImpl;
@useResult
$Res call({
 List<Data>? data
});




}
/// @nodoc
class _$GetApiBookingsResponseCopyWithImpl<$Res>
    implements $GetApiBookingsResponseCopyWith<$Res> {
  _$GetApiBookingsResponseCopyWithImpl(this._self, this._then);

  final GetApiBookingsResponse _self;
  final $Res Function(GetApiBookingsResponse) _then;

/// Create a copy of GetApiBookingsResponse
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? data = freezed,}) {
  return _then(GetApiBookingsResponse(
data: freezed == data ? _self.data : data // ignore: cast_nullable_to_non_nullable
as List<Data>?,
  ));
}

}


/// Adds pattern-matching-related methods to [GetApiBookingsResponse].
extension GetApiBookingsResponsePatterns on GetApiBookingsResponse {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _GetApiBookingsResponse value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _GetApiBookingsResponse() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _GetApiBookingsResponse value)  $default,){
final _that = this;
switch (_that) {
case _GetApiBookingsResponse():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _GetApiBookingsResponse value)?  $default,){
final _that = this;
switch (_that) {
case _GetApiBookingsResponse() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( List<Data>? data)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _GetApiBookingsResponse() when $default != null:
return $default(_that.data);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( List<Data>? data)  $default,) {final _that = this;
switch (_that) {
case _GetApiBookingsResponse():
return $default(_that.data);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( List<Data>? data)?  $default,) {final _that = this;
switch (_that) {
case _GetApiBookingsResponse() when $default != null:
return $default(_that.data);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _GetApiBookingsResponse implements GetApiBookingsResponse {
  const _GetApiBookingsResponse({ List<Data>? data}): _data = data;
  factory _GetApiBookingsResponse.fromJson(Map<String, dynamic> json) => _$GetApiBookingsResponseFromJson(json);

 final  List<Data>? _data;
@override List<Data>? get data {
  final value = _data;
  if (value == null) return null;
  if (_data is EqualUnmodifiableListView) return _data;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(value);
}


/// Create a copy of GetApiBookingsResponse
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$GetApiBookingsResponseCopyWith<_GetApiBookingsResponse> get copyWith => __$GetApiBookingsResponseCopyWithImpl<_GetApiBookingsResponse>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$GetApiBookingsResponseToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _GetApiBookingsResponse&&const DeepCollectionEquality().equals(other._data, _data));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(_data));

@override
String toString() {
  return 'GetApiBookingsResponse(data: $data)';
}


}

/// @nodoc
abstract mixin class _$GetApiBookingsResponseCopyWith<$Res> implements $GetApiBookingsResponseCopyWith<$Res> {
  factory _$GetApiBookingsResponseCopyWith(_GetApiBookingsResponse value, $Res Function(_GetApiBookingsResponse) _then) = __$GetApiBookingsResponseCopyWithImpl;
@override @useResult
$Res call({
 List<Data>? data
});




}
/// @nodoc
class __$GetApiBookingsResponseCopyWithImpl<$Res>
    implements _$GetApiBookingsResponseCopyWith<$Res> {
  __$GetApiBookingsResponseCopyWithImpl(this._self, this._then);

  final _GetApiBookingsResponse _self;
  final $Res Function(_GetApiBookingsResponse) _then;

/// Create a copy of GetApiBookingsResponse
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? data = freezed,}) {
  return _then(_GetApiBookingsResponse(
data: freezed == data ? _self._data : data // ignore: cast_nullable_to_non_nullable
as List<Data>?,
  ));
}


}

// dart format on
