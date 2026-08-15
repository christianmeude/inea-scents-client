// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'register_request_body.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

RegisterRequestBody _$RegisterRequestBodyFromJson(Map<String, dynamic> json) {
  return _RegisterRequestBody.fromJson(json);
}

/// @nodoc
mixin _$RegisterRequestBody {
  String get name => throw _privateConstructorUsedError;
  String get email => throw _privateConstructorUsedError;
  String get password => throw _privateConstructorUsedError;

  /// Serializes this RegisterRequestBody to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of RegisterRequestBody
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $RegisterRequestBodyCopyWith<RegisterRequestBody> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $RegisterRequestBodyCopyWith<$Res> {
  factory $RegisterRequestBodyCopyWith(
    RegisterRequestBody value,
    $Res Function(RegisterRequestBody) then,
  ) = _$RegisterRequestBodyCopyWithImpl<$Res, RegisterRequestBody>;
  @useResult
  $Res call({String name, String email, String password});
}

/// @nodoc
class _$RegisterRequestBodyCopyWithImpl<$Res, $Val extends RegisterRequestBody>
    implements $RegisterRequestBodyCopyWith<$Res> {
  _$RegisterRequestBodyCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of RegisterRequestBody
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? name = null,
    Object? email = null,
    Object? password = null,
  }) {
    return _then(
      _value.copyWith(
            name: null == name
                ? _value.name
                : name // ignore: cast_nullable_to_non_nullable
                      as String,
            email: null == email
                ? _value.email
                : email // ignore: cast_nullable_to_non_nullable
                      as String,
            password: null == password
                ? _value.password
                : password // ignore: cast_nullable_to_non_nullable
                      as String,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$RegisterRequestBodyImplCopyWith<$Res>
    implements $RegisterRequestBodyCopyWith<$Res> {
  factory _$$RegisterRequestBodyImplCopyWith(
    _$RegisterRequestBodyImpl value,
    $Res Function(_$RegisterRequestBodyImpl) then,
  ) = __$$RegisterRequestBodyImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({String name, String email, String password});
}

/// @nodoc
class __$$RegisterRequestBodyImplCopyWithImpl<$Res>
    extends _$RegisterRequestBodyCopyWithImpl<$Res, _$RegisterRequestBodyImpl>
    implements _$$RegisterRequestBodyImplCopyWith<$Res> {
  __$$RegisterRequestBodyImplCopyWithImpl(
    _$RegisterRequestBodyImpl _value,
    $Res Function(_$RegisterRequestBodyImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of RegisterRequestBody
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? name = null,
    Object? email = null,
    Object? password = null,
  }) {
    return _then(
      _$RegisterRequestBodyImpl(
        name: null == name
            ? _value.name
            : name // ignore: cast_nullable_to_non_nullable
                  as String,
        email: null == email
            ? _value.email
            : email // ignore: cast_nullable_to_non_nullable
                  as String,
        password: null == password
            ? _value.password
            : password // ignore: cast_nullable_to_non_nullable
                  as String,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$RegisterRequestBodyImpl implements _RegisterRequestBody {
  const _$RegisterRequestBodyImpl({
    required this.name,
    required this.email,
    required this.password,
  });

  factory _$RegisterRequestBodyImpl.fromJson(Map<String, dynamic> json) =>
      _$$RegisterRequestBodyImplFromJson(json);

  @override
  final String name;
  @override
  final String email;
  @override
  final String password;

  @override
  String toString() {
    return 'RegisterRequestBody(name: $name, email: $email, password: $password)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$RegisterRequestBodyImpl &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.email, email) || other.email == email) &&
            (identical(other.password, password) ||
                other.password == password));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, name, email, password);

  /// Create a copy of RegisterRequestBody
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$RegisterRequestBodyImplCopyWith<_$RegisterRequestBodyImpl> get copyWith =>
      __$$RegisterRequestBodyImplCopyWithImpl<_$RegisterRequestBodyImpl>(
        this,
        _$identity,
      );

  @override
  Map<String, dynamic> toJson() {
    return _$$RegisterRequestBodyImplToJson(this);
  }
}

abstract class _RegisterRequestBody implements RegisterRequestBody {
  const factory _RegisterRequestBody({
    required final String name,
    required final String email,
    required final String password,
  }) = _$RegisterRequestBodyImpl;

  factory _RegisterRequestBody.fromJson(Map<String, dynamic> json) =
      _$RegisterRequestBodyImpl.fromJson;

  @override
  String get name;
  @override
  String get email;
  @override
  String get password;

  /// Create a copy of RegisterRequestBody
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$RegisterRequestBodyImplCopyWith<_$RegisterRequestBodyImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
