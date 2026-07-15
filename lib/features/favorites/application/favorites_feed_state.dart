import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../core/error/app_failure.dart';
import '../../posts/domain/entities/post.dart';

part 'favorites_feed_state.freezed.dart';

@freezed
abstract class FavoritesFeedState with _$FavoritesFeedState {
  const factory FavoritesFeedState({
    @Default(<Post>[]) List<Post> posts,
    @Default(false) bool isLoading,
    AppFailure? failure,
  }) = _FavoritesFeedState;
}
