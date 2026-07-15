import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lumina/core/error/app_failure.dart';
import 'package:lumina/features/users/application/users_controller.dart';
import 'package:lumina/features/users/application/users_state.dart';
import 'package:lumina/features/users/data/repositories/users_repository_impl.dart';
import 'package:lumina/features/users/domain/entities/address.dart';
import 'package:lumina/features/users/domain/entities/company.dart';
import 'package:lumina/features/users/domain/entities/geo_location.dart';
import 'package:lumina/features/users/domain/entities/user.dart';
import 'package:lumina/features/users/domain/repositories/users_repository.dart';
import 'package:mocktail/mocktail.dart';

class _MockUsersRepository extends Mock implements UsersRepository {}

User _user(
  int id, {
  required String name,
  required String username,
  required String email,
  required String companyName,
}) => User(
  id: id,
  name: name,
  username: username,
  email: email,
  phone: '555-0100',
  website: 'example.org',
  address: const Address(
    street: 'Main Street',
    suite: 'Apt. 1',
    city: 'Springfield',
    zipcode: '12345',
    geo: GeoLocation(latitude: 1.5, longitude: -2.5),
  ),
  company: Company(
    name: companyName,
    catchPhrase: 'catch phrase',
    businessSummary: 'business summary',
  ),
);

final _users = [
  _user(
    1,
    name: 'Leanne Graham',
    username: 'Bret',
    email: 'leanne@april.biz',
    companyName: 'Romaguera-Crona',
  ),
  _user(
    2,
    name: 'Ervin Howell',
    username: 'Antonette',
    email: 'ervin@melissa.tv',
    companyName: 'Deckow-Crist',
  ),
  _user(
    3,
    name: 'Clementine Bauch',
    username: 'Samantha',
    email: 'clementine@yesenia.net',
    companyName: 'Keebler LLC',
  ),
];

