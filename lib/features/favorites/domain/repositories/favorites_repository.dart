/// Implementations throw [AppFailure] subtypes on error; they never expose
/// storage exceptions.
abstract interface class FavoritesRepository {
  Future<Set<int>> getFavoritePostIds();

  Future<void> addFavorite(int postId);

  Future<void> removeFavorite(int postId);
}
