import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../core/error/app_failure.dart';
import '../di.dart';
import 'users_state.dart';

part 'users_controller.g.dart';

@riverpod
class UsersController extends _$UsersController {
  bool _requestInFlight = false;

  @override
  UsersState build() {
    Future.microtask(_loadUsers);
    return const UsersState(isInitialLoading: true);
  }

  Future<void> retry() => _loadUsers();

  /// Keeps current users visible while fetching; a failure is exposed on
  /// [UsersState.failure] instead of being rethrown, so pull-to-refresh
  /// always completes.
  Future<void> refresh() async {
    if (_requestInFlight) {
      return;
    }
    _requestInFlight = true;
    state = state.copyWith(isRefreshing: true, failure: null);
    try {
      final users = await ref.read(usersRepositoryProvider).getUsers();
      if (!ref.mounted) return;
      state = state.copyWith(users: users, isRefreshing: false, failure: null);
    } on AppFailure catch (failure) {
      if (!ref.mounted) return;
      state = state.copyWith(isRefreshing: false, failure: failure);
    } finally {
      _requestInFlight = false;
    }
  }

  void setQuery(String query) {
    state = state.copyWith(query: query);
  }

  void clearQuery() => setQuery('');

  Future<void> _loadUsers() async {
    if (_requestInFlight) {
      return;
    }
    _requestInFlight = true;
    state = state.copyWith(isInitialLoading: true, failure: null);
    try {
      final users = await ref.read(usersRepositoryProvider).getUsers();
      if (!ref.mounted) return;
      state = state.copyWith(
        users: users,
        isInitialLoading: false,
        failure: null,
      );
    } on AppFailure catch (failure) {
      if (!ref.mounted) return;
      state = state.copyWith(isInitialLoading: false, failure: failure);
    } finally {
      _requestInFlight = false;
    }
  }
}
