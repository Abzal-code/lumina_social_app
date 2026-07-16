import 'package:flutter_test/flutter_test.dart';
import 'package:lumina/core/error/app_exception.dart';
import 'package:lumina/core/error/app_failure.dart';
import 'package:lumina/features/posts/data/datasources/posts_remote_data_source.dart';
import 'package:lumina/features/posts/data/dto/post_dto.dart';
import 'package:lumina/features/posts/data/models/local_post_changes.dart';
import 'package:lumina/features/posts/data/repositories/posts_repository_impl.dart';
import 'package:lumina/features/posts/domain/entities/post.dart';
import 'package:mocktail/mocktail.dart';

import '../../../../helpers/fake_repositories.dart';

class _MockPostsRemoteDataSource extends Mock
    implements PostsRemoteDataSource {}

void main() {
  late _MockPostsRemoteDataSource dataSource;
  late FakePostsLocalDataSource localDataSource;
  late PostsRepositoryImpl repository;

  setUp(() {
    dataSource = _MockPostsRemoteDataSource();
    localDataSource = FakePostsLocalDataSource();
    repository = PostsRepositoryImpl(dataSource, localDataSource);
  });

  group('PostsRepositoryImpl.getPosts', () {
    test('maps DTOs to domain entities with userId as authorId', () async {
      when(() => dataSource.getPosts()).thenAnswer(
        (_) async => const [
          PostDto(userId: 7, id: 1, title: 'first', body: 'body one'),
        ],
      );

      final posts = await repository.getPosts();

      expect(posts, const [
        Post(id: 1, authorId: 7, title: 'first', body: 'body one'),
      ]);
    });

    test('preserves the order returned by the data source', () async {
      when(() => dataSource.getPosts()).thenAnswer(
        (_) async => const [
          PostDto(userId: 1, id: 5, title: 'c', body: 'c'),
          PostDto(userId: 2, id: 2, title: 'a', body: 'a'),
          PostDto(userId: 3, id: 9, title: 'b', body: 'b'),
        ],
      );

      final posts = await repository.getPosts();

      expect(posts.map((post) => post.id), [5, 2, 9]);
    });

    test('maps NetworkException to NetworkFailure', () {
      when(() => dataSource.getPosts()).thenThrow(const NetworkException());

      expect(repository.getPosts(), throwsA(isA<NetworkFailure>()));
    });

    test('maps ParsingException to DataParsingFailure', () {
      when(() => dataSource.getPosts()).thenThrow(const ParsingException());

      expect(repository.getPosts(), throwsA(isA<DataParsingFailure>()));
    });

    test('maps ServerException to ServerFailure keeping the status code', () {
      when(
        () => dataSource.getPosts(),
      ).thenThrow(const ServerException(statusCode: 503));

      expect(
        repository.getPosts(),
        throwsA(
          isA<ServerFailure>().having(
            (failure) => failure.statusCode,
            'statusCode',
            503,
          ),
        ),
      );
    });
  });

  group('PostsRepositoryImpl.getPost', () {
    test('maps the DTO to a domain entity with userId as authorId', () async {
      when(() => dataSource.getPost(10)).thenAnswer(
        (_) async =>
            const PostDto(userId: 4, id: 10, title: 'one', body: 'body'),
      );

      final post = await repository.getPost(10);

      expect(post, const Post(id: 10, authorId: 4, title: 'one', body: 'body'));
    });

    test('maps NotFoundException to NotFoundFailure', () {
      when(() => dataSource.getPost(999)).thenThrow(const NotFoundException());

      expect(repository.getPost(999), throwsA(isA<NotFoundFailure>()));
    });

    test('surfaces the typed failure for invalid IDs without network', () {
      when(() => dataSource.getPost(0)).thenThrow(const NotFoundException());

      expect(repository.getPost(0), throwsA(isA<NotFoundFailure>()));
    });
  });

  group('PostsRepositoryImpl.getPostsForUser', () {
    test('maps DTOs to domain entities preserving order', () async {
      when(() => dataSource.getPostsForUser(7)).thenAnswer(
        (_) async => const [
          PostDto(userId: 7, id: 9, title: 'b', body: 'b'),
          PostDto(userId: 7, id: 2, title: 'a', body: 'a'),
        ],
      );

      final posts = await repository.getPostsForUser(7);

      expect(posts, const [
        Post(id: 9, authorId: 7, title: 'b', body: 'b'),
        Post(id: 2, authorId: 7, title: 'a', body: 'a'),
      ]);
    });

    test('maps NetworkException to NetworkFailure', () {
      when(
        () => dataSource.getPostsForUser(7),
      ).thenThrow(const NetworkException());

      expect(repository.getPostsForUser(7), throwsA(isA<NetworkFailure>()));
    });

    test('maps ServerException to ServerFailure keeping the status code', () {
      when(
        () => dataSource.getPostsForUser(7),
      ).thenThrow(const ServerException(statusCode: 502));

      expect(
        repository.getPostsForUser(7),
        throwsA(
          isA<ServerFailure>().having(
            (failure) => failure.statusCode,
            'statusCode',
            502,
          ),
        ),
      );
    });
  });

  group('PostsRepositoryImpl overlay merge', () {
    const remoteDtos = [
      PostDto(userId: 1, id: 1, title: 'remote one', body: 'r1'),
      PostDto(userId: 2, id: 2, title: 'remote two', body: 'r2'),
      PostDto(userId: 1, id: 3, title: 'remote three', body: 'r3'),
    ];
    const createdOld = Post(id: -1, authorId: 1, title: 'local a', body: 'la');
    const createdNew = Post(id: -2, authorId: 2, title: 'local b', body: 'lb');
    const updatedTwo = Post(id: 2, authorId: 2, title: 'edited', body: 'e2');

    setUp(() {
      when(() => dataSource.getPosts()).thenAnswer((_) async => remoteDtos);
    });

    test('created posts come first, newest local ID before older', () async {
      localDataSource.changes = const LocalPostChanges(
        createdPosts: [createdOld, createdNew],
        nextLocalId: -3,
      );

      final posts = await repository.getPosts();

      expect(posts.map((post) => post.id), [-2, -1, 1, 2, 3]);
    });

    test('an updated remote post replaces the original in place', () async {
      localDataSource.changes = const LocalPostChanges(
        updatedPosts: {2: updatedTwo},
      );

      final posts = await repository.getPosts();

      expect(posts.map((post) => post.id), [1, 2, 3]);
      expect(posts[1], updatedTwo);
    });

    test('a deleted post never appears', () async {
      localDataSource.changes = const LocalPostChanges(deletedPostIds: {2});

      final posts = await repository.getPosts();

      expect(posts.map((post) => post.id), [1, 3]);
    });

    test('created, updated, and deleted combine; remote order kept', () async {
      localDataSource.changes = const LocalPostChanges(
        createdPosts: [createdOld, createdNew],
        updatedPosts: {2: updatedTwo},
        deletedPostIds: {1},
        nextLocalId: -3,
      );

      final posts = await repository.getPosts();

      expect(posts.map((post) => post.id), [-2, -1, 2, 3]);
      expect(posts[2], updatedTwo);
    });

    test('getPost returns a locally created post without network', () async {
      localDataSource.changes = const LocalPostChanges(
        createdPosts: [createdOld],
        nextLocalId: -2,
      );

      final post = await repository.getPost(-1);

      expect(post, createdOld);
      verifyNever(() => dataSource.getPost(any()));
    });

    test('getPost returns the local update without network', () async {
      localDataSource.changes = const LocalPostChanges(
        updatedPosts: {2: updatedTwo},
      );

      final post = await repository.getPost(2);

      expect(post, updatedTwo);
      verifyNever(() => dataSource.getPost(any()));
    });

    test('getPost throws NotFoundFailure for a deleted ID', () async {
      localDataSource.changes = const LocalPostChanges(deletedPostIds: {2});

      await expectLater(repository.getPost(2), throwsA(isA<NotFoundFailure>()));
      verifyNever(() => dataSource.getPost(any()));
    });

    test('getPost throws NotFoundFailure for an unknown negative ID', () async {
      await expectLater(
        repository.getPost(-42),
        throwsA(isA<NotFoundFailure>()),
      );
      verifyNever(() => dataSource.getPost(any()));
    });

    test('getPostsForUser merges only that author’s local changes', () async {
      when(() => dataSource.getPostsForUser(1)).thenAnswer(
        (_) async => const [
          PostDto(userId: 1, id: 1, title: 'remote one', body: 'r1'),
          PostDto(userId: 1, id: 3, title: 'remote three', body: 'r3'),
        ],
      );
      localDataSource.changes = const LocalPostChanges(
        createdPosts: [createdOld, createdNew],
        deletedPostIds: {3},
        nextLocalId: -3,
      );

      final posts = await repository.getPostsForUser(1);

      expect(posts.map((post) => post.id), [-1, 1]);
    });

    test('getPostsForUser applies updates in place', () async {
      when(() => dataSource.getPostsForUser(2)).thenAnswer(
        (_) async => const [
          PostDto(userId: 2, id: 2, title: 'remote two', body: 'r2'),
        ],
      );
      localDataSource.changes = const LocalPostChanges(
        updatedPosts: {2: updatedTwo},
      );

      final posts = await repository.getPostsForUser(2);

      expect(posts, [updatedTwo]);
    });

    test('a post reassigned to another author moves between users', () async {
      when(() => dataSource.getPostsForUser(1)).thenAnswer(
        (_) async => const [
          PostDto(userId: 1, id: 1, title: 'remote one', body: 'r1'),
        ],
      );
      when(() => dataSource.getPostsForUser(9)).thenAnswer((_) async => []);
      const reassigned = Post(id: 1, authorId: 9, title: 'moved', body: 'm');
      localDataSource.changes = const LocalPostChanges(
        updatedPosts: {1: reassigned},
      );

      expect(await repository.getPostsForUser(1), isEmpty);
      expect(await repository.getPostsForUser(9), [reassigned]);
    });
  });

  group('PostsRepositoryImpl.createPost', () {
    setUp(() {
      when(
        () => dataSource.createPost(
          authorId: any(named: 'authorId'),
          title: any(named: 'title'),
          body: any(named: 'body'),
        ),
      ).thenAnswer(
        (_) async => const PostDto(userId: 1, id: 101, title: 't', body: 'b'),
      );
    });

    test('persists locally after remote success with a negative ID', () async {
      final post = await repository.createPost(
        authorId: 1,
        title: ' fresh ',
        body: ' body ',
      );

      expect(
        post,
        const Post(id: -1, authorId: 1, title: 'fresh', body: 'body'),
      );
      expect(localDataSource.changes.createdPosts, [post]);
      verify(
        () => dataSource.createPost(authorId: 1, title: 'fresh', body: 'body'),
      ).called(1);
    });

    test('ignores the server-assigned ID entirely', () async {
      final first = await repository.createPost(
        authorId: 1,
        title: 'a',
        body: 'a',
      );
      final second = await repository.createPost(
        authorId: 1,
        title: 'b',
        body: 'b',
      );

      expect(first.id, -1);
      expect(second.id, -2);
    });

    test('does not persist when the remote create fails', () async {
      when(
        () => dataSource.createPost(
          authorId: any(named: 'authorId'),
          title: any(named: 'title'),
          body: any(named: 'body'),
        ),
      ).thenThrow(const NetworkException());

      await expectLater(
        repository.createPost(authorId: 1, title: 't', body: 'b'),
        throwsA(isA<NetworkFailure>()),
      );
      expect(localDataSource.changes.createdPosts, isEmpty);
    });

    test('surfaces a local persistence failure after remote success', () async {
      localDataSource.writeError = const UnexpectedException('disk full');

      await expectLater(
        repository.createPost(authorId: 1, title: 't', body: 'b'),
        throwsA(isA<UnexpectedFailure>()),
      );
    });

    test('rejects invalid input before any network call', () async {
      await expectLater(
        repository.createPost(authorId: 0, title: 't', body: 'b'),
        throwsA(isA<ValidationFailure>()),
      );
      await expectLater(
        repository.createPost(authorId: 1, title: '  ', body: 'b'),
        throwsA(isA<ValidationFailure>()),
      );
      await expectLater(
        repository.createPost(authorId: 1, title: 't', body: ''),
        throwsA(isA<ValidationFailure>()),
      );
      verifyNever(
        () => dataSource.createPost(
          authorId: any(named: 'authorId'),
          title: any(named: 'title'),
          body: any(named: 'body'),
        ),
      );
    });
  });

  group('PostsRepositoryImpl.updatePost', () {
    test('updates a locally created post without any remote call', () async {
      localDataSource.changes = const LocalPostChanges(
        createdPosts: [Post(id: -1, authorId: 1, title: 'old', body: 'old')],
        nextLocalId: -2,
      );

      final post = await repository.updatePost(
        postId: -1,
        authorId: 2,
        title: 'new',
        body: 'new body',
      );

      expect(
        post,
        const Post(id: -1, authorId: 2, title: 'new', body: 'new body'),
      );
      expect(localDataSource.changes.createdPosts, [post]);
      expect(localDataSource.changes.updatedPosts, isEmpty);
      verifyNever(
        () => dataSource.updatePost(
          postId: any(named: 'postId'),
          authorId: any(named: 'authorId'),
          title: any(named: 'title'),
          body: any(named: 'body'),
        ),
      );
    });

    test('persists a remote post edit after PATCH succeeds', () async {
      when(
        () => dataSource.updatePost(
          postId: 2,
          authorId: 2,
          title: 'edited',
          body: 'body',
        ),
      ).thenAnswer(
        (_) async =>
            const PostDto(userId: 2, id: 2, title: 'edited', body: 'body'),
      );

      final post = await repository.updatePost(
        postId: 2,
        authorId: 2,
        title: ' edited ',
        body: ' body ',
      );

      expect(
        post,
        const Post(id: 2, authorId: 2, title: 'edited', body: 'body'),
      );
      expect(localDataSource.changes.updatedPosts, {2: post});
    });

    test('does not persist when the remote PATCH fails', () async {
      when(
        () => dataSource.updatePost(
          postId: any(named: 'postId'),
          authorId: any(named: 'authorId'),
          title: any(named: 'title'),
          body: any(named: 'body'),
        ),
      ).thenThrow(const ServerException(statusCode: 500));

      await expectLater(
        repository.updatePost(postId: 2, authorId: 1, title: 't', body: 'b'),
        throwsA(isA<ServerFailure>()),
      );
      expect(localDataSource.changes.updatedPosts, isEmpty);
    });

    test('rejects updates to deleted posts', () async {
      localDataSource.changes = const LocalPostChanges(deletedPostIds: {2});

      await expectLater(
        repository.updatePost(postId: 2, authorId: 1, title: 't', body: 'b'),
        throwsA(isA<NotFoundFailure>()),
      );
      verifyNever(
        () => dataSource.updatePost(
          postId: any(named: 'postId'),
          authorId: any(named: 'authorId'),
          title: any(named: 'title'),
          body: any(named: 'body'),
        ),
      );
    });

    test('rejects unknown negative IDs and invalid input', () async {
      await expectLater(
        repository.updatePost(postId: -5, authorId: 1, title: 't', body: 'b'),
        throwsA(isA<NotFoundFailure>()),
      );
      await expectLater(
        repository.updatePost(postId: 0, authorId: 1, title: 't', body: 'b'),
        throwsA(isA<NotFoundFailure>()),
      );
      await expectLater(
        repository.updatePost(postId: 2, authorId: 1, title: '', body: 'b'),
        throwsA(isA<ValidationFailure>()),
      );
      verifyNever(
        () => dataSource.updatePost(
          postId: any(named: 'postId'),
          authorId: any(named: 'authorId'),
          title: any(named: 'title'),
          body: any(named: 'body'),
        ),
      );
    });
  });

  group('PostsRepositoryImpl.deletePost', () {
    test('removes a locally created post without any remote call', () async {
      localDataSource.changes = const LocalPostChanges(
        createdPosts: [Post(id: -1, authorId: 1, title: 't', body: 'b')],
        nextLocalId: -2,
      );

      await repository.deletePost(-1);

      expect(localDataSource.changes.createdPosts, isEmpty);
      expect(localDataSource.changes.deletedPostIds, isEmpty);
      verifyNever(() => dataSource.deletePost(any()));
    });

    test('records a remote post ID after DELETE succeeds', () async {
      when(() => dataSource.deletePost(2)).thenAnswer((_) async {});

      await repository.deletePost(2);

      expect(localDataSource.changes.deletedPostIds, {2});
      verify(() => dataSource.deletePost(2)).called(1);
    });

    test('does not persist when the remote DELETE fails', () async {
      when(() => dataSource.deletePost(2)).thenThrow(const NetworkException());

      await expectLater(
        repository.deletePost(2),
        throwsA(isA<NetworkFailure>()),
      );
      expect(localDataSource.changes.deletedPostIds, isEmpty);
    });

    test('rejects already-deleted, unknown local, and invalid IDs', () async {
      localDataSource.changes = const LocalPostChanges(deletedPostIds: {2});

      await expectLater(
        repository.deletePost(2),
        throwsA(isA<NotFoundFailure>()),
      );
      await expectLater(
        repository.deletePost(-7),
        throwsA(isA<NotFoundFailure>()),
      );
      await expectLater(
        repository.deletePost(0),
        throwsA(isA<NotFoundFailure>()),
      );
      verifyNever(() => dataSource.deletePost(any()));
    });
  });
}
