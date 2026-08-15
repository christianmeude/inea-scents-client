// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'get_api_packages_package_response.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

GetApiPackagesPackageResponse _$GetApiPackagesPackageResponseFromJson(
  Map<String, dynamic> json,
) {
  return _GetApiPackagesPackageResponse.fromJson(json);
}

/// @nodoc
mixin _$GetApiPackagesPackageResponse {
  Package? get data => throw _privateConstructorUsedError;

  /// Serializes this GetApiPackagesPackageResponse to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of GetApiPackagesPackageResponse
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $GetApiPackagesPackageResponseCopyWith<GetApiPackagesPackageResponse>
  get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $GetApiPackagesPackageResponseCopyWith<$Res> {
  factory $GetApiPackagesPackageResponseCopyWith(
    GetApiPackagesPackageResponse value,
    $Res Function(GetApiPackagesPackageResponse) then,
  ) =
      _$GetApiPackagesPackageResponseCopyWithImpl<
        $Res,
        GetApiPackagesPackageResponse
      >;
  @useResult
  $Res call({Package? data});

  $PackageCopyWith<$Res>? get data;
}

/// @nodoc
class _$GetApiPackagesPackageResponseCopyWithImpl<
  $Res,
  $Val extends GetApiPackagesPackageResponse
>
    implements $GetApiPackagesPackageResponseCopyWith<$Res> {
  _$GetApiPackagesPackageResponseCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of GetApiPackagesPackageResponse
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? data = freezed}) {
    return _then(
      _value.copyWith(
            data: freezed == data
                ? _value.data
                : data // ignore: cast_nullable_to_non_nullable
                      as Package?,
          )
          as $Val,
    );
  }

  /// Create a copy of GetApiPackagesPackageResponse
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $PackageCopyWith<$Res>? get data {
    if (_value.data == null) {
      return null;
    }

    return $PackageCopyWith<$Res>(_value.data!, (value) {
      return _then(_value.copyWith(data: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$GetApiPackagesPackageResponseImplCopyWith<$Res>
    implements $GetApiPackagesPackageResponseCopyWith<$Res> {
  factory _$$GetApiPackagesPackageResponseImplCopyWith(
    _$GetApiPackagesPackageResponseImpl value,
    $Res Function(_$GetApiPackagesPackageResponseImpl) then,
  ) = __$$GetApiPackagesPackageResponseImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({Package? data});

  @override
  $PackageCopyWith<$Res>? get data;
}

/// @nodoc
class __$$GetApiPackagesPackageResponseImplCopyWithImpl<$Res>
    extends
        _$GetApiPackagesPackageResponseCopyWithImpl<
          $Res,
          _$GetApiPackagesPackageResponseImpl
        >
    implements _$$GetApiPackagesPackageResponseImplCopyWith<$Res> {
  __$$GetApiPackagesPackageResponseImplCopyWithImpl(
    _$GetApiPackagesPackageResponseImpl _value,
    $Res Function(_$GetApiPackagesPackageResponseImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of GetApiPackagesPackageResponse
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? data = freezed}) {
    return _then(
      _$GetApiPackagesPackageResponseImpl(
        data: freezed == data
            ? _value.data
            : data // ignore: cast_nullable_to_non_nullable
                  as Package?,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$GetApiPackagesPackageResponseImpl
    implements _GetApiPackagesPackageResponse {
  const _$GetApiPackagesPackageResponseImpl({this.data});

  factory _$GetApiPackagesPackageResponseImpl.fromJson(
    Map<String, dynamic> json,
  ) => _$$GetApiPackagesPackageResponseImplFromJson(json);

  @override
  final Package? data;

  @override
  String toString() {
    return 'GetApiPackagesPackageResponse(data: $data)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$GetApiPackagesPackageResponseImpl &&
            (identical(other.data, data) || other.data == data));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, data);

  /// Create a copy of GetApiPackagesPackageResponse
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$GetApiPackagesPackageResponseImplCopyWith<
    _$GetApiPackagesPackageResponseImpl
  >
  get copyWith =>
      __$$GetApiPackagesPackageResponseImplCopyWithImpl<
        _$GetApiPackagesPackageResponseImpl
      >(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$GetApiPackagesPackageResponseImplToJson(this);
  }
}

abstract class _GetApiPackagesPackageResponse
    implements GetApiPackagesPackageResponse {
  const factory _GetApiPackagesPackageResponse({final Package? data}) =
      _$GetApiPackagesPackageResponseImpl;

  factory _GetApiPackagesPackageResponse.fromJson(Map<String, dynamic> json) =
      _$GetApiPackagesPackageResponseImpl.fromJson;

  @override
  Package? get data;

  /// Create a copy of GetApiPackagesPackageResponse
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$GetApiPackagesPackageResponseImplCopyWith<
    _$GetApiPackagesPackageResponseImpl
  >
  get copyWith => throw _privateConstructorUsedError;
}
