import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/error/app_exception.dart';
import '../../../../core/network/api_client.dart';
import '../dto/comment_dto.dart';

/// Implementations throw [AppException] subtypes on error.
abstract interface class CommentsRemoteDataSource {
  Future<List<CommentDto>> getCommentsForPost(int postId);
}

class CommentsRemoteDataSourceImpl implements CommentsRemoteDataSource {
  const CommentsRemoteDataSourceImpl(this._client);

  final ApiClient _client;

  @override
  Future<List<CommentDto>> getCommentsForPost(int postId) async {
    if (postId <= 0) {
      throw NotFoundException('Invalid post id: $postId');
    }
    final data = await _client.get('/posts/$postId/comments');
    if (data is! List) {
      throw ParsingException(
        'Expected a JSON list for /posts/$postId/comments, '
        'got ${data.runtimeType}',
      );
    }
    return data.map(_parseComment).toList(growable: false);
  }

  CommentDto _parseComment(Object? element) {
    if (element is! Map<String, dynamic>) {
      throw ParsingException(
        'Expected a JSON object in comments, got ${element.runtimeType}',
      );
    }
    try {
      return CommentDto.fromJson(element);
    } on TypeError catch (error) {
      throw ParsingException('Malformed comment payload: $error');
    } on FormatException catch (error) {
      throw ParsingException('Malformed comment payload: ${error.message}');
    }
  }
}

final commentsRemoteDataSourceProvider = Provider<CommentsRemoteDataSource>(
  (ref) => CommentsRemoteDataSourceImpl(ref.watch(apiClientProvider)),
);
