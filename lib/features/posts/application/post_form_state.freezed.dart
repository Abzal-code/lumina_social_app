// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'post_form_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$PostFormState {

/// Post being edited; null in create mode.
 Post? get initialPost; bool get isLoadingPost; AppFailure? get loadFailure; bool get isSubmitting; AppFailure? get submitFailure;
/// Create a copy of PostFormState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$PostFormStateCopyWith<PostFormState> get copyWith => _$PostFormStateCopyWithImpl<PostFormState>(this as PostFormState, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is PostFormState&&(identical(other.initialPost, initialPost) || other.initialPost == initialPost)&&(identical(other.isLoadingPost, isLoadingPost) || other.isLoadingPost == isLoadingPost)&&(identical(other.loadFailure, loadFailure) || other.loadFailure == loadFailure)&&(identical(other.isSubmitting, isSubmitting) || other.isSubmitting == isSubmitting)&&(identical(other.submitFailure, submitFailure) || other.submitFailure == submitFailure));
}


@override
int get hashCode => Object.hash(runtimeType,initialPost,isLoadingPost,loadFailure,isSubmitting,submitFailure);

@override
String toString() {
  return 'PostFormState(initialPost: $initialPost, isLoadingPost: $isLoadingPost, loadFailure: $loadFailure, isSubmitting: $isSubmitting, submitFailure: $submitFailure)';
}


}

/// @nodoc
abstract mixin class $PostFormStateCopyWith<$Res>  {
  factory $PostFormStateCopyWith(PostFormState value, $Res Function(PostFormState) _then) = _$PostFormStateCopyWithImpl;
@useResult
$Res call({
 Post? initialPost, bool isLoadingPost, AppFailure? loadFailure, bool isSubmitting, AppFailure? submitFailure
});


$PostCopyWith<$Res>? get initialPost;

}
/// @nodoc
class _$PostFormStateCopyWithImpl<$Res>
    implements $PostFormStateCopyWith<$Res> {
  _$PostFormStateCopyWithImpl(this._self, this._then);

  final PostFormState _self;
  final $Res Function(PostFormState) _then;

/// Create a copy of PostFormState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? initialPost = freezed,Object? isLoadingPost = null,Object? loadFailure = freezed,Object? isSubmitting = null,Object? submitFailure = freezed,}) {
  return _then(_self.copyWith(
initialPost: freezed == initialPost ? _self.initialPost : initialPost // ignore: cast_nullable_to_non_nullable
as Post?,isLoadingPost: null == isLoadingPost ? _self.isLoadingPost : isLoadingPost // ignore: cast_nullable_to_non_nullable
as bool,loadFailure: freezed == loadFailure ? _self.loadFailure : loadFailure // ignore: cast_nullable_to_non_nullable
as AppFailure?,isSubmitting: null == isSubmitting ? _self.isSubmitting : isSubmitting // ignore: cast_nullable_to_non_nullable
as bool,submitFailure: freezed == submitFailure ? _self.submitFailure : submitFailure // ignore: cast_nullable_to_non_nullable
as AppFailure?,
  ));
}
/// Create a copy of PostFormState
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$PostCopyWith<$Res>? get initialPost {
    if (_self.initialPost == null) {
    return null;
  }

  return $PostCopyWith<$Res>(_self.initialPost!, (value) {
    return _then(_self.copyWith(initialPost: value));
  });
}
}


