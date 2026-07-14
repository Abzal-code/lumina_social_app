import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../core/error/app_failure.dart';
import '../../comments/data/repositories/comments_repository_impl.dart';
import '../data/repositories/posts_repository_impl.dart';
import '../domain/entities/post.dart';
import 'posts_controller.dart';
import 'post_details_state.dart';

part 'post_details_controller.g.dart';

@riverpod
class PostDetailsController extends _$PostDetailsController {
  bool _postRequestInFlight = false;
  bool _commentsRequestInFlight = false;

  @override
  PostDetailsState build(int postId) {
    if (postId <= 0) {
      return const PostDetailsState(postFailure: NotFoundFailure());
    }
    Future.microtask(() {
      _loadPost();
      _loadComments();
    });
    return const PostDetailsState(
      isPostLoading: true,
      areCommentsLoading: true,
    );
  }

  Future<void> retryPost() => _loadPost();

  Future<void> retryComments() => _loadComments();

  /// Keeps current comments visible while fetching; a failure is exposed on
  /// [PostDetailsState.commentsFailure] instead of being rethrown, so
  /// pull-to-refresh always completes.
  Future<void> refreshComments() async {
    if (postId <= 0 || _commentsRequestInFlight) {
      return;
    }
    _commentsRequestInFlight = true;
    state = state.copyWith(areCommentsRefreshing: true);
    try {
      final comments = await ref
          .read(commentsRepositoryProvider)
          .getCommentsForPost(postId);
      if (!ref.mounted) return;
      state = state.copyWith(
        comments: comments,
        areCommentsRefreshing: false,
        commentsFailure: null,
      );
    } on AppFailure catch (failure) {
      if (!ref.mounted) return;
      state = state.copyWith(
        areCommentsRefreshing: false,
        commentsFailure: failure,
      );
    } finally {
      _commentsRequestInFlight = false;
    }
  }

  Future<void> _loadPost() async {
    if (postId <= 0 || _postRequestInFlight) {
      return;
    }
    final loadedPost = _findAlreadyLoadedPost();
    if (loadedPost != null) {
      state = state.copyWith(
        post: loadedPost,
        isPostLoading: false,
        postFailure: null,
      );
      return;
    }
    _postRequestInFlight = true;
    state = state.copyWith(isPostLoading: true, postFailure: null);
    try {
      final post = await ref.read(postsRepositoryProvider).getPost(postId);
      if (!ref.mounted) return;
      state = state.copyWith(
        post: post,
        isPostLoading: false,
        postFailure: null,
      );
    } on AppFailure catch (failure) {
      if (!ref.mounted) return;
      state = state.copyWith(isPostLoading: false, postFailure: failure);
    } finally {
      _postRequestInFlight = false;
    }
  }

  Post? _findAlreadyLoadedPost() {
    if (!ref.exists(postsControllerProvider)) {
      return null;
    }
    final postsState = ref.read(postsControllerProvider);
    if (postsState.isInitialLoading) {
      return null;
    }
    for (final post in postsState.posts) {
      if (post.id == postId) {
        return post;
      }
    }
    return null;
  }

  Future<void> _loadComments() async {
    if (postId <= 0 || _commentsRequestInFlight) {
      return;
    }
    _commentsRequestInFlight = true;
    state = state.copyWith(areCommentsLoading: true, commentsFailure: null);
    try {
      final comments = await ref
          .read(commentsRepositoryProvider)
          .getCommentsForPost(postId);
      if (!ref.mounted) return;
      state = state.copyWith(
        comments: comments,
        areCommentsLoading: false,
        commentsFailure: null,
      );
    } on AppFailure catch (failure) {
      if (!ref.mounted) return;
      state = state.copyWith(
        areCommentsLoading: false,
        commentsFailure: failure,
      );
    } finally {
      _commentsRequestInFlight = false;
    }
  }
}
