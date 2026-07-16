// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'delete_post_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$DeletePostState {

 bool get isDeleting; AppFailure? get failure;
/// Create a copy of DeletePostState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$DeletePostStateCopyWith<DeletePostState> get copyWith => _$DeletePostStateCopyWithImpl<DeletePostState>(this as DeletePostState, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is DeletePostState&&(identical(other.isDeleting, isDeleting) || other.isDeleting == isDeleting)&&(identical(other.failure, failure) || other.failure == failure));
}


@override
int get hashCode => Object.hash(runtimeType,isDeleting,failure);

@override
String toString() {
  return 'DeletePostState(isDeleting: $isDeleting, failure: $failure)';
}


}

/// @nodoc
abstract mixin class $DeletePostStateCopyWith<$Res>  {
  factory $DeletePostStateCopyWith(DeletePostState value, $Res Function(DeletePostState) _then) = _$DeletePostStateCopyWithImpl;
@useResult
$Res call({
 bool isDeleting, AppFailure? failure
});




}
/// @nodoc
class _$DeletePostStateCopyWithImpl<$Res>
    implements $DeletePostStateCopyWith<$Res> {
  _$DeletePostStateCopyWithImpl(this._self, this._then);

  final DeletePostState _self;
  final $Res Function(DeletePostState) _then;

/// Create a copy of DeletePostState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? isDeleting = null,Object? failure = freezed,}) {
  return _then(_self.copyWith(
isDeleting: null == isDeleting ? _self.isDeleting : isDeleting // ignore: cast_nullable_to_non_nullable
as bool,failure: freezed == failure ? _self.failure : failure // ignore: cast_nullable_to_non_nullable
as AppFailure?,
  ));
}

}


/// Adds pattern-matching-related methods to [DeletePostState].
extension DeletePostStatePatterns on DeletePostState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _DeletePostState value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _DeletePostState() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _DeletePostState value)  $default,){
final _that = this;
switch (_that) {
case _DeletePostState():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _DeletePostState value)?  $default,){
final _that = this;
switch (_that) {
case _DeletePostState() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( bool isDeleting,  AppFailure? failure)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _DeletePostState() when $default != null:
return $default(_that.isDeleting,_that.failure);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( bool isDeleting,  AppFailure? failure)  $default,) {final _that = this;
switch (_that) {
case _DeletePostState():
return $default(_that.isDeleting,_that.failure);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( bool isDeleting,  AppFailure? failure)?  $default,) {final _that = this;
switch (_that) {
case _DeletePostState() when $default != null:
return $default(_that.isDeleting,_that.failure);case _:
  return null;

}
}

}

/// @nodoc


class _DeletePostState implements DeletePostState {
  const _DeletePostState({this.isDeleting = false, this.failure});
  

@override@JsonKey() final  bool isDeleting;
@override final  AppFailure? failure;

/// Create a copy of DeletePostState
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$DeletePostStateCopyWith<_DeletePostState> get copyWith => __$DeletePostStateCopyWithImpl<_DeletePostState>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _DeletePostState&&(identical(other.isDeleting, isDeleting) || other.isDeleting == isDeleting)&&(identical(other.failure, failure) || other.failure == failure));
}


@override
int get hashCode => Object.hash(runtimeType,isDeleting,failure);

@override
String toString() {
  return 'DeletePostState(isDeleting: $isDeleting, failure: $failure)';
}


}

/// @nodoc
abstract mixin class _$DeletePostStateCopyWith<$Res> implements $DeletePostStateCopyWith<$Res> {
  factory _$DeletePostStateCopyWith(_DeletePostState value, $Res Function(_DeletePostState) _then) = __$DeletePostStateCopyWithImpl;
@override @useResult
$Res call({
 bool isDeleting, AppFailure? failure
});




}
/// @nodoc
class __$DeletePostStateCopyWithImpl<$Res>
    implements _$DeletePostStateCopyWith<$Res> {
  __$DeletePostStateCopyWithImpl(this._self, this._then);

  final _DeletePostState _self;
  final $Res Function(_DeletePostState) _then;

/// Create a copy of DeletePostState
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? isDeleting = null,Object? failure = freezed,}) {
  return _then(_DeletePostState(
isDeleting: null == isDeleting ? _self.isDeleting : isDeleting // ignore: cast_nullable_to_non_nullable
as bool,failure: freezed == failure ? _self.failure : failure // ignore: cast_nullable_to_non_nullable
as AppFailure?,
  ));
}


}

// dart format on
