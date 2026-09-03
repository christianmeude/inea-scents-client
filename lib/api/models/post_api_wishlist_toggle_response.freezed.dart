// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'post_api_wishlist_toggle_response.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$PostApiWishlistToggleResponse {

 bool? get attached; String? get message;
/// Create a copy of PostApiWishlistToggleResponse
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$PostApiWishlistToggleResponseCopyWith<PostApiWishlistToggleResponse> get copyWith => _$PostApiWishlistToggleResponseCopyWithImpl<PostApiWishlistToggleResponse>(this as PostApiWishlistToggleResponse, _$identity);

  /// Serializes this PostApiWishlistToggleResponse to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is PostApiWishlistToggleResponse&&(identical(other.attached, attached) || other.attached == attached)&&(identical(other.message, message) || other.message == message));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,attached,message);

@override
String toString() {
  return 'PostApiWishlistToggleResponse(attached: $attached, message: $message)';
}


}

/// @nodoc
abstract mixin class $PostApiWishlistToggleResponseCopyWith<$Res>  {
  factory $PostApiWishlistToggleResponseCopyWith(PostApiWishlistToggleResponse value, $Res Function(PostApiWishlistToggleResponse) _then) = _$PostApiWishlistToggleResponseCopyWithImpl;
@useResult
$Res call({
 bool? attached, String? message
});




}
/// @nodoc
class _$PostApiWishlistToggleResponseCopyWithImpl<$Res>
    implements $PostApiWishlistToggleResponseCopyWith<$Res> {
  _$PostApiWishlistToggleResponseCopyWithImpl(this._self, this._then);

  final PostApiWishlistToggleResponse _self;
  final $Res Function(PostApiWishlistToggleResponse) _then;

/// Create a copy of PostApiWishlistToggleResponse
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? attached = freezed,Object? message = freezed,}) {
  return _then(_self.copyWith(
attached: freezed == attached ? _self.attached : attached // ignore: cast_nullable_to_non_nullable
as bool?,message: freezed == message ? _self.message : message // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [PostApiWishlistToggleResponse].
extension PostApiWishlistToggleResponsePatterns on PostApiWishlistToggleResponse {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _PostApiWishlistToggleResponse value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _PostApiWishlistToggleResponse() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _PostApiWishlistToggleResponse value)  $default,){
final _that = this;
switch (_that) {
case _PostApiWishlistToggleResponse():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _PostApiWishlistToggleResponse value)?  $default,){
final _that = this;
switch (_that) {
case _PostApiWishlistToggleResponse() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( bool? attached,  String? message)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _PostApiWishlistToggleResponse() when $default != null:
return $default(_that.attached,_that.message);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( bool? attached,  String? message)  $default,) {final _that = this;
switch (_that) {
case _PostApiWishlistToggleResponse():
return $default(_that.attached,_that.message);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( bool? attached,  String? message)?  $default,) {final _that = this;
switch (_that) {
case _PostApiWishlistToggleResponse() when $default != null:
return $default(_that.attached,_that.message);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _PostApiWishlistToggleResponse implements PostApiWishlistToggleResponse {
  const _PostApiWishlistToggleResponse({this.attached, this.message});
  factory _PostApiWishlistToggleResponse.fromJson(Map<String, dynamic> json) => _$PostApiWishlistToggleResponseFromJson(json);

@override final  bool? attached;
@override final  String? message;

/// Create a copy of PostApiWishlistToggleResponse
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$PostApiWishlistToggleResponseCopyWith<_PostApiWishlistToggleResponse> get copyWith => __$PostApiWishlistToggleResponseCopyWithImpl<_PostApiWishlistToggleResponse>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$PostApiWishlistToggleResponseToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _PostApiWishlistToggleResponse&&(identical(other.attached, attached) || other.attached == attached)&&(identical(other.message, message) || other.message == message));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,attached,message);

@override
String toString() {
  return 'PostApiWishlistToggleResponse(attached: $attached, message: $message)';
}


}

/// @nodoc
abstract mixin class _$PostApiWishlistToggleResponseCopyWith<$Res> implements $PostApiWishlistToggleResponseCopyWith<$Res> {
  factory _$PostApiWishlistToggleResponseCopyWith(_PostApiWishlistToggleResponse value, $Res Function(_PostApiWishlistToggleResponse) _then) = __$PostApiWishlistToggleResponseCopyWithImpl;
@override @useResult
$Res call({
 bool? attached, String? message
});




}
/// @nodoc
class __$PostApiWishlistToggleResponseCopyWithImpl<$Res>
    implements _$PostApiWishlistToggleResponseCopyWith<$Res> {
  __$PostApiWishlistToggleResponseCopyWithImpl(this._self, this._then);

  final _PostApiWishlistToggleResponse _self;
  final $Res Function(_PostApiWishlistToggleResponse) _then;

/// Create a copy of PostApiWishlistToggleResponse
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? attached = freezed,Object? message = freezed,}) {
  return _then(_PostApiWishlistToggleResponse(
attached: freezed == attached ? _self.attached : attached // ignore: cast_nullable_to_non_nullable
as bool?,message: freezed == message ? _self.message : message // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}

// dart format on
