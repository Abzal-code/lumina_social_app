import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../core/error/app_failure.dart';
import '../../posts/domain/entities/post.dart';
import '../domain/entities/user.dart';

part 'user_profile_state.freezed.dart';

@freezed
abstract class UserProfileState with _$UserProfileState {
  const factory UserProfileState({
    User? user,
    @Default(<Post>[]) List<Post> posts,
    @Default(false) bool isUserLoading,
    @Default(false) bool arePostsLoading,
    @Default(false) bool arePostsRefreshing,
    AppFailure? userFailure,
    AppFailure? postsFailure,
  }) = _UserProfileState;
}
