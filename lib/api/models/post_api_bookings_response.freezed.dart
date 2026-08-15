// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'post_api_bookings_response.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

PostApiBookingsResponse _$PostApiBookingsResponseFromJson(
  Map<String, dynamic> json,
) {
  return _PostApiBookingsResponse.fromJson(json);
}

/// @nodoc
mixin _$PostApiBookingsResponse {
  Data2? get data => throw _privateConstructorUsedError;

  /// Serializes this PostApiBookingsResponse to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of PostApiBookingsResponse
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $PostApiBookingsResponseCopyWith<PostApiBookingsResponse> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $PostApiBookingsResponseCopyWith<$Res> {
  factory $PostApiBookingsResponseCopyWith(
    PostApiBookingsResponse value,
    $Res Function(PostApiBookingsResponse) then,
  ) = _$PostApiBookingsResponseCopyWithImpl<$Res, PostApiBookingsResponse>;
  @useResult
  $Res call({Data2? data});

  $Data2CopyWith<$Res>? get data;
}

/// @nodoc
class _$PostApiBookingsResponseCopyWithImpl<
  $Res,
  $Val extends PostApiBookingsResponse
>
    implements $PostApiBookingsResponseCopyWith<$Res> {
  _$PostApiBookingsResponseCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of PostApiBookingsResponse
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? data = freezed}) {
    return _then(
      _value.copyWith(
            data: freezed == data
                ? _value.data
                : data // ignore: cast_nullable_to_non_nullable
                      as Data2?,
          )
          as $Val,
    );
  }

  /// Create a copy of PostApiBookingsResponse
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $Data2CopyWith<$Res>? get data {
    if (_value.data == null) {
      return null;
    }

    return $Data2CopyWith<$Res>(_value.data!, (value) {
      return _then(_value.copyWith(data: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$PostApiBookingsResponseImplCopyWith<$Res>
    implements $PostApiBookingsResponseCopyWith<$Res> {
  factory _$$PostApiBookingsResponseImplCopyWith(
    _$PostApiBookingsResponseImpl value,
    $Res Function(_$PostApiBookingsResponseImpl) then,
  ) = __$$PostApiBookingsResponseImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({Data2? data});

  @override
  $Data2CopyWith<$Res>? get data;
}

/// @nodoc
class __$$PostApiBookingsResponseImplCopyWithImpl<$Res>
    extends
        _$PostApiBookingsResponseCopyWithImpl<
          $Res,
          _$PostApiBookingsResponseImpl
        >
    implements _$$PostApiBookingsResponseImplCopyWith<$Res> {
  __$$PostApiBookingsResponseImplCopyWithImpl(
    _$PostApiBookingsResponseImpl _value,
    $Res Function(_$PostApiBookingsResponseImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of PostApiBookingsResponse
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? data = freezed}) {
    return _then(
      _$PostApiBookingsResponseImpl(
        data: freezed == data
            ? _value.data
            : data // ignore: cast_nullable_to_non_nullable
                  as Data2?,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$PostApiBookingsResponseImpl implements _PostApiBookingsResponse {
  const _$PostApiBookingsResponseImpl({this.data});

  factory _$PostApiBookingsResponseImpl.fromJson(Map<String, dynamic> json) =>
      _$$PostApiBookingsResponseImplFromJson(json);

  @override
  final Data2? data;

  @override
  String toString() {
    return 'PostApiBookingsResponse(data: $data)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$PostApiBookingsResponseImpl &&
            (identical(other.data, data) || other.data == data));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, data);

  /// Create a copy of PostApiBookingsResponse
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$PostApiBookingsResponseImplCopyWith<_$PostApiBookingsResponseImpl>
  get copyWith =>
      __$$PostApiBookingsResponseImplCopyWithImpl<
        _$PostApiBookingsResponseImpl
      >(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$PostApiBookingsResponseImplToJson(this);
  }
}

abstract class _PostApiBookingsResponse implements PostApiBookingsResponse {
  const factory _PostApiBookingsResponse({final Data2? data}) =
      _$PostApiBookingsResponseImpl;

  factory _PostApiBookingsResponse.fromJson(Map<String, dynamic> json) =
      _$PostApiBookingsResponseImpl.fromJson;

  @override
  Data2? get data;

  /// Create a copy of PostApiBookingsResponse
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$PostApiBookingsResponseImplCopyWith<_$PostApiBookingsResponseImpl>
  get copyWith => throw _privateConstructorUsedError;
}
