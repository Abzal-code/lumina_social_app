import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../core/error/app_failure.dart';
import '../domain/entities/post.dart';

part 'posts_state.freezed.dart';

@freezed
abstract class PostsState with _$PostsState {
  const PostsState._();

  const factory PostsState({
    @Default(<Post>[]) List<Post> posts,
    @Default('') String query,
    @Default(false) bool isInitialLoading,
    @Default(false) bool isRefreshing,
    AppFailure? failure,
  }) = _PostsState;

  /// [posts] filtered by the trimmed, case-insensitive [query]; original
  /// order is preserved.
  List<Post> get visiblePosts {
    final normalizedQuery = query.trim().toLowerCase();
    if (normalizedQuery.isEmpty) {
      return posts;
    }
    return posts
        .where(
          (post) =>
              post.title.toLowerCase().contains(normalizedQuery) ||
              post.body.toLowerCase().contains(normalizedQuery),
        )
        .toList(growable: false);
  }
}
