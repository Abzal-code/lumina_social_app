import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lumina/app/theme/app_theme.dart';
import 'package:lumina/core/error/app_failure.dart';
import 'package:lumina/features/users/di.dart';
import 'package:lumina/features/users/domain/entities/address.dart';
import 'package:lumina/features/users/domain/entities/company.dart';
import 'package:lumina/features/users/domain/entities/geo_location.dart';
import 'package:lumina/features/users/domain/entities/user.dart';
import 'package:lumina/features/users/domain/repositories/users_repository.dart';
import 'package:lumina/features/users/presentation/users_page.dart';
import 'package:lumina/features/users/presentation/widgets/user_card.dart';
import 'package:lumina/features/users/presentation/widgets/users_loading_view.dart';
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
];

void main() {
  late _MockUsersRepository repository;

  setUp(() {
    repository = _MockUsersRepository();
  });

  Future<void> pumpUsersPage(WidgetTester tester) {
    return tester.pumpWidget(
      ProviderScope(
        overrides: [usersRepositoryProvider.overrideWithValue(repository)],
        child: MaterialApp(theme: AppTheme.light, home: const UsersPage()),
      ),
    );
  }

  testWidgets('shows the loading view while the request is pending', (
    tester,
  ) async {
    final completer = Completer<List<User>>();
    when(() => repository.getUsers()).thenAnswer((_) => completer.future);

    await pumpUsersPage(tester);

    expect(find.byType(UsersLoadingView), findsOneWidget);
    expect(find.byType(UserCard), findsNothing);

    completer.complete(_users);
    await tester.pump();
    expect(find.byType(UsersLoadingView), findsNothing);
  });

  testWidgets('renders name, username, email, and company', (tester) async {
    when(() => repository.getUsers()).thenAnswer((_) async => _users);

    await pumpUsersPage(tester);
    await tester.pump();

    expect(find.text('Leanne Graham'), findsOneWidget);
    expect(find.text('@Bret'), findsOneWidget);
    expect(find.text('leanne@april.biz'), findsOneWidget);
    expect(find.text('Romaguera-Crona'), findsOneWidget);
    expect(find.byType(UserCard), findsNWidgets(2));
  });

  testWidgets('shows a retryable error state and recovers on retry', (
    tester,
  ) async {
    var calls = 0;
    when(() => repository.getUsers()).thenAnswer((_) async {
      calls++;
      if (calls == 1) {
        throw const NetworkFailure();
      }
      return _users;
    });

    await pumpUsersPage(tester);
    await tester.pump();

    expect(find.text('Couldn’t load users'), findsOneWidget);
    expect(find.text('Retry'), findsOneWidget);
    expect(find.byType(UserCard), findsNothing);

    await tester.tap(find.text('Retry'));
    await tester.pump();
    await tester.pump();

    expect(find.byType(UserCard), findsNWidgets(2));
    expect(find.text('Retry'), findsNothing);
  });

  testWidgets('shows the empty state when there are no users', (tester) async {
    when(() => repository.getUsers()).thenAnswer((_) async => const []);

    await pumpUsersPage(tester);
    await tester.pump();

    expect(find.text('No users yet'), findsOneWidget);
    expect(find.byType(UserCard), findsNothing);
  });

  testWidgets('typing in search filters the visible cards', (tester) async {
    when(() => repository.getUsers()).thenAnswer((_) async => _users);

    await pumpUsersPage(tester);
    await tester.pump();

    await tester.enterText(find.byType(TextField), 'deckow');
    await tester.pump();

    expect(find.text('Ervin Howell'), findsOneWidget);
    expect(find.text('Leanne Graham'), findsNothing);
    expect(find.byType(UserCard), findsOneWidget);
  });

  testWidgets('shows the filtered-empty state and clears it', (tester) async {
    when(() => repository.getUsers()).thenAnswer((_) async => _users);

    await pumpUsersPage(tester);
    await tester.pump();

    await tester.enterText(find.byType(TextField), 'zzz');
    await tester.pump();

    expect(find.text('No matching users'), findsOneWidget);
    expect(find.byType(UserCard), findsNothing);

    await tester.tap(find.text('Clear search'));
    await tester.pump();

    expect(find.byType(UserCard), findsNWidgets(2));
    expect(find.text('No matching users'), findsNothing);
  });

  testWidgets('pull-to-refresh fetches again and updates the list', (
    tester,
  ) async {
    var calls = 0;
    when(() => repository.getUsers()).thenAnswer((_) async {
      calls++;
      if (calls == 1) {
        return [_users.first];
      }
      return _users;
    });

    await pumpUsersPage(tester);
    await tester.pump();
    expect(find.byType(UserCard), findsOneWidget);

    await tester.fling(find.text('Leanne Graham'), const Offset(0, 300), 1000);
    await tester.pump();
    await tester.pump(const Duration(seconds: 1));
    await tester.pump(const Duration(seconds: 1));

    verify(() => repository.getUsers()).called(2);
    expect(find.byType(UserCard), findsNWidgets(2));
    expect(find.text('Ervin Howell'), findsOneWidget);
  });

  testWidgets('refresh failure keeps cards and shows a snackbar', (
    tester,
  ) async {
    var calls = 0;
    when(() => repository.getUsers()).thenAnswer((_) async {
      calls++;
      if (calls == 1) {
        return _users;
      }
      throw const TimeoutFailure();
    });

    await pumpUsersPage(tester);
    await tester.pump();
    expect(find.byType(UserCard), findsNWidgets(2));

    await tester.fling(find.text('Leanne Graham'), const Offset(0, 300), 1000);
    await tester.pump();
    await tester.pump(const Duration(seconds: 1));
    await tester.pump(const Duration(seconds: 1));

    expect(find.byType(UserCard), findsNWidgets(2));
    expect(find.byType(SnackBar), findsOneWidget);
    expect(
      find.text('The request took too long. Please try again.'),
      findsOneWidget,
    );
    expect(find.text('Retry'), findsNothing);
  });
}