/// Adds pattern-matching-related methods to [PostFormState].
extension PostFormStatePatterns on PostFormState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _PostFormState value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _PostFormState() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _PostFormState value)  $default,){
final _that = this;
switch (_that) {
case _PostFormState():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _PostFormState value)?  $default,){
final _that = this;
switch (_that) {
case _PostFormState() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( Post? initialPost,  bool isLoadingPost,  AppFailure? loadFailure,  bool isSubmitting,  AppFailure? submitFailure)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _PostFormState() when $default != null:
return $default(_that.initialPost,_that.isLoadingPost,_that.loadFailure,_that.isSubmitting,_that.submitFailure);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( Post? initialPost,  bool isLoadingPost,  AppFailure? loadFailure,  bool isSubmitting,  AppFailure? submitFailure)  $default,) {final _that = this;
switch (_that) {
case _PostFormState():
return $default(_that.initialPost,_that.isLoadingPost,_that.loadFailure,_that.isSubmitting,_that.submitFailure);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( Post? initialPost,  bool isLoadingPost,  AppFailure? loadFailure,  bool isSubmitting,  AppFailure? submitFailure)?  $default,) {final _that = this;
switch (_that) {
case _PostFormState() when $default != null:
return $default(_that.initialPost,_that.isLoadingPost,_that.loadFailure,_that.isSubmitting,_that.submitFailure);case _:
  return null;

}
}

}

/// @nodoc


class _PostFormState implements PostFormState {
  const _PostFormState({this.initialPost, this.isLoadingPost = false, this.loadFailure, this.isSubmitting = false, this.submitFailure});
  

/// Post being edited; null in create mode.
@override final  Post? initialPost;
@override@JsonKey() final  bool isLoadingPost;
@override final  AppFailure? loadFailure;
@override@JsonKey() final  bool isSubmitting;
@override final  AppFailure? submitFailure;

/// Create a copy of PostFormState
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$PostFormStateCopyWith<_PostFormState> get copyWith => __$PostFormStateCopyWithImpl<_PostFormState>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _PostFormState&&(identical(other.initialPost, initialPost) || other.initialPost == initialPost)&&(identical(other.isLoadingPost, isLoadingPost) || other.isLoadingPost == isLoadingPost)&&(identical(other.loadFailure, loadFailure) || other.loadFailure == loadFailure)&&(identical(other.isSubmitting, isSubmitting) || other.isSubmitting == isSubmitting)&&(identical(other.submitFailure, submitFailure) || other.submitFailure == submitFailure));
}


@override
int get hashCode => Object.hash(runtimeType,initialPost,isLoadingPost,loadFailure,isSubmitting,submitFailure);

@override
String toString() {
  return 'PostFormState(initialPost: $initialPost, isLoadingPost: $isLoadingPost, loadFailure: $loadFailure, isSubmitting: $isSubmitting, submitFailure: $submitFailure)';
}


}

/// @nodoc
abstract mixin class _$PostFormStateCopyWith<$Res> implements $PostFormStateCopyWith<$Res> {
  factory _$PostFormStateCopyWith(_PostFormState value, $Res Function(_PostFormState) _then) = __$PostFormStateCopyWithImpl;
@override @useResult
$Res call({
 Post? initialPost, bool isLoadingPost, AppFailure? loadFailure, bool isSubmitting, AppFailure? submitFailure
});


@override $PostCopyWith<$Res>? get initialPost;

}
/// @nodoc
class __$PostFormStateCopyWithImpl<$Res>
    implements _$PostFormStateCopyWith<$Res> {
  __$PostFormStateCopyWithImpl(this._self, this._then);

  final _PostFormState _self;
  final $Res Function(_PostFormState) _then;

/// Create a copy of PostFormState
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? initialPost = freezed,Object? isLoadingPost = null,Object? loadFailure = freezed,Object? isSubmitting = null,Object? submitFailure = freezed,}) {
  return _then(_PostFormState(
initialPost: freezed == initialPost ? _self.initialPost : initialPost // ignore: cast_nullable_to_non_nullable
as Post?,isLoadingPost: null == isLoadingPost ? _self.isLoadingPost : isLoadingPost // ignore: cast_nullable_to_non_nullable
as bool,loadFailure: freezed == loadFailure ? _self.loadFailure : loadFailure // ignore: cast_nullable_to_non_nullable
as AppFailure?,isSubmitting: null == isSubmitting ? _self.isSubmitting : isSubmitting // ignore: cast_nullable_to_non_nullable
as bool,submitFailure: freezed == submitFailure ? _self.submitFailure : submitFailure // ignore: cast_nullable_to_non_nullable
as AppFailure?,
  ));
}

/// Create a copy of PostFormState
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$PostCopyWith<$Res>? get initialPost {
    if (_self.initialPost == null) {
    return null;
  }

  return $PostCopyWith<$Res>(_self.initialPost!, (value) {
    return _then(_self.copyWith(initialPost: value));
  });
}
}

// dart format on
