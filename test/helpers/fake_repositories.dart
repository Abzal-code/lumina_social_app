import 'package:lumina/core/error/app_exception.dart';
import 'package:lumina/features/favorites/domain/repositories/favorites_repository.dart';
import 'package:lumina/features/posts/data/datasources/posts_local_data_source.dart';
import 'package:lumina/features/posts/data/models/local_post_changes.dart';
import 'package:lumina/features/posts/domain/entities/post.dart';
import 'package:lumina/features/users/domain/entities/address.dart';
import 'package:lumina/features/users/domain/entities/company.dart';
import 'package:lumina/features/users/domain/entities/geo_location.dart';
import 'package:lumina/features/users/domain/entities/user.dart';
import 'package:lumina/features/users/domain/repositories/users_repository.dart';

/// In-memory [FavoritesRepository] for tests that never touches
/// SharedPreferences.
class FakeFavoritesRepository implements FavoritesRepository {
  FakeFavoritesRepository({Set<int>? initialIds}) : _ids = {...?initialIds};

  final Set<int> _ids;

  @override
  Future<Set<int>> getFavoritePostIds() async => {..._ids};

  @override
  Future<void> addFavorite(int postId) async {
    _ids.add(postId);
  }

  @override
  Future<void> removeFavorite(int postId) async {
    _ids.remove(postId);
  }
}

/// In-memory [PostsLocalDataSource] for tests that never touches
/// SharedPreferences. Failures can be injected through [readError] and
/// [writeError].
class FakePostsLocalDataSource implements PostsLocalDataSource {
  FakePostsLocalDataSource({LocalPostChanges? initialChanges})
    : changes = initialChanges ?? const LocalPostChanges();

  LocalPostChanges changes;
  AppException? readError;
  AppException? writeError;

  @override
  Future<LocalPostChanges> getChanges() async {
    if (readError case final error?) {
      throw error;
    }
    return changes;
  }

  @override
  Future<Post> createLocalPost({
    required int authorId,
    required String title,
    required String body,
  }) async {
    _checkWrite();
    final post = Post(
      id: changes.nextLocalId,
      authorId: authorId,
      title: title,
      body: body,
    );
    changes = changes.copyWith(
      createdPosts: [...changes.createdPosts, post],
      nextLocalId: changes.nextLocalId - 1,
    );
    return post;
  }

  @override
  Future<void> saveUpdatedPost(Post post) async {
    _checkWrite();
    if (changes.deletedPostIds.contains(post.id)) {
      throw NotFoundException('Cannot update deleted post ${post.id}');
    }
    if (post.id < 0) {
      changes = changes.copyWith(
        createdPosts: [
          for (final created in changes.createdPosts)
            created.id == post.id ? post : created,
        ],
      );
      return;
    }
    changes = changes.copyWith(
      updatedPosts: {...changes.updatedPosts, post.id: post},
    );
  }

  @override
  Future<void> saveDeletedPost(int postId) async {
    _checkWrite();
    if (postId < 0) {
      changes = changes.copyWith(
        createdPosts: [
          for (final created in changes.createdPosts)
            if (created.id != postId) created,
        ],
      );
      return;
    }
    changes = changes.copyWith(
      deletedPostIds: {...changes.deletedPostIds, postId},
      updatedPosts: {...changes.updatedPosts}..remove(postId),
    );
  }

  void _checkWrite() {
    if (writeError case final error?) {
      throw error;
    }
  }
}

/// In-memory [UsersRepository] serving a fixed users list.
class FakeUsersRepository implements UsersRepository {
  FakeUsersRepository({List<User>? users}) : _users = users ?? defaultUsers;

  static final defaultUsers = [
    testUser(1, name: 'Leanne Graham'),
    testUser(2, name: 'Ervin Howell'),
  ];

  final List<User> _users;

  @override
  Future<List<User>> getUsers() async => [..._users];

  @override
  Future<User> getUser(int userId) async =>
      _users.firstWhere((user) => user.id == userId);
}

User testUser(int id, {required String name}) => User(
  id: id,
  name: name,
  username: name.split(' ').first,
  email: 'user$id@example.org',
  phone: '555-0100',
  website: 'example.org',
  address: const Address(
    street: 'Main Street',
    suite: 'Apt. 1',
    city: 'Springfield',
    zipcode: '12345',
    geo: GeoLocation(latitude: 1.5, longitude: -2.5),
  ),
  company: const Company(
    name: 'Acme',
    catchPhrase: 'catch phrase',
    businessSummary: 'business summary',
  ),
);
