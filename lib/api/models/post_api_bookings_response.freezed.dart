// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'post_api_bookings_response.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$PostApiBookingsResponse {

 Data2? get data;
/// Create a copy of PostApiBookingsResponse
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$PostApiBookingsResponseCopyWith<PostApiBookingsResponse> get copyWith => _$PostApiBookingsResponseCopyWithImpl<PostApiBookingsResponse>(this as PostApiBookingsResponse, _$identity);

  /// Serializes this PostApiBookingsResponse to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is PostApiBookingsResponse&&(identical(other.data, data) || other.data == data));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,data);

@override
String toString() {
  return 'PostApiBookingsResponse(data: $data)';
}


}

/// @nodoc
abstract mixin class $PostApiBookingsResponseCopyWith<$Res>  {
  factory $PostApiBookingsResponseCopyWith(PostApiBookingsResponse value, $Res Function(PostApiBookingsResponse) _then) = _$PostApiBookingsResponseCopyWithImpl;
@useResult
$Res call({
 Data2? data
});


$Data2CopyWith<$Res>? get data;

}
/// @nodoc
class _$PostApiBookingsResponseCopyWithImpl<$Res>
    implements $PostApiBookingsResponseCopyWith<$Res> {
  _$PostApiBookingsResponseCopyWithImpl(this._self, this._then);

  final PostApiBookingsResponse _self;
  final $Res Function(PostApiBookingsResponse) _then;

/// Create a copy of PostApiBookingsResponse
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? data = freezed,}) {
  return _then(PostApiBookingsResponse(
data: freezed == data ? _self.data : data // ignore: cast_nullable_to_non_nullable
as Data2?,
  ));
}
/// Create a copy of PostApiBookingsResponse
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$Data2CopyWith<$Res>? get data {
    if (_self.data == null) {
    return null;
  }

  return $Data2CopyWith<$Res>(_self.data!, (value) {
    return _then(_self.copyWith(data: value));
  });
}
}


/// Adds pattern-matching-related methods to [PostApiBookingsResponse].
extension PostApiBookingsResponsePatterns on PostApiBookingsResponse {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _PostApiBookingsResponse value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _PostApiBookingsResponse() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _PostApiBookingsResponse value)  $default,){
final _that = this;
switch (_that) {
case _PostApiBookingsResponse():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _PostApiBookingsResponse value)?  $default,){
final _that = this;
switch (_that) {
case _PostApiBookingsResponse() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( Data2? data)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _PostApiBookingsResponse() when $default != null:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( Data2? data)  $default,) {final _that = this;
switch (_that) {
case _PostApiBookingsResponse():
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( Data2? data)?  $default,) {final _that = this;
switch (_that) {
case _PostApiBookingsResponse() when $default != null:
return $default(_that.data);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _PostApiBookingsResponse implements PostApiBookingsResponse {
  const _PostApiBookingsResponse({this.data});
  factory _PostApiBookingsResponse.fromJson(Map<String, dynamic> json) => _$PostApiBookingsResponseFromJson(json);

@override final  Data2? data;

/// Create a copy of PostApiBookingsResponse
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$PostApiBookingsResponseCopyWith<_PostApiBookingsResponse> get copyWith => __$PostApiBookingsResponseCopyWithImpl<_PostApiBookingsResponse>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$PostApiBookingsResponseToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _PostApiBookingsResponse&&(identical(other.data, data) || other.data == data));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,data);

@override
String toString() {
  return 'PostApiBookingsResponse(data: $data)';
}


}

/// @nodoc
abstract mixin class _$PostApiBookingsResponseCopyWith<$Res> implements $PostApiBookingsResponseCopyWith<$Res> {
  factory _$PostApiBookingsResponseCopyWith(_PostApiBookingsResponse value, $Res Function(_PostApiBookingsResponse) _then) = __$PostApiBookingsResponseCopyWithImpl;
@override @useResult
$Res call({
 Data2? data
});


@override $Data2CopyWith<$Res>? get data;

}
/// @nodoc
class __$PostApiBookingsResponseCopyWithImpl<$Res>
    implements _$PostApiBookingsResponseCopyWith<$Res> {
  __$PostApiBookingsResponseCopyWithImpl(this._self, this._then);

  final _PostApiBookingsResponse _self;
  final $Res Function(_PostApiBookingsResponse) _then;

/// Create a copy of PostApiBookingsResponse
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? data = freezed,}) {
  return _then(_PostApiBookingsResponse(
data: freezed == data ? _self.data : data // ignore: cast_nullable_to_non_nullable
as Data2?,
  ));
}

/// Create a copy of PostApiBookingsResponse
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$Data2CopyWith<$Res>? get data {
    if (_self.data == null) {
    return null;
  }

  return $Data2CopyWith<$Res>(_self.data!, (value) {
    return _then(_self.copyWith(data: value));
  });
}
}

// dart format on
