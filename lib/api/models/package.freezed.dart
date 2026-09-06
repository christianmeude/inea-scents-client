// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'package.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$Package {

@JsonKey(fromJson: parseIntTolerant) int? get id; String? get name; String? get description;@JsonKey(fromJson: parseStringList) List<String>? get inclusions;@JsonKey(name: 'pax_options', fromJson: parseIntList) List<int>? get paxOptions;@JsonKey(fromJson: parseStringList) List<String>? get freebies;@JsonKey(fromJson: parseDoubleTolerant) double? get price;@JsonKey(fromJson: parseDoubleTolerant) double? get rating;@JsonKey(name: 'reviews_count', fromJson: parseIntTolerant) int? get reviewsCount;@JsonKey(fromJson: parseStringList) List<String>? get images;@JsonKey(name: 'gallery_images', fromJson: parseStringList) List<String>? get galleryImages;@JsonKey(fromJson: parseScentList) List<Scent>? get scents;@JsonKey(name: 'created_at') DateTime? get createdAt;@JsonKey(name: 'updated_at') DateTime? get updatedAt;
/// Create a copy of Package
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$PackageCopyWith<Package> get copyWith => _$PackageCopyWithImpl<Package>(this as Package, _$identity);

  /// Serializes this Package to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is Package&&(identical(other.id, id) || other.id == id)&&(identical(other.name, name) || other.name == name)&&(identical(other.description, description) || other.description == description)&&const DeepCollectionEquality().equals(other.inclusions, inclusions)&&const DeepCollectionEquality().equals(other.paxOptions, paxOptions)&&const DeepCollectionEquality().equals(other.freebies, freebies)&&(identical(other.price, price) || other.price == price)&&(identical(other.rating, rating) || other.rating == rating)&&(identical(other.reviewsCount, reviewsCount) || other.reviewsCount == reviewsCount)&&const DeepCollectionEquality().equals(other.images, images)&&const DeepCollectionEquality().equals(other.galleryImages, galleryImages)&&const DeepCollectionEquality().equals(other.scents, scents)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.updatedAt, updatedAt) || other.updatedAt == updatedAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,name,description,const DeepCollectionEquality().hash(inclusions),const DeepCollectionEquality().hash(paxOptions),const DeepCollectionEquality().hash(freebies),price,rating,reviewsCount,const DeepCollectionEquality().hash(images),const DeepCollectionEquality().hash(galleryImages),const DeepCollectionEquality().hash(scents),createdAt,updatedAt);

@override
String toString() {
  return 'Package(id: $id, name: $name, description: $description, inclusions: $inclusions, paxOptions: $paxOptions, freebies: $freebies, price: $price, rating: $rating, reviewsCount: $reviewsCount, images: $images, galleryImages: $galleryImages, scents: $scents, createdAt: $createdAt, updatedAt: $updatedAt)';
}


}

/// @nodoc
abstract mixin class $PackageCopyWith<$Res>  {
  factory $PackageCopyWith(Package value, $Res Function(Package) _then) = _$PackageCopyWithImpl;
@useResult
$Res call({
@JsonKey(fromJson: parseIntTolerant) int? id, String? name, String? description,@JsonKey(fromJson: parseStringList) List<String>? inclusions,@JsonKey(name: 'pax_options', fromJson: parseIntList) List<int>? paxOptions,@JsonKey(fromJson: parseStringList) List<String>? freebies,@JsonKey(fromJson: parseDoubleTolerant) double? price,@JsonKey(fromJson: parseDoubleTolerant) double? rating,@JsonKey(name: 'reviews_count', fromJson: parseIntTolerant) int? reviewsCount,@JsonKey(fromJson: parseStringList) List<String>? images,@JsonKey(name: 'gallery_images', fromJson: parseStringList) List<String>? galleryImages,@JsonKey(fromJson: parseScentList) List<Scent>? scents,@JsonKey(name: 'created_at') DateTime? createdAt,@JsonKey(name: 'updated_at') DateTime? updatedAt
});




}
/// @nodoc
class _$PackageCopyWithImpl<$Res>
    implements $PackageCopyWith<$Res> {
  _$PackageCopyWithImpl(this._self, this._then);

  final Package _self;
  final $Res Function(Package) _then;

/// Create a copy of Package
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = freezed,Object? name = freezed,Object? description = freezed,Object? inclusions = freezed,Object? paxOptions = freezed,Object? freebies = freezed,Object? price = freezed,Object? rating = freezed,Object? reviewsCount = freezed,Object? images = freezed,Object? galleryImages = freezed,Object? scents = freezed,Object? createdAt = freezed,Object? updatedAt = freezed,}) {
  return _then(_self.copyWith(
id: freezed == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int?,name: freezed == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String?,description: freezed == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String?,inclusions: freezed == inclusions ? _self.inclusions : inclusions // ignore: cast_nullable_to_non_nullable
as List<String>?,paxOptions: freezed == paxOptions ? _self.paxOptions : paxOptions // ignore: cast_nullable_to_non_nullable
as List<int>?,freebies: freezed == freebies ? _self.freebies : freebies // ignore: cast_nullable_to_non_nullable
as List<String>?,price: freezed == price ? _self.price : price // ignore: cast_nullable_to_non_nullable
as double?,rating: freezed == rating ? _self.rating : rating // ignore: cast_nullable_to_non_nullable
as double?,reviewsCount: freezed == reviewsCount ? _self.reviewsCount : reviewsCount // ignore: cast_nullable_to_non_nullable
as int?,images: freezed == images ? _self.images : images // ignore: cast_nullable_to_non_nullable
as List<String>?,galleryImages: freezed == galleryImages ? _self.galleryImages : galleryImages // ignore: cast_nullable_to_non_nullable
as List<String>?,scents: freezed == scents ? _self.scents : scents // ignore: cast_nullable_to_non_nullable
as List<Scent>?,createdAt: freezed == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime?,updatedAt: freezed == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,
  ));
}

}


