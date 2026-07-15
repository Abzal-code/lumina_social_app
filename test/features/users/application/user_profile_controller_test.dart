import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lumina/core/error/app_failure.dart';
import 'package:lumina/features/posts/data/repositories/posts_repository_impl.dart';
import 'package:lumina/features/posts/domain/entities/post.dart';
import 'package:lumina/features/posts/domain/repositories/posts_repository.dart';
import 'package:lumina/features/users/application/user_profile_controller.dart';
import 'package:lumina/features/users/application/user_profile_state.dart';
import 'package:lumina/features/users/application/users_controller.dart';
import 'package:lumina/features/users/data/repositories/users_repository_impl.dart';
import 'package:lumina/features/users/domain/entities/address.dart';
import 'package:lumina/features/users/domain/entities/company.dart';
import 'package:lumina/features/users/domain/entities/geo_location.dart';
import 'package:lumina/features/users/domain/entities/user.dart';
import 'package:lumina/features/users/domain/repositories/users_repository.dart';
import 'package:mocktail/mocktail.dart';

class _MockUsersRepository extends Mock implements UsersRepository {}

class _MockPostsRepository extends Mock implements PostsRepository {}

const _user = User(
  id: 2,
  name: 'Ervin Howell',
  username: 'Antonette',
  email: 'ervin@melissa.tv',
  phone: '555-0100',
  website: 'anastasia.net',
  address: Address(
    street: 'Victor Plains',
    suite: 'Suite 879',
    city: 'Wisokyburgh',
    zipcode: '90566-7771',
    geo: GeoLocation(latitude: -43.9509, longitude: -34.4618),
  ),
  company: Company(
    name: 'Deckow-Crist',
    catchPhrase: 'Proactive didactic contingency',
    businessSummary: 'synergize scalable supply-chains',
  ),
);

const _posts = [
  Post(id: 11, authorId: 2, title: 'First publication', body: 'Body one'),
  Post(id: 12, authorId: 2, title: 'Second publication', body: 'Body two'),
];

