import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../core/error/app_failure.dart';
import '../data/repositories/posts_repository_impl.dart';
import '../domain/entities/post.dart';
import 'post_change_propagation.dart';
import 'post_form_state.dart';

part 'post_form_controller.g.dart';

/// Owns submission state for the post form; [postId] is null in create mode.
@riverpod
class PostFormController extends _$PostFormController {
  bool _loadInFlight = false;

  @override
  PostFormState build(int? postId) {
    if (postId == null) {
      return const PostFormState();
    }
    if (postId == 0) {
      return const PostFormState(loadFailure: NotFoundFailure());
    }
    Future.microtask(_loadPost);
    return const PostFormState(isLoadingPost: true);
  }

  Future<void> retryLoad() => _loadPost();

  Future<Post?> submit({
    required int authorId,
    required String title,
    required String body,
  }) async {
    if (state.isSubmitting || state.isLoadingPost || postId == 0) {
      return null;
    }
    state = state.copyWith(isSubmitting: true, submitFailure: null);
    try {
      final repository = ref.read(postsRepositoryProvider);
      final Post post;
      if (postId case final int id) {
        post = await repository.updatePost(
          postId: id,
          authorId: authorId,
          title: title,
          body: body,
        );
        if (!ref.mounted) return post;
        propagatePostUpdated(ref, post);
      } else {
        post = await repository.createPost(
          authorId: authorId,
          title: title,
          body: body,
        );
        if (!ref.mounted) return post;
        propagatePostCreated(ref, post);
      }
      state = state.copyWith(isSubmitting: false);
      return post;
    } on AppFailure catch (failure) {
      if (!ref.mounted) return null;
      state = state.copyWith(isSubmitting: false, submitFailure: failure);
      return null;
    } catch (_) {
      if (ref.mounted) {
        state = state.copyWith(isSubmitting: false);
      }
      rethrow;
    }
  }

  Future<void> _loadPost() async {
    final id = postId;
    if (id == null || id == 0 || _loadInFlight) {
      return;
    }
    _loadInFlight = true;
    state = state.copyWith(isLoadingPost: true, loadFailure: null);
    try {
      final post = await ref.read(postsRepositoryProvider).getPost(id);
      if (!ref.mounted) return;
      state = state.copyWith(
        initialPost: post,
        isLoadingPost: false,
        loadFailure: null,
      );
    } on AppFailure catch (failure) {
      if (!ref.mounted) return;

      state = state.copyWith(isLoadingPost: false, loadFailure: failure);
    } catch (_) {
      if (ref.mounted) {
        state = state.copyWith(isLoadingPost: false);
      }
      rethrow;
    } finally {
      _loadInFlight = false;
    }
  }
}
