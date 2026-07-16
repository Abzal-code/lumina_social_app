import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lumina/core/error/app_failure.dart';
import 'package:lumina/features/comments/di.dart';
import 'package:lumina/features/comments/domain/entities/comment.dart';
import 'package:lumina/features/comments/domain/repositories/comments_repository.dart';
import 'package:lumina/features/posts/application/post_details_controller.dart';
import 'package:lumina/features/posts/application/post_details_state.dart';
import 'package:lumina/features/posts/application/posts_controller.dart';
import 'package:lumina/features/posts/di.dart';
import 'package:lumina/features/posts/domain/entities/post.dart';
import 'package:lumina/features/posts/domain/repositories/posts_repository.dart';
import 'package:mocktail/mocktail.dart';

class _MockPostsRepository extends Mock implements PostsRepository {}

class _MockCommentsRepository extends Mock implements CommentsRepository {}

const _post = Post(id: 2, authorId: 1, title: 'Loaded post', body: 'Body');

const _comments = [
  Comment(
    id: 1,
    postId: 2,
    name: 'First commenter',
    email: 'first@example.com',
    body: 'Nice read',
  ),
  Comment(
    id: 2,
    postId: 2,
    name: 'Second commenter',
    email: 'second@example.com',
    body: 'Agreed',
  ),
];

