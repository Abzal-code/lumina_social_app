import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/network/api_client.dart';
import '../../core/storage/shared_preferences_provider.dart';
import 'data/datasources/posts_local_data_source.dart';
import 'data/datasources/posts_remote_data_source.dart';
import 'data/repositories/posts_repository_impl.dart';
import 'domain/repositories/posts_repository.dart';

final postsRemoteDataSourceProvider = Provider<PostsRemoteDataSource>(
  (ref) => PostsRemoteDataSourceImpl(ref.watch(apiClientProvider)),
);

final postsLocalDataSourceProvider = Provider<PostsLocalDataSource>(
  (ref) => SharedPreferencesPostsLocalDataSource(
    ref.watch(sharedPreferencesProvider.future),
  ),
);

final postsRepositoryProvider = Provider<PostsRepository>(
  (ref) => PostsRepositoryImpl(
    ref.watch(postsRemoteDataSourceProvider),
    ref.watch(postsLocalDataSourceProvider),
  ),
);
