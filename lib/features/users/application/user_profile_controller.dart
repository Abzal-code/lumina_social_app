import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../core/error/app_failure.dart';
import '../../posts/di.dart';
import '../di.dart';
import '../domain/entities/user.dart';
import 'user_profile_state.dart';
import 'users_controller.dart';

part 'user_profile_controller.g.dart';

@riverpod
class UserProfileController extends _$UserProfileController {
  bool _userRequestInFlight = false;
  bool _postsRequestInFlight = false;

  @override
  UserProfileState build(int userId) {
    if (userId <= 0) {
      return const UserProfileState(userFailure: NotFoundFailure());
    }
    Future.microtask(() {
      _loadUser();
      _loadPosts();
    });
    return const UserProfileState(isUserLoading: true, arePostsLoading: true);
  }

  Future<void> retryUser() => _loadUser();

  Future<void> retryPosts() => _loadPosts();

  Future<void> refreshPosts() async {
    if (userId <= 0 || _postsRequestInFlight) {
      return;
    }
    _postsRequestInFlight = true;
    state = state.copyWith(arePostsRefreshing: true, postsFailure: null);
    try {
      final posts = await ref
          .read(postsRepositoryProvider)
          .getPostsForUser(userId);
      if (!ref.mounted) return;
      state = state.copyWith(
        posts: posts,
        arePostsRefreshing: false,
        postsFailure: null,
      );
    } on AppFailure catch (failure) {
      if (!ref.mounted) return;
      state = state.copyWith(arePostsRefreshing: false, postsFailure: failure);
    } finally {
      _postsRequestInFlight = false;
    }
  }

  Future<void> _loadUser() async {
    if (userId <= 0 || _userRequestInFlight) {
      return;
    }
    final loadedUser = _findAlreadyLoadedUser();
    if (loadedUser != null) {
      state = state.copyWith(
        user: loadedUser,
        isUserLoading: false,
        userFailure: null,
      );
      return;
    }
    _userRequestInFlight = true;
    state = state.copyWith(isUserLoading: true, userFailure: null);
    try {
      final user = await ref.read(usersRepositoryProvider).getUser(userId);
      if (!ref.mounted) return;
      state = state.copyWith(
        user: user,
        isUserLoading: false,
        userFailure: null,
      );
    } on AppFailure catch (failure) {
      if (!ref.mounted) return;
      state = state.copyWith(isUserLoading: false, userFailure: failure);
    } finally {
      _userRequestInFlight = false;
    }
  }

  User? _findAlreadyLoadedUser() {
    if (!ref.exists(usersControllerProvider)) {
      return null;
    }
    final usersState = ref.read(usersControllerProvider);
    if (usersState.isInitialLoading) {
      return null;
    }
    for (final user in usersState.users) {
      if (user.id == userId) {
        return user;
      }
    }
    return null;
  }

  Future<void> _loadPosts() async {
    if (userId <= 0 || _postsRequestInFlight) {
      return;
    }
    _postsRequestInFlight = true;
    state = state.copyWith(arePostsLoading: true, postsFailure: null);
    try {
      final posts = await ref
          .read(postsRepositoryProvider)
          .getPostsForUser(userId);
      if (!ref.mounted) return;
      state = state.copyWith(
        posts: posts,
        arePostsLoading: false,
        postsFailure: null,
      );
    } on AppFailure catch (failure) {
      if (!ref.mounted) return;
      state = state.copyWith(arePostsLoading: false, postsFailure: failure);
    } finally {
      _postsRequestInFlight = false;
    }
  }
}
