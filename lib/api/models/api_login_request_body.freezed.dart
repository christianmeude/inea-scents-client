// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'api_login_request_body.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

ApiLoginRequestBody _$ApiLoginRequestBodyFromJson(Map<String, dynamic> json) {
  return _ApiLoginRequestBody.fromJson(json);
}

/// @nodoc
mixin _$ApiLoginRequestBody {
  String get email => throw _privateConstructorUsedError;
  String get password => throw _privateConstructorUsedError;

  /// Serializes this ApiLoginRequestBody to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of ApiLoginRequestBody
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $ApiLoginRequestBodyCopyWith<ApiLoginRequestBody> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ApiLoginRequestBodyCopyWith<$Res> {
  factory $ApiLoginRequestBodyCopyWith(
    ApiLoginRequestBody value,
    $Res Function(ApiLoginRequestBody) then,
  ) = _$ApiLoginRequestBodyCopyWithImpl<$Res, ApiLoginRequestBody>;
  @useResult
  $Res call({String email, String password});
}

/// @nodoc
class _$ApiLoginRequestBodyCopyWithImpl<$Res, $Val extends ApiLoginRequestBody>
    implements $ApiLoginRequestBodyCopyWith<$Res> {
  _$ApiLoginRequestBodyCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of ApiLoginRequestBody
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? email = null, Object? password = null}) {
    return _then(
      _value.copyWith(
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
abstract class _$$ApiLoginRequestBodyImplCopyWith<$Res>
    implements $ApiLoginRequestBodyCopyWith<$Res> {
  factory _$$ApiLoginRequestBodyImplCopyWith(
    _$ApiLoginRequestBodyImpl value,
    $Res Function(_$ApiLoginRequestBodyImpl) then,
  ) = __$$ApiLoginRequestBodyImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({String email, String password});
}

/// @nodoc
class __$$ApiLoginRequestBodyImplCopyWithImpl<$Res>
    extends _$ApiLoginRequestBodyCopyWithImpl<$Res, _$ApiLoginRequestBodyImpl>
    implements _$$ApiLoginRequestBodyImplCopyWith<$Res> {
  __$$ApiLoginRequestBodyImplCopyWithImpl(
    _$ApiLoginRequestBodyImpl _value,
    $Res Function(_$ApiLoginRequestBodyImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of ApiLoginRequestBody
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? email = null, Object? password = null}) {
    return _then(
      _$ApiLoginRequestBodyImpl(
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
class _$ApiLoginRequestBodyImpl implements _ApiLoginRequestBody {
  const _$ApiLoginRequestBodyImpl({
    required this.email,
    required this.password,
  });

  factory _$ApiLoginRequestBodyImpl.fromJson(Map<String, dynamic> json) =>
      _$$ApiLoginRequestBodyImplFromJson(json);

  @override
  final String email;
  @override
  final String password;

  @override
  String toString() {
    return 'ApiLoginRequestBody(email: $email, password: $password)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ApiLoginRequestBodyImpl &&
            (identical(other.email, email) || other.email == email) &&
            (identical(other.password, password) ||
                other.password == password));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, email, password);

  /// Create a copy of ApiLoginRequestBody
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$ApiLoginRequestBodyImplCopyWith<_$ApiLoginRequestBodyImpl> get copyWith =>
      __$$ApiLoginRequestBodyImplCopyWithImpl<_$ApiLoginRequestBodyImpl>(
        this,
        _$identity,
      );

  @override
  Map<String, dynamic> toJson() {
    return _$$ApiLoginRequestBodyImplToJson(this);
  }
}

abstract class _ApiLoginRequestBody implements ApiLoginRequestBody {
  const factory _ApiLoginRequestBody({
    required final String email,
    required final String password,
  }) = _$ApiLoginRequestBodyImpl;

  factory _ApiLoginRequestBody.fromJson(Map<String, dynamic> json) =
      _$ApiLoginRequestBodyImpl.fromJson;

  @override
  String get email;
  @override
  String get password;

  /// Create a copy of ApiLoginRequestBody
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$ApiLoginRequestBodyImplCopyWith<_$ApiLoginRequestBodyImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