void main() {
  late _MockPostsRepository postsRepository;
  late _MockCommentsRepository commentsRepository;

  setUp(() {
    postsRepository = _MockPostsRepository();
    commentsRepository = _MockCommentsRepository();
    when(
      () => commentsRepository.getCommentsForPost(any()),
    ).thenAnswer((_) async => _comments);
  });

  ProviderContainer createContainer() {
    final container = ProviderContainer(
      overrides: [
        postsRepositoryProvider.overrideWithValue(postsRepository),
        commentsRepositoryProvider.overrideWithValue(commentsRepository),
      ],
    );
    addTearDown(container.dispose);
    return container;
  }

  ProviderContainer detailsContainer(int postId) {
    final container = createContainer();
    final subscription = container.listen(
      postDetailsControllerProvider(postId),
      (previous, next) {},
    );
    addTearDown(subscription.close);
    return container;
  }

  PostDetailsState stateOf(ProviderContainer container, [int postId = 2]) =>
      container.read(postDetailsControllerProvider(postId));

  PostDetailsController controllerOf(
    ProviderContainer container, [
    int postId = 2,
  ]) => container.read(postDetailsControllerProvider(postId).notifier);

  group('post resolution', () {
    test('reuses an already-loaded post without calling getPost', () async {
      when(() => postsRepository.getPosts()).thenAnswer((_) async => [_post]);
      final container = createContainer();
      final listSubscription = container.listen(
        postsControllerProvider,
        (previous, next) {},
      );
      addTearDown(listSubscription.close);
      await pumpEventQueue();

      final subscription = container.listen(
        postDetailsControllerProvider(2),
        (previous, next) {},
      );
      addTearDown(subscription.close);
      await pumpEventQueue();

      expect(stateOf(container).post, _post);
      expect(stateOf(container).isPostLoading, isFalse);
      verifyNever(() => postsRepository.getPost(any()));
    });

    test('falls back to getPost when the list is not loaded', () async {
      when(() => postsRepository.getPost(2)).thenAnswer((_) async => _post);

      final container = detailsContainer(2);
      await pumpEventQueue();

      expect(stateOf(container).post, _post);
      verify(() => postsRepository.getPost(2)).called(1);
    });

    test('exposes the failure and recovers via retryPost', () async {
      var calls = 0;
      when(() => postsRepository.getPost(2)).thenAnswer((_) async {
        calls++;
        if (calls == 1) {
          throw const NetworkFailure();
        }
        return _post;
      });

      final container = detailsContainer(2);
      await pumpEventQueue();

      expect(stateOf(container).postFailure, isA<NetworkFailure>());
      expect(stateOf(container).post, isNull);

      await controllerOf(container).retryPost();

      expect(stateOf(container).post, _post);
      expect(stateOf(container).postFailure, isNull);
      verify(() => postsRepository.getPost(2)).called(2);
    });
  });

  group('comments', () {
    setUp(() {
      when(() => postsRepository.getPost(2)).thenAnswer((_) async => _post);
    });

    test('loads comments independently of the post', () async {
      final container = detailsContainer(2);
      await pumpEventQueue();

      final state = stateOf(container);
      expect(state.comments, _comments);
      expect(state.areCommentsLoading, isFalse);
      expect(state.commentsFailure, isNull);
    });

    test('a comments failure does not hide the loaded post', () async {
      when(
        () => commentsRepository.getCommentsForPost(2),
      ).thenThrow(const ServerFailure(statusCode: 500));

      final container = detailsContainer(2);
      await pumpEventQueue();

      final state = stateOf(container);
      expect(state.post, _post);
      expect(state.comments, isEmpty);
      expect(state.commentsFailure, isA<ServerFailure>());
    });

    test('retryComments recovers from a failure', () async {
      var calls = 0;
      when(() => commentsRepository.getCommentsForPost(2)).thenAnswer((
        _,
      ) async {
        calls++;
        if (calls == 1) {
          throw const TimeoutFailure();
        }
        return _comments;
      });

      final container = detailsContainer(2);
      await pumpEventQueue();
      expect(stateOf(container).commentsFailure, isA<TimeoutFailure>());

      await controllerOf(container).retryComments();

      expect(stateOf(container).comments, _comments);
      expect(stateOf(container).commentsFailure, isNull);
    });

    test('refresh keeps old comments while pending, then replaces', () async {
      var calls = 0;
      final refreshCompleter = Completer<List<Comment>>();
      when(() => commentsRepository.getCommentsForPost(2)).thenAnswer((_) {
        calls++;
        if (calls == 1) {
          return Future.value([_comments.first]);
        }
        return refreshCompleter.future;
      });

      final container = detailsContainer(2);
      await pumpEventQueue();
      expect(stateOf(container).comments, [_comments.first]);

      final refreshFuture = controllerOf(container).refreshComments();
      await pumpEventQueue();

      var state = stateOf(container);
      expect(state.areCommentsRefreshing, isTrue);
      expect(state.comments, [_comments.first]);

      refreshCompleter.complete(_comments);
      await refreshFuture;

      state = stateOf(container);
      expect(state.areCommentsRefreshing, isFalse);
      expect(state.comments, _comments);
    });

    test('refresh failure preserves comments and stops refreshing', () async {
      var calls = 0;
      when(() => commentsRepository.getCommentsForPost(2)).thenAnswer((
        _,
      ) async {
        calls++;
        if (calls == 1) {
          return _comments;
        }
        throw const NetworkFailure();
      });

      final container = detailsContainer(2);
      await pumpEventQueue();

      await controllerOf(container).refreshComments();

      final state = stateOf(container);
      expect(state.comments, _comments);
      expect(state.areCommentsRefreshing, isFalse);
      expect(state.commentsFailure, isA<NetworkFailure>());
    });

    test('ignores an overlapping refresh while one is pending', () async {
      var calls = 0;
      final refreshCompleter = Completer<List<Comment>>();
      when(() => commentsRepository.getCommentsForPost(2)).thenAnswer((_) {
        calls++;
        if (calls == 1) {
          return Future.value(_comments);
        }
        return refreshCompleter.future;
      });

      final container = detailsContainer(2);
      await pumpEventQueue();

      final first = controllerOf(container).refreshComments();
      final second = controllerOf(container).refreshComments();
      await second;

      refreshCompleter.complete(_comments);
      await first;

      verify(() => commentsRepository.getCommentsForPost(2)).called(2);
    });
  });

  group('invalid IDs', () {
    test('does not call any repository and exposes NotFoundFailure', () async {
      final container = detailsContainer(0);
      await pumpEventQueue();

      final state = stateOf(container, 0);
      expect(state.postFailure, isA<NotFoundFailure>());
      expect(state.isPostLoading, isFalse);
      expect(state.areCommentsLoading, isFalse);
      verifyNever(() => postsRepository.getPost(any()));
      verifyNever(() => commentsRepository.getCommentsForPost(any()));

      await controllerOf(container, 0).retryPost();
      await controllerOf(container, 0).retryComments();
      await controllerOf(container, 0).refreshComments();

      verifyNever(() => postsRepository.getPost(any()));
      verifyNever(() => commentsRepository.getCommentsForPost(any()));
    });
  });
}
