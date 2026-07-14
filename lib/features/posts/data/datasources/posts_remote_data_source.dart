import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/error/app_exception.dart';
import '../../../../core/network/api_client.dart';
import '../dto/post_dto.dart';

/// Implementations throw [AppException] subtypes on error.
abstract interface class PostsRemoteDataSource {
  Future<List<PostDto>> getPosts();

  Future<PostDto> getPost(int postId);
}

class PostsRemoteDataSourceImpl implements PostsRemoteDataSource {
  const PostsRemoteDataSourceImpl(this._client);

  final ApiClient _client;

  @override
  Future<List<PostDto>> getPosts() async {
    final data = await _client.get('/posts');
    if (data is! List) {
      throw ParsingException(
        'Expected a JSON list for /posts, got ${data.runtimeType}',
      );
    }
    return data.map(_parsePost).toList(growable: false);
  }

  @override
  Future<PostDto> getPost(int postId) async {
    if (postId <= 0) {
      throw NotFoundException('Invalid post id: $postId');
    }
    final data = await _client.get('/posts/$postId');
    return _parsePost(data);
  }

  PostDto _parsePost(Object? element) {
    if (element is! Map<String, dynamic>) {
      throw ParsingException(
        'Expected a JSON object in /posts, got ${element.runtimeType}',
      );
    }
    try {
      return PostDto.fromJson(element);
    } on TypeError catch (error) {
      throw ParsingException('Malformed post payload: $error');
    } on FormatException catch (error) {
      throw ParsingException('Malformed post payload: ${error.message}');
    }
  }
}

final postsRemoteDataSourceProvider = Provider<PostsRemoteDataSource>(
  (ref) => PostsRemoteDataSourceImpl(ref.watch(apiClientProvider)),
);
