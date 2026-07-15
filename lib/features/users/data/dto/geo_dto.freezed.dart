// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'geo_dto.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$GeoDto {

 String get lat; String get lng;
/// Create a copy of GeoDto
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$GeoDtoCopyWith<GeoDto> get copyWith => _$GeoDtoCopyWithImpl<GeoDto>(this as GeoDto, _$identity);

  /// Serializes this GeoDto to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is GeoDto&&(identical(other.lat, lat) || other.lat == lat)&&(identical(other.lng, lng) || other.lng == lng));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,lat,lng);

@override
String toString() {
  return 'GeoDto(lat: $lat, lng: $lng)';
}


}

/// @nodoc
abstract mixin class $GeoDtoCopyWith<$Res>  {
  factory $GeoDtoCopyWith(GeoDto value, $Res Function(GeoDto) _then) = _$GeoDtoCopyWithImpl;
@useResult
$Res call({
 String lat, String lng
});




}
/// @nodoc
class _$GeoDtoCopyWithImpl<$Res>
    implements $GeoDtoCopyWith<$Res> {
  _$GeoDtoCopyWithImpl(this._self, this._then);

  final GeoDto _self;
  final $Res Function(GeoDto) _then;

/// Create a copy of GeoDto
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? lat = null,Object? lng = null,}) {
  return _then(_self.copyWith(
lat: null == lat ? _self.lat : lat // ignore: cast_nullable_to_non_nullable
as String,lng: null == lng ? _self.lng : lng // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

}


/// Adds pattern-matching-related methods to [GeoDto].
extension GeoDtoPatterns on GeoDto {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _GeoDto value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _GeoDto() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _GeoDto value)  $default,){
final _that = this;
switch (_that) {
case _GeoDto():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _GeoDto value)?  $default,){
final _that = this;
switch (_that) {
case _GeoDto() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String lat,  String lng)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _GeoDto() when $default != null:
return $default(_that.lat,_that.lng);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String lat,  String lng)  $default,) {final _that = this;
switch (_that) {
case _GeoDto():
return $default(_that.lat,_that.lng);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String lat,  String lng)?  $default,) {final _that = this;
switch (_that) {
case _GeoDto() when $default != null:
return $default(_that.lat,_that.lng);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _GeoDto implements GeoDto {
  const _GeoDto({required this.lat, required this.lng});
  factory _GeoDto.fromJson(Map<String, dynamic> json) => _$GeoDtoFromJson(json);

@override final  String lat;
@override final  String lng;

/// Create a copy of GeoDto
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$GeoDtoCopyWith<_GeoDto> get copyWith => __$GeoDtoCopyWithImpl<_GeoDto>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$GeoDtoToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _GeoDto&&(identical(other.lat, lat) || other.lat == lat)&&(identical(other.lng, lng) || other.lng == lng));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,lat,lng);

@override
String toString() {
  return 'GeoDto(lat: $lat, lng: $lng)';
}


}

/// @nodoc
abstract mixin class _$GeoDtoCopyWith<$Res> implements $GeoDtoCopyWith<$Res> {
  factory _$GeoDtoCopyWith(_GeoDto value, $Res Function(_GeoDto) _then) = __$GeoDtoCopyWithImpl;
@override @useResult
$Res call({
 String lat, String lng
});




}
/// @nodoc
class __$GeoDtoCopyWithImpl<$Res>
    implements _$GeoDtoCopyWith<$Res> {
  __$GeoDtoCopyWithImpl(this._self, this._then);

  final _GeoDto _self;
  final $Res Function(_GeoDto) _then;

/// Create a copy of GeoDto
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? lat = null,Object? lng = null,}) {
  return _then(_GeoDto(
lat: null == lat ? _self.lat : lat // ignore: cast_nullable_to_non_nullable
as String,lng: null == lng ? _self.lng : lng // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

// dart format on
