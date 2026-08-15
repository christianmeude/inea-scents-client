// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'get_api_packages_response.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

GetApiPackagesResponse _$GetApiPackagesResponseFromJson(
  Map<String, dynamic> json,
) {
  return _GetApiPackagesResponse.fromJson(json);
}

/// @nodoc
mixin _$GetApiPackagesResponse {
  List<Package>? get data => throw _privateConstructorUsedError;

  /// Serializes this GetApiPackagesResponse to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of GetApiPackagesResponse
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $GetApiPackagesResponseCopyWith<GetApiPackagesResponse> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $GetApiPackagesResponseCopyWith<$Res> {
  factory $GetApiPackagesResponseCopyWith(
    GetApiPackagesResponse value,
    $Res Function(GetApiPackagesResponse) then,
  ) = _$GetApiPackagesResponseCopyWithImpl<$Res, GetApiPackagesResponse>;
  @useResult
  $Res call({List<Package>? data});
}

/// @nodoc
class _$GetApiPackagesResponseCopyWithImpl<
  $Res,
  $Val extends GetApiPackagesResponse
>
    implements $GetApiPackagesResponseCopyWith<$Res> {
  _$GetApiPackagesResponseCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of GetApiPackagesResponse
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
abstract class _$$GetApiPackagesResponseImplCopyWith<$Res>
    implements $GetApiPackagesResponseCopyWith<$Res> {
  factory _$$GetApiPackagesResponseImplCopyWith(
    _$GetApiPackagesResponseImpl value,
    $Res Function(_$GetApiPackagesResponseImpl) then,
  ) = __$$GetApiPackagesResponseImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({List<Package>? data});
}

/// @nodoc
class __$$GetApiPackagesResponseImplCopyWithImpl<$Res>
    extends
        _$GetApiPackagesResponseCopyWithImpl<$Res, _$GetApiPackagesResponseImpl>
    implements _$$GetApiPackagesResponseImplCopyWith<$Res> {
  __$$GetApiPackagesResponseImplCopyWithImpl(
    _$GetApiPackagesResponseImpl _value,
    $Res Function(_$GetApiPackagesResponseImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of GetApiPackagesResponse
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? data = freezed}) {
    return _then(
      _$GetApiPackagesResponseImpl(
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
class _$GetApiPackagesResponseImpl implements _GetApiPackagesResponse {
  const _$GetApiPackagesResponseImpl({final List<Package>? data})
    : _data = data;

  factory _$GetApiPackagesResponseImpl.fromJson(Map<String, dynamic> json) =>
      _$$GetApiPackagesResponseImplFromJson(json);

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
    return 'GetApiPackagesResponse(data: $data)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$GetApiPackagesResponseImpl &&
            const DeepCollectionEquality().equals(other._data, _data));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode =>
      Object.hash(runtimeType, const DeepCollectionEquality().hash(_data));

  /// Create a copy of GetApiPackagesResponse
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$GetApiPackagesResponseImplCopyWith<_$GetApiPackagesResponseImpl>
  get copyWith =>
      __$$GetApiPackagesResponseImplCopyWithImpl<_$GetApiPackagesResponseImpl>(
        this,
        _$identity,
      );

  @override
  Map<String, dynamic> toJson() {
    return _$$GetApiPackagesResponseImplToJson(this);
  }
}

abstract class _GetApiPackagesResponse implements GetApiPackagesResponse {
  const factory _GetApiPackagesResponse({final List<Package>? data}) =
      _$GetApiPackagesResponseImpl;

  factory _GetApiPackagesResponse.fromJson(Map<String, dynamic> json) =
      _$GetApiPackagesResponseImpl.fromJson;

  @override
  List<Package>? get data;

  /// Create a copy of GetApiPackagesResponse
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$GetApiPackagesResponseImplCopyWith<_$GetApiPackagesResponseImpl>
  get copyWith => throw _privateConstructorUsedError;
}
