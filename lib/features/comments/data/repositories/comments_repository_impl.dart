import '../../../../core/error/app_exception.dart';
import '../../../../core/error/failure_mapper.dart';
import '../../domain/entities/comment.dart';
import '../../domain/repositories/comments_repository.dart';
import '../datasources/comments_remote_data_source.dart';
import '../mappers/comment_mapper.dart';

class CommentsRepositoryImpl implements CommentsRepository {
  const CommentsRepositoryImpl(this._remoteDataSource);

  final CommentsRemoteDataSource _remoteDataSource;

  @override
  Future<List<Comment>> getCommentsForPost(int postId) async {
    try {
      final dtos = await _remoteDataSource.getCommentsForPost(postId);
      return dtos.map(commentFromDto).toList(growable: false);
    } on AppException catch (exception) {
      throw mapExceptionToFailure(exception);
    }
  }
}
