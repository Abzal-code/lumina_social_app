// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'local_post_changes.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$LocalPostChanges {

 List<Post> get createdPosts; Map<int, Post> get updatedPosts; Set<int> get deletedPostIds; int get nextLocalId;
/// Create a copy of LocalPostChanges
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$LocalPostChangesCopyWith<LocalPostChanges> get copyWith => _$LocalPostChangesCopyWithImpl<LocalPostChanges>(this as LocalPostChanges, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is LocalPostChanges&&const DeepCollectionEquality().equals(other.createdPosts, createdPosts)&&const DeepCollectionEquality().equals(other.updatedPosts, updatedPosts)&&const DeepCollectionEquality().equals(other.deletedPostIds, deletedPostIds)&&(identical(other.nextLocalId, nextLocalId) || other.nextLocalId == nextLocalId));
}


@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(createdPosts),const DeepCollectionEquality().hash(updatedPosts),const DeepCollectionEquality().hash(deletedPostIds),nextLocalId);

@override
String toString() {
  return 'LocalPostChanges(createdPosts: $createdPosts, updatedPosts: $updatedPosts, deletedPostIds: $deletedPostIds, nextLocalId: $nextLocalId)';
}


}

/// @nodoc
abstract mixin class $LocalPostChangesCopyWith<$Res>  {
  factory $LocalPostChangesCopyWith(LocalPostChanges value, $Res Function(LocalPostChanges) _then) = _$LocalPostChangesCopyWithImpl;
@useResult
$Res call({
 List<Post> createdPosts, Map<int, Post> updatedPosts, Set<int> deletedPostIds, int nextLocalId
});




}
/// @nodoc
class _$LocalPostChangesCopyWithImpl<$Res>
    implements $LocalPostChangesCopyWith<$Res> {
  _$LocalPostChangesCopyWithImpl(this._self, this._then);

  final LocalPostChanges _self;
  final $Res Function(LocalPostChanges) _then;

/// Create a copy of LocalPostChanges
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? createdPosts = null,Object? updatedPosts = null,Object? deletedPostIds = null,Object? nextLocalId = null,}) {
  return _then(_self.copyWith(
createdPosts: null == createdPosts ? _self.createdPosts : createdPosts // ignore: cast_nullable_to_non_nullable
as List<Post>,updatedPosts: null == updatedPosts ? _self.updatedPosts : updatedPosts // ignore: cast_nullable_to_non_nullable
as Map<int, Post>,deletedPostIds: null == deletedPostIds ? _self.deletedPostIds : deletedPostIds // ignore: cast_nullable_to_non_nullable
as Set<int>,nextLocalId: null == nextLocalId ? _self.nextLocalId : nextLocalId // ignore: cast_nullable_to_non_nullable
as int,
  ));
}

}


