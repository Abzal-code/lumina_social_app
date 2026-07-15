// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'users_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$UsersState {

 List<User> get users; String get query; bool get isInitialLoading; bool get isRefreshing; AppFailure? get failure;
/// Create a copy of UsersState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$UsersStateCopyWith<UsersState> get copyWith => _$UsersStateCopyWithImpl<UsersState>(this as UsersState, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is UsersState&&const DeepCollectionEquality().equals(other.users, users)&&(identical(other.query, query) || other.query == query)&&(identical(other.isInitialLoading, isInitialLoading) || other.isInitialLoading == isInitialLoading)&&(identical(other.isRefreshing, isRefreshing) || other.isRefreshing == isRefreshing)&&(identical(other.failure, failure) || other.failure == failure));
}


@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(users),query,isInitialLoading,isRefreshing,failure);

@override
String toString() {
  return 'UsersState(users: $users, query: $query, isInitialLoading: $isInitialLoading, isRefreshing: $isRefreshing, failure: $failure)';
}


}

/// @nodoc
abstract mixin class $UsersStateCopyWith<$Res>  {
  factory $UsersStateCopyWith(UsersState value, $Res Function(UsersState) _then) = _$UsersStateCopyWithImpl;
@useResult
$Res call({
 List<User> users, String query, bool isInitialLoading, bool isRefreshing, AppFailure? failure
});




}
/// @nodoc
class _$UsersStateCopyWithImpl<$Res>
    implements $UsersStateCopyWith<$Res> {
  _$UsersStateCopyWithImpl(this._self, this._then);

  final UsersState _self;
  final $Res Function(UsersState) _then;

/// Create a copy of UsersState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? users = null,Object? query = null,Object? isInitialLoading = null,Object? isRefreshing = null,Object? failure = freezed,}) {
  return _then(_self.copyWith(
users: null == users ? _self.users : users // ignore: cast_nullable_to_non_nullable
as List<User>,query: null == query ? _self.query : query // ignore: cast_nullable_to_non_nullable
as String,isInitialLoading: null == isInitialLoading ? _self.isInitialLoading : isInitialLoading // ignore: cast_nullable_to_non_nullable
as bool,isRefreshing: null == isRefreshing ? _self.isRefreshing : isRefreshing // ignore: cast_nullable_to_non_nullable
as bool,failure: freezed == failure ? _self.failure : failure // ignore: cast_nullable_to_non_nullable
as AppFailure?,
  ));
}

}


/// Adds pattern-matching-related methods to [UsersState].
extension UsersStatePatterns on UsersState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _UsersState value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _UsersState() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _UsersState value)  $default,){
final _that = this;
switch (_that) {
case _UsersState():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _UsersState value)?  $default,){
final _that = this;
switch (_that) {
case _UsersState() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( List<User> users,  String query,  bool isInitialLoading,  bool isRefreshing,  AppFailure? failure)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _UsersState() when $default != null:
return $default(_that.users,_that.query,_that.isInitialLoading,_that.isRefreshing,_that.failure);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( List<User> users,  String query,  bool isInitialLoading,  bool isRefreshing,  AppFailure? failure)  $default,) {final _that = this;
switch (_that) {
case _UsersState():
return $default(_that.users,_that.query,_that.isInitialLoading,_that.isRefreshing,_that.failure);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( List<User> users,  String query,  bool isInitialLoading,  bool isRefreshing,  AppFailure? failure)?  $default,) {final _that = this;
switch (_that) {
case _UsersState() when $default != null:
return $default(_that.users,_that.query,_that.isInitialLoading,_that.isRefreshing,_that.failure);case _:
  return null;

}
}

}

/// @nodoc


class _UsersState extends UsersState {
  const _UsersState({final  List<User> users = const <User>[], this.query = '', this.isInitialLoading = false, this.isRefreshing = false, this.failure}): _users = users,super._();
  

 final  List<User> _users;
@override@JsonKey() List<User> get users {
  if (_users is EqualUnmodifiableListView) return _users;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_users);
}

@override@JsonKey() final  String query;
@override@JsonKey() final  bool isInitialLoading;
@override@JsonKey() final  bool isRefreshing;
@override final  AppFailure? failure;

/// Create a copy of UsersState
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$UsersStateCopyWith<_UsersState> get copyWith => __$UsersStateCopyWithImpl<_UsersState>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _UsersState&&const DeepCollectionEquality().equals(other._users, _users)&&(identical(other.query, query) || other.query == query)&&(identical(other.isInitialLoading, isInitialLoading) || other.isInitialLoading == isInitialLoading)&&(identical(other.isRefreshing, isRefreshing) || other.isRefreshing == isRefreshing)&&(identical(other.failure, failure) || other.failure == failure));
}


@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(_users),query,isInitialLoading,isRefreshing,failure);

@override
String toString() {
  return 'UsersState(users: $users, query: $query, isInitialLoading: $isInitialLoading, isRefreshing: $isRefreshing, failure: $failure)';
}


}

/// @nodoc
abstract mixin class _$UsersStateCopyWith<$Res> implements $UsersStateCopyWith<$Res> {
  factory _$UsersStateCopyWith(_UsersState value, $Res Function(_UsersState) _then) = __$UsersStateCopyWithImpl;
@override @useResult
$Res call({
 List<User> users, String query, bool isInitialLoading, bool isRefreshing, AppFailure? failure
});




}
/// @nodoc
class __$UsersStateCopyWithImpl<$Res>
    implements _$UsersStateCopyWith<$Res> {
  __$UsersStateCopyWithImpl(this._self, this._then);

  final _UsersState _self;
  final $Res Function(_UsersState) _then;

/// Create a copy of UsersState
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? users = null,Object? query = null,Object? isInitialLoading = null,Object? isRefreshing = null,Object? failure = freezed,}) {
  return _then(_UsersState(
users: null == users ? _self._users : users // ignore: cast_nullable_to_non_nullable
as List<User>,query: null == query ? _self.query : query // ignore: cast_nullable_to_non_nullable
as String,isInitialLoading: null == isInitialLoading ? _self.isInitialLoading : isInitialLoading // ignore: cast_nullable_to_non_nullable
as bool,isRefreshing: null == isRefreshing ? _self.isRefreshing : isRefreshing // ignore: cast_nullable_to_non_nullable
as bool,failure: freezed == failure ? _self.failure : failure // ignore: cast_nullable_to_non_nullable
as AppFailure?,
  ));
}


}

// dart format on
