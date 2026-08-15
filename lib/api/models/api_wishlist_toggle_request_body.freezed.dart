// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'api_wishlist_toggle_request_body.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

ApiWishlistToggleRequestBody _$ApiWishlistToggleRequestBodyFromJson(
  Map<String, dynamic> json,
) {
  return _ApiWishlistToggleRequestBody.fromJson(json);
}

/// @nodoc
mixin _$ApiWishlistToggleRequestBody {
  @JsonKey(name: 'package_id')
  int get packageId => throw _privateConstructorUsedError;

  /// Serializes this ApiWishlistToggleRequestBody to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of ApiWishlistToggleRequestBody
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $ApiWishlistToggleRequestBodyCopyWith<ApiWishlistToggleRequestBody>
  get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ApiWishlistToggleRequestBodyCopyWith<$Res> {
  factory $ApiWishlistToggleRequestBodyCopyWith(
    ApiWishlistToggleRequestBody value,
    $Res Function(ApiWishlistToggleRequestBody) then,
  ) =
      _$ApiWishlistToggleRequestBodyCopyWithImpl<
        $Res,
        ApiWishlistToggleRequestBody
      >;
  @useResult
  $Res call({@JsonKey(name: 'package_id') int packageId});
}

/// @nodoc
class _$ApiWishlistToggleRequestBodyCopyWithImpl<
  $Res,
  $Val extends ApiWishlistToggleRequestBody
>
    implements $ApiWishlistToggleRequestBodyCopyWith<$Res> {
  _$ApiWishlistToggleRequestBodyCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of ApiWishlistToggleRequestBody
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? packageId = null}) {
    return _then(
      _value.copyWith(
            packageId: null == packageId
                ? _value.packageId
                : packageId // ignore: cast_nullable_to_non_nullable
                      as int,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$ApiWishlistToggleRequestBodyImplCopyWith<$Res>
    implements $ApiWishlistToggleRequestBodyCopyWith<$Res> {
  factory _$$ApiWishlistToggleRequestBodyImplCopyWith(
    _$ApiWishlistToggleRequestBodyImpl value,
    $Res Function(_$ApiWishlistToggleRequestBodyImpl) then,
  ) = __$$ApiWishlistToggleRequestBodyImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({@JsonKey(name: 'package_id') int packageId});
}

/// @nodoc
class __$$ApiWishlistToggleRequestBodyImplCopyWithImpl<$Res>
    extends
        _$ApiWishlistToggleRequestBodyCopyWithImpl<
          $Res,
          _$ApiWishlistToggleRequestBodyImpl
        >
    implements _$$ApiWishlistToggleRequestBodyImplCopyWith<$Res> {
  __$$ApiWishlistToggleRequestBodyImplCopyWithImpl(
    _$ApiWishlistToggleRequestBodyImpl _value,
    $Res Function(_$ApiWishlistToggleRequestBodyImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of ApiWishlistToggleRequestBody
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? packageId = null}) {
    return _then(
      _$ApiWishlistToggleRequestBodyImpl(
        packageId: null == packageId
            ? _value.packageId
            : packageId // ignore: cast_nullable_to_non_nullable
                  as int,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$ApiWishlistToggleRequestBodyImpl
    implements _ApiWishlistToggleRequestBody {
  const _$ApiWishlistToggleRequestBodyImpl({
    @JsonKey(name: 'package_id') required this.packageId,
  });

  factory _$ApiWishlistToggleRequestBodyImpl.fromJson(
    Map<String, dynamic> json,
  ) => _$$ApiWishlistToggleRequestBodyImplFromJson(json);

  @override
  @JsonKey(name: 'package_id')
  final int packageId;

  @override
  String toString() {
    return 'ApiWishlistToggleRequestBody(packageId: $packageId)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ApiWishlistToggleRequestBodyImpl &&
            (identical(other.packageId, packageId) ||
                other.packageId == packageId));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, packageId);

  /// Create a copy of ApiWishlistToggleRequestBody
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$ApiWishlistToggleRequestBodyImplCopyWith<
    _$ApiWishlistToggleRequestBodyImpl
  >
  get copyWith =>
      __$$ApiWishlistToggleRequestBodyImplCopyWithImpl<
        _$ApiWishlistToggleRequestBodyImpl
      >(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$ApiWishlistToggleRequestBodyImplToJson(this);
  }
}

abstract class _ApiWishlistToggleRequestBody
    implements ApiWishlistToggleRequestBody {
  const factory _ApiWishlistToggleRequestBody({
    @JsonKey(name: 'package_id') required final int packageId,
  }) = _$ApiWishlistToggleRequestBodyImpl;

  factory _ApiWishlistToggleRequestBody.fromJson(Map<String, dynamic> json) =
      _$ApiWishlistToggleRequestBodyImpl.fromJson;

  @override
  @JsonKey(name: 'package_id')
  int get packageId;

  /// Create a copy of ApiWishlistToggleRequestBody
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$ApiWishlistToggleRequestBodyImplCopyWith<
    _$ApiWishlistToggleRequestBodyImpl
  >
  get copyWith => throw _privateConstructorUsedError;
}
