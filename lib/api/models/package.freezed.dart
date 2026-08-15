// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'package.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

Package _$PackageFromJson(Map<String, dynamic> json) {
  return _Package.fromJson(json);
}

/// @nodoc
mixin _$Package {
  int? get id => throw _privateConstructorUsedError;
  String? get name => throw _privateConstructorUsedError;
  String? get description => throw _privateConstructorUsedError;
  List<String>? get inclusions => throw _privateConstructorUsedError;
  @JsonKey(name: 'pax_options')
  List<int>? get paxOptions => throw _privateConstructorUsedError;
  List<String>? get freebies => throw _privateConstructorUsedError;
  double? get price => throw _privateConstructorUsedError;
  double? get rating => throw _privateConstructorUsedError;
  @JsonKey(name: 'reviews_count')
  int? get reviewsCount => throw _privateConstructorUsedError;
  List<String>? get images => throw _privateConstructorUsedError;
  @JsonKey(name: 'gallery_images')
  List<String>? get galleryImages => throw _privateConstructorUsedError;
  List<Scent>? get scents => throw _privateConstructorUsedError;
  @JsonKey(name: 'created_at')
  DateTime? get createdAt => throw _privateConstructorUsedError;
  @JsonKey(name: 'updated_at')
  DateTime? get updatedAt => throw _privateConstructorUsedError;

  /// Serializes this Package to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of Package
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $PackageCopyWith<Package> get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $PackageCopyWith<$Res> {
  factory $PackageCopyWith(Package value, $Res Function(Package) then) =
      _$PackageCopyWithImpl<$Res, Package>;
  @useResult
  $Res call({
    int? id,
    String? name,
    String? description,
    List<String>? inclusions,
    @JsonKey(name: 'pax_options') List<int>? paxOptions,
    List<String>? freebies,
    double? price,
    double? rating,
    @JsonKey(name: 'reviews_count') int? reviewsCount,
    List<String>? images,
    @JsonKey(name: 'gallery_images') List<String>? galleryImages,
    List<Scent>? scents,
    @JsonKey(name: 'created_at') DateTime? createdAt,
    @JsonKey(name: 'updated_at') DateTime? updatedAt,
  });
}

/// @nodoc
class _$PackageCopyWithImpl<$Res, $Val extends Package>
    implements $PackageCopyWith<$Res> {
  _$PackageCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of Package
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = freezed,
    Object? name = freezed,
    Object? description = freezed,
    Object? inclusions = freezed,
    Object? paxOptions = freezed,
    Object? freebies = freezed,
    Object? price = freezed,
    Object? rating = freezed,
    Object? reviewsCount = freezed,
    Object? images = freezed,
    Object? galleryImages = freezed,
    Object? scents = freezed,
    Object? createdAt = freezed,
    Object? updatedAt = freezed,
  }) {
    return _then(
      _value.copyWith(
            id: freezed == id
                ? _value.id
                : id // ignore: cast_nullable_to_non_nullable
                      as int?,
            name: freezed == name
                ? _value.name
                : name // ignore: cast_nullable_to_non_nullable
                      as String?,
            description: freezed == description
                ? _value.description
                : description // ignore: cast_nullable_to_non_nullable
                      as String?,
            inclusions: freezed == inclusions
                ? _value.inclusions
                : inclusions // ignore: cast_nullable_to_non_nullable
                      as List<String>?,
            paxOptions: freezed == paxOptions
                ? _value.paxOptions
                : paxOptions // ignore: cast_nullable_to_non_nullable
                      as List<int>?,
            freebies: freezed == freebies
                ? _value.freebies
                : freebies // ignore: cast_nullable_to_non_nullable
                      as List<String>?,
            price: freezed == price
                ? _value.price
                : price // ignore: cast_nullable_to_non_nullable
                      as double?,
            rating: freezed == rating
                ? _value.rating
                : rating // ignore: cast_nullable_to_non_nullable
                      as double?,
            reviewsCount: freezed == reviewsCount
                ? _value.reviewsCount
                : reviewsCount // ignore: cast_nullable_to_non_nullable
                      as int?,
            images: freezed == images
                ? _value.images
                : images // ignore: cast_nullable_to_non_nullable
                      as List<String>?,
            galleryImages: freezed == galleryImages
                ? _value.galleryImages
                : galleryImages // ignore: cast_nullable_to_non_nullable
                      as List<String>?,
            scents: freezed == scents
                ? _value.scents
                : scents // ignore: cast_nullable_to_non_nullable
                      as List<Scent>?,
            createdAt: freezed == createdAt
                ? _value.createdAt
                : createdAt // ignore: cast_nullable_to_non_nullable
                      as DateTime?,
            updatedAt: freezed == updatedAt
                ? _value.updatedAt
                : updatedAt // ignore: cast_nullable_to_non_nullable
                      as DateTime?,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$PackageImplCopyWith<$Res> implements $PackageCopyWith<$Res> {
  factory _$$PackageImplCopyWith(
    _$PackageImpl value,
    $Res Function(_$PackageImpl) then,
  ) = __$$PackageImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    int? id,
    String? name,
    String? description,
    List<String>? inclusions,
    @JsonKey(name: 'pax_options') List<int>? paxOptions,
    List<String>? freebies,
    double? price,
    double? rating,
    @JsonKey(name: 'reviews_count') int? reviewsCount,
    List<String>? images,
    @JsonKey(name: 'gallery_images') List<String>? galleryImages,
    List<Scent>? scents,
    @JsonKey(name: 'created_at') DateTime? createdAt,
    @JsonKey(name: 'updated_at') DateTime? updatedAt,
  });
}

/// @nodoc
class __$$PackageImplCopyWithImpl<$Res>
    extends _$PackageCopyWithImpl<$Res, _$PackageImpl>
    implements _$$PackageImplCopyWith<$Res> {
  __$$PackageImplCopyWithImpl(
    _$PackageImpl _value,
    $Res Function(_$PackageImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of Package
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = freezed,
    Object? name = freezed,
    Object? description = freezed,
    Object? inclusions = freezed,
    Object? paxOptions = freezed,
    Object? freebies = freezed,
    Object? price = freezed,
    Object? rating = freezed,
    Object? reviewsCount = freezed,
    Object? images = freezed,
    Object? galleryImages = freezed,
    Object? scents = freezed,
    Object? createdAt = freezed,
    Object? updatedAt = freezed,
  }) {
    return _then(
      _$PackageImpl(
        id: freezed == id
            ? _value.id
            : id // ignore: cast_nullable_to_non_nullable
                  as int?,
        name: freezed == name
            ? _value.name
            : name // ignore: cast_nullable_to_non_nullable
                  as String?,
        description: freezed == description
            ? _value.description
            : description // ignore: cast_nullable_to_non_nullable
                  as String?,
        inclusions: freezed == inclusions
            ? _value._inclusions
            : inclusions // ignore: cast_nullable_to_non_nullable
                  as List<String>?,
        paxOptions: freezed == paxOptions
            ? _value._paxOptions
            : paxOptions // ignore: cast_nullable_to_non_nullable
                  as List<int>?,
        freebies: freezed == freebies
            ? _value._freebies
            : freebies // ignore: cast_nullable_to_non_nullable
                  as List<String>?,
        price: freezed == price
            ? _value.price
            : price // ignore: cast_nullable_to_non_nullable
                  as double?,
        rating: freezed == rating
            ? _value.rating
            : rating // ignore: cast_nullable_to_non_nullable
                  as double?,
        reviewsCount: freezed == reviewsCount
            ? _value.reviewsCount
            : reviewsCount // ignore: cast_nullable_to_non_nullable
                  as int?,
        images: freezed == images
            ? _value._images
            : images // ignore: cast_nullable_to_non_nullable
                  as List<String>?,
        galleryImages: freezed == galleryImages
            ? _value._galleryImages
            : galleryImages // ignore: cast_nullable_to_non_nullable
                  as List<String>?,
        scents: freezed == scents
            ? _value._scents
            : scents // ignore: cast_nullable_to_non_nullable
                  as List<Scent>?,
        createdAt: freezed == createdAt
            ? _value.createdAt
            : createdAt // ignore: cast_nullable_to_non_nullable
                  as DateTime?,
        updatedAt: freezed == updatedAt
            ? _value.updatedAt
            : updatedAt // ignore: cast_nullable_to_non_nullable
                  as DateTime?,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$PackageImpl implements _Package {
  const _$PackageImpl({
    this.id,
    this.name,
    this.description,
    final List<String>? inclusions,
    @JsonKey(name: 'pax_options') final List<int>? paxOptions,
    final List<String>? freebies,
    this.price,
    this.rating,
    @JsonKey(name: 'reviews_count') this.reviewsCount,
    final List<String>? images,
    @JsonKey(name: 'gallery_images') final List<String>? galleryImages,
    final List<Scent>? scents,
    @JsonKey(name: 'created_at') this.createdAt,
    @JsonKey(name: 'updated_at') this.updatedAt,
  }) : _inclusions = inclusions,
       _paxOptions = paxOptions,
       _freebies = freebies,
       _images = images,
       _galleryImages = galleryImages,
       _scents = scents;

  factory _$PackageImpl.fromJson(Map<String, dynamic> json) =>
      _$$PackageImplFromJson(json);

  @override
  final int? id;
  @override
  final String? name;
  @override
  final String? description;
  final List<String>? _inclusions;
  @override
  List<String>? get inclusions {
    final value = _inclusions;
    if (value == null) return null;
    if (_inclusions is EqualUnmodifiableListView) return _inclusions;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(value);
  }

  final List<int>? _paxOptions;
  @override
  @JsonKey(name: 'pax_options')
  List<int>? get paxOptions {
    final value = _paxOptions;
    if (value == null) return null;
    if (_paxOptions is EqualUnmodifiableListView) return _paxOptions;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(value);
  }

  final List<String>? _freebies;
  @override
  List<String>? get freebies {
    final value = _freebies;
    if (value == null) return null;
    if (_freebies is EqualUnmodifiableListView) return _freebies;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(value);
  }

  @override
  final double? price;
  @override
  final double? rating;
  @override
  @JsonKey(name: 'reviews_count')
  final int? reviewsCount;
  final List<String>? _images;
  @override
  List<String>? get images {
    final value = _images;
    if (value == null) return null;
    if (_images is EqualUnmodifiableListView) return _images;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(value);
  }

  final List<String>? _galleryImages;
  @override
  @JsonKey(name: 'gallery_images')
  List<String>? get galleryImages {
    final value = _galleryImages;
    if (value == null) return null;
    if (_galleryImages is EqualUnmodifiableListView) return _galleryImages;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(value);
  }

  final List<Scent>? _scents;
  @override
  List<Scent>? get scents {
    final value = _scents;
    if (value == null) return null;
    if (_scents is EqualUnmodifiableListView) return _scents;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(value);
  }

  @override
  @JsonKey(name: 'created_at')
  final DateTime? createdAt;
  @override
  @JsonKey(name: 'updated_at')
  final DateTime? updatedAt;

  @override
  String toString() {
    return 'Package(id: $id, name: $name, description: $description, inclusions: $inclusions, paxOptions: $paxOptions, freebies: $freebies, price: $price, rating: $rating, reviewsCount: $reviewsCount, images: $images, galleryImages: $galleryImages, scents: $scents, createdAt: $createdAt, updatedAt: $updatedAt)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$PackageImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.description, description) ||
                other.description == description) &&
            const DeepCollectionEquality().equals(
              other._inclusions,
              _inclusions,
            ) &&
            const DeepCollectionEquality().equals(
              other._paxOptions,
              _paxOptions,
            ) &&
            const DeepCollectionEquality().equals(other._freebies, _freebies) &&
            (identical(other.price, price) || other.price == price) &&
            (identical(other.rating, rating) || other.rating == rating) &&
            (identical(other.reviewsCount, reviewsCount) ||
                other.reviewsCount == reviewsCount) &&
            const DeepCollectionEquality().equals(other._images, _images) &&
            const DeepCollectionEquality().equals(
              other._galleryImages,
              _galleryImages,
            ) &&
            const DeepCollectionEquality().equals(other._scents, _scents) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            (identical(other.updatedAt, updatedAt) ||
                other.updatedAt == updatedAt));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    id,
    name,
    description,
    const DeepCollectionEquality().hash(_inclusions),
    const DeepCollectionEquality().hash(_paxOptions),
    const DeepCollectionEquality().hash(_freebies),
    price,
    rating,
    reviewsCount,
    const DeepCollectionEquality().hash(_images),
    const DeepCollectionEquality().hash(_galleryImages),
    const DeepCollectionEquality().hash(_scents),
    createdAt,
    updatedAt,
  );

  /// Create a copy of Package
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$PackageImplCopyWith<_$PackageImpl> get copyWith =>
      __$$PackageImplCopyWithImpl<_$PackageImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$PackageImplToJson(this);
  }
}

abstract class _Package implements Package {
  const factory _Package({
    final int? id,
    final String? name,
    final String? description,
    final List<String>? inclusions,
    @JsonKey(name: 'pax_options') final List<int>? paxOptions,
    final List<String>? freebies,
    final double? price,
    final double? rating,
    @JsonKey(name: 'reviews_count') final int? reviewsCount,
    final List<String>? images,
    @JsonKey(name: 'gallery_images') final List<String>? galleryImages,
    final List<Scent>? scents,
    @JsonKey(name: 'created_at') final DateTime? createdAt,
    @JsonKey(name: 'updated_at') final DateTime? updatedAt,
  }) = _$PackageImpl;

  factory _Package.fromJson(Map<String, dynamic> json) = _$PackageImpl.fromJson;

  @override
  int? get id;
  @override
  String? get name;
  @override
  String? get description;
  @override
  List<String>? get inclusions;
  @override
  @JsonKey(name: 'pax_options')
  List<int>? get paxOptions;
  @override
  List<String>? get freebies;
  @override
  double? get price;
  @override
  double? get rating;
  @override
  @JsonKey(name: 'reviews_count')
  int? get reviewsCount;
  @override
  List<String>? get images;
  @override
  @JsonKey(name: 'gallery_images')
  List<String>? get galleryImages;
  @override
  List<Scent>? get scents;
  @override
  @JsonKey(name: 'created_at')
  DateTime? get createdAt;
  @override
  @JsonKey(name: 'updated_at')
  DateTime? get updatedAt;

  /// Create a copy of Package
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$PackageImplCopyWith<_$PackageImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