/// Adds pattern-matching-related methods to [Package].
extension PackagePatterns on Package {
/// A variant of `map` that fallback to returning `orElse`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _Package value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _Package() when $default != null:
return $default(_that);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// Callbacks receives the raw object, upcasted.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case final Subclass2 value:
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _Package value)  $default,){
final _that = this;
switch (_that) {
case _Package():
return $default(_that);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `map` that fallback to returning `null`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _Package value)?  $default,){
final _that = this;
switch (_that) {
case _Package() when $default != null:
return $default(_that);case _:
  return null;

}
}
/// A variant of `when` that fallback to an `orElse` callback.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function(@JsonKey(fromJson: parseIntTolerant)  int? id,  String? name,  String? description, @JsonKey(fromJson: parseStringList)  List<String>? inclusions, @JsonKey(name: 'pax_options', fromJson: parseIntList)  List<int>? paxOptions, @JsonKey(fromJson: parseStringList)  List<String>? freebies, @JsonKey(fromJson: parseDoubleTolerant)  double? price, @JsonKey(fromJson: parseDoubleTolerant)  double? rating, @JsonKey(name: 'reviews_count', fromJson: parseIntTolerant)  int? reviewsCount, @JsonKey(fromJson: parseStringList)  List<String>? images, @JsonKey(name: 'gallery_images', fromJson: parseStringList)  List<String>? galleryImages, @JsonKey(fromJson: parseScentList)  List<Scent>? scents, @JsonKey(name: 'created_at')  DateTime? createdAt, @JsonKey(name: 'updated_at')  DateTime? updatedAt)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _Package() when $default != null:
return $default(_that.id,_that.name,_that.description,_that.inclusions,_that.paxOptions,_that.freebies,_that.price,_that.rating,_that.reviewsCount,_that.images,_that.galleryImages,_that.scents,_that.createdAt,_that.updatedAt);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// As opposed to `map`, this offers destructuring.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case Subclass2(:final field2):
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function(@JsonKey(fromJson: parseIntTolerant)  int? id,  String? name,  String? description, @JsonKey(fromJson: parseStringList)  List<String>? inclusions, @JsonKey(name: 'pax_options', fromJson: parseIntList)  List<int>? paxOptions, @JsonKey(fromJson: parseStringList)  List<String>? freebies, @JsonKey(fromJson: parseDoubleTolerant)  double? price, @JsonKey(fromJson: parseDoubleTolerant)  double? rating, @JsonKey(name: 'reviews_count', fromJson: parseIntTolerant)  int? reviewsCount, @JsonKey(fromJson: parseStringList)  List<String>? images, @JsonKey(name: 'gallery_images', fromJson: parseStringList)  List<String>? galleryImages, @JsonKey(fromJson: parseScentList)  List<Scent>? scents, @JsonKey(name: 'created_at')  DateTime? createdAt, @JsonKey(name: 'updated_at')  DateTime? updatedAt)  $default,) {final _that = this;
switch (_that) {
case _Package():
return $default(_that.id,_that.name,_that.description,_that.inclusions,_that.paxOptions,_that.freebies,_that.price,_that.rating,_that.reviewsCount,_that.images,_that.galleryImages,_that.scents,_that.createdAt,_that.updatedAt);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `when` that fallback to returning `null`
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function(@JsonKey(fromJson: parseIntTolerant)  int? id,  String? name,  String? description, @JsonKey(fromJson: parseStringList)  List<String>? inclusions, @JsonKey(name: 'pax_options', fromJson: parseIntList)  List<int>? paxOptions, @JsonKey(fromJson: parseStringList)  List<String>? freebies, @JsonKey(fromJson: parseDoubleTolerant)  double? price, @JsonKey(fromJson: parseDoubleTolerant)  double? rating, @JsonKey(name: 'reviews_count', fromJson: parseIntTolerant)  int? reviewsCount, @JsonKey(fromJson: parseStringList)  List<String>? images, @JsonKey(name: 'gallery_images', fromJson: parseStringList)  List<String>? galleryImages, @JsonKey(fromJson: parseScentList)  List<Scent>? scents, @JsonKey(name: 'created_at')  DateTime? createdAt, @JsonKey(name: 'updated_at')  DateTime? updatedAt)?  $default,) {final _that = this;
switch (_that) {
case _Package() when $default != null:
return $default(_that.id,_that.name,_that.description,_that.inclusions,_that.paxOptions,_that.freebies,_that.price,_that.rating,_that.reviewsCount,_that.images,_that.galleryImages,_that.scents,_that.createdAt,_that.updatedAt);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _Package implements Package {
  const _Package({@JsonKey(fromJson: parseIntTolerant) this.id, this.name, this.description, @JsonKey(fromJson: parseStringList) final  List<String>? inclusions, @JsonKey(name: 'pax_options', fromJson: parseIntList) final  List<int>? paxOptions, @JsonKey(fromJson: parseStringList) final  List<String>? freebies, @JsonKey(fromJson: parseDoubleTolerant) this.price, @JsonKey(fromJson: parseDoubleTolerant) this.rating, @JsonKey(name: 'reviews_count', fromJson: parseIntTolerant) this.reviewsCount, @JsonKey(fromJson: parseStringList) final  List<String>? images, @JsonKey(name: 'gallery_images', fromJson: parseStringList) final  List<String>? galleryImages, @JsonKey(fromJson: parseScentList) final  List<Scent>? scents, @JsonKey(name: 'created_at') this.createdAt, @JsonKey(name: 'updated_at') this.updatedAt}): _inclusions = inclusions,_paxOptions = paxOptions,_freebies = freebies,_images = images,_galleryImages = galleryImages,_scents = scents;
  factory _Package.fromJson(Map<String, dynamic> json) => _$PackageFromJson(json);

@override@JsonKey(fromJson: parseIntTolerant) final  int? id;
@override final  String? name;
@override final  String? description;
 final  List<String>? _inclusions;
@override@JsonKey(fromJson: parseStringList) List<String>? get inclusions {
  final value = _inclusions;
  if (value == null) return null;
  if (_inclusions is EqualUnmodifiableListView) return _inclusions;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(value);
}

 final  List<int>? _paxOptions;
@override@JsonKey(name: 'pax_options', fromJson: parseIntList) List<int>? get paxOptions {
  final value = _paxOptions;
  if (value == null) return null;
  if (_paxOptions is EqualUnmodifiableListView) return _paxOptions;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(value);
}

 final  List<String>? _freebies;
@override@JsonKey(fromJson: parseStringList) List<String>? get freebies {
  final value = _freebies;
  if (value == null) return null;
  if (_freebies is EqualUnmodifiableListView) return _freebies;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(value);
}

@override@JsonKey(fromJson: parseDoubleTolerant) final  double? price;
@override@JsonKey(fromJson: parseDoubleTolerant) final  double? rating;
@override@JsonKey(name: 'reviews_count', fromJson: parseIntTolerant) final  int? reviewsCount;
 final  List<String>? _images;
@override@JsonKey(fromJson: parseStringList) List<String>? get images {
  final value = _images;
  if (value == null) return null;
  if (_images is EqualUnmodifiableListView) return _images;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(value);
}

 final  List<String>? _galleryImages;
@override@JsonKey(name: 'gallery_images', fromJson: parseStringList) List<String>? get galleryImages {
  final value = _galleryImages;
  if (value == null) return null;
  if (_galleryImages is EqualUnmodifiableListView) return _galleryImages;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(value);
}

 final  List<Scent>? _scents;
@override@JsonKey(fromJson: parseScentList) List<Scent>? get scents {
  final value = _scents;
  if (value == null) return null;
  if (_scents is EqualUnmodifiableListView) return _scents;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(value);
}

@override@JsonKey(name: 'created_at') final  DateTime? createdAt;
@override@JsonKey(name: 'updated_at') final  DateTime? updatedAt;

/// Create a copy of Package
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$PackageCopyWith<_Package> get copyWith => __$PackageCopyWithImpl<_Package>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$PackageToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _Package&&(identical(other.id, id) || other.id == id)&&(identical(other.name, name) || other.name == name)&&(identical(other.description, description) || other.description == description)&&const DeepCollectionEquality().equals(other._inclusions, _inclusions)&&const DeepCollectionEquality().equals(other._paxOptions, _paxOptions)&&const DeepCollectionEquality().equals(other._freebies, _freebies)&&(identical(other.price, price) || other.price == price)&&(identical(other.rating, rating) || other.rating == rating)&&(identical(other.reviewsCount, reviewsCount) || other.reviewsCount == reviewsCount)&&const DeepCollectionEquality().equals(other._images, _images)&&const DeepCollectionEquality().equals(other._galleryImages, _galleryImages)&&const DeepCollectionEquality().equals(other._scents, _scents)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.updatedAt, updatedAt) || other.updatedAt == updatedAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,name,description,const DeepCollectionEquality().hash(_inclusions),const DeepCollectionEquality().hash(_paxOptions),const DeepCollectionEquality().hash(_freebies),price,rating,reviewsCount,const DeepCollectionEquality().hash(_images),const DeepCollectionEquality().hash(_galleryImages),const DeepCollectionEquality().hash(_scents),createdAt,updatedAt);

@override
String toString() {
  return 'Package(id: $id, name: $name, description: $description, inclusions: $inclusions, paxOptions: $paxOptions, freebies: $freebies, price: $price, rating: $rating, reviewsCount: $reviewsCount, images: $images, galleryImages: $galleryImages, scents: $scents, createdAt: $createdAt, updatedAt: $updatedAt)';
}


}

/// @nodoc
abstract mixin class _$PackageCopyWith<$Res> implements $PackageCopyWith<$Res> {
  factory _$PackageCopyWith(_Package value, $Res Function(_Package) _then) = __$PackageCopyWithImpl;
@override @useResult
$Res call({
@JsonKey(fromJson: parseIntTolerant) int? id, String? name, String? description,@JsonKey(fromJson: parseStringList) List<String>? inclusions,@JsonKey(name: 'pax_options', fromJson: parseIntList) List<int>? paxOptions,@JsonKey(fromJson: parseStringList) List<String>? freebies,@JsonKey(fromJson: parseDoubleTolerant) double? price,@JsonKey(fromJson: parseDoubleTolerant) double? rating,@JsonKey(name: 'reviews_count', fromJson: parseIntTolerant) int? reviewsCount,@JsonKey(fromJson: parseStringList) List<String>? images,@JsonKey(name: 'gallery_images', fromJson: parseStringList) List<String>? galleryImages,@JsonKey(fromJson: parseScentList) List<Scent>? scents,@JsonKey(name: 'created_at') DateTime? createdAt,@JsonKey(name: 'updated_at') DateTime? updatedAt
});




}
/// @nodoc
class __$PackageCopyWithImpl<$Res>
    implements _$PackageCopyWith<$Res> {
  __$PackageCopyWithImpl(this._self, this._then);

  final _Package _self;
  final $Res Function(_Package) _then;

/// Create a copy of Package
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = freezed,Object? name = freezed,Object? description = freezed,Object? inclusions = freezed,Object? paxOptions = freezed,Object? freebies = freezed,Object? price = freezed,Object? rating = freezed,Object? reviewsCount = freezed,Object? images = freezed,Object? galleryImages = freezed,Object? scents = freezed,Object? createdAt = freezed,Object? updatedAt = freezed,}) {
  return _then(_Package(
id: freezed == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int?,name: freezed == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String?,description: freezed == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String?,inclusions: freezed == inclusions ? _self._inclusions : inclusions // ignore: cast_nullable_to_non_nullable
as List<String>?,paxOptions: freezed == paxOptions ? _self._paxOptions : paxOptions // ignore: cast_nullable_to_non_nullable
as List<int>?,freebies: freezed == freebies ? _self._freebies : freebies // ignore: cast_nullable_to_non_nullable
as List<String>?,price: freezed == price ? _self.price : price // ignore: cast_nullable_to_non_nullable
as double?,rating: freezed == rating ? _self.rating : rating // ignore: cast_nullable_to_non_nullable
as double?,reviewsCount: freezed == reviewsCount ? _self.reviewsCount : reviewsCount // ignore: cast_nullable_to_non_nullable
as int?,images: freezed == images ? _self._images : images // ignore: cast_nullable_to_non_nullable
as List<String>?,galleryImages: freezed == galleryImages ? _self._galleryImages : galleryImages // ignore: cast_nullable_to_non_nullable
as List<String>?,scents: freezed == scents ? _self._scents : scents // ignore: cast_nullable_to_non_nullable
as List<Scent>?,createdAt: freezed == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime?,updatedAt: freezed == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,
  ));
}


}

// dart format on
