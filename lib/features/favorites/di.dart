import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/storage/shared_preferences_provider.dart';
import 'data/datasources/favorites_local_data_source.dart';
import 'data/repositories/favorites_repository_impl.dart';
import 'domain/repositories/favorites_repository.dart';

final favoritesLocalDataSourceProvider = Provider<FavoritesLocalDataSource>(
  (ref) => SharedPreferencesFavoritesDataSource(
    ref.watch(sharedPreferencesProvider.future),
  ),
);

final favoritesRepositoryProvider = Provider<FavoritesRepository>(
  (ref) => FavoritesRepositoryImpl(ref.watch(favoritesLocalDataSourceProvider)),
);
