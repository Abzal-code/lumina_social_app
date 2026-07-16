import '../../../../core/error/app_exception.dart';
import '../../../../core/error/failure_mapper.dart';
import '../../domain/repositories/favorites_repository.dart';
import '../datasources/favorites_local_data_source.dart';

class FavoritesRepositoryImpl implements FavoritesRepository {
  const FavoritesRepositoryImpl(this._localDataSource);

  final FavoritesLocalDataSource _localDataSource;

  @override
  Future<Set<int>> getFavoritePostIds() async {
    try {
      return await _localDataSource.getFavoritePostIds();
    } on AppException catch (exception) {
      throw mapExceptionToFailure(exception);
    }
  }

  @override
  Future<void> addFavorite(int postId) async {
    try {
      await _localDataSource.addFavorite(postId);
    } on AppException catch (exception) {
      throw mapExceptionToFailure(exception);
    }
  }

  @override
  Future<void> removeFavorite(int postId) async {
    try {
      await _localDataSource.removeFavorite(postId);
    } on AppException catch (exception) {
      throw mapExceptionToFailure(exception);
    }
  }
}
