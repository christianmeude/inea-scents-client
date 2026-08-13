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
  int get id => throw _privateConstructorUsedError;
  String get name => throw _privateConstructorUsedError;
  String get description => throw _privateConstructorUsedError;
  List<String> get inclusions => throw _privateConstructorUsedError;
  List<int> get pax_options => throw _privateConstructorUsedError;
  List<String> get freebies => throw _privateConstructorUsedError;
  double get price => throw _privateConstructorUsedError;
  double get rating => throw _privateConstructorUsedError;
  int get reviews_count => throw _privateConstructorUsedError;
  List<String> get images => throw _privateConstructorUsedError;
  List<String> get gallery_images => throw _privateConstructorUsedError;
  List<Scent> get scents => throw _privateConstructorUsedError;
  String get created_at => throw _privateConstructorUsedError;
  String get updated_at => throw _privateConstructorUsedError;

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
    int id,
    String name,
    String description,
    List<String> inclusions,
    List<int> pax_options,
    List<String> freebies,
    double price,
    double rating,
    int reviews_count,
    List<String> images,
    List<String> gallery_images,
    List<Scent> scents,
    String created_at,
    String updated_at,
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
    Object? id = null,
    Object? name = null,
    Object? description = null,
    Object? inclusions = null,
    Object? pax_options = null,
    Object? freebies = null,
    Object? price = null,
    Object? rating = null,
    Object? reviews_count = null,
    Object? images = null,
    Object? gallery_images = null,
    Object? scents = null,
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
            inclusions: null == inclusions
                ? _value.inclusions
                : inclusions // ignore: cast_nullable_to_non_nullable
                      as List<String>,
            pax_options: null == pax_options
                ? _value.pax_options
                : pax_options // ignore: cast_nullable_to_non_nullable
                      as List<int>,
            freebies: null == freebies
                ? _value.freebies
                : freebies // ignore: cast_nullable_to_non_nullable
                      as List<String>,
            price: null == price
                ? _value.price
                : price // ignore: cast_nullable_to_non_nullable
                      as double,
            rating: null == rating
                ? _value.rating
                : rating // ignore: cast_nullable_to_non_nullable
                      as double,
            reviews_count: null == reviews_count
                ? _value.reviews_count
                : reviews_count // ignore: cast_nullable_to_non_nullable
                      as int,
            images: null == images
                ? _value.images
                : images // ignore: cast_nullable_to_non_nullable
                      as List<String>,
            gallery_images: null == gallery_images
                ? _value.gallery_images
                : gallery_images // ignore: cast_nullable_to_non_nullable
                      as List<String>,
            scents: null == scents
                ? _value.scents
                : scents // ignore: cast_nullable_to_non_nullable
                      as List<Scent>,
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
abstract class _$$PackageImplCopyWith<$Res> implements $PackageCopyWith<$Res> {
  factory _$$PackageImplCopyWith(
    _$PackageImpl value,
    $Res Function(_$PackageImpl) then,
  ) = __$$PackageImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    int id,
    String name,
    String description,
    List<String> inclusions,
    List<int> pax_options,
    List<String> freebies,
    double price,
    double rating,
    int reviews_count,
    List<String> images,
    List<String> gallery_images,
    List<Scent> scents,
    String created_at,
    String updated_at,
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
    Object? id = null,
    Object? name = null,
    Object? description = null,
    Object? inclusions = null,
    Object? pax_options = null,
    Object? freebies = null,
    Object? price = null,
    Object? rating = null,
    Object? reviews_count = null,
    Object? images = null,
    Object? gallery_images = null,
    Object? scents = null,
    Object? created_at = null,
    Object? updated_at = null,
  }) {
    return _then(
      _$PackageImpl(
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
        inclusions: null == inclusions
            ? _value._inclusions
            : inclusions // ignore: cast_nullable_to_non_nullable
                  as List<String>,
        pax_options: null == pax_options
            ? _value._pax_options
            : pax_options // ignore: cast_nullable_to_non_nullable
                  as List<int>,
        freebies: null == freebies
            ? _value._freebies
            : freebies // ignore: cast_nullable_to_non_nullable
                  as List<String>,
        price: null == price
            ? _value.price
            : price // ignore: cast_nullable_to_non_nullable
                  as double,
        rating: null == rating
            ? _value.rating
            : rating // ignore: cast_nullable_to_non_nullable
                  as double,
        reviews_count: null == reviews_count
            ? _value.reviews_count
            : reviews_count // ignore: cast_nullable_to_non_nullable
                  as int,
        images: null == images
            ? _value._images
            : images // ignore: cast_nullable_to_non_nullable
                  as List<String>,
        gallery_images: null == gallery_images
            ? _value._gallery_images
            : gallery_images // ignore: cast_nullable_to_non_nullable
                  as List<String>,
        scents: null == scents
            ? _value._scents
            : scents // ignore: cast_nullable_to_non_nullable
                  as List<Scent>,
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
class _$PackageImpl implements _Package {
  const _$PackageImpl({
    required this.id,
    required this.name,
    required this.description,
    required final List<String> inclusions,
    required final List<int> pax_options,
    required final List<String> freebies,
    required this.price,
    required this.rating,
    required this.reviews_count,
    required final List<String> images,
    required final List<String> gallery_images,
    required final List<Scent> scents,
    required this.created_at,
    required this.updated_at,
  }) : _inclusions = inclusions,
       _pax_options = pax_options,
       _freebies = freebies,
       _images = images,
       _gallery_images = gallery_images,
       _scents = scents;

  factory _$PackageImpl.fromJson(Map<String, dynamic> json) =>
      _$$PackageImplFromJson(json);

  @override
  final int id;
  @override
  final String name;
  @override
  final String description;
  final List<String> _inclusions;
  @override
  List<String> get inclusions {
    if (_inclusions is EqualUnmodifiableListView) return _inclusions;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_inclusions);
  }

  final List<int> _pax_options;
  @override
  List<int> get pax_options {
    if (_pax_options is EqualUnmodifiableListView) return _pax_options;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_pax_options);
  }

  final List<String> _freebies;
  @override
  List<String> get freebies {
    if (_freebies is EqualUnmodifiableListView) return _freebies;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_freebies);
  }

  @override
  final double price;
  @override
  final double rating;
  @override
  final int reviews_count;
  final List<String> _images;
  @override
  List<String> get images {
    if (_images is EqualUnmodifiableListView) return _images;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_images);
  }

  final List<String> _gallery_images;
  @override
  List<String> get gallery_images {
    if (_gallery_images is EqualUnmodifiableListView) return _gallery_images;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_gallery_images);
  }

  final List<Scent> _scents;
  @override
  List<Scent> get scents {
    if (_scents is EqualUnmodifiableListView) return _scents;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_scents);
  }

  @override
  final String created_at;
  @override
  final String updated_at;

  @override
  String toString() {
    return 'Package(id: $id, name: $name, description: $description, inclusions: $inclusions, pax_options: $pax_options, freebies: $freebies, price: $price, rating: $rating, reviews_count: $reviews_count, images: $images, gallery_images: $gallery_images, scents: $scents, created_at: $created_at, updated_at: $updated_at)';
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
              other._pax_options,
              _pax_options,
            ) &&
            const DeepCollectionEquality().equals(other._freebies, _freebies) &&
            (identical(other.price, price) || other.price == price) &&
            (identical(other.rating, rating) || other.rating == rating) &&
            (identical(other.reviews_count, reviews_count) ||
                other.reviews_count == reviews_count) &&
            const DeepCollectionEquality().equals(other._images, _images) &&
            const DeepCollectionEquality().equals(
              other._gallery_images,
              _gallery_images,
            ) &&
            const DeepCollectionEquality().equals(other._scents, _scents) &&
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
    const DeepCollectionEquality().hash(_inclusions),
    const DeepCollectionEquality().hash(_pax_options),
    const DeepCollectionEquality().hash(_freebies),
    price,
    rating,
    reviews_count,
    const DeepCollectionEquality().hash(_images),
    const DeepCollectionEquality().hash(_gallery_images),
    const DeepCollectionEquality().hash(_scents),
    created_at,
    updated_at,
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
    required final int id,
    required final String name,
    required final String description,
    required final List<String> inclusions,
    required final List<int> pax_options,
    required final List<String> freebies,
    required final double price,
    required final double rating,
    required final int reviews_count,
    required final List<String> images,
    required final List<String> gallery_images,
    required final List<Scent> scents,
    required final String created_at,
    required final String updated_at,
  }) = _$PackageImpl;

  factory _Package.fromJson(Map<String, dynamic> json) = _$PackageImpl.fromJson;

  @override
  int get id;
  @override
  String get name;
  @override
  String get description;
  @override
  List<String> get inclusions;
  @override
  List<int> get pax_options;
  @override
  List<String> get freebies;
  @override
  double get price;
  @override
  double get rating;
  @override
  int get reviews_count;
  @override
  List<String> get images;
  @override
  List<String> get gallery_images;
  @override
  List<Scent> get scents;
  @override
  String get created_at;
  @override
  String get updated_at;

  /// Create a copy of Package
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$PackageImplCopyWith<_$PackageImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
