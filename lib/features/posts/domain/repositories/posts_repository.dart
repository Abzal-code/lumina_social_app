import '../entities/post.dart';

/// Implementations throw [AppFailure] subtypes on error; they never expose
/// infrastructure exceptions.
abstract interface class PostsRepository {
  Future<List<Post>> getPosts();

  Future<Post> getPost(int postId);

  Future<List<Post>> getPostsForUser(int userId);
}
