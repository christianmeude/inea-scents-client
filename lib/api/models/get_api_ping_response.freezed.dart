// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'get_api_ping_response.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$GetApiPingResponse {

 String? get message;
/// Create a copy of GetApiPingResponse
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$GetApiPingResponseCopyWith<GetApiPingResponse> get copyWith => _$GetApiPingResponseCopyWithImpl<GetApiPingResponse>(this as GetApiPingResponse, _$identity);

  /// Serializes this GetApiPingResponse to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is GetApiPingResponse&&(identical(other.message, message) || other.message == message));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,message);

@override
String toString() {
  return 'GetApiPingResponse(message: $message)';
}


}

/// @nodoc
abstract mixin class $GetApiPingResponseCopyWith<$Res>  {
  factory $GetApiPingResponseCopyWith(GetApiPingResponse value, $Res Function(GetApiPingResponse) _then) = _$GetApiPingResponseCopyWithImpl;
@useResult
$Res call({
 String? message
});




}
/// @nodoc
class _$GetApiPingResponseCopyWithImpl<$Res>
    implements $GetApiPingResponseCopyWith<$Res> {
  _$GetApiPingResponseCopyWithImpl(this._self, this._then);

  final GetApiPingResponse _self;
  final $Res Function(GetApiPingResponse) _then;

/// Create a copy of GetApiPingResponse
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? message = freezed,}) {
  return _then(GetApiPingResponse(
message: freezed == message ? _self.message : message // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [GetApiPingResponse].
extension GetApiPingResponsePatterns on GetApiPingResponse {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _GetApiPingResponse value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _GetApiPingResponse() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _GetApiPingResponse value)  $default,){
final _that = this;
switch (_that) {
case _GetApiPingResponse():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _GetApiPingResponse value)?  $default,){
final _that = this;
switch (_that) {
case _GetApiPingResponse() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String? message)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _GetApiPingResponse() when $default != null:
return $default(_that.message);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String? message)  $default,) {final _that = this;
switch (_that) {
case _GetApiPingResponse():
return $default(_that.message);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String? message)?  $default,) {final _that = this;
switch (_that) {
case _GetApiPingResponse() when $default != null:
return $default(_that.message);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _GetApiPingResponse implements GetApiPingResponse {
  const _GetApiPingResponse({this.message});
  factory _GetApiPingResponse.fromJson(Map<String, dynamic> json) => _$GetApiPingResponseFromJson(json);

@override final  String? message;

/// Create a copy of GetApiPingResponse
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$GetApiPingResponseCopyWith<_GetApiPingResponse> get copyWith => __$GetApiPingResponseCopyWithImpl<_GetApiPingResponse>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$GetApiPingResponseToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _GetApiPingResponse&&(identical(other.message, message) || other.message == message));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,message);

@override
String toString() {
  return 'GetApiPingResponse(message: $message)';
}


}

/// @nodoc
abstract mixin class _$GetApiPingResponseCopyWith<$Res> implements $GetApiPingResponseCopyWith<$Res> {
  factory _$GetApiPingResponseCopyWith(_GetApiPingResponse value, $Res Function(_GetApiPingResponse) _then) = __$GetApiPingResponseCopyWithImpl;
@override @useResult
$Res call({
 String? message
});




}
/// @nodoc
class __$GetApiPingResponseCopyWithImpl<$Res>
    implements _$GetApiPingResponseCopyWith<$Res> {
  __$GetApiPingResponseCopyWithImpl(this._self, this._then);

  final _GetApiPingResponse _self;
  final $Res Function(_GetApiPingResponse) _then;

/// Create a copy of GetApiPingResponse
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? message = freezed,}) {
  return _then(_GetApiPingResponse(
message: freezed == message ? _self.message : message // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}

// dart format on
