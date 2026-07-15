// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'favorites_feed_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$FavoritesFeedState {

 List<Post> get posts; bool get isLoading; AppFailure? get failure;
/// Create a copy of FavoritesFeedState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$FavoritesFeedStateCopyWith<FavoritesFeedState> get copyWith => _$FavoritesFeedStateCopyWithImpl<FavoritesFeedState>(this as FavoritesFeedState, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is FavoritesFeedState&&const DeepCollectionEquality().equals(other.posts, posts)&&(identical(other.isLoading, isLoading) || other.isLoading == isLoading)&&(identical(other.failure, failure) || other.failure == failure));
}


@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(posts),isLoading,failure);

@override
String toString() {
  return 'FavoritesFeedState(posts: $posts, isLoading: $isLoading, failure: $failure)';
}


}

/// @nodoc
abstract mixin class $FavoritesFeedStateCopyWith<$Res>  {
  factory $FavoritesFeedStateCopyWith(FavoritesFeedState value, $Res Function(FavoritesFeedState) _then) = _$FavoritesFeedStateCopyWithImpl;
@useResult
$Res call({
 List<Post> posts, bool isLoading, AppFailure? failure
});




}
/// @nodoc
class _$FavoritesFeedStateCopyWithImpl<$Res>
    implements $FavoritesFeedStateCopyWith<$Res> {
  _$FavoritesFeedStateCopyWithImpl(this._self, this._then);

  final FavoritesFeedState _self;
  final $Res Function(FavoritesFeedState) _then;

/// Create a copy of FavoritesFeedState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? posts = null,Object? isLoading = null,Object? failure = freezed,}) {
  return _then(_self.copyWith(
posts: null == posts ? _self.posts : posts // ignore: cast_nullable_to_non_nullable
as List<Post>,isLoading: null == isLoading ? _self.isLoading : isLoading // ignore: cast_nullable_to_non_nullable
as bool,failure: freezed == failure ? _self.failure : failure // ignore: cast_nullable_to_non_nullable
as AppFailure?,
  ));
}

}


/// Adds pattern-matching-related methods to [FavoritesFeedState].
extension FavoritesFeedStatePatterns on FavoritesFeedState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _FavoritesFeedState value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _FavoritesFeedState() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _FavoritesFeedState value)  $default,){
final _that = this;
switch (_that) {
case _FavoritesFeedState():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _FavoritesFeedState value)?  $default,){
final _that = this;
switch (_that) {
case _FavoritesFeedState() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( List<Post> posts,  bool isLoading,  AppFailure? failure)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _FavoritesFeedState() when $default != null:
return $default(_that.posts,_that.isLoading,_that.failure);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( List<Post> posts,  bool isLoading,  AppFailure? failure)  $default,) {final _that = this;
switch (_that) {
case _FavoritesFeedState():
return $default(_that.posts,_that.isLoading,_that.failure);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( List<Post> posts,  bool isLoading,  AppFailure? failure)?  $default,) {final _that = this;
switch (_that) {
case _FavoritesFeedState() when $default != null:
return $default(_that.posts,_that.isLoading,_that.failure);case _:
  return null;

}
}

}

/// @nodoc


class _FavoritesFeedState implements FavoritesFeedState {
  const _FavoritesFeedState({final  List<Post> posts = const <Post>[], this.isLoading = false, this.failure}): _posts = posts;
  

 final  List<Post> _posts;
@override@JsonKey() List<Post> get posts {
  if (_posts is EqualUnmodifiableListView) return _posts;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_posts);
}

@override@JsonKey() final  bool isLoading;
@override final  AppFailure? failure;

/// Create a copy of FavoritesFeedState
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$FavoritesFeedStateCopyWith<_FavoritesFeedState> get copyWith => __$FavoritesFeedStateCopyWithImpl<_FavoritesFeedState>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _FavoritesFeedState&&const DeepCollectionEquality().equals(other._posts, _posts)&&(identical(other.isLoading, isLoading) || other.isLoading == isLoading)&&(identical(other.failure, failure) || other.failure == failure));
}


@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(_posts),isLoading,failure);

@override
String toString() {
  return 'FavoritesFeedState(posts: $posts, isLoading: $isLoading, failure: $failure)';
}


}

/// @nodoc
abstract mixin class _$FavoritesFeedStateCopyWith<$Res> implements $FavoritesFeedStateCopyWith<$Res> {
  factory _$FavoritesFeedStateCopyWith(_FavoritesFeedState value, $Res Function(_FavoritesFeedState) _then) = __$FavoritesFeedStateCopyWithImpl;
@override @useResult
$Res call({
 List<Post> posts, bool isLoading, AppFailure? failure
});




}
/// @nodoc
class __$FavoritesFeedStateCopyWithImpl<$Res>
    implements _$FavoritesFeedStateCopyWith<$Res> {
  __$FavoritesFeedStateCopyWithImpl(this._self, this._then);

  final _FavoritesFeedState _self;
  final $Res Function(_FavoritesFeedState) _then;

/// Create a copy of FavoritesFeedState
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? posts = null,Object? isLoading = null,Object? failure = freezed,}) {
  return _then(_FavoritesFeedState(
posts: null == posts ? _self._posts : posts // ignore: cast_nullable_to_non_nullable
as List<Post>,isLoading: null == isLoading ? _self.isLoading : isLoading // ignore: cast_nullable_to_non_nullable
as bool,failure: freezed == failure ? _self.failure : failure // ignore: cast_nullable_to_non_nullable
as AppFailure?,
  ));
}


}

// dart format on
