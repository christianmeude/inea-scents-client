// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'get_api_packages_package_response.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$GetApiPackagesPackageResponse {

 Package? get data;
/// Create a copy of GetApiPackagesPackageResponse
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$GetApiPackagesPackageResponseCopyWith<GetApiPackagesPackageResponse> get copyWith => _$GetApiPackagesPackageResponseCopyWithImpl<GetApiPackagesPackageResponse>(this as GetApiPackagesPackageResponse, _$identity);

  /// Serializes this GetApiPackagesPackageResponse to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is GetApiPackagesPackageResponse&&(identical(other.data, data) || other.data == data));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,data);

@override
String toString() {
  return 'GetApiPackagesPackageResponse(data: $data)';
}


}

/// @nodoc
abstract mixin class $GetApiPackagesPackageResponseCopyWith<$Res>  {
  factory $GetApiPackagesPackageResponseCopyWith(GetApiPackagesPackageResponse value, $Res Function(GetApiPackagesPackageResponse) _then) = _$GetApiPackagesPackageResponseCopyWithImpl;
@useResult
$Res call({
 Package? data
});


$PackageCopyWith<$Res>? get data;

}
/// @nodoc
class _$GetApiPackagesPackageResponseCopyWithImpl<$Res>
    implements $GetApiPackagesPackageResponseCopyWith<$Res> {
  _$GetApiPackagesPackageResponseCopyWithImpl(this._self, this._then);

  final GetApiPackagesPackageResponse _self;
  final $Res Function(GetApiPackagesPackageResponse) _then;

/// Create a copy of GetApiPackagesPackageResponse
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? data = freezed,}) {
  return _then(_self.copyWith(
data: freezed == data ? _self.data : data // ignore: cast_nullable_to_non_nullable
as Package?,
  ));
}
/// Create a copy of GetApiPackagesPackageResponse
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$PackageCopyWith<$Res>? get data {
    if (_self.data == null) {
    return null;
  }

  return $PackageCopyWith<$Res>(_self.data!, (value) {
    return _then(_self.copyWith(data: value));
  });
}
}


/// Adds pattern-matching-related methods to [GetApiPackagesPackageResponse].
extension GetApiPackagesPackageResponsePatterns on GetApiPackagesPackageResponse {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _GetApiPackagesPackageResponse value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _GetApiPackagesPackageResponse() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _GetApiPackagesPackageResponse value)  $default,){
final _that = this;
switch (_that) {
case _GetApiPackagesPackageResponse():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _GetApiPackagesPackageResponse value)?  $default,){
final _that = this;
switch (_that) {
case _GetApiPackagesPackageResponse() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( Package? data)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _GetApiPackagesPackageResponse() when $default != null:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( Package? data)  $default,) {final _that = this;
switch (_that) {
case _GetApiPackagesPackageResponse():
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( Package? data)?  $default,) {final _that = this;
switch (_that) {
case _GetApiPackagesPackageResponse() when $default != null:
return $default(_that.data);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _GetApiPackagesPackageResponse implements GetApiPackagesPackageResponse {
  const _GetApiPackagesPackageResponse({this.data});
  factory _GetApiPackagesPackageResponse.fromJson(Map<String, dynamic> json) => _$GetApiPackagesPackageResponseFromJson(json);

@override final  Package? data;

/// Create a copy of GetApiPackagesPackageResponse
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$GetApiPackagesPackageResponseCopyWith<_GetApiPackagesPackageResponse> get copyWith => __$GetApiPackagesPackageResponseCopyWithImpl<_GetApiPackagesPackageResponse>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$GetApiPackagesPackageResponseToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _GetApiPackagesPackageResponse&&(identical(other.data, data) || other.data == data));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,data);

@override
String toString() {
  return 'GetApiPackagesPackageResponse(data: $data)';
}


}

/// @nodoc
abstract mixin class _$GetApiPackagesPackageResponseCopyWith<$Res> implements $GetApiPackagesPackageResponseCopyWith<$Res> {
  factory _$GetApiPackagesPackageResponseCopyWith(_GetApiPackagesPackageResponse value, $Res Function(_GetApiPackagesPackageResponse) _then) = __$GetApiPackagesPackageResponseCopyWithImpl;
@override @useResult
$Res call({
 Package? data
});


@override $PackageCopyWith<$Res>? get data;

}
/// @nodoc
class __$GetApiPackagesPackageResponseCopyWithImpl<$Res>
    implements _$GetApiPackagesPackageResponseCopyWith<$Res> {
  __$GetApiPackagesPackageResponseCopyWithImpl(this._self, this._then);

  final _GetApiPackagesPackageResponse _self;
  final $Res Function(_GetApiPackagesPackageResponse) _then;

/// Create a copy of GetApiPackagesPackageResponse
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? data = freezed,}) {
  return _then(_GetApiPackagesPackageResponse(
data: freezed == data ? _self.data : data // ignore: cast_nullable_to_non_nullable
as Package?,
  ));
}

/// Create a copy of GetApiPackagesPackageResponse
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$PackageCopyWith<$Res>? get data {
    if (_self.data == null) {
    return null;
  }

  return $PackageCopyWith<$Res>(_self.data!, (value) {
    return _then(_self.copyWith(data: value));
  });
}
}

// dart format on
