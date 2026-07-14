import '../entities/comment.dart';

/// Implementations throw [AppFailure] subtypes on error; they never expose
/// infrastructure exceptions.
abstract interface class CommentsRepository {
  Future<List<Comment>> getCommentsForPost(int postId);
}
