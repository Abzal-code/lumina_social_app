import 'package:lumina/features/favorites/domain/repositories/favorites_repository.dart';

/// In-memory [FavoritesRepository] for tests that never touches
/// SharedPreferences.
class FakeFavoritesRepository implements FavoritesRepository {
  FakeFavoritesRepository({Set<int>? initialIds}) : _ids = {...?initialIds};

  final Set<int> _ids;

  @override
  Future<Set<int>> getFavoritePostIds() async => {..._ids};

  @override
  Future<void> addFavorite(int postId) async {
    _ids.add(postId);
  }

  @override
  Future<void> removeFavorite(int postId) async {
    _ids.remove(postId);
  }
}
