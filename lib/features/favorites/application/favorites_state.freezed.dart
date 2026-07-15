// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'favorites_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$FavoritesState {

 Set<int> get favoritePostIds; bool get isInitialLoading; int? get updatingPostId; AppFailure? get failure; AppFailure? get toggleFailure;
/// Create a copy of FavoritesState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$FavoritesStateCopyWith<FavoritesState> get copyWith => _$FavoritesStateCopyWithImpl<FavoritesState>(this as FavoritesState, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is FavoritesState&&const DeepCollectionEquality().equals(other.favoritePostIds, favoritePostIds)&&(identical(other.isInitialLoading, isInitialLoading) || other.isInitialLoading == isInitialLoading)&&(identical(other.updatingPostId, updatingPostId) || other.updatingPostId == updatingPostId)&&(identical(other.failure, failure) || other.failure == failure)&&(identical(other.toggleFailure, toggleFailure) || other.toggleFailure == toggleFailure));
}


@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(favoritePostIds),isInitialLoading,updatingPostId,failure,toggleFailure);

@override
String toString() {
  return 'FavoritesState(favoritePostIds: $favoritePostIds, isInitialLoading: $isInitialLoading, updatingPostId: $updatingPostId, failure: $failure, toggleFailure: $toggleFailure)';
}


}

/// @nodoc
abstract mixin class $FavoritesStateCopyWith<$Res>  {
  factory $FavoritesStateCopyWith(FavoritesState value, $Res Function(FavoritesState) _then) = _$FavoritesStateCopyWithImpl;
@useResult
$Res call({
 Set<int> favoritePostIds, bool isInitialLoading, int? updatingPostId, AppFailure? failure, AppFailure? toggleFailure
});




}
/// @nodoc
class _$FavoritesStateCopyWithImpl<$Res>
    implements $FavoritesStateCopyWith<$Res> {
  _$FavoritesStateCopyWithImpl(this._self, this._then);

  final FavoritesState _self;
  final $Res Function(FavoritesState) _then;

/// Create a copy of FavoritesState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? favoritePostIds = null,Object? isInitialLoading = null,Object? updatingPostId = freezed,Object? failure = freezed,Object? toggleFailure = freezed,}) {
  return _then(_self.copyWith(
favoritePostIds: null == favoritePostIds ? _self.favoritePostIds : favoritePostIds // ignore: cast_nullable_to_non_nullable
as Set<int>,isInitialLoading: null == isInitialLoading ? _self.isInitialLoading : isInitialLoading // ignore: cast_nullable_to_non_nullable
as bool,updatingPostId: freezed == updatingPostId ? _self.updatingPostId : updatingPostId // ignore: cast_nullable_to_non_nullable
as int?,failure: freezed == failure ? _self.failure : failure // ignore: cast_nullable_to_non_nullable
as AppFailure?,toggleFailure: freezed == toggleFailure ? _self.toggleFailure : toggleFailure // ignore: cast_nullable_to_non_nullable
as AppFailure?,
  ));
}

}


