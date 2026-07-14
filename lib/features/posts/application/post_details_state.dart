import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../core/error/app_failure.dart';
import '../../comments/domain/entities/comment.dart';
import '../domain/entities/post.dart';

part 'post_details_state.freezed.dart';

@freezed
abstract class PostDetailsState with _$PostDetailsState {
  const factory PostDetailsState({
    Post? post,
    @Default(<Comment>[]) List<Comment> comments,
    @Default(false) bool isPostLoading,
    @Default(false) bool areCommentsLoading,
    @Default(false) bool areCommentsRefreshing,
    AppFailure? postFailure,
    AppFailure? commentsFailure,
  }) = _PostDetailsState;
}
