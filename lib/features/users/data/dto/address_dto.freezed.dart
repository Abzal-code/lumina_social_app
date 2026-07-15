// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'address_dto.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$AddressDto {

 String get street; String get suite; String get city; String get zipcode; GeoDto get geo;
/// Create a copy of AddressDto
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$AddressDtoCopyWith<AddressDto> get copyWith => _$AddressDtoCopyWithImpl<AddressDto>(this as AddressDto, _$identity);

  /// Serializes this AddressDto to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is AddressDto&&(identical(other.street, street) || other.street == street)&&(identical(other.suite, suite) || other.suite == suite)&&(identical(other.city, city) || other.city == city)&&(identical(other.zipcode, zipcode) || other.zipcode == zipcode)&&(identical(other.geo, geo) || other.geo == geo));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,street,suite,city,zipcode,geo);

@override
String toString() {
  return 'AddressDto(street: $street, suite: $suite, city: $city, zipcode: $zipcode, geo: $geo)';
}


}

/// @nodoc
abstract mixin class $AddressDtoCopyWith<$Res>  {
  factory $AddressDtoCopyWith(AddressDto value, $Res Function(AddressDto) _then) = _$AddressDtoCopyWithImpl;
@useResult
$Res call({
 String street, String suite, String city, String zipcode, GeoDto geo
});


$GeoDtoCopyWith<$Res> get geo;

}
/// @nodoc
class _$AddressDtoCopyWithImpl<$Res>
    implements $AddressDtoCopyWith<$Res> {
  _$AddressDtoCopyWithImpl(this._self, this._then);

  final AddressDto _self;
  final $Res Function(AddressDto) _then;

/// Create a copy of AddressDto
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? street = null,Object? suite = null,Object? city = null,Object? zipcode = null,Object? geo = null,}) {
  return _then(_self.copyWith(
street: null == street ? _self.street : street // ignore: cast_nullable_to_non_nullable
as String,suite: null == suite ? _self.suite : suite // ignore: cast_nullable_to_non_nullable
as String,city: null == city ? _self.city : city // ignore: cast_nullable_to_non_nullable
as String,zipcode: null == zipcode ? _self.zipcode : zipcode // ignore: cast_nullable_to_non_nullable
as String,geo: null == geo ? _self.geo : geo // ignore: cast_nullable_to_non_nullable
as GeoDto,
  ));
}
/// Create a copy of AddressDto
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$GeoDtoCopyWith<$Res> get geo {
  
  return $GeoDtoCopyWith<$Res>(_self.geo, (value) {
    return _then(_self.copyWith(geo: value));
  });
}
}


/// Adds pattern-matching-related methods to [AddressDto].
extension AddressDtoPatterns on AddressDto {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _AddressDto value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _AddressDto() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _AddressDto value)  $default,){
final _that = this;
switch (_that) {
case _AddressDto():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _AddressDto value)?  $default,){
final _that = this;
switch (_that) {
case _AddressDto() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String street,  String suite,  String city,  String zipcode,  GeoDto geo)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _AddressDto() when $default != null:
return $default(_that.street,_that.suite,_that.city,_that.zipcode,_that.geo);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String street,  String suite,  String city,  String zipcode,  GeoDto geo)  $default,) {final _that = this;
switch (_that) {
case _AddressDto():
return $default(_that.street,_that.suite,_that.city,_that.zipcode,_that.geo);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String street,  String suite,  String city,  String zipcode,  GeoDto geo)?  $default,) {final _that = this;
switch (_that) {
case _AddressDto() when $default != null:
return $default(_that.street,_that.suite,_that.city,_that.zipcode,_that.geo);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _AddressDto implements AddressDto {
  const _AddressDto({required this.street, required this.suite, required this.city, required this.zipcode, required this.geo});
  factory _AddressDto.fromJson(Map<String, dynamic> json) => _$AddressDtoFromJson(json);

@override final  String street;
@override final  String suite;
@override final  String city;
@override final  String zipcode;
@override final  GeoDto geo;

/// Create a copy of AddressDto
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$AddressDtoCopyWith<_AddressDto> get copyWith => __$AddressDtoCopyWithImpl<_AddressDto>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$AddressDtoToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _AddressDto&&(identical(other.street, street) || other.street == street)&&(identical(other.suite, suite) || other.suite == suite)&&(identical(other.city, city) || other.city == city)&&(identical(other.zipcode, zipcode) || other.zipcode == zipcode)&&(identical(other.geo, geo) || other.geo == geo));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,street,suite,city,zipcode,geo);

@override
String toString() {
  return 'AddressDto(street: $street, suite: $suite, city: $city, zipcode: $zipcode, geo: $geo)';
}


}

/// @nodoc
abstract mixin class _$AddressDtoCopyWith<$Res> implements $AddressDtoCopyWith<$Res> {
  factory _$AddressDtoCopyWith(_AddressDto value, $Res Function(_AddressDto) _then) = __$AddressDtoCopyWithImpl;
@override @useResult
$Res call({
 String street, String suite, String city, String zipcode, GeoDto geo
});


@override $GeoDtoCopyWith<$Res> get geo;

}
/// @nodoc
class __$AddressDtoCopyWithImpl<$Res>
    implements _$AddressDtoCopyWith<$Res> {
  __$AddressDtoCopyWithImpl(this._self, this._then);

  final _AddressDto _self;
  final $Res Function(_AddressDto) _then;

/// Create a copy of AddressDto
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? street = null,Object? suite = null,Object? city = null,Object? zipcode = null,Object? geo = null,}) {
  return _then(_AddressDto(
street: null == street ? _self.street : street // ignore: cast_nullable_to_non_nullable
as String,suite: null == suite ? _self.suite : suite // ignore: cast_nullable_to_non_nullable
as String,city: null == city ? _self.city : city // ignore: cast_nullable_to_non_nullable
as String,zipcode: null == zipcode ? _self.zipcode : zipcode // ignore: cast_nullable_to_non_nullable
as String,geo: null == geo ? _self.geo : geo // ignore: cast_nullable_to_non_nullable
as GeoDto,
  ));
}

/// Create a copy of AddressDto
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$GeoDtoCopyWith<$Res> get geo {
  
  return $GeoDtoCopyWith<$Res>(_self.geo, (value) {
    return _then(_self.copyWith(geo: value));
  });
}
}

// dart format on