/// Adds pattern-matching-related methods to [FavoritesState].
extension FavoritesStatePatterns on FavoritesState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _FavoritesState value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _FavoritesState() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _FavoritesState value)  $default,){
final _that = this;
switch (_that) {
case _FavoritesState():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _FavoritesState value)?  $default,){
final _that = this;
switch (_that) {
case _FavoritesState() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( Set<int> favoritePostIds,  bool isInitialLoading,  int? updatingPostId,  AppFailure? failure,  AppFailure? toggleFailure)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _FavoritesState() when $default != null:
return $default(_that.favoritePostIds,_that.isInitialLoading,_that.updatingPostId,_that.failure,_that.toggleFailure);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( Set<int> favoritePostIds,  bool isInitialLoading,  int? updatingPostId,  AppFailure? failure,  AppFailure? toggleFailure)  $default,) {final _that = this;
switch (_that) {
case _FavoritesState():
return $default(_that.favoritePostIds,_that.isInitialLoading,_that.updatingPostId,_that.failure,_that.toggleFailure);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( Set<int> favoritePostIds,  bool isInitialLoading,  int? updatingPostId,  AppFailure? failure,  AppFailure? toggleFailure)?  $default,) {final _that = this;
switch (_that) {
case _FavoritesState() when $default != null:
return $default(_that.favoritePostIds,_that.isInitialLoading,_that.updatingPostId,_that.failure,_that.toggleFailure);case _:
  return null;

}
}

}

/// @nodoc


class _FavoritesState extends FavoritesState {
  const _FavoritesState({final  Set<int> favoritePostIds = const <int>{}, this.isInitialLoading = false, this.updatingPostId, this.failure, this.toggleFailure}): _favoritePostIds = favoritePostIds,super._();
  

 final  Set<int> _favoritePostIds;
@override@JsonKey() Set<int> get favoritePostIds {
  if (_favoritePostIds is EqualUnmodifiableSetView) return _favoritePostIds;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableSetView(_favoritePostIds);
}

@override@JsonKey() final  bool isInitialLoading;
@override final  int? updatingPostId;
@override final  AppFailure? failure;
@override final  AppFailure? toggleFailure;

/// Create a copy of FavoritesState
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$FavoritesStateCopyWith<_FavoritesState> get copyWith => __$FavoritesStateCopyWithImpl<_FavoritesState>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _FavoritesState&&const DeepCollectionEquality().equals(other._favoritePostIds, _favoritePostIds)&&(identical(other.isInitialLoading, isInitialLoading) || other.isInitialLoading == isInitialLoading)&&(identical(other.updatingPostId, updatingPostId) || other.updatingPostId == updatingPostId)&&(identical(other.failure, failure) || other.failure == failure)&&(identical(other.toggleFailure, toggleFailure) || other.toggleFailure == toggleFailure));
}


@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(_favoritePostIds),isInitialLoading,updatingPostId,failure,toggleFailure);

@override
String toString() {
  return 'FavoritesState(favoritePostIds: $favoritePostIds, isInitialLoading: $isInitialLoading, updatingPostId: $updatingPostId, failure: $failure, toggleFailure: $toggleFailure)';
}


}

/// @nodoc
abstract mixin class _$FavoritesStateCopyWith<$Res> implements $FavoritesStateCopyWith<$Res> {
  factory _$FavoritesStateCopyWith(_FavoritesState value, $Res Function(_FavoritesState) _then) = __$FavoritesStateCopyWithImpl;
@override @useResult
$Res call({
 Set<int> favoritePostIds, bool isInitialLoading, int? updatingPostId, AppFailure? failure, AppFailure? toggleFailure
});




}
/// @nodoc
class __$FavoritesStateCopyWithImpl<$Res>
    implements _$FavoritesStateCopyWith<$Res> {
  __$FavoritesStateCopyWithImpl(this._self, this._then);

  final _FavoritesState _self;
  final $Res Function(_FavoritesState) _then;

/// Create a copy of FavoritesState
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? favoritePostIds = null,Object? isInitialLoading = null,Object? updatingPostId = freezed,Object? failure = freezed,Object? toggleFailure = freezed,}) {
  return _then(_FavoritesState(
favoritePostIds: null == favoritePostIds ? _self._favoritePostIds : favoritePostIds // ignore: cast_nullable_to_non_nullable
as Set<int>,isInitialLoading: null == isInitialLoading ? _self.isInitialLoading : isInitialLoading // ignore: cast_nullable_to_non_nullable
as bool,updatingPostId: freezed == updatingPostId ? _self.updatingPostId : updatingPostId // ignore: cast_nullable_to_non_nullable
as int?,failure: freezed == failure ? _self.failure : failure // ignore: cast_nullable_to_non_nullable
as AppFailure?,toggleFailure: freezed == toggleFailure ? _self.toggleFailure : toggleFailure // ignore: cast_nullable_to_non_nullable
as AppFailure?,
  ));
}


}

// dart format on
