// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'post_api_wishlist_toggle_response.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

PostApiWishlistToggleResponse _$PostApiWishlistToggleResponseFromJson(
  Map<String, dynamic> json,
) {
  return _PostApiWishlistToggleResponse.fromJson(json);
}

/// @nodoc
mixin _$PostApiWishlistToggleResponse {
  bool? get attached => throw _privateConstructorUsedError;
  String? get message => throw _privateConstructorUsedError;

  /// Serializes this PostApiWishlistToggleResponse to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of PostApiWishlistToggleResponse
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $PostApiWishlistToggleResponseCopyWith<PostApiWishlistToggleResponse>
  get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $PostApiWishlistToggleResponseCopyWith<$Res> {
  factory $PostApiWishlistToggleResponseCopyWith(
    PostApiWishlistToggleResponse value,
    $Res Function(PostApiWishlistToggleResponse) then,
  ) =
      _$PostApiWishlistToggleResponseCopyWithImpl<
        $Res,
        PostApiWishlistToggleResponse
      >;
  @useResult
  $Res call({bool? attached, String? message});
}

/// @nodoc
class _$PostApiWishlistToggleResponseCopyWithImpl<
  $Res,
  $Val extends PostApiWishlistToggleResponse
>
    implements $PostApiWishlistToggleResponseCopyWith<$Res> {
  _$PostApiWishlistToggleResponseCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of PostApiWishlistToggleResponse
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? attached = freezed, Object? message = freezed}) {
    return _then(
      _value.copyWith(
            attached: freezed == attached
                ? _value.attached
                : attached // ignore: cast_nullable_to_non_nullable
                      as bool?,
            message: freezed == message
                ? _value.message
                : message // ignore: cast_nullable_to_non_nullable
                      as String?,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$PostApiWishlistToggleResponseImplCopyWith<$Res>
    implements $PostApiWishlistToggleResponseCopyWith<$Res> {
  factory _$$PostApiWishlistToggleResponseImplCopyWith(
    _$PostApiWishlistToggleResponseImpl value,
    $Res Function(_$PostApiWishlistToggleResponseImpl) then,
  ) = __$$PostApiWishlistToggleResponseImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({bool? attached, String? message});
}

/// @nodoc
class __$$PostApiWishlistToggleResponseImplCopyWithImpl<$Res>
    extends
        _$PostApiWishlistToggleResponseCopyWithImpl<
          $Res,
          _$PostApiWishlistToggleResponseImpl
        >
    implements _$$PostApiWishlistToggleResponseImplCopyWith<$Res> {
  __$$PostApiWishlistToggleResponseImplCopyWithImpl(
    _$PostApiWishlistToggleResponseImpl _value,
    $Res Function(_$PostApiWishlistToggleResponseImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of PostApiWishlistToggleResponse
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? attached = freezed, Object? message = freezed}) {
    return _then(
      _$PostApiWishlistToggleResponseImpl(
        attached: freezed == attached
            ? _value.attached
            : attached // ignore: cast_nullable_to_non_nullable
                  as bool?,
        message: freezed == message
            ? _value.message
            : message // ignore: cast_nullable_to_non_nullable
                  as String?,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$PostApiWishlistToggleResponseImpl
    implements _PostApiWishlistToggleResponse {
  const _$PostApiWishlistToggleResponseImpl({this.attached, this.message});

  factory _$PostApiWishlistToggleResponseImpl.fromJson(
    Map<String, dynamic> json,
  ) => _$$PostApiWishlistToggleResponseImplFromJson(json);

  @override
  final bool? attached;
  @override
  final String? message;

  @override
  String toString() {
    return 'PostApiWishlistToggleResponse(attached: $attached, message: $message)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$PostApiWishlistToggleResponseImpl &&
            (identical(other.attached, attached) ||
                other.attached == attached) &&
            (identical(other.message, message) || other.message == message));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, attached, message);

  /// Create a copy of PostApiWishlistToggleResponse
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$PostApiWishlistToggleResponseImplCopyWith<
    _$PostApiWishlistToggleResponseImpl
  >
  get copyWith =>
      __$$PostApiWishlistToggleResponseImplCopyWithImpl<
        _$PostApiWishlistToggleResponseImpl
      >(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$PostApiWishlistToggleResponseImplToJson(this);
  }
}

abstract class _PostApiWishlistToggleResponse
    implements PostApiWishlistToggleResponse {
  const factory _PostApiWishlistToggleResponse({
    final bool? attached,
    final String? message,
  }) = _$PostApiWishlistToggleResponseImpl;

  factory _PostApiWishlistToggleResponse.fromJson(Map<String, dynamic> json) =
      _$PostApiWishlistToggleResponseImpl.fromJson;

  @override
  bool? get attached;
  @override
  String? get message;

  /// Create a copy of PostApiWishlistToggleResponse
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$PostApiWishlistToggleResponseImplCopyWith<
    _$PostApiWishlistToggleResponseImpl
  >
  get copyWith => throw _privateConstructorUsedError;
}
