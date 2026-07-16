import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../core/error/app_failure.dart';
import '../di.dart';
import '../domain/entities/post.dart';
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

  Future<void> refresh() async {
    if (_requestInFlight) {
      return;
    }
    _requestInFlight = true;
    state = state.copyWith(isRefreshing: true, failure: null);
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

  void applyPostCreated(Post post) {
    state = state.copyWith(
      posts: [
        post,
        for (final existing in state.posts)
          if (existing.id != post.id) existing,
      ],
    );
  }

  void applyPostUpdated(Post post) {
    final exists = state.posts.any((item) => item.id == post.id);

    state = state.copyWith(
      posts: [
        if (!exists) post,
        for (final existing in state.posts)
          existing.id == post.id ? post : existing,
      ],
    );
  }

  void applyPostDeleted(int postId) {
    state = state.copyWith(
      posts: [
        for (final existing in state.posts)
          if (existing.id != postId) existing,
      ],
    );
  }

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
