// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'api_login_request_body.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$ApiLoginRequestBody {

 String get email; String get password;
/// Create a copy of ApiLoginRequestBody
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ApiLoginRequestBodyCopyWith<ApiLoginRequestBody> get copyWith => _$ApiLoginRequestBodyCopyWithImpl<ApiLoginRequestBody>(this as ApiLoginRequestBody, _$identity);

  /// Serializes this ApiLoginRequestBody to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ApiLoginRequestBody&&(identical(other.email, email) || other.email == email)&&(identical(other.password, password) || other.password == password));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,email,password);

@override
String toString() {
  return 'ApiLoginRequestBody(email: $email, password: $password)';
}


}

/// @nodoc
abstract mixin class $ApiLoginRequestBodyCopyWith<$Res>  {
  factory $ApiLoginRequestBodyCopyWith(ApiLoginRequestBody value, $Res Function(ApiLoginRequestBody) _then) = _$ApiLoginRequestBodyCopyWithImpl;
@useResult
$Res call({
 String email, String password
});




}
/// @nodoc
class _$ApiLoginRequestBodyCopyWithImpl<$Res>
    implements $ApiLoginRequestBodyCopyWith<$Res> {
  _$ApiLoginRequestBodyCopyWithImpl(this._self, this._then);

  final ApiLoginRequestBody _self;
  final $Res Function(ApiLoginRequestBody) _then;

/// Create a copy of ApiLoginRequestBody
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? email = null,Object? password = null,}) {
  return _then(ApiLoginRequestBody(
email: null == email ? _self.email : email // ignore: cast_nullable_to_non_nullable
as String,password: null == password ? _self.password : password // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

}


/// Adds pattern-matching-related methods to [ApiLoginRequestBody].
extension ApiLoginRequestBodyPatterns on ApiLoginRequestBody {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ApiLoginRequestBody value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ApiLoginRequestBody() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ApiLoginRequestBody value)  $default,){
final _that = this;
switch (_that) {
case _ApiLoginRequestBody():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ApiLoginRequestBody value)?  $default,){
final _that = this;
switch (_that) {
case _ApiLoginRequestBody() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String email,  String password)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ApiLoginRequestBody() when $default != null:
return $default(_that.email,_that.password);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String email,  String password)  $default,) {final _that = this;
switch (_that) {
case _ApiLoginRequestBody():
return $default(_that.email,_that.password);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String email,  String password)?  $default,) {final _that = this;
switch (_that) {
case _ApiLoginRequestBody() when $default != null:
return $default(_that.email,_that.password);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _ApiLoginRequestBody implements ApiLoginRequestBody {
  const _ApiLoginRequestBody({required this.email, required this.password});
  factory _ApiLoginRequestBody.fromJson(Map<String, dynamic> json) => _$ApiLoginRequestBodyFromJson(json);

@override final  String email;
@override final  String password;

/// Create a copy of ApiLoginRequestBody
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ApiLoginRequestBodyCopyWith<_ApiLoginRequestBody> get copyWith => __$ApiLoginRequestBodyCopyWithImpl<_ApiLoginRequestBody>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$ApiLoginRequestBodyToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _ApiLoginRequestBody&&(identical(other.email, email) || other.email == email)&&(identical(other.password, password) || other.password == password));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,email,password);

@override
String toString() {
  return 'ApiLoginRequestBody(email: $email, password: $password)';
}


}

/// @nodoc
abstract mixin class _$ApiLoginRequestBodyCopyWith<$Res> implements $ApiLoginRequestBodyCopyWith<$Res> {
  factory _$ApiLoginRequestBodyCopyWith(_ApiLoginRequestBody value, $Res Function(_ApiLoginRequestBody) _then) = __$ApiLoginRequestBodyCopyWithImpl;
@override @useResult
$Res call({
 String email, String password
});




}
/// @nodoc
class __$ApiLoginRequestBodyCopyWithImpl<$Res>
    implements _$ApiLoginRequestBodyCopyWith<$Res> {
  __$ApiLoginRequestBodyCopyWithImpl(this._self, this._then);

  final _ApiLoginRequestBody _self;
  final $Res Function(_ApiLoginRequestBody) _then;

/// Create a copy of ApiLoginRequestBody
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? email = null,Object? password = null,}) {
  return _then(_ApiLoginRequestBody(
email: null == email ? _self.email : email // ignore: cast_nullable_to_non_nullable
as String,password: null == password ? _self.password : password // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

// dart format on
