// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'get_api_availability_response.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

GetApiAvailabilityResponse _$GetApiAvailabilityResponseFromJson(
  Map<String, dynamic> json,
) {
  return _GetApiAvailabilityResponse.fromJson(json);
}

/// @nodoc
mixin _$GetApiAvailabilityResponse {
  DateTime? get date => throw _privateConstructorUsedError;
  String? get status => throw _privateConstructorUsedError;

  /// Serializes this GetApiAvailabilityResponse to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of GetApiAvailabilityResponse
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $GetApiAvailabilityResponseCopyWith<GetApiAvailabilityResponse>
  get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $GetApiAvailabilityResponseCopyWith<$Res> {
  factory $GetApiAvailabilityResponseCopyWith(
    GetApiAvailabilityResponse value,
    $Res Function(GetApiAvailabilityResponse) then,
  ) =
      _$GetApiAvailabilityResponseCopyWithImpl<
        $Res,
        GetApiAvailabilityResponse
      >;
  @useResult
  $Res call({DateTime? date, String? status});
}

/// @nodoc
class _$GetApiAvailabilityResponseCopyWithImpl<
  $Res,
  $Val extends GetApiAvailabilityResponse
>
    implements $GetApiAvailabilityResponseCopyWith<$Res> {
  _$GetApiAvailabilityResponseCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of GetApiAvailabilityResponse
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? date = freezed, Object? status = freezed}) {
    return _then(
      _value.copyWith(
            date: freezed == date
                ? _value.date
                : date // ignore: cast_nullable_to_non_nullable
                      as DateTime?,
            status: freezed == status
                ? _value.status
                : status // ignore: cast_nullable_to_non_nullable
                      as String?,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$GetApiAvailabilityResponseImplCopyWith<$Res>
    implements $GetApiAvailabilityResponseCopyWith<$Res> {
  factory _$$GetApiAvailabilityResponseImplCopyWith(
    _$GetApiAvailabilityResponseImpl value,
    $Res Function(_$GetApiAvailabilityResponseImpl) then,
  ) = __$$GetApiAvailabilityResponseImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({DateTime? date, String? status});
}

/// @nodoc
class __$$GetApiAvailabilityResponseImplCopyWithImpl<$Res>
    extends
        _$GetApiAvailabilityResponseCopyWithImpl<
          $Res,
          _$GetApiAvailabilityResponseImpl
        >
    implements _$$GetApiAvailabilityResponseImplCopyWith<$Res> {
  __$$GetApiAvailabilityResponseImplCopyWithImpl(
    _$GetApiAvailabilityResponseImpl _value,
    $Res Function(_$GetApiAvailabilityResponseImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of GetApiAvailabilityResponse
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? date = freezed, Object? status = freezed}) {
    return _then(
      _$GetApiAvailabilityResponseImpl(
        date: freezed == date
            ? _value.date
            : date // ignore: cast_nullable_to_non_nullable
                  as DateTime?,
        status: freezed == status
            ? _value.status
            : status // ignore: cast_nullable_to_non_nullable
                  as String?,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$GetApiAvailabilityResponseImpl implements _GetApiAvailabilityResponse {
  const _$GetApiAvailabilityResponseImpl({this.date, this.status});

  factory _$GetApiAvailabilityResponseImpl.fromJson(
    Map<String, dynamic> json,
  ) => _$$GetApiAvailabilityResponseImplFromJson(json);

  @override
  final DateTime? date;
  @override
  final String? status;

  @override
  String toString() {
    return 'GetApiAvailabilityResponse(date: $date, status: $status)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$GetApiAvailabilityResponseImpl &&
            (identical(other.date, date) || other.date == date) &&
            (identical(other.status, status) || other.status == status));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, date, status);

  /// Create a copy of GetApiAvailabilityResponse
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$GetApiAvailabilityResponseImplCopyWith<_$GetApiAvailabilityResponseImpl>
  get copyWith =>
      __$$GetApiAvailabilityResponseImplCopyWithImpl<
        _$GetApiAvailabilityResponseImpl
      >(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$GetApiAvailabilityResponseImplToJson(this);
  }
}

abstract class _GetApiAvailabilityResponse
    implements GetApiAvailabilityResponse {
  const factory _GetApiAvailabilityResponse({
    final DateTime? date,
    final String? status,
  }) = _$GetApiAvailabilityResponseImpl;

  factory _GetApiAvailabilityResponse.fromJson(Map<String, dynamic> json) =
      _$GetApiAvailabilityResponseImpl.fromJson;

  @override
  DateTime? get date;
  @override
  String? get status;

  /// Create a copy of GetApiAvailabilityResponse
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$GetApiAvailabilityResponseImplCopyWith<_$GetApiAvailabilityResponseImpl>
  get copyWith => throw _privateConstructorUsedError;
}
