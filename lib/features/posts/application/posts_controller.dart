import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../core/error/app_failure.dart';
import '../data/repositories/posts_repository_impl.dart';
import 'posts_state.dart';

part 'posts_controller.g.dart';

@riverpod
class PostsController extends _$PostsController {
  bool _requestInFlight = false;

  @override
  PostsState build() {
    Future.microtask(_loadPosts);
    return const PostsState(isInitialLoading: true);
  }

  Future<void> retry() => _loadPosts();

  /// Keeps current posts visible while fetching; a failure is exposed on
  /// [PostsState.failure] instead of being rethrown, so pull-to-refresh
  /// always completes.
  Future<void> refresh() async {
    if (_requestInFlight) {
      return;
    }
    _requestInFlight = true;
    state = state.copyWith(isRefreshing: true);
    try {
      final posts = await ref.read(postsRepositoryProvider).getPosts();
      if (!ref.mounted) return;
      state = state.copyWith(posts: posts, isRefreshing: false, failure: null);
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

  Future<void> _loadPosts() async {
    if (_requestInFlight) {
      return;
    }
    _requestInFlight = true;
    state = state.copyWith(isInitialLoading: true, failure: null);
    try {
      final posts = await ref.read(postsRepositoryProvider).getPosts();
      if (!ref.mounted) return;
      state = state.copyWith(
        posts: posts,
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
