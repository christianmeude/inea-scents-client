// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'get_api_packages_response.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$GetApiPackagesResponse {

 List<Package>? get data;
/// Create a copy of GetApiPackagesResponse
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$GetApiPackagesResponseCopyWith<GetApiPackagesResponse> get copyWith => _$GetApiPackagesResponseCopyWithImpl<GetApiPackagesResponse>(this as GetApiPackagesResponse, _$identity);

  /// Serializes this GetApiPackagesResponse to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is GetApiPackagesResponse&&const DeepCollectionEquality().equals(other.data, data));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(data));

@override
String toString() {
  return 'GetApiPackagesResponse(data: $data)';
}


}

/// @nodoc
abstract mixin class $GetApiPackagesResponseCopyWith<$Res>  {
  factory $GetApiPackagesResponseCopyWith(GetApiPackagesResponse value, $Res Function(GetApiPackagesResponse) _then) = _$GetApiPackagesResponseCopyWithImpl;
@useResult
$Res call({
 List<Package>? data
});




}
/// @nodoc
class _$GetApiPackagesResponseCopyWithImpl<$Res>
    implements $GetApiPackagesResponseCopyWith<$Res> {
  _$GetApiPackagesResponseCopyWithImpl(this._self, this._then);

  final GetApiPackagesResponse _self;
  final $Res Function(GetApiPackagesResponse) _then;

/// Create a copy of GetApiPackagesResponse
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? data = freezed,}) {
  return _then(GetApiPackagesResponse(
data: freezed == data ? _self.data : data // ignore: cast_nullable_to_non_nullable
as List<Package>?,
  ));
}

}


/// Adds pattern-matching-related methods to [GetApiPackagesResponse].
extension GetApiPackagesResponsePatterns on GetApiPackagesResponse {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _GetApiPackagesResponse value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _GetApiPackagesResponse() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _GetApiPackagesResponse value)  $default,){
final _that = this;
switch (_that) {
case _GetApiPackagesResponse():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _GetApiPackagesResponse value)?  $default,){
final _that = this;
switch (_that) {
case _GetApiPackagesResponse() when $default != null:
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
case _GetApiPackagesResponse() when $default != null:
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
case _GetApiPackagesResponse():
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
case _GetApiPackagesResponse() when $default != null:
return $default(_that.data);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _GetApiPackagesResponse implements GetApiPackagesResponse {
  const _GetApiPackagesResponse({ List<Package>? data}): _data = data;
  factory _GetApiPackagesResponse.fromJson(Map<String, dynamic> json) => _$GetApiPackagesResponseFromJson(json);

 final  List<Package>? _data;
@override List<Package>? get data {
  final value = _data;
  if (value == null) return null;
  if (_data is EqualUnmodifiableListView) return _data;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(value);
}


/// Create a copy of GetApiPackagesResponse
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$GetApiPackagesResponseCopyWith<_GetApiPackagesResponse> get copyWith => __$GetApiPackagesResponseCopyWithImpl<_GetApiPackagesResponse>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$GetApiPackagesResponseToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _GetApiPackagesResponse&&const DeepCollectionEquality().equals(other._data, _data));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(_data));

@override
String toString() {
  return 'GetApiPackagesResponse(data: $data)';
}


}

/// @nodoc
abstract mixin class _$GetApiPackagesResponseCopyWith<$Res> implements $GetApiPackagesResponseCopyWith<$Res> {
  factory _$GetApiPackagesResponseCopyWith(_GetApiPackagesResponse value, $Res Function(_GetApiPackagesResponse) _then) = __$GetApiPackagesResponseCopyWithImpl;
@override @useResult
$Res call({
 List<Package>? data
});




}
/// @nodoc
class __$GetApiPackagesResponseCopyWithImpl<$Res>
    implements _$GetApiPackagesResponseCopyWith<$Res> {
  __$GetApiPackagesResponseCopyWithImpl(this._self, this._then);

  final _GetApiPackagesResponse _self;
  final $Res Function(_GetApiPackagesResponse) _then;

/// Create a copy of GetApiPackagesResponse
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? data = freezed,}) {
  return _then(_GetApiPackagesResponse(
data: freezed == data ? _self._data : data // ignore: cast_nullable_to_non_nullable
as List<Package>?,
  ));
}


}

// dart format on
