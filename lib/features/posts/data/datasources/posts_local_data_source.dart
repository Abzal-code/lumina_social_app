import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

import '../../../../core/error/app_exception.dart';
import '../../domain/entities/post.dart';
import '../models/local_post_changes.dart';

/// Skips malformed entries while treating unreadable stored values as errors.
abstract interface class PostsLocalDataSource {
  Future<LocalPostChanges> getChanges();

  Future<Post> createLocalPost({
    required int authorId,
    required String title,
    required String body,
  });

  Future<void> saveUpdatedPost(Post post);

  Future<void> saveDeletedPost(int postId);
}

class SharedPreferencesPostsLocalDataSource implements PostsLocalDataSource {
  const SharedPreferencesPostsLocalDataSource(this._preferences);

  static const _createdKey = 'post_changes_created';
  static const _updatedKey = 'post_changes_updated';
  static const _deletedKey = 'post_changes_deleted_ids';
  static const _nextLocalIdKey = 'post_changes_next_local_id';

  final Future<SharedPreferences> _preferences;

  @override
  Future<LocalPostChanges> getChanges() async {
    final preferences = await _openPreferences();
    return _readChanges(preferences);
  }

  @override
  Future<Post> createLocalPost({
    required int authorId,
    required String title,
    required String body,
  }) async {
    if (authorId <= 0) {
      throw NotFoundException('Invalid author id: $authorId');
    }
    final preferences = await _openPreferences();
    final changes = _readChanges(preferences);
    final post = Post(
      id: changes.nextLocalId,
      authorId: authorId,
      title: title,
      body: body,
    );
    await _writeNextLocalId(preferences, changes.nextLocalId - 1);
    await _writeCreated(preferences, [...changes.createdPosts, post]);
    return post;
  }

  @override
  Future<void> saveUpdatedPost(Post post) async {
    if (post.id == 0 || post.authorId <= 0) {
      throw NotFoundException('Invalid post: ${post.id}/${post.authorId}');
    }
    final preferences = await _openPreferences();
    final changes = _readChanges(preferences);
    if (changes.deletedPostIds.contains(post.id)) {
      throw NotFoundException('Cannot update deleted post ${post.id}');
    }
    if (post.id < 0) {
      if (!changes.createdPosts.any((created) => created.id == post.id)) {
        throw NotFoundException('Unknown local post id: ${post.id}');
      }
      await _writeCreated(preferences, [
        for (final created in changes.createdPosts)
          created.id == post.id ? post : created,
      ]);
      return;
    }
    await _writeUpdated(preferences, {...changes.updatedPosts, post.id: post});
  }

  @override
  Future<void> saveDeletedPost(int postId) async {
    if (postId == 0) {
      throw NotFoundException('Invalid post id: $postId');
    }
    final preferences = await _openPreferences();
    final changes = _readChanges(preferences);
    if (postId < 0) {
      final exists = changes.createdPosts.any((post) => post.id == postId);

      if (!exists) {
        throw NotFoundException('Unknown local post id: $postId');
      }

      await _writeCreated(preferences, [
        for (final created in changes.createdPosts)
          if (created.id != postId) created,
      ]);
      return;
    }
    await _writeDeleted(preferences, {...changes.deletedPostIds, postId});
    if (changes.updatedPosts.containsKey(postId)) {
      final remaining = {...changes.updatedPosts}..remove(postId);
      await _writeUpdated(preferences, remaining);
    }
  }

  Future<SharedPreferences> _openPreferences() async {
    try {
      return await _preferences;
    } on AppException {
      rethrow;
    } catch (_) {
      throw const UnexpectedException('Failed to access local post storage');
    }
  }

  LocalPostChanges _readChanges(SharedPreferences preferences) {
    final createdPosts = _readCreated(preferences);
    return LocalPostChanges(
      createdPosts: createdPosts,
      updatedPosts: _readUpdated(preferences),
      deletedPostIds: _readDeleted(preferences),
      nextLocalId: _readNextLocalId(preferences, createdPosts),
    );
  }

  List<Post> _readCreated(SharedPreferences preferences) {
    final elements = _decodeStoredList(preferences, _createdKey);
    final seenIds = <int>{};
    return [
      for (final element in elements)
        if (_postFromJson(element) case final Post post
            when post.id < 0 && seenIds.add(post.id))
          post,
    ];
  }

