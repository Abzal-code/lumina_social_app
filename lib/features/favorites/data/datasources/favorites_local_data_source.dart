import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../../core/error/app_exception.dart';
import '../../../../core/storage/shared_preferences_provider.dart';

/// Implementations throw [AppException] subtypes on error.
abstract interface class FavoritesLocalDataSource {
  /// Stored entries that are not positive integers are dropped on read; the
  /// cleaned set is written back by the next mutation.
  Future<Set<int>> getFavoritePostIds();

  Future<void> addFavorite(int postId);

  Future<void> removeFavorite(int postId);
}

class SharedPreferencesFavoritesDataSource implements FavoritesLocalDataSource {
  const SharedPreferencesFavoritesDataSource(this._preferences);

  static const _storageKey = 'favorite_post_ids';

  final Future<SharedPreferences> _preferences;

  @override
  Future<Set<int>> getFavoritePostIds() async {
    try {
      final preferences = await _preferences;
      final entries = preferences.getStringList(_storageKey) ?? const [];
      return {
        for (final entry in entries)
          if (int.tryParse(entry) case final int id when id > 0) id,
      };
    } on AppException {
      rethrow;
    } catch (_) {
      throw const UnexpectedException('Failed to read favorite post ids');
    }
  }

  @override
  Future<void> addFavorite(int postId) async {
    _validatePostId(postId);
    final ids = await getFavoritePostIds();
    await _persist(ids..add(postId));
  }

  @override
  Future<void> removeFavorite(int postId) async {
    _validatePostId(postId);
    final ids = await getFavoritePostIds();
    await _persist(ids..remove(postId));
  }

  void _validatePostId(int postId) {
    if (postId <= 0) {
      throw NotFoundException('Invalid post id: $postId');
    }
  }

  Future<void> _persist(Set<int> ids) async {
    try {
      final preferences = await _preferences;
      final sortedIds = ids.toList()..sort();
      final written = await preferences.setStringList(_storageKey, [
        for (final id in sortedIds) '$id',
      ]);
      if (!written) {
        throw const UnexpectedException('Failed to persist favorites');
      }
    } on AppException {
      rethrow;
    } catch (_) {
      throw const UnexpectedException('Failed to persist favorite post ids');
    }
  }
}

final favoritesLocalDataSourceProvider = Provider<FavoritesLocalDataSource>(
  (ref) => SharedPreferencesFavoritesDataSource(
    ref.watch(sharedPreferencesProvider.future),
  ),
);
