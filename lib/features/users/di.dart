import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/network/api_client.dart';
import 'data/datasources/users_remote_data_source.dart';
import 'data/repositories/users_repository_impl.dart';
import 'domain/repositories/users_repository.dart';

final usersRemoteDataSourceProvider = Provider<UsersRemoteDataSource>(
  (ref) => UsersRemoteDataSourceImpl(ref.watch(apiClientProvider)),
);

final usersRepositoryProvider = Provider<UsersRepository>(
  (ref) => UsersRepositoryImpl(ref.watch(usersRemoteDataSourceProvider)),
);
