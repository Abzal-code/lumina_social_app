// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'post_details_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$PostDetailsState {

 Post? get post; List<Comment> get comments; bool get isPostLoading; bool get areCommentsLoading; bool get areCommentsRefreshing; AppFailure? get postFailure; AppFailure? get commentsFailure;
/// Create a copy of PostDetailsState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$PostDetailsStateCopyWith<PostDetailsState> get copyWith => _$PostDetailsStateCopyWithImpl<PostDetailsState>(this as PostDetailsState, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is PostDetailsState&&(identical(other.post, post) || other.post == post)&&const DeepCollectionEquality().equals(other.comments, comments)&&(identical(other.isPostLoading, isPostLoading) || other.isPostLoading == isPostLoading)&&(identical(other.areCommentsLoading, areCommentsLoading) || other.areCommentsLoading == areCommentsLoading)&&(identical(other.areCommentsRefreshing, areCommentsRefreshing) || other.areCommentsRefreshing == areCommentsRefreshing)&&(identical(other.postFailure, postFailure) || other.postFailure == postFailure)&&(identical(other.commentsFailure, commentsFailure) || other.commentsFailure == commentsFailure));
}


@override
int get hashCode => Object.hash(runtimeType,post,const DeepCollectionEquality().hash(comments),isPostLoading,areCommentsLoading,areCommentsRefreshing,postFailure,commentsFailure);

@override
String toString() {
  return 'PostDetailsState(post: $post, comments: $comments, isPostLoading: $isPostLoading, areCommentsLoading: $areCommentsLoading, areCommentsRefreshing: $areCommentsRefreshing, postFailure: $postFailure, commentsFailure: $commentsFailure)';
}


}

/// @nodoc
abstract mixin class $PostDetailsStateCopyWith<$Res>  {
  factory $PostDetailsStateCopyWith(PostDetailsState value, $Res Function(PostDetailsState) _then) = _$PostDetailsStateCopyWithImpl;
@useResult
$Res call({
 Post? post, List<Comment> comments, bool isPostLoading, bool areCommentsLoading, bool areCommentsRefreshing, AppFailure? postFailure, AppFailure? commentsFailure
});


$PostCopyWith<$Res>? get post;

}
/// @nodoc
class _$PostDetailsStateCopyWithImpl<$Res>
    implements $PostDetailsStateCopyWith<$Res> {
  _$PostDetailsStateCopyWithImpl(this._self, this._then);

  final PostDetailsState _self;
  final $Res Function(PostDetailsState) _then;

/// Create a copy of PostDetailsState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? post = freezed,Object? comments = null,Object? isPostLoading = null,Object? areCommentsLoading = null,Object? areCommentsRefreshing = null,Object? postFailure = freezed,Object? commentsFailure = freezed,}) {
  return _then(_self.copyWith(
post: freezed == post ? _self.post : post // ignore: cast_nullable_to_non_nullable
as Post?,comments: null == comments ? _self.comments : comments // ignore: cast_nullable_to_non_nullable
as List<Comment>,isPostLoading: null == isPostLoading ? _self.isPostLoading : isPostLoading // ignore: cast_nullable_to_non_nullable
as bool,areCommentsLoading: null == areCommentsLoading ? _self.areCommentsLoading : areCommentsLoading // ignore: cast_nullable_to_non_nullable
as bool,areCommentsRefreshing: null == areCommentsRefreshing ? _self.areCommentsRefreshing : areCommentsRefreshing // ignore: cast_nullable_to_non_nullable
as bool,postFailure: freezed == postFailure ? _self.postFailure : postFailure // ignore: cast_nullable_to_non_nullable
as AppFailure?,commentsFailure: freezed == commentsFailure ? _self.commentsFailure : commentsFailure // ignore: cast_nullable_to_non_nullable
as AppFailure?,
  ));
}
/// Create a copy of PostDetailsState
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$PostCopyWith<$Res>? get post {
    if (_self.post == null) {
    return null;
  }

  return $PostCopyWith<$Res>(_self.post!, (value) {
    return _then(_self.copyWith(post: value));
  });
}
}


