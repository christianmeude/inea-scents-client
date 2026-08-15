// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'get_api_wishlist_response.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

GetApiWishlistResponse _$GetApiWishlistResponseFromJson(
  Map<String, dynamic> json,
) {
  return _GetApiWishlistResponse.fromJson(json);
}

/// @nodoc
mixin _$GetApiWishlistResponse {
  List<Package>? get data => throw _privateConstructorUsedError;

  /// Serializes this GetApiWishlistResponse to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of GetApiWishlistResponse
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $GetApiWishlistResponseCopyWith<GetApiWishlistResponse> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $GetApiWishlistResponseCopyWith<$Res> {
  factory $GetApiWishlistResponseCopyWith(
    GetApiWishlistResponse value,
    $Res Function(GetApiWishlistResponse) then,
  ) = _$GetApiWishlistResponseCopyWithImpl<$Res, GetApiWishlistResponse>;
  @useResult
  $Res call({List<Package>? data});
}

/// @nodoc
class _$GetApiWishlistResponseCopyWithImpl<
  $Res,
  $Val extends GetApiWishlistResponse
>
    implements $GetApiWishlistResponseCopyWith<$Res> {
  _$GetApiWishlistResponseCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of GetApiWishlistResponse
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? data = freezed}) {
    return _then(
      _value.copyWith(
            data: freezed == data
                ? _value.data
                : data // ignore: cast_nullable_to_non_nullable
                      as List<Package>?,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$GetApiWishlistResponseImplCopyWith<$Res>
    implements $GetApiWishlistResponseCopyWith<$Res> {
  factory _$$GetApiWishlistResponseImplCopyWith(
    _$GetApiWishlistResponseImpl value,
    $Res Function(_$GetApiWishlistResponseImpl) then,
  ) = __$$GetApiWishlistResponseImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({List<Package>? data});
}

/// @nodoc
class __$$GetApiWishlistResponseImplCopyWithImpl<$Res>
    extends
        _$GetApiWishlistResponseCopyWithImpl<$Res, _$GetApiWishlistResponseImpl>
    implements _$$GetApiWishlistResponseImplCopyWith<$Res> {
  __$$GetApiWishlistResponseImplCopyWithImpl(
    _$GetApiWishlistResponseImpl _value,
    $Res Function(_$GetApiWishlistResponseImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of GetApiWishlistResponse
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? data = freezed}) {
    return _then(
      _$GetApiWishlistResponseImpl(
        data: freezed == data
            ? _value._data
            : data // ignore: cast_nullable_to_non_nullable
                  as List<Package>?,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$GetApiWishlistResponseImpl implements _GetApiWishlistResponse {
  const _$GetApiWishlistResponseImpl({final List<Package>? data})
    : _data = data;

  factory _$GetApiWishlistResponseImpl.fromJson(Map<String, dynamic> json) =>
      _$$GetApiWishlistResponseImplFromJson(json);

  final List<Package>? _data;
  @override
  List<Package>? get data {
    final value = _data;
    if (value == null) return null;
    if (_data is EqualUnmodifiableListView) return _data;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(value);
  }

  @override
  String toString() {
    return 'GetApiWishlistResponse(data: $data)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$GetApiWishlistResponseImpl &&
            const DeepCollectionEquality().equals(other._data, _data));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode =>
      Object.hash(runtimeType, const DeepCollectionEquality().hash(_data));

  /// Create a copy of GetApiWishlistResponse
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$GetApiWishlistResponseImplCopyWith<_$GetApiWishlistResponseImpl>
  get copyWith =>
      __$$GetApiWishlistResponseImplCopyWithImpl<_$GetApiWishlistResponseImpl>(
        this,
        _$identity,
      );

  @override
  Map<String, dynamic> toJson() {
    return _$$GetApiWishlistResponseImplToJson(this);
  }
}

abstract class _GetApiWishlistResponse implements GetApiWishlistResponse {
  const factory _GetApiWishlistResponse({final List<Package>? data}) =
      _$GetApiWishlistResponseImpl;

  factory _GetApiWishlistResponse.fromJson(Map<String, dynamic> json) =
      _$GetApiWishlistResponseImpl.fromJson;

  @override
  List<Package>? get data;

  /// Create a copy of GetApiWishlistResponse
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$GetApiWishlistResponseImplCopyWith<_$GetApiWishlistResponseImpl>
  get copyWith => throw _privateConstructorUsedError;
}
