// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'user_profile_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$UserProfileState {

 User? get user; List<Post> get posts; bool get isUserLoading; bool get arePostsLoading; bool get arePostsRefreshing; AppFailure? get userFailure; AppFailure? get postsFailure;
/// Create a copy of UserProfileState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$UserProfileStateCopyWith<UserProfileState> get copyWith => _$UserProfileStateCopyWithImpl<UserProfileState>(this as UserProfileState, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is UserProfileState&&(identical(other.user, user) || other.user == user)&&const DeepCollectionEquality().equals(other.posts, posts)&&(identical(other.isUserLoading, isUserLoading) || other.isUserLoading == isUserLoading)&&(identical(other.arePostsLoading, arePostsLoading) || other.arePostsLoading == arePostsLoading)&&(identical(other.arePostsRefreshing, arePostsRefreshing) || other.arePostsRefreshing == arePostsRefreshing)&&(identical(other.userFailure, userFailure) || other.userFailure == userFailure)&&(identical(other.postsFailure, postsFailure) || other.postsFailure == postsFailure));
}


@override
int get hashCode => Object.hash(runtimeType,user,const DeepCollectionEquality().hash(posts),isUserLoading,arePostsLoading,arePostsRefreshing,userFailure,postsFailure);

@override
String toString() {
  return 'UserProfileState(user: $user, posts: $posts, isUserLoading: $isUserLoading, arePostsLoading: $arePostsLoading, arePostsRefreshing: $arePostsRefreshing, userFailure: $userFailure, postsFailure: $postsFailure)';
}


}

/// @nodoc
abstract mixin class $UserProfileStateCopyWith<$Res>  {
  factory $UserProfileStateCopyWith(UserProfileState value, $Res Function(UserProfileState) _then) = _$UserProfileStateCopyWithImpl;
@useResult
$Res call({
 User? user, List<Post> posts, bool isUserLoading, bool arePostsLoading, bool arePostsRefreshing, AppFailure? userFailure, AppFailure? postsFailure
});


$UserCopyWith<$Res>? get user;

}
/// @nodoc
class _$UserProfileStateCopyWithImpl<$Res>
    implements $UserProfileStateCopyWith<$Res> {
  _$UserProfileStateCopyWithImpl(this._self, this._then);

  final UserProfileState _self;
  final $Res Function(UserProfileState) _then;

/// Create a copy of UserProfileState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? user = freezed,Object? posts = null,Object? isUserLoading = null,Object? arePostsLoading = null,Object? arePostsRefreshing = null,Object? userFailure = freezed,Object? postsFailure = freezed,}) {
  return _then(_self.copyWith(
user: freezed == user ? _self.user : user // ignore: cast_nullable_to_non_nullable
as User?,posts: null == posts ? _self.posts : posts // ignore: cast_nullable_to_non_nullable
as List<Post>,isUserLoading: null == isUserLoading ? _self.isUserLoading : isUserLoading // ignore: cast_nullable_to_non_nullable
as bool,arePostsLoading: null == arePostsLoading ? _self.arePostsLoading : arePostsLoading // ignore: cast_nullable_to_non_nullable
as bool,arePostsRefreshing: null == arePostsRefreshing ? _self.arePostsRefreshing : arePostsRefreshing // ignore: cast_nullable_to_non_nullable
as bool,userFailure: freezed == userFailure ? _self.userFailure : userFailure // ignore: cast_nullable_to_non_nullable
as AppFailure?,postsFailure: freezed == postsFailure ? _self.postsFailure : postsFailure // ignore: cast_nullable_to_non_nullable
as AppFailure?,
  ));
}
/// Create a copy of UserProfileState
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$UserCopyWith<$Res>? get user {
    if (_self.user == null) {
    return null;
  }

  return $UserCopyWith<$Res>(_self.user!, (value) {
    return _then(_self.copyWith(user: value));
  });
}
}


