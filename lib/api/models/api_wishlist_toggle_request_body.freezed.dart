// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'api_wishlist_toggle_request_body.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$ApiWishlistToggleRequestBody {

@JsonKey(name: 'package_id') int get packageId;
/// Create a copy of ApiWishlistToggleRequestBody
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ApiWishlistToggleRequestBodyCopyWith<ApiWishlistToggleRequestBody> get copyWith => _$ApiWishlistToggleRequestBodyCopyWithImpl<ApiWishlistToggleRequestBody>(this as ApiWishlistToggleRequestBody, _$identity);

  /// Serializes this ApiWishlistToggleRequestBody to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ApiWishlistToggleRequestBody&&(identical(other.packageId, packageId) || other.packageId == packageId));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,packageId);

@override
String toString() {
  return 'ApiWishlistToggleRequestBody(packageId: $packageId)';
}


}

/// @nodoc
abstract mixin class $ApiWishlistToggleRequestBodyCopyWith<$Res>  {
  factory $ApiWishlistToggleRequestBodyCopyWith(ApiWishlistToggleRequestBody value, $Res Function(ApiWishlistToggleRequestBody) _then) = _$ApiWishlistToggleRequestBodyCopyWithImpl;
@useResult
$Res call({
@JsonKey(name: 'package_id') int packageId
});




}
/// @nodoc
class _$ApiWishlistToggleRequestBodyCopyWithImpl<$Res>
    implements $ApiWishlistToggleRequestBodyCopyWith<$Res> {
  _$ApiWishlistToggleRequestBodyCopyWithImpl(this._self, this._then);

  final ApiWishlistToggleRequestBody _self;
  final $Res Function(ApiWishlistToggleRequestBody) _then;

/// Create a copy of ApiWishlistToggleRequestBody
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? packageId = null,}) {
  return _then(_self.copyWith(
packageId: null == packageId ? _self.packageId : packageId // ignore: cast_nullable_to_non_nullable
as int,
  ));
}

}


/// Adds pattern-matching-related methods to [ApiWishlistToggleRequestBody].
extension ApiWishlistToggleRequestBodyPatterns on ApiWishlistToggleRequestBody {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ApiWishlistToggleRequestBody value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ApiWishlistToggleRequestBody() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ApiWishlistToggleRequestBody value)  $default,){
final _that = this;
switch (_that) {
case _ApiWishlistToggleRequestBody():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ApiWishlistToggleRequestBody value)?  $default,){
final _that = this;
switch (_that) {
case _ApiWishlistToggleRequestBody() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function(@JsonKey(name: 'package_id')  int packageId)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ApiWishlistToggleRequestBody() when $default != null:
return $default(_that.packageId);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function(@JsonKey(name: 'package_id')  int packageId)  $default,) {final _that = this;
switch (_that) {
case _ApiWishlistToggleRequestBody():
return $default(_that.packageId);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function(@JsonKey(name: 'package_id')  int packageId)?  $default,) {final _that = this;
switch (_that) {
case _ApiWishlistToggleRequestBody() when $default != null:
return $default(_that.packageId);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _ApiWishlistToggleRequestBody implements ApiWishlistToggleRequestBody {
  const _ApiWishlistToggleRequestBody({@JsonKey(name: 'package_id') required this.packageId});
  factory _ApiWishlistToggleRequestBody.fromJson(Map<String, dynamic> json) => _$ApiWishlistToggleRequestBodyFromJson(json);

@override@JsonKey(name: 'package_id') final  int packageId;

/// Create a copy of ApiWishlistToggleRequestBody
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ApiWishlistToggleRequestBodyCopyWith<_ApiWishlistToggleRequestBody> get copyWith => __$ApiWishlistToggleRequestBodyCopyWithImpl<_ApiWishlistToggleRequestBody>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$ApiWishlistToggleRequestBodyToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _ApiWishlistToggleRequestBody&&(identical(other.packageId, packageId) || other.packageId == packageId));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,packageId);

@override
String toString() {
  return 'ApiWishlistToggleRequestBody(packageId: $packageId)';
}


}

/// @nodoc
abstract mixin class _$ApiWishlistToggleRequestBodyCopyWith<$Res> implements $ApiWishlistToggleRequestBodyCopyWith<$Res> {
  factory _$ApiWishlistToggleRequestBodyCopyWith(_ApiWishlistToggleRequestBody value, $Res Function(_ApiWishlistToggleRequestBody) _then) = __$ApiWishlistToggleRequestBodyCopyWithImpl;
@override @useResult
$Res call({
@JsonKey(name: 'package_id') int packageId
});




}
/// @nodoc
class __$ApiWishlistToggleRequestBodyCopyWithImpl<$Res>
    implements _$ApiWishlistToggleRequestBodyCopyWith<$Res> {
  __$ApiWishlistToggleRequestBodyCopyWithImpl(this._self, this._then);

  final _ApiWishlistToggleRequestBody _self;
  final $Res Function(_ApiWishlistToggleRequestBody) _then;

/// Create a copy of ApiWishlistToggleRequestBody
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? packageId = null,}) {
  return _then(_ApiWishlistToggleRequestBody(
packageId: null == packageId ? _self.packageId : packageId // ignore: cast_nullable_to_non_nullable
as int,
  ));
}


}

// dart format on
