import '../../../../core/error/app_exception.dart';
import '../../../../core/error/app_failure.dart';
import '../../../../core/error/failure_mapper.dart';
import '../../domain/entities/post.dart';
import '../../domain/repositories/posts_repository.dart';
import '../datasources/posts_local_data_source.dart';
import '../datasources/posts_remote_data_source.dart';
import '../mappers/post_mapper.dart';
import '../models/local_post_changes.dart';

class PostsRepositoryImpl implements PostsRepository {
  const PostsRepositoryImpl(this._remoteDataSource, this._localDataSource);

  final PostsRemoteDataSource _remoteDataSource;
  final PostsLocalDataSource _localDataSource;

  @override
  Future<List<Post>> getPosts() async {
    try {
      final dtos = await _remoteDataSource.getPosts();
      final changes = await _localDataSource.getChanges();
      return _mergeWithChanges(dtos.map(postFromDto), changes);
    } on AppException catch (exception) {
      throw mapExceptionToFailure(exception);
    }
  }

  @override
  Future<Post> getPost(int postId) async {
    try {
      final changes = await _localDataSource.getChanges();
      final localPost = _findLocalVersion(postId, changes);
      if (localPost != null) {
        return localPost;
      }
      if (postId < 0) {
        // Negative IDs exist only locally; the server cannot know them.
        throw const NotFoundFailure();
      }
      final dto = await _remoteDataSource.getPost(postId);
      // The post may have been mutated while the fetch was in flight.
      final freshChanges = await _localDataSource.getChanges();
      final freshLocalPost = _findLocalVersion(postId, freshChanges);
      return freshLocalPost ?? postFromDto(dto);
    } on AppException catch (exception) {
      throw mapExceptionToFailure(exception);
    }
  }

  @override
  Future<List<Post>> getPostsForUser(int userId) async {
    try {
      final dtos = await _remoteDataSource.getPostsForUser(userId);
      final changes = await _localDataSource.getChanges();
      final merged = _mergeWithChanges(
        dtos.map(postFromDto),
        changes,
        authorId: userId,
      );
      return [...merged, ..._reassignedPostsForUser(userId, changes, merged)];
    } on AppException catch (exception) {
      throw mapExceptionToFailure(exception);
    }
  }

  @override
  Future<Post> createPost({
    required int authorId,
    required String title,
    required String body,
  }) async {
    final trimmedTitle = _validText(title);
    final trimmedBody = _validText(body);
    _validateAuthorId(authorId);
    try {
      // JSONPlaceholder acknowledges the create but never persists it, and
      // its echoed ID collides across requests, so local identity comes from
      // the negative-ID allocator instead.
      await _remoteDataSource.createPost(
        authorId: authorId,
        title: trimmedTitle,
        body: trimmedBody,
      );
      return await _localDataSource.createLocalPost(
        authorId: authorId,
        title: trimmedTitle,
        body: trimmedBody,
      );
    } on AppException catch (exception) {
      throw mapExceptionToFailure(exception);
    }
  }

  @override
  Future<Post> updatePost({
    required int postId,
    required int authorId,
    required String title,
    required String body,
  }) async {
    final trimmedTitle = _validText(title);
    final trimmedBody = _validText(body);
    _validateAuthorId(authorId);
    if (postId == 0) {
      throw const NotFoundFailure();
    }
    final post = Post(
      id: postId,
      authorId: authorId,
      title: trimmedTitle,
      body: trimmedBody,
    );
    try {
      final changes = await _localDataSource.getChanges();
      if (changes.deletedPostIds.contains(postId)) {
        throw const NotFoundFailure();
      }
      if (postId < 0) {
        if (!changes.createdPosts.any((created) => created.id == postId)) {
          throw const NotFoundFailure();
        }
      } else {
        await _remoteDataSource.updatePost(
          postId: postId,
          authorId: authorId,
          title: trimmedTitle,
          body: trimmedBody,
        );
      }
      await _localDataSource.saveUpdatedPost(post);
      return post;
    } on AppException catch (exception) {
      throw mapExceptionToFailure(exception);
    }
  }

  @override
  Future<void> deletePost(int postId) async {
    if (postId == 0) {
      throw const NotFoundFailure();
    }
    try {
      final changes = await _localDataSource.getChanges();
      if (postId < 0) {
        if (!changes.createdPosts.any((created) => created.id == postId)) {
          throw const NotFoundFailure();
        }
      } else {
        if (changes.deletedPostIds.contains(postId)) {
          throw const NotFoundFailure();
        }
        await _remoteDataSource.deletePost(postId);
      }
      await _localDataSource.saveDeletedPost(postId);
    } on AppException catch (exception) {
      throw mapExceptionToFailure(exception);
    }
  }

  /// Created posts (newest first, optionally narrowed to [authorId]) precede
  /// the remote list; deletions and updates apply in the remote positions.
  List<Post> _mergeWithChanges(
    Iterable<Post> remotePosts,
    LocalPostChanges changes, {
    int? authorId,
  }) {
    final merged = <Post>[
      for (final created in changes.createdPosts.reversed)
        if (authorId == null || created.authorId == authorId) created,
    ];
    for (final post in remotePosts) {
      if (changes.deletedPostIds.contains(post.id)) {
        continue;
      }
      final effective = changes.updatedPosts[post.id] ?? post;
      if (authorId == null || effective.authorId == authorId) {
        merged.add(effective);
      }
    }
    return merged;
  }

  /// Updates may move a remote post to another author; such posts never
  /// appear in the server's per-user response, so they are appended here.
  List<Post> _reassignedPostsForUser(
    int userId,
    LocalPostChanges changes,
    List<Post> alreadyIncluded,
  ) {
    final includedIds = {for (final post in alreadyIncluded) post.id};
    final sortedIds = changes.updatedPosts.keys.toList()..sort();
    final result = <Post>[];

    for (final id in sortedIds) {
      if (changes.deletedPostIds.contains(id) || includedIds.contains(id)) {
        continue;
      }

      final updated = changes.updatedPosts[id]!;
      if (updated.authorId == userId) {
        result.add(updated);
      }
    }

    return result;
  }

  Post? _findLocalVersion(int postId, LocalPostChanges changes) {
    if (changes.deletedPostIds.contains(postId)) {
      throw const NotFoundFailure();
    }
    for (final created in changes.createdPosts) {
      if (created.id == postId) {
        return created;
      }
    }
    return changes.updatedPosts[postId];
  }

  void _validateAuthorId(int authorId) {
    if (authorId <= 0) {
      throw const ValidationFailure();
    }
  }

  String _validText(String value) {
    final trimmed = value.trim();
    if (trimmed.isEmpty) {
      throw const ValidationFailure();
    }
    return trimmed;
  }
}