/// Adds pattern-matching-related methods to [UserProfileState].
extension UserProfileStatePatterns on UserProfileState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _UserProfileState value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _UserProfileState() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _UserProfileState value)  $default,){
final _that = this;
switch (_that) {
case _UserProfileState():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _UserProfileState value)?  $default,){
final _that = this;
switch (_that) {
case _UserProfileState() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( User? user,  List<Post> posts,  bool isUserLoading,  bool arePostsLoading,  bool arePostsRefreshing,  AppFailure? userFailure,  AppFailure? postsFailure)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _UserProfileState() when $default != null:
return $default(_that.user,_that.posts,_that.isUserLoading,_that.arePostsLoading,_that.arePostsRefreshing,_that.userFailure,_that.postsFailure);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( User? user,  List<Post> posts,  bool isUserLoading,  bool arePostsLoading,  bool arePostsRefreshing,  AppFailure? userFailure,  AppFailure? postsFailure)  $default,) {final _that = this;
switch (_that) {
case _UserProfileState():
return $default(_that.user,_that.posts,_that.isUserLoading,_that.arePostsLoading,_that.arePostsRefreshing,_that.userFailure,_that.postsFailure);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( User? user,  List<Post> posts,  bool isUserLoading,  bool arePostsLoading,  bool arePostsRefreshing,  AppFailure? userFailure,  AppFailure? postsFailure)?  $default,) {final _that = this;
switch (_that) {
case _UserProfileState() when $default != null:
return $default(_that.user,_that.posts,_that.isUserLoading,_that.arePostsLoading,_that.arePostsRefreshing,_that.userFailure,_that.postsFailure);case _:
  return null;

}
}

}

/// @nodoc


class _UserProfileState implements UserProfileState {
  const _UserProfileState({this.user, final  List<Post> posts = const <Post>[], this.isUserLoading = false, this.arePostsLoading = false, this.arePostsRefreshing = false, this.userFailure, this.postsFailure}): _posts = posts;
  

@override final  User? user;
 final  List<Post> _posts;
@override@JsonKey() List<Post> get posts {
  if (_posts is EqualUnmodifiableListView) return _posts;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_posts);
}

@override@JsonKey() final  bool isUserLoading;
@override@JsonKey() final  bool arePostsLoading;
@override@JsonKey() final  bool arePostsRefreshing;
@override final  AppFailure? userFailure;
@override final  AppFailure? postsFailure;

/// Create a copy of UserProfileState
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$UserProfileStateCopyWith<_UserProfileState> get copyWith => __$UserProfileStateCopyWithImpl<_UserProfileState>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _UserProfileState&&(identical(other.user, user) || other.user == user)&&const DeepCollectionEquality().equals(other._posts, _posts)&&(identical(other.isUserLoading, isUserLoading) || other.isUserLoading == isUserLoading)&&(identical(other.arePostsLoading, arePostsLoading) || other.arePostsLoading == arePostsLoading)&&(identical(other.arePostsRefreshing, arePostsRefreshing) || other.arePostsRefreshing == arePostsRefreshing)&&(identical(other.userFailure, userFailure) || other.userFailure == userFailure)&&(identical(other.postsFailure, postsFailure) || other.postsFailure == postsFailure));
}


@override
int get hashCode => Object.hash(runtimeType,user,const DeepCollectionEquality().hash(_posts),isUserLoading,arePostsLoading,arePostsRefreshing,userFailure,postsFailure);

@override
String toString() {
  return 'UserProfileState(user: $user, posts: $posts, isUserLoading: $isUserLoading, arePostsLoading: $arePostsLoading, arePostsRefreshing: $arePostsRefreshing, userFailure: $userFailure, postsFailure: $postsFailure)';
}


}

/// @nodoc
abstract mixin class _$UserProfileStateCopyWith<$Res> implements $UserProfileStateCopyWith<$Res> {
  factory _$UserProfileStateCopyWith(_UserProfileState value, $Res Function(_UserProfileState) _then) = __$UserProfileStateCopyWithImpl;
@override @useResult
$Res call({
 User? user, List<Post> posts, bool isUserLoading, bool arePostsLoading, bool arePostsRefreshing, AppFailure? userFailure, AppFailure? postsFailure
});


@override $UserCopyWith<$Res>? get user;

}
/// @nodoc
class __$UserProfileStateCopyWithImpl<$Res>
    implements _$UserProfileStateCopyWith<$Res> {
  __$UserProfileStateCopyWithImpl(this._self, this._then);

  final _UserProfileState _self;
  final $Res Function(_UserProfileState) _then;

/// Create a copy of UserProfileState
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? user = freezed,Object? posts = null,Object? isUserLoading = null,Object? arePostsLoading = null,Object? arePostsRefreshing = null,Object? userFailure = freezed,Object? postsFailure = freezed,}) {
  return _then(_UserProfileState(
user: freezed == user ? _self.user : user // ignore: cast_nullable_to_non_nullable
as User?,posts: null == posts ? _self._posts : posts // ignore: cast_nullable_to_non_nullable
as List<Post>,isUserLoading: null == isUserLoading ? _self.isUserLoading : isUserLoading // ignore: cast_nullable_to_non_nullable
as bool,arePostsLoading: null == arePostsLoading ? _self.arePostsLoading : arePostsLoading // ignore: cast_nullable_to_non_nullable
as bool,arePostsRefreshing: null == arePostsRefreshing ? _self.arePostsRefreshing : arePostsRefreshing // ignore: cast_nullable_to_non_nullable
as bool,userFailure: freezed == userFailure ? _self.userFailure : userFailure // ignore: cast_nullable_to_non_nullable
as AppFailure?,postsFailure: freezed == postsFailure ? _self.postsFailure : postsFailure // ignore: cast_nullable_to_non_nullable
as AppFailure?,
  ));
}

/// Create a copy of UserProfileState
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$UserCopyWith<$Res>? get user {
    if (_self.user == null) {
    return null;
  }

  return $UserCopyWith<$Res>(_self.user!, (value) {
    return _then(_self.copyWith(user: value));
  });
}
}

// dart format on