void main() {
  late _MockUsersRepository usersRepository;
  late _MockPostsRepository postsRepository;

  setUp(() {
    usersRepository = _MockUsersRepository();
    postsRepository = _MockPostsRepository();
    when(
      () => postsRepository.getPostsForUser(any()),
    ).thenAnswer((_) async => _posts);
  });

  ProviderContainer createContainer() {
    final container = ProviderContainer(
      overrides: [
        usersRepositoryProvider.overrideWithValue(usersRepository),
        postsRepositoryProvider.overrideWithValue(postsRepository),
      ],
    );
    addTearDown(container.dispose);
    return container;
  }

  ProviderContainer profileContainer(int userId) {
    final container = createContainer();
    final subscription = container.listen(
      userProfileControllerProvider(userId),
      (previous, next) {},
    );
    addTearDown(subscription.close);
    return container;
  }

  UserProfileState stateOf(ProviderContainer container, [int userId = 2]) =>
      container.read(userProfileControllerProvider(userId));

  UserProfileController controllerOf(
    ProviderContainer container, [
    int userId = 2,
  ]) => container.read(userProfileControllerProvider(userId).notifier);

  group('user resolution', () {
    test('reuses an already-loaded user without calling getUser', () async {
      when(() => usersRepository.getUsers()).thenAnswer((_) async => [_user]);
      final container = createContainer();
      final listSubscription = container.listen(
        usersControllerProvider,
        (previous, next) {},
      );
      addTearDown(listSubscription.close);
      await pumpEventQueue();

      final subscription = container.listen(
        userProfileControllerProvider(2),
        (previous, next) {},
      );
      addTearDown(subscription.close);
      await pumpEventQueue();

      expect(stateOf(container).user, _user);
      expect(stateOf(container).isUserLoading, isFalse);
      verifyNever(() => usersRepository.getUser(any()));
    });

    test(
      'falls back to getUser without instantiating the users list',
      () async {
        when(() => usersRepository.getUser(2)).thenAnswer((_) async => _user);

        final container = profileContainer(2);
        await pumpEventQueue();

        expect(stateOf(container).user, _user);
        verify(() => usersRepository.getUser(2)).called(1);
        verifyNever(() => usersRepository.getUsers());
      },
    );

    test('exposes the failure and recovers via retryUser', () async {
      var calls = 0;
      when(() => usersRepository.getUser(2)).thenAnswer((_) async {
        calls++;
        if (calls == 1) {
          throw const NetworkFailure();
        }
        return _user;
      });

      final container = profileContainer(2);
      await pumpEventQueue();

      expect(stateOf(container).userFailure, isA<NetworkFailure>());
      expect(stateOf(container).user, isNull);

      await controllerOf(container).retryUser();

      expect(stateOf(container).user, _user);
      expect(stateOf(container).userFailure, isNull);
      verify(() => usersRepository.getUser(2)).called(2);
    });
  });

  group('publications', () {
    setUp(() {
      when(() => usersRepository.getUser(2)).thenAnswer((_) async => _user);
    });

    test('loads posts independently of the user', () async {
      final container = profileContainer(2);
      await pumpEventQueue();

      final state = stateOf(container);
      expect(state.posts, _posts);
      expect(state.arePostsLoading, isFalse);
      expect(state.postsFailure, isNull);
    });

    test('a posts failure does not hide the loaded user', () async {
      when(
        () => postsRepository.getPostsForUser(2),
      ).thenThrow(const ServerFailure(statusCode: 500));

      final container = profileContainer(2);
      await pumpEventQueue();

      final state = stateOf(container);
      expect(state.user, _user);
      expect(state.posts, isEmpty);
      expect(state.postsFailure, isA<ServerFailure>());
    });

    test('retryPosts recovers from a failure', () async {
      var calls = 0;
      when(() => postsRepository.getPostsForUser(2)).thenAnswer((_) async {
        calls++;
        if (calls == 1) {
          throw const TimeoutFailure();
        }
        return _posts;
      });

      final container = profileContainer(2);
      await pumpEventQueue();
      expect(stateOf(container).postsFailure, isA<TimeoutFailure>());

      await controllerOf(container).retryPosts();

      expect(stateOf(container).posts, _posts);
      expect(stateOf(container).postsFailure, isNull);
    });

    test('refresh keeps old posts while pending, then replaces', () async {
      var calls = 0;
      final refreshCompleter = Completer<List<Post>>();
      when(() => postsRepository.getPostsForUser(2)).thenAnswer((_) {
        calls++;
        if (calls == 1) {
          return Future.value([_posts.first]);
        }
        return refreshCompleter.future;
      });

      final container = profileContainer(2);
      await pumpEventQueue();
      expect(stateOf(container).posts, [_posts.first]);

      final refreshFuture = controllerOf(container).refreshPosts();
      await pumpEventQueue();

      var state = stateOf(container);
      expect(state.arePostsRefreshing, isTrue);
      expect(state.posts, [_posts.first]);

      refreshCompleter.complete(_posts);
      await refreshFuture;

      state = stateOf(container);
      expect(state.arePostsRefreshing, isFalse);
      expect(state.posts, _posts);
    });

    test('refresh failure preserves posts and stops refreshing', () async {
      var calls = 0;
      when(() => postsRepository.getPostsForUser(2)).thenAnswer((_) async {
        calls++;
        if (calls == 1) {
          return _posts;
        }
        throw const NetworkFailure();
      });

      final container = profileContainer(2);
      await pumpEventQueue();

      await controllerOf(container).refreshPosts();

      final state = stateOf(container);
      expect(state.posts, _posts);
      expect(state.arePostsRefreshing, isFalse);
      expect(state.postsFailure, isA<NetworkFailure>());
    });

    test('clears a stale posts failure when a new refresh begins', () async {
      var calls = 0;
      final refreshCompleter = Completer<List<Post>>();
      when(() => postsRepository.getPostsForUser(2)).thenAnswer((_) {
        calls++;
        if (calls == 1) {
          return Future.value(_posts);
        }
        if (calls == 2) {
          return Future.error(const NetworkFailure());
        }
        return refreshCompleter.future;
      });

      final container = profileContainer(2);
      await pumpEventQueue();

      await controllerOf(container).refreshPosts();
      expect(stateOf(container).postsFailure, isA<NetworkFailure>());

      final refreshFuture = controllerOf(container).refreshPosts();
      await pumpEventQueue();
      expect(stateOf(container).postsFailure, isNull);

      refreshCompleter.complete(_posts);
      await refreshFuture;
      expect(stateOf(container).postsFailure, isNull);
    });

    test('ignores an overlapping refresh while one is pending', () async {
      var calls = 0;
      final refreshCompleter = Completer<List<Post>>();
      when(() => postsRepository.getPostsForUser(2)).thenAnswer((_) {
        calls++;
        if (calls == 1) {
          return Future.value(_posts);
        }
        return refreshCompleter.future;
      });

      final container = profileContainer(2);
      await pumpEventQueue();

      final first = controllerOf(container).refreshPosts();
      final second = controllerOf(container).refreshPosts();
      await second;

      refreshCompleter.complete(_posts);
      await first;

      verify(() => postsRepository.getPostsForUser(2)).called(2);
    });
  });

  group('invalid IDs', () {
    test('does not call any repository and exposes NotFoundFailure', () async {
      final container = profileContainer(0);
      await pumpEventQueue();

      final state = stateOf(container, 0);
      expect(state.userFailure, isA<NotFoundFailure>());
      expect(state.isUserLoading, isFalse);
      expect(state.arePostsLoading, isFalse);
      verifyNever(() => usersRepository.getUser(any()));
      verifyNever(() => postsRepository.getPostsForUser(any()));

      await controllerOf(container, 0).retryUser();
      await controllerOf(container, 0).retryPosts();
      await controllerOf(container, 0).refreshPosts();

      verifyNever(() => usersRepository.getUser(any()));
      verifyNever(() => postsRepository.getPostsForUser(any()));
    });
  });
}
