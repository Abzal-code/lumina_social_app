import 'package:freezed_annotation/freezed_annotation.dart';

import '../../domain/entities/post.dart';

part 'local_post_changes.freezed.dart';

/// Locally persisted post mutations, merged over remote reads.
///
/// Created posts carry negative IDs allocated from [nextLocalId] so they can
/// never collide with server-assigned IDs. [createdPosts] keeps creation
/// order; [updatedPosts] is keyed by the (positive) remote post ID;
/// [deletedPostIds] suppresses remote posts and their local updates.
@freezed
abstract class LocalPostChanges with _$LocalPostChanges {
  const factory LocalPostChanges({
    @Default(<Post>[]) List<Post> createdPosts,
    @Default(<int, Post>{}) Map<int, Post> updatedPosts,
    @Default(<int>{}) Set<int> deletedPostIds,
    @Default(-1) int nextLocalId,
  }) = _LocalPostChanges;
}