/// Adds pattern-matching-related methods to [LocalPostChanges].
extension LocalPostChangesPatterns on LocalPostChanges {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _LocalPostChanges value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _LocalPostChanges() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _LocalPostChanges value)  $default,){
final _that = this;
switch (_that) {
case _LocalPostChanges():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _LocalPostChanges value)?  $default,){
final _that = this;
switch (_that) {
case _LocalPostChanges() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( List<Post> createdPosts,  Map<int, Post> updatedPosts,  Set<int> deletedPostIds,  int nextLocalId)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _LocalPostChanges() when $default != null:
return $default(_that.createdPosts,_that.updatedPosts,_that.deletedPostIds,_that.nextLocalId);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( List<Post> createdPosts,  Map<int, Post> updatedPosts,  Set<int> deletedPostIds,  int nextLocalId)  $default,) {final _that = this;
switch (_that) {
case _LocalPostChanges():
return $default(_that.createdPosts,_that.updatedPosts,_that.deletedPostIds,_that.nextLocalId);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( List<Post> createdPosts,  Map<int, Post> updatedPosts,  Set<int> deletedPostIds,  int nextLocalId)?  $default,) {final _that = this;
switch (_that) {
case _LocalPostChanges() when $default != null:
return $default(_that.createdPosts,_that.updatedPosts,_that.deletedPostIds,_that.nextLocalId);case _:
  return null;

}
}

}

/// @nodoc


class _LocalPostChanges implements LocalPostChanges {
  const _LocalPostChanges({final  List<Post> createdPosts = const <Post>[], final  Map<int, Post> updatedPosts = const <int, Post>{}, final  Set<int> deletedPostIds = const <int>{}, this.nextLocalId = -1}): _createdPosts = createdPosts,_updatedPosts = updatedPosts,_deletedPostIds = deletedPostIds;
  

 final  List<Post> _createdPosts;
@override@JsonKey() List<Post> get createdPosts {
  if (_createdPosts is EqualUnmodifiableListView) return _createdPosts;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_createdPosts);
}

 final  Map<int, Post> _updatedPosts;
@override@JsonKey() Map<int, Post> get updatedPosts {
  if (_updatedPosts is EqualUnmodifiableMapView) return _updatedPosts;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableMapView(_updatedPosts);
}

 final  Set<int> _deletedPostIds;
@override@JsonKey() Set<int> get deletedPostIds {
  if (_deletedPostIds is EqualUnmodifiableSetView) return _deletedPostIds;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableSetView(_deletedPostIds);
}

@override@JsonKey() final  int nextLocalId;

/// Create a copy of LocalPostChanges
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$LocalPostChangesCopyWith<_LocalPostChanges> get copyWith => __$LocalPostChangesCopyWithImpl<_LocalPostChanges>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _LocalPostChanges&&const DeepCollectionEquality().equals(other._createdPosts, _createdPosts)&&const DeepCollectionEquality().equals(other._updatedPosts, _updatedPosts)&&const DeepCollectionEquality().equals(other._deletedPostIds, _deletedPostIds)&&(identical(other.nextLocalId, nextLocalId) || other.nextLocalId == nextLocalId));
}


@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(_createdPosts),const DeepCollectionEquality().hash(_updatedPosts),const DeepCollectionEquality().hash(_deletedPostIds),nextLocalId);

@override
String toString() {
  return 'LocalPostChanges(createdPosts: $createdPosts, updatedPosts: $updatedPosts, deletedPostIds: $deletedPostIds, nextLocalId: $nextLocalId)';
}


}

/// @nodoc
abstract mixin class _$LocalPostChangesCopyWith<$Res> implements $LocalPostChangesCopyWith<$Res> {
  factory _$LocalPostChangesCopyWith(_LocalPostChanges value, $Res Function(_LocalPostChanges) _then) = __$LocalPostChangesCopyWithImpl;
@override @useResult
$Res call({
 List<Post> createdPosts, Map<int, Post> updatedPosts, Set<int> deletedPostIds, int nextLocalId
});




}
/// @nodoc
class __$LocalPostChangesCopyWithImpl<$Res>
    implements _$LocalPostChangesCopyWith<$Res> {
  __$LocalPostChangesCopyWithImpl(this._self, this._then);

  final _LocalPostChanges _self;
  final $Res Function(_LocalPostChanges) _then;

/// Create a copy of LocalPostChanges
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? createdPosts = null,Object? updatedPosts = null,Object? deletedPostIds = null,Object? nextLocalId = null,}) {
  return _then(_LocalPostChanges(
createdPosts: null == createdPosts ? _self._createdPosts : createdPosts // ignore: cast_nullable_to_non_nullable
as List<Post>,updatedPosts: null == updatedPosts ? _self._updatedPosts : updatedPosts // ignore: cast_nullable_to_non_nullable
as Map<int, Post>,deletedPostIds: null == deletedPostIds ? _self._deletedPostIds : deletedPostIds // ignore: cast_nullable_to_non_nullable
as Set<int>,nextLocalId: null == nextLocalId ? _self.nextLocalId : nextLocalId // ignore: cast_nullable_to_non_nullable
as int,
  ));
}


}

// dart format on
