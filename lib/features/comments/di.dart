import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/network/api_client.dart';
import 'data/datasources/comments_remote_data_source.dart';
import 'data/repositories/comments_repository_impl.dart';
import 'domain/repositories/comments_repository.dart';

final commentsRemoteDataSourceProvider = Provider<CommentsRemoteDataSource>(
  (ref) => CommentsRemoteDataSourceImpl(ref.watch(apiClientProvider)),
);

final commentsRepositoryProvider = Provider<CommentsRepository>(
  (ref) => CommentsRepositoryImpl(ref.watch(commentsRemoteDataSourceProvider)),
);
