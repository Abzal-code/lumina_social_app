import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../core/error/app_failure.dart';
import '../../favorites/application/favorites_controller.dart';
import '../data/repositories/posts_repository_impl.dart';
import 'delete_post_state.dart';
import 'post_change_propagation.dart';

part 'delete_post_controller.g.dart';

@riverpod
class DeletePostController extends _$DeletePostController {
  @override
  DeletePostState build() => const DeletePostState();

  Future<bool> deletePost(int postId) async {
    if (postId == 0 || state.isDeleting) {
      return false;
    }

    state = const DeletePostState(isDeleting: true);

    try {
      await ref.read(postsRepositoryProvider).deletePost(postId);
    } on AppFailure catch (failure) {
      if (!ref.mounted) return false;

      state = DeletePostState(failure: failure);
      return false;
    } catch (_) {
      if (ref.mounted) {
        state = const DeletePostState();
      }
      rethrow;
    }

    if (!ref.mounted) return true;

    try {
      propagatePostDeleted(ref, postId);

      await ref
          .read(favoritesControllerProvider.notifier)
          .removeFavorite(postId);
    } catch (_) {
      if (ref.mounted) {
        state = const DeletePostState();
      }
      rethrow;
    }

    if (ref.mounted) {
      state = const DeletePostState();
    }

    return true;
  }
}
