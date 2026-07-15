import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../core/error/app_failure.dart';

part 'favorites_state.freezed.dart';

@freezed
abstract class FavoritesState with _$FavoritesState {
  const FavoritesState._();

  const factory FavoritesState({
    @Default(<int>{}) Set<int> favoritePostIds,
    @Default(false) bool isInitialLoading,
    int? updatingPostId,
    AppFailure? failure,
    AppFailure? toggleFailure,
  }) = _FavoritesState;

  bool isFavorite(int postId) => favoritePostIds.contains(postId);

  bool get isUpdating => updatingPostId != null;

  /// Toggling requires restored IDs; otherwise a mutation could silently
  /// diverge from what is already persisted.
  bool get canToggle => !isInitialLoading && failure == null;
}