void main() {
  late _MockUsersRepository repository;

  setUp(() {
    repository = _MockUsersRepository();
  });

  ProviderContainer createContainer() {
    final container = ProviderContainer(
      overrides: [usersRepositoryProvider.overrideWithValue(repository)],
    );
    addTearDown(container.dispose);
    final subscription = container.listen(
      usersControllerProvider,
      (previous, next) {},
    );
    addTearDown(subscription.close);
    return container;
  }

  UsersState stateOf(ProviderContainer container) =>
      container.read(usersControllerProvider);

  UsersController controllerOf(ProviderContainer container) =>
      container.read(usersControllerProvider.notifier);

  group('initial load', () {
    test('exposes loading until the repository answers, then users', () async {
      final completer = Completer<List<User>>();
      when(() => repository.getUsers()).thenAnswer((_) => completer.future);

      final container = createContainer();

      expect(stateOf(container).isInitialLoading, isTrue);
      await pumpEventQueue();
      expect(stateOf(container).isInitialLoading, isTrue);
      expect(stateOf(container).users, isEmpty);

      completer.complete(_users);
      await pumpEventQueue();

      final state = stateOf(container);
      expect(state.isInitialLoading, isFalse);
      expect(state.users, _users);
      expect(state.failure, isNull);
    });

    test('exposes the typed failure and keeps users empty on error', () async {
      when(() => repository.getUsers()).thenThrow(const NetworkFailure());

      final container = createContainer();
      await pumpEventQueue();

      final state = stateOf(container);
      expect(state.isInitialLoading, isFalse);
      expect(state.failure, isA<NetworkFailure>());
      expect(state.users, isEmpty);
    });
  });

  group('retry', () {
    test('calls the repository again and replaces the error state', () async {
      var calls = 0;
      when(() => repository.getUsers()).thenAnswer((_) async {
        calls++;
        if (calls == 1) {
          throw const TimeoutFailure();
        }
        return _users;
      });

      final container = createContainer();
      await pumpEventQueue();
      expect(stateOf(container).failure, isA<TimeoutFailure>());

      await controllerOf(container).retry();

      final state = stateOf(container);
      expect(state.users, _users);
      expect(state.failure, isNull);
      verify(() => repository.getUsers()).called(2);
    });

    test('does not start a second request while one is pending', () async {
      final completer = Completer<List<User>>();
      when(() => repository.getUsers()).thenAnswer((_) => completer.future);

      final container = createContainer();
      await pumpEventQueue();

      await controllerOf(container).retry();
      await pumpEventQueue();
      verify(() => repository.getUsers()).called(1);

      completer.complete(_users);
      await pumpEventQueue();
      expect(stateOf(container).users, _users);
    });
  });

  group('refresh', () {
    test(
      'keeps old users while pending and replaces them on success',
      () async {
        var calls = 0;
        final refreshCompleter = Completer<List<User>>();
        when(() => repository.getUsers()).thenAnswer((_) {
          calls++;
          if (calls == 1) {
            return Future.value([_users.first]);
          }
          return refreshCompleter.future;
        });

        final container = createContainer();
        await pumpEventQueue();
        expect(stateOf(container).users, [_users.first]);

        final refreshFuture = controllerOf(container).refresh();
        await pumpEventQueue();

        var state = stateOf(container);
        expect(state.isRefreshing, isTrue);
        expect(state.users, [_users.first]);
        expect(state.isInitialLoading, isFalse);

        refreshCompleter.complete(_users);
        await refreshFuture;

        state = stateOf(container);
        expect(state.isRefreshing, isFalse);
        expect(state.users, _users);
        expect(state.failure, isNull);
      },
    );

    test('keeps previous users and exposes the failure on error', () async {
      var calls = 0;
      when(() => repository.getUsers()).thenAnswer((_) async {
        calls++;
        if (calls == 1) {
          return [_users.first];
        }
        throw const ServerFailure(statusCode: 500);
      });

      final container = createContainer();
      await pumpEventQueue();

      await controllerOf(container).refresh();

      final state = stateOf(container);
      expect(state.users, [_users.first]);
      expect(state.isRefreshing, isFalse);
      expect(
        state.failure,
        isA<ServerFailure>().having((f) => f.statusCode, 'statusCode', 500),
      );
    });

    test('clears a stale failure when a new refresh begins', () async {
      var calls = 0;
      final refreshCompleter = Completer<List<User>>();
      when(() => repository.getUsers()).thenAnswer((_) {
        calls++;
        if (calls == 1) {
          return Future.value(_users);
        }
        if (calls == 2) {
          return Future.error(const NetworkFailure());
        }
        return refreshCompleter.future;
      });

      final container = createContainer();
      await pumpEventQueue();

      await controllerOf(container).refresh();
      expect(stateOf(container).failure, isA<NetworkFailure>());

      final refreshFuture = controllerOf(container).refresh();
      await pumpEventQueue();
      expect(stateOf(container).failure, isNull);

      refreshCompleter.complete(_users);
      await refreshFuture;
      expect(stateOf(container).failure, isNull);
    });

    test('ignores an overlapping refresh while one is pending', () async {
      var calls = 0;
      final refreshCompleter = Completer<List<User>>();
      when(() => repository.getUsers()).thenAnswer((_) {
        calls++;
        if (calls == 1) {
          return Future.value([_users.first]);
        }
        return refreshCompleter.future;
      });

      final container = createContainer();
      await pumpEventQueue();

      final first = controllerOf(container).refresh();
      final second = controllerOf(container).refresh();
      await second;

      refreshCompleter.complete(_users);
      await first;

      verify(() => repository.getUsers()).called(2);
      expect(stateOf(container).users, _users);
    });
  });

  group('search', () {
    Future<ProviderContainer> loadedContainer() async {
      when(() => repository.getUsers()).thenAnswer((_) async => _users);
      final container = createContainer();
      await pumpEventQueue();
      return container;
    }

    test('matches names case-insensitively', () async {
      final container = await loadedContainer();

      controllerOf(container).setQuery('ERVIN HOWELL');

      expect(stateOf(container).visibleUsers, [_users[1]]);
    });

    test('matches usernames', () async {
      final container = await loadedContainer();

      controllerOf(container).setQuery('samantha');

      expect(stateOf(container).visibleUsers, [_users[2]]);
    });

    test('matches emails', () async {
      final container = await loadedContainer();

      controllerOf(container).setQuery('melissa.tv');

      expect(stateOf(container).visibleUsers, [_users[1]]);
    });

    test('matches company names', () async {
      final container = await loadedContainer();

      controllerOf(container).setQuery('keebler');

      expect(stateOf(container).visibleUsers, [_users[2]]);
    });

    test('trims surrounding whitespace and normalizes case', () async {
      final container = await loadedContainer();

      controllerOf(container).setQuery('  BrEt  ');

      expect(stateOf(container).visibleUsers, [_users[0]]);
    });

    test('preserves original order for multiple matches', () async {
      final container = await loadedContainer();

      controllerOf(container).setQuery('e');

      expect(stateOf(container).visibleUsers.map((user) => user.id), [1, 2, 3]);
    });

    test(
      'clearing the query restores all users without a repository call',
      () async {
        final container = await loadedContainer();

        controllerOf(container).setQuery('keebler');
        controllerOf(container).clearQuery();

        expect(stateOf(container).visibleUsers, _users);
        verify(() => repository.getUsers()).called(1);
      },
    );

    test('searching never calls the repository', () async {
      final container = await loadedContainer();

      controllerOf(container).setQuery('leanne');
      controllerOf(container).setQuery('antonette');
      controllerOf(container).setQuery('');

      verify(() => repository.getUsers()).called(1);
    });
  });
}
