// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'get_api_wishlist_response.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$GetApiWishlistResponse {

 List<Package>? get data;
/// Create a copy of GetApiWishlistResponse
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$GetApiWishlistResponseCopyWith<GetApiWishlistResponse> get copyWith => _$GetApiWishlistResponseCopyWithImpl<GetApiWishlistResponse>(this as GetApiWishlistResponse, _$identity);

  /// Serializes this GetApiWishlistResponse to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is GetApiWishlistResponse&&const DeepCollectionEquality().equals(other.data, data));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(data));

@override
String toString() {
  return 'GetApiWishlistResponse(data: $data)';
}


}

/// @nodoc
abstract mixin class $GetApiWishlistResponseCopyWith<$Res>  {
  factory $GetApiWishlistResponseCopyWith(GetApiWishlistResponse value, $Res Function(GetApiWishlistResponse) _then) = _$GetApiWishlistResponseCopyWithImpl;
@useResult
$Res call({
 List<Package>? data
});




}
/// @nodoc
class _$GetApiWishlistResponseCopyWithImpl<$Res>
    implements $GetApiWishlistResponseCopyWith<$Res> {
  _$GetApiWishlistResponseCopyWithImpl(this._self, this._then);

  final GetApiWishlistResponse _self;
  final $Res Function(GetApiWishlistResponse) _then;

/// Create a copy of GetApiWishlistResponse
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? data = freezed,}) {
  return _then(_self.copyWith(
data: freezed == data ? _self.data : data // ignore: cast_nullable_to_non_nullable
as List<Package>?,
  ));
}

}


/// Adds pattern-matching-related methods to [GetApiWishlistResponse].
extension GetApiWishlistResponsePatterns on GetApiWishlistResponse {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _GetApiWishlistResponse value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _GetApiWishlistResponse() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _GetApiWishlistResponse value)  $default,){
final _that = this;
switch (_that) {
case _GetApiWishlistResponse():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _GetApiWishlistResponse value)?  $default,){
final _that = this;
switch (_that) {
case _GetApiWishlistResponse() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( List<Package>? data)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _GetApiWishlistResponse() when $default != null:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( List<Package>? data)  $default,) {final _that = this;
switch (_that) {
case _GetApiWishlistResponse():
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( List<Package>? data)?  $default,) {final _that = this;
switch (_that) {
case _GetApiWishlistResponse() when $default != null:
return $default(_that.data);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _GetApiWishlistResponse implements GetApiWishlistResponse {
  const _GetApiWishlistResponse({final  List<Package>? data}): _data = data;
  factory _GetApiWishlistResponse.fromJson(Map<String, dynamic> json) => _$GetApiWishlistResponseFromJson(json);

 final  List<Package>? _data;
@override List<Package>? get data {
  final value = _data;
  if (value == null) return null;
  if (_data is EqualUnmodifiableListView) return _data;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(value);
}


/// Create a copy of GetApiWishlistResponse
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$GetApiWishlistResponseCopyWith<_GetApiWishlistResponse> get copyWith => __$GetApiWishlistResponseCopyWithImpl<_GetApiWishlistResponse>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$GetApiWishlistResponseToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _GetApiWishlistResponse&&const DeepCollectionEquality().equals(other._data, _data));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(_data));

@override
String toString() {
  return 'GetApiWishlistResponse(data: $data)';
}


}

/// @nodoc
abstract mixin class _$GetApiWishlistResponseCopyWith<$Res> implements $GetApiWishlistResponseCopyWith<$Res> {
  factory _$GetApiWishlistResponseCopyWith(_GetApiWishlistResponse value, $Res Function(_GetApiWishlistResponse) _then) = __$GetApiWishlistResponseCopyWithImpl;
@override @useResult
$Res call({
 List<Package>? data
});




}
/// @nodoc
class __$GetApiWishlistResponseCopyWithImpl<$Res>
    implements _$GetApiWishlistResponseCopyWith<$Res> {
  __$GetApiWishlistResponseCopyWithImpl(this._self, this._then);

  final _GetApiWishlistResponse _self;
  final $Res Function(_GetApiWishlistResponse) _then;

/// Create a copy of GetApiWishlistResponse
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? data = freezed,}) {
  return _then(_GetApiWishlistResponse(
data: freezed == data ? _self._data : data // ignore: cast_nullable_to_non_nullable
as List<Package>?,
  ));
}


}

// dart format on
