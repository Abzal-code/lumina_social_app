import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../favorites/application/favorites_feed_controller.dart';
import '../../users/application/user_profile_controller.dart';
import '../domain/entities/post.dart';
import 'post_details_controller.dart';
import 'posts_controller.dart';

/// Synchronizes active post-related controllers after a mutation.

void propagatePostCreated(Ref ref, Post post) {
  if (ref.exists(postsControllerProvider)) {
    ref.read(postsControllerProvider.notifier).applyPostCreated(post);
  }
  ref.invalidate(userProfileControllerProvider);
}

void propagatePostUpdated(Ref ref, Post post) {
  if (ref.exists(postsControllerProvider)) {
    ref.read(postsControllerProvider.notifier).applyPostUpdated(post);
  }
  if (ref.exists(postDetailsControllerProvider(post.id))) {
    ref
        .read(postDetailsControllerProvider(post.id).notifier)
        .applyPostUpdated(post);
  }
  if (ref.exists(favoritesFeedControllerProvider)) {
    ref.read(favoritesFeedControllerProvider.notifier).applyPostUpdated(post);
  }
  ref.invalidate(userProfileControllerProvider);
}

void propagatePostDeleted(Ref ref, int postId) {
  if (ref.exists(postsControllerProvider)) {
    ref.read(postsControllerProvider.notifier).applyPostDeleted(postId);
  }
  if (ref.exists(favoritesFeedControllerProvider)) {
    ref.read(favoritesFeedControllerProvider.notifier).applyPostDeleted(postId);
  }
  ref.invalidate(userProfileControllerProvider);
}
