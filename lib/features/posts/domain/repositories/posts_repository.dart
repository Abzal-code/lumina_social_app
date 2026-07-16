import '../entities/post.dart';

/// Implementations throw [AppFailure] subtypes on error; they never expose
/// infrastructure exceptions.
abstract interface class PostsRepository {
  Future<List<Post>> getPosts();

  Future<Post> getPost(int postId);

  Future<List<Post>> getPostsForUser(int userId);

  Future<Post> createPost({
    required int authorId,
    required String title,
    required String body,
  });

  Future<Post> updatePost({
    required int postId,
    required int authorId,
    required String title,
    required String body,
  });

  Future<void> deletePost(int postId);
}