  Map<int, Post> _readUpdated(SharedPreferences preferences) {
    final elements = _decodeStoredList(preferences, _updatedKey);
    return {
      for (final element in elements)
        if (_postFromJson(element) case final Post post when post.id > 0)
          post.id: post,
    };
  }

  Set<int> _readDeleted(SharedPreferences preferences) {
    final List<String> entries;
    try {
      entries = preferences.getStringList(_deletedKey) ?? const [];
    } on AppException {
      rethrow;
    } catch (_) {
      throw ParsingException('Unreadable value for $_deletedKey');
    }
    return {
      for (final entry in entries)
        if (int.tryParse(entry) case final int id when id > 0) id,
    };
  }

  int _readNextLocalId(SharedPreferences preferences, List<Post> created) {
    final int? stored;
    try {
      stored = preferences.getInt(_nextLocalIdKey);
    } on AppException {
      rethrow;
    } catch (_) {
      throw ParsingException('Unreadable value for $_nextLocalIdKey');
    }
    final lowestCreatedId = created.isEmpty
        ? 0
        : created.map((post) => post.id).reduce((a, b) => a < b ? a : b);
    if (stored == null || stored >= 0) {
      return lowestCreatedId - 1;
    }
    return stored < lowestCreatedId ? stored : lowestCreatedId - 1;
  }

  List<Object?> _decodeStoredList(SharedPreferences preferences, String key) {
    final String? stored;
    try {
      stored = preferences.getString(key);
    } on AppException {
      rethrow;
    } catch (_) {
      throw ParsingException('Unreadable value for $key');
    }
    if (stored == null) {
      return const [];
    }
    final Object? decoded;
    try {
      decoded = jsonDecode(stored);
    } on FormatException {
      throw ParsingException('Corrupted JSON for $key');
    }
    if (decoded is! List) {
      throw ParsingException('Expected a JSON list for $key');
    }
    return decoded;
  }

  Post? _postFromJson(Object? element) {
    if (element is! Map<String, dynamic>) {
      return null;
    }
    final id = element['id'];
    final authorId = element['authorId'];
    final title = element['title'];
    final body = element['body'];
    if (id is! int || authorId is! int || authorId <= 0) {
      return null;
    }
    if (title is! String || body is! String) {
      return null;
    }
    return Post(id: id, authorId: authorId, title: title, body: body);
  }

  Map<String, Object?> _postToJson(Post post) => {
    'id': post.id,
    'authorId': post.authorId,
    'title': post.title,
    'body': post.body,
  };

  Future<void> _writeCreated(SharedPreferences preferences, List<Post> posts) =>
      _writeString(
        preferences,
        _createdKey,
        jsonEncode([for (final post in posts) _postToJson(post)]),
      );

  Future<void> _writeUpdated(
    SharedPreferences preferences,
    Map<int, Post> posts,
  ) {
    final sortedIds = posts.keys.toList()..sort();
    return _writeString(
      preferences,
      _updatedKey,
      jsonEncode([for (final id in sortedIds) _postToJson(posts[id]!)]),
    );
  }

  Future<void> _writeDeleted(SharedPreferences preferences, Set<int> ids) {
    final sortedIds = ids.toList()..sort();
    return _guardWrite(
      _deletedKey,
      () => preferences.setStringList(_deletedKey, [
        for (final id in sortedIds) '$id',
      ]),
    );
  }

  Future<void> _writeNextLocalId(SharedPreferences preferences, int nextId) =>
      _guardWrite(
        _nextLocalIdKey,
        () => preferences.setInt(_nextLocalIdKey, nextId),
      );

  Future<void> _writeString(
    SharedPreferences preferences,
    String key,
    String value,
  ) => _guardWrite(key, () => preferences.setString(key, value));

  Future<void> _guardWrite(String key, Future<bool> Function() write) async {
    final bool written;
    try {
      written = await write();
    } on AppException {
      rethrow;
    } catch (_) {
      throw UnexpectedException('Failed to persist $key');
    }
    if (!written) {
      throw UnexpectedException('Failed to persist $key');
    }
  }
}