/// Adds pattern-matching-related methods to [PostDetailsState].
extension PostDetailsStatePatterns on PostDetailsState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _PostDetailsState value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _PostDetailsState() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _PostDetailsState value)  $default,){
final _that = this;
switch (_that) {
case _PostDetailsState():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _PostDetailsState value)?  $default,){
final _that = this;
switch (_that) {
case _PostDetailsState() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( Post? post,  List<Comment> comments,  bool isPostLoading,  bool areCommentsLoading,  bool areCommentsRefreshing,  AppFailure? postFailure,  AppFailure? commentsFailure)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _PostDetailsState() when $default != null:
return $default(_that.post,_that.comments,_that.isPostLoading,_that.areCommentsLoading,_that.areCommentsRefreshing,_that.postFailure,_that.commentsFailure);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( Post? post,  List<Comment> comments,  bool isPostLoading,  bool areCommentsLoading,  bool areCommentsRefreshing,  AppFailure? postFailure,  AppFailure? commentsFailure)  $default,) {final _that = this;
switch (_that) {
case _PostDetailsState():
return $default(_that.post,_that.comments,_that.isPostLoading,_that.areCommentsLoading,_that.areCommentsRefreshing,_that.postFailure,_that.commentsFailure);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( Post? post,  List<Comment> comments,  bool isPostLoading,  bool areCommentsLoading,  bool areCommentsRefreshing,  AppFailure? postFailure,  AppFailure? commentsFailure)?  $default,) {final _that = this;
switch (_that) {
case _PostDetailsState() when $default != null:
return $default(_that.post,_that.comments,_that.isPostLoading,_that.areCommentsLoading,_that.areCommentsRefreshing,_that.postFailure,_that.commentsFailure);case _:
  return null;

}
}

}

/// @nodoc


class _PostDetailsState implements PostDetailsState {
  const _PostDetailsState({this.post, final  List<Comment> comments = const <Comment>[], this.isPostLoading = false, this.areCommentsLoading = false, this.areCommentsRefreshing = false, this.postFailure, this.commentsFailure}): _comments = comments;
  

@override final  Post? post;
 final  List<Comment> _comments;
@override@JsonKey() List<Comment> get comments {
  if (_comments is EqualUnmodifiableListView) return _comments;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_comments);
}

@override@JsonKey() final  bool isPostLoading;
@override@JsonKey() final  bool areCommentsLoading;
@override@JsonKey() final  bool areCommentsRefreshing;
@override final  AppFailure? postFailure;
@override final  AppFailure? commentsFailure;

/// Create a copy of PostDetailsState
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$PostDetailsStateCopyWith<_PostDetailsState> get copyWith => __$PostDetailsStateCopyWithImpl<_PostDetailsState>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _PostDetailsState&&(identical(other.post, post) || other.post == post)&&const DeepCollectionEquality().equals(other._comments, _comments)&&(identical(other.isPostLoading, isPostLoading) || other.isPostLoading == isPostLoading)&&(identical(other.areCommentsLoading, areCommentsLoading) || other.areCommentsLoading == areCommentsLoading)&&(identical(other.areCommentsRefreshing, areCommentsRefreshing) || other.areCommentsRefreshing == areCommentsRefreshing)&&(identical(other.postFailure, postFailure) || other.postFailure == postFailure)&&(identical(other.commentsFailure, commentsFailure) || other.commentsFailure == commentsFailure));
}


@override
int get hashCode => Object.hash(runtimeType,post,const DeepCollectionEquality().hash(_comments),isPostLoading,areCommentsLoading,areCommentsRefreshing,postFailure,commentsFailure);

@override
String toString() {
  return 'PostDetailsState(post: $post, comments: $comments, isPostLoading: $isPostLoading, areCommentsLoading: $areCommentsLoading, areCommentsRefreshing: $areCommentsRefreshing, postFailure: $postFailure, commentsFailure: $commentsFailure)';
}


}

/// @nodoc
abstract mixin class _$PostDetailsStateCopyWith<$Res> implements $PostDetailsStateCopyWith<$Res> {
  factory _$PostDetailsStateCopyWith(_PostDetailsState value, $Res Function(_PostDetailsState) _then) = __$PostDetailsStateCopyWithImpl;
@override @useResult
$Res call({
 Post? post, List<Comment> comments, bool isPostLoading, bool areCommentsLoading, bool areCommentsRefreshing, AppFailure? postFailure, AppFailure? commentsFailure
});


@override $PostCopyWith<$Res>? get post;

}
/// @nodoc
class __$PostDetailsStateCopyWithImpl<$Res>
    implements _$PostDetailsStateCopyWith<$Res> {
  __$PostDetailsStateCopyWithImpl(this._self, this._then);

  final _PostDetailsState _self;
  final $Res Function(_PostDetailsState) _then;

/// Create a copy of PostDetailsState
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? post = freezed,Object? comments = null,Object? isPostLoading = null,Object? areCommentsLoading = null,Object? areCommentsRefreshing = null,Object? postFailure = freezed,Object? commentsFailure = freezed,}) {
  return _then(_PostDetailsState(
post: freezed == post ? _self.post : post // ignore: cast_nullable_to_non_nullable
as Post?,comments: null == comments ? _self._comments : comments // ignore: cast_nullable_to_non_nullable
as List<Comment>,isPostLoading: null == isPostLoading ? _self.isPostLoading : isPostLoading // ignore: cast_nullable_to_non_nullable
as bool,areCommentsLoading: null == areCommentsLoading ? _self.areCommentsLoading : areCommentsLoading // ignore: cast_nullable_to_non_nullable
as bool,areCommentsRefreshing: null == areCommentsRefreshing ? _self.areCommentsRefreshing : areCommentsRefreshing // ignore: cast_nullable_to_non_nullable
as bool,postFailure: freezed == postFailure ? _self.postFailure : postFailure // ignore: cast_nullable_to_non_nullable
as AppFailure?,commentsFailure: freezed == commentsFailure ? _self.commentsFailure : commentsFailure // ignore: cast_nullable_to_non_nullable
as AppFailure?,
  ));
}

/// Create a copy of PostDetailsState
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$PostCopyWith<$Res>? get post {
    if (_self.post == null) {
    return null;
  }

  return $PostCopyWith<$Res>(_self.post!, (value) {
    return _then(_self.copyWith(post: value));
  });
}
}

// dart format on
