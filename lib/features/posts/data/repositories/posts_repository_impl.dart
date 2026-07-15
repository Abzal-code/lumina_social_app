import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/error/app_exception.dart';
import '../../../../core/error/failure_mapper.dart';
import '../../domain/entities/post.dart';
import '../../domain/repositories/posts_repository.dart';
import '../datasources/posts_remote_data_source.dart';
import '../mappers/post_mapper.dart';

class PostsRepositoryImpl implements PostsRepository {
  const PostsRepositoryImpl(this._remoteDataSource);

  final PostsRemoteDataSource _remoteDataSource;

  @override
  Future<List<Post>> getPosts() async {
    try {
      final dtos = await _remoteDataSource.getPosts();
      return dtos.map(postFromDto).toList(growable: false);
    } on AppException catch (exception) {
      throw mapExceptionToFailure(exception);
    }
  }

  @override
  Future<Post> getPost(int postId) async {
    try {
      final dto = await _remoteDataSource.getPost(postId);
      return postFromDto(dto);
    } on AppException catch (exception) {
      throw mapExceptionToFailure(exception);
    }
  }

  @override
  Future<List<Post>> getPostsForUser(int userId) async {
    try {
      final dtos = await _remoteDataSource.getPostsForUser(userId);
      return dtos.map(postFromDto).toList(growable: false);
    } on AppException catch (exception) {
      throw mapExceptionToFailure(exception);
    }
  }
}

final postsRepositoryProvider = Provider<PostsRepository>(
  (ref) => PostsRepositoryImpl(ref.watch(postsRemoteDataSourceProvider)),
);
