// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'get_api_bookings_response.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

GetApiBookingsResponse _$GetApiBookingsResponseFromJson(
  Map<String, dynamic> json,
) {
  return _GetApiBookingsResponse.fromJson(json);
}

/// @nodoc
mixin _$GetApiBookingsResponse {
  List<Data>? get data => throw _privateConstructorUsedError;

  /// Serializes this GetApiBookingsResponse to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of GetApiBookingsResponse
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $GetApiBookingsResponseCopyWith<GetApiBookingsResponse> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $GetApiBookingsResponseCopyWith<$Res> {
  factory $GetApiBookingsResponseCopyWith(
    GetApiBookingsResponse value,
    $Res Function(GetApiBookingsResponse) then,
  ) = _$GetApiBookingsResponseCopyWithImpl<$Res, GetApiBookingsResponse>;
  @useResult
  $Res call({List<Data>? data});
}

/// @nodoc
class _$GetApiBookingsResponseCopyWithImpl<
  $Res,
  $Val extends GetApiBookingsResponse
>
    implements $GetApiBookingsResponseCopyWith<$Res> {
  _$GetApiBookingsResponseCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of GetApiBookingsResponse
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? data = freezed}) {
    return _then(
      _value.copyWith(
            data: freezed == data
                ? _value.data
                : data // ignore: cast_nullable_to_non_nullable
                      as List<Data>?,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$GetApiBookingsResponseImplCopyWith<$Res>
    implements $GetApiBookingsResponseCopyWith<$Res> {
  factory _$$GetApiBookingsResponseImplCopyWith(
    _$GetApiBookingsResponseImpl value,
    $Res Function(_$GetApiBookingsResponseImpl) then,
  ) = __$$GetApiBookingsResponseImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({List<Data>? data});
}

/// @nodoc
class __$$GetApiBookingsResponseImplCopyWithImpl<$Res>
    extends
        _$GetApiBookingsResponseCopyWithImpl<$Res, _$GetApiBookingsResponseImpl>
    implements _$$GetApiBookingsResponseImplCopyWith<$Res> {
  __$$GetApiBookingsResponseImplCopyWithImpl(
    _$GetApiBookingsResponseImpl _value,
    $Res Function(_$GetApiBookingsResponseImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of GetApiBookingsResponse
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? data = freezed}) {
    return _then(
      _$GetApiBookingsResponseImpl(
        data: freezed == data
            ? _value._data
            : data // ignore: cast_nullable_to_non_nullable
                  as List<Data>?,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$GetApiBookingsResponseImpl implements _GetApiBookingsResponse {
  const _$GetApiBookingsResponseImpl({final List<Data>? data}) : _data = data;

  factory _$GetApiBookingsResponseImpl.fromJson(Map<String, dynamic> json) =>
      _$$GetApiBookingsResponseImplFromJson(json);

  final List<Data>? _data;
  @override
  List<Data>? get data {
    final value = _data;
    if (value == null) return null;
    if (_data is EqualUnmodifiableListView) return _data;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(value);
  }

  @override
  String toString() {
    return 'GetApiBookingsResponse(data: $data)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$GetApiBookingsResponseImpl &&
            const DeepCollectionEquality().equals(other._data, _data));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode =>
      Object.hash(runtimeType, const DeepCollectionEquality().hash(_data));

  /// Create a copy of GetApiBookingsResponse
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$GetApiBookingsResponseImplCopyWith<_$GetApiBookingsResponseImpl>
  get copyWith =>
      __$$GetApiBookingsResponseImplCopyWithImpl<_$GetApiBookingsResponseImpl>(
        this,
        _$identity,
      );

  @override
  Map<String, dynamic> toJson() {
    return _$$GetApiBookingsResponseImplToJson(this);
  }
}

abstract class _GetApiBookingsResponse implements GetApiBookingsResponse {
  const factory _GetApiBookingsResponse({final List<Data>? data}) =
      _$GetApiBookingsResponseImpl;

  factory _GetApiBookingsResponse.fromJson(Map<String, dynamic> json) =
      _$GetApiBookingsResponseImpl.fromJson;

  @override
  List<Data>? get data;

  /// Create a copy of GetApiBookingsResponse
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$GetApiBookingsResponseImplCopyWith<_$GetApiBookingsResponseImpl>
  get copyWith => throw _privateConstructorUsedError;
}
