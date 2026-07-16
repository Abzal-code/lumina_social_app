import '../../../../core/error/app_exception.dart';
import '../../../../core/network/api_client.dart';
import '../dto/post_dto.dart';

/// Implementations throw [AppException] subtypes on error.
///
/// JSONPlaceholder accepts mutations but never persists them; callers are
/// responsible for keeping successful mutation results locally.
abstract interface class PostsRemoteDataSource {
  Future<List<PostDto>> getPosts();

  Future<PostDto> getPost(int postId);

  Future<List<PostDto>> getPostsForUser(int userId);

  Future<PostDto> createPost({
    required int authorId,
    required String title,
    required String body,
  });

  Future<PostDto> updatePost({
    required int postId,
    required int authorId,
    required String title,
    required String body,
  });

  Future<void> deletePost(int postId);
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

  @override
  Future<List<PostDto>> getPostsForUser(int userId) async {
    if (userId <= 0) {
      throw NotFoundException('Invalid user id: $userId');
    }
    final data = await _client.get('/users/$userId/posts');
    if (data is! List) {
      throw ParsingException(
        'Expected a JSON list for /users/$userId/posts, '
        'got ${data.runtimeType}',
      );
    }
    return data.map(_parsePost).toList(growable: false);
  }

  @override
  Future<PostDto> createPost({
    required int authorId,
    required String title,
    required String body,
  }) async {
    if (authorId <= 0) {
      throw NotFoundException('Invalid author id: $authorId');
    }
    final data = await _client.post(
      '/posts',
      body: {
        'userId': authorId,
        'title': _requireText(title, 'title'),
        'body': _requireText(body, 'body'),
      },
    );
    return _parsePost(data);
  }

  @override
  Future<PostDto> updatePost({
    required int postId,
    required int authorId,
    required String title,
    required String body,
  }) async {
    if (postId <= 0) {
      throw NotFoundException('Invalid post id: $postId');
    }
    if (authorId <= 0) {
      throw NotFoundException('Invalid author id: $authorId');
    }
    final data = await _client.patch(
      '/posts/$postId',
      body: {
        'userId': authorId,
        'title': _requireText(title, 'title'),
        'body': _requireText(body, 'body'),
      },
    );
    return _parsePost(data);
  }

  @override
  Future<void> deletePost(int postId) async {
    if (postId <= 0) {
      throw NotFoundException('Invalid post id: $postId');
    }
    // JSONPlaceholder responds with an empty object; the body carries no
    // information, so a successful status is all that matters here.
    await _client.delete('/posts/$postId');
  }

  String _requireText(String value, String field) {
    final trimmed = value.trim();
    if (trimmed.isEmpty) {
      throw UnexpectedException('Post $field must not be empty');
    }
    return trimmed;
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
