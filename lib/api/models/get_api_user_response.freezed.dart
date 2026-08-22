// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'get_api_user_response.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$GetApiUserResponse {

 int? get id; String? get name; String? get email;@JsonKey(name: 'is_admin') bool? get isAdmin;
/// Create a copy of GetApiUserResponse
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$GetApiUserResponseCopyWith<GetApiUserResponse> get copyWith => _$GetApiUserResponseCopyWithImpl<GetApiUserResponse>(this as GetApiUserResponse, _$identity);

  /// Serializes this GetApiUserResponse to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is GetApiUserResponse&&(identical(other.id, id) || other.id == id)&&(identical(other.name, name) || other.name == name)&&(identical(other.email, email) || other.email == email)&&(identical(other.isAdmin, isAdmin) || other.isAdmin == isAdmin));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,name,email,isAdmin);

@override
String toString() {
  return 'GetApiUserResponse(id: $id, name: $name, email: $email, isAdmin: $isAdmin)';
}


}

/// @nodoc
abstract mixin class $GetApiUserResponseCopyWith<$Res>  {
  factory $GetApiUserResponseCopyWith(GetApiUserResponse value, $Res Function(GetApiUserResponse) _then) = _$GetApiUserResponseCopyWithImpl;
@useResult
$Res call({
 int? id, String? name, String? email,@JsonKey(name: 'is_admin') bool? isAdmin
});




}
/// @nodoc
class _$GetApiUserResponseCopyWithImpl<$Res>
    implements $GetApiUserResponseCopyWith<$Res> {
  _$GetApiUserResponseCopyWithImpl(this._self, this._then);

  final GetApiUserResponse _self;
  final $Res Function(GetApiUserResponse) _then;

/// Create a copy of GetApiUserResponse
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = freezed,Object? name = freezed,Object? email = freezed,Object? isAdmin = freezed,}) {
  return _then(GetApiUserResponse(
id: freezed == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int?,name: freezed == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String?,email: freezed == email ? _self.email : email // ignore: cast_nullable_to_non_nullable
as String?,isAdmin: freezed == isAdmin ? _self.isAdmin : isAdmin // ignore: cast_nullable_to_non_nullable
as bool?,
  ));
}

}


/// Adds pattern-matching-related methods to [GetApiUserResponse].
extension GetApiUserResponsePatterns on GetApiUserResponse {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _GetApiUserResponse value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _GetApiUserResponse() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _GetApiUserResponse value)  $default,){
final _that = this;
switch (_that) {
case _GetApiUserResponse():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _GetApiUserResponse value)?  $default,){
final _that = this;
switch (_that) {
case _GetApiUserResponse() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int? id,  String? name,  String? email, @JsonKey(name: 'is_admin')  bool? isAdmin)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _GetApiUserResponse() when $default != null:
return $default(_that.id,_that.name,_that.email,_that.isAdmin);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int? id,  String? name,  String? email, @JsonKey(name: 'is_admin')  bool? isAdmin)  $default,) {final _that = this;
switch (_that) {
case _GetApiUserResponse():
return $default(_that.id,_that.name,_that.email,_that.isAdmin);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int? id,  String? name,  String? email, @JsonKey(name: 'is_admin')  bool? isAdmin)?  $default,) {final _that = this;
switch (_that) {
case _GetApiUserResponse() when $default != null:
return $default(_that.id,_that.name,_that.email,_that.isAdmin);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _GetApiUserResponse implements GetApiUserResponse {
  const _GetApiUserResponse({this.id, this.name, this.email, @JsonKey(name: 'is_admin') this.isAdmin});
  factory _GetApiUserResponse.fromJson(Map<String, dynamic> json) => _$GetApiUserResponseFromJson(json);

@override final  int? id;
@override final  String? name;
@override final  String? email;
@override@JsonKey(name: 'is_admin') final  bool? isAdmin;

/// Create a copy of GetApiUserResponse
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$GetApiUserResponseCopyWith<_GetApiUserResponse> get copyWith => __$GetApiUserResponseCopyWithImpl<_GetApiUserResponse>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$GetApiUserResponseToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _GetApiUserResponse&&(identical(other.id, id) || other.id == id)&&(identical(other.name, name) || other.name == name)&&(identical(other.email, email) || other.email == email)&&(identical(other.isAdmin, isAdmin) || other.isAdmin == isAdmin));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,name,email,isAdmin);

@override
String toString() {
  return 'GetApiUserResponse(id: $id, name: $name, email: $email, isAdmin: $isAdmin)';
}


}

/// @nodoc
abstract mixin class _$GetApiUserResponseCopyWith<$Res> implements $GetApiUserResponseCopyWith<$Res> {
  factory _$GetApiUserResponseCopyWith(_GetApiUserResponse value, $Res Function(_GetApiUserResponse) _then) = __$GetApiUserResponseCopyWithImpl;
@override @useResult
$Res call({
 int? id, String? name, String? email,@JsonKey(name: 'is_admin') bool? isAdmin
});




}
/// @nodoc
class __$GetApiUserResponseCopyWithImpl<$Res>
    implements _$GetApiUserResponseCopyWith<$Res> {
  __$GetApiUserResponseCopyWithImpl(this._self, this._then);

  final _GetApiUserResponse _self;
  final $Res Function(_GetApiUserResponse) _then;

/// Create a copy of GetApiUserResponse
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = freezed,Object? name = freezed,Object? email = freezed,Object? isAdmin = freezed,}) {
  return _then(_GetApiUserResponse(
id: freezed == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int?,name: freezed == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String?,email: freezed == email ? _self.email : email // ignore: cast_nullable_to_non_nullable
as String?,isAdmin: freezed == isAdmin ? _self.isAdmin : isAdmin // ignore: cast_nullable_to_non_nullable
as bool?,
  ));
}


}

// dart format on
