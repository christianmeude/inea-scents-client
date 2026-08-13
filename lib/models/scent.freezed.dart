// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'scent.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

Scent _$ScentFromJson(Map<String, dynamic> json) {
  return _Scent.fromJson(json);
}

/// @nodoc
mixin _$Scent {
  int get id => throw _privateConstructorUsedError;
  String get name => throw _privateConstructorUsedError;
  String get description => throw _privateConstructorUsedError;
  String get image_url => throw _privateConstructorUsedError;
  bool get is_available => throw _privateConstructorUsedError;
  String get created_at => throw _privateConstructorUsedError;
  String get updated_at => throw _privateConstructorUsedError;

  /// Serializes this Scent to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of Scent
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $ScentCopyWith<Scent> get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ScentCopyWith<$Res> {
  factory $ScentCopyWith(Scent value, $Res Function(Scent) then) =
      _$ScentCopyWithImpl<$Res, Scent>;
  @useResult
  $Res call({
    int id,
    String name,
    String description,
    String image_url,
    bool is_available,
    String created_at,
    String updated_at,
  });
}

/// @nodoc
class _$ScentCopyWithImpl<$Res, $Val extends Scent>
    implements $ScentCopyWith<$Res> {
  _$ScentCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of Scent
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? name = null,
    Object? description = null,
    Object? image_url = null,
    Object? is_available = null,
    Object? created_at = null,
    Object? updated_at = null,
  }) {
    return _then(
      _value.copyWith(
            id: null == id
                ? _value.id
                : id // ignore: cast_nullable_to_non_nullable
                      as int,
            name: null == name
                ? _value.name
                : name // ignore: cast_nullable_to_non_nullable
                      as String,
            description: null == description
                ? _value.description
                : description // ignore: cast_nullable_to_non_nullable
                      as String,
            image_url: null == image_url
                ? _value.image_url
                : image_url // ignore: cast_nullable_to_non_nullable
                      as String,
            is_available: null == is_available
                ? _value.is_available
                : is_available // ignore: cast_nullable_to_non_nullable
                      as bool,
            created_at: null == created_at
                ? _value.created_at
                : created_at // ignore: cast_nullable_to_non_nullable
                      as String,
            updated_at: null == updated_at
                ? _value.updated_at
                : updated_at // ignore: cast_nullable_to_non_nullable
                      as String,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$ScentImplCopyWith<$Res> implements $ScentCopyWith<$Res> {
  factory _$$ScentImplCopyWith(
    _$ScentImpl value,
    $Res Function(_$ScentImpl) then,
  ) = __$$ScentImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    int id,
    String name,
    String description,
    String image_url,
    bool is_available,
    String created_at,
    String updated_at,
  });
}

/// @nodoc
class __$$ScentImplCopyWithImpl<$Res>
    extends _$ScentCopyWithImpl<$Res, _$ScentImpl>
    implements _$$ScentImplCopyWith<$Res> {
  __$$ScentImplCopyWithImpl(
    _$ScentImpl _value,
    $Res Function(_$ScentImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of Scent
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? name = null,
    Object? description = null,
    Object? image_url = null,
    Object? is_available = null,
    Object? created_at = null,
    Object? updated_at = null,
  }) {
    return _then(
      _$ScentImpl(
        id: null == id
            ? _value.id
            : id // ignore: cast_nullable_to_non_nullable
                  as int,
        name: null == name
            ? _value.name
            : name // ignore: cast_nullable_to_non_nullable
                  as String,
        description: null == description
            ? _value.description
            : description // ignore: cast_nullable_to_non_nullable
                  as String,
        image_url: null == image_url
            ? _value.image_url
            : image_url // ignore: cast_nullable_to_non_nullable
                  as String,
        is_available: null == is_available
            ? _value.is_available
            : is_available // ignore: cast_nullable_to_non_nullable
                  as bool,
        created_at: null == created_at
            ? _value.created_at
            : created_at // ignore: cast_nullable_to_non_nullable
                  as String,
        updated_at: null == updated_at
            ? _value.updated_at
            : updated_at // ignore: cast_nullable_to_non_nullable
                  as String,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$ScentImpl implements _Scent {
  const _$ScentImpl({
    required this.id,
    required this.name,
    required this.description,
    required this.image_url,
    required this.is_available,
    required this.created_at,
    required this.updated_at,
  });

  factory _$ScentImpl.fromJson(Map<String, dynamic> json) =>
      _$$ScentImplFromJson(json);

  @override
  final int id;
  @override
  final String name;
  @override
  final String description;
  @override
  final String image_url;
  @override
  final bool is_available;
  @override
  final String created_at;
  @override
  final String updated_at;

  @override
  String toString() {
    return 'Scent(id: $id, name: $name, description: $description, image_url: $image_url, is_available: $is_available, created_at: $created_at, updated_at: $updated_at)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ScentImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.description, description) ||
                other.description == description) &&
            (identical(other.image_url, image_url) ||
                other.image_url == image_url) &&
            (identical(other.is_available, is_available) ||
                other.is_available == is_available) &&
            (identical(other.created_at, created_at) ||
                other.created_at == created_at) &&
            (identical(other.updated_at, updated_at) ||
                other.updated_at == updated_at));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    id,
    name,
    description,
    image_url,
    is_available,
    created_at,
    updated_at,
  );

  /// Create a copy of Scent
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$ScentImplCopyWith<_$ScentImpl> get copyWith =>
      __$$ScentImplCopyWithImpl<_$ScentImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$ScentImplToJson(this);
  }
}

abstract class _Scent implements Scent {
  const factory _Scent({
    required final int id,
    required final String name,
    required final String description,
    required final String image_url,
    required final bool is_available,
    required final String created_at,
    required final String updated_at,
  }) = _$ScentImpl;

  factory _Scent.fromJson(Map<String, dynamic> json) = _$ScentImpl.fromJson;

  @override
  int get id;
  @override
  String get name;
  @override
  String get description;
  @override
  String get image_url;
  @override
  bool get is_available;
  @override
  String get created_at;
  @override
  String get updated_at;

  /// Create a copy of Scent
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$ScentImplCopyWith<_$ScentImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
