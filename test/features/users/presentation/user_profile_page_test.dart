import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:lumina/app/app.dart';
import 'package:lumina/app/router/app_router.dart';
import 'package:lumina/core/error/app_failure.dart';
import 'package:lumina/core/widgets/skeleton_bar.dart';
import 'package:lumina/features/comments/di.dart';
import 'package:lumina/features/comments/domain/repositories/comments_repository.dart';
import 'package:lumina/features/favorites/di.dart';
import 'package:lumina/features/posts/di.dart';
import 'package:lumina/features/posts/domain/entities/post.dart';
import 'package:lumina/features/posts/domain/repositories/posts_repository.dart';
import 'package:lumina/features/posts/presentation/post_details_page.dart';
import 'package:lumina/features/posts/presentation/widgets/post_card.dart';
import 'package:lumina/features/users/di.dart';
import 'package:lumina/features/users/domain/entities/address.dart';
import 'package:lumina/features/users/domain/entities/company.dart';
import 'package:lumina/features/users/domain/entities/geo_location.dart';
import 'package:lumina/features/users/domain/entities/user.dart';
import 'package:lumina/features/users/domain/repositories/users_repository.dart';
import 'package:lumina/features/users/presentation/user_profile_page.dart';
import 'package:lumina/features/users/presentation/widgets/user_card.dart';
import 'package:mocktail/mocktail.dart';

import '../../../helpers/fake_repositories.dart';

class _MockUsersRepository extends Mock implements UsersRepository {}

class _MockPostsRepository extends Mock implements PostsRepository {}

class _MockCommentsRepository extends Mock implements CommentsRepository {}

const _users = [
  User(
    id: 1,
    name: 'Leanne Graham',
    username: 'Bret',
    email: 'leanne@april.biz',
    phone: '1-770-736-8031',
    website: 'hildegard.org',
    address: Address(
      street: 'Kulas Light',
      suite: 'Apt. 556',
      city: 'Gwenborough',
      zipcode: '92998-3874',
      geo: GeoLocation(latitude: -37.3159, longitude: 81.1496),
    ),
    company: Company(
      name: 'Romaguera-Crona',
      catchPhrase: 'Multi-layered client-server neural-net',
      businessSummary: 'harness real-time e-markets',
    ),
  ),
  User(
    id: 2,
    name: 'Ervin Howell',
    username: 'Antonette',
    email: 'ervin@melissa.tv',
    phone: '010-692-6593',
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
  ),
];

const _userPosts = [
  Post(id: 11, authorId: 1, title: 'First publication', body: 'Body one'),
  Post(id: 12, authorId: 1, title: 'Second publication', body: 'Body two'),
];

void main() {
  late _MockUsersRepository usersRepository;
  late _MockPostsRepository postsRepository;
  late _MockCommentsRepository commentsRepository;

  setUp(() {
    usersRepository = _MockUsersRepository();
    postsRepository = _MockPostsRepository();
    commentsRepository = _MockCommentsRepository();
    when(() => usersRepository.getUsers()).thenAnswer((_) async => _users);
    when(() => postsRepository.getPosts()).thenAnswer((_) async => _userPosts);
    when(
      () => postsRepository.getPostsForUser(any()),
    ).thenAnswer((_) async => _userPosts);
    when(
      () => commentsRepository.getCommentsForPost(any()),
    ).thenAnswer((_) async => const []);
  });

  Future<void> pumpApp(WidgetTester tester) async {
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          usersRepositoryProvider.overrideWithValue(usersRepository),
          postsRepositoryProvider.overrideWithValue(postsRepository),
          commentsRepositoryProvider.overrideWithValue(commentsRepository),
          favoritesRepositoryProvider.overrideWithValue(
            FakeFavoritesRepository(),
          ),
        ],
        child: const LuminaApp(),
      ),
    );
    await tester.pumpAndSettle();
  }

  GoRouter routerOf(WidgetTester tester) {
    final container = ProviderScope.containerOf(
      tester.element(find.byType(LuminaApp)),
    );
    return container.read(appRouterProvider);
  }

  Future<void> openFirstUser(WidgetTester tester) async {
    await tester.tap(find.text('Users'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Leanne Graham'));
    await tester.pumpAndSettle();
  }

  // The publications section sits below the initial viewport; scroll the
  // profile so its lazily built widgets exist before asserting on them.
  Future<void> scrollToPublications(WidgetTester tester) async {
    await tester.drag(find.byType(ListView).first, const Offset(0, -600));
    await tester.pumpAndSettle();
  }

  testWidgets('tapping a user card opens the profile with the navigation bar', (
    tester,
  ) async {
    await pumpApp(tester);
    await openFirstUser(tester);

    expect(find.byType(UserProfilePage), findsOneWidget);
    expect(find.byType(NavigationBar), findsOneWidget);
    expect(find.text('Leanne Graham'), findsOneWidget);
    expect(find.text('@Bret'), findsOneWidget);
    verifyNever(() => usersRepository.getUser(any()));
  });

  testWidgets('back returns to the users list with search preserved', (
    tester,
  ) async {
    await pumpApp(tester);
    await tester.tap(find.text('Users'));
    await tester.pumpAndSettle();

    await tester.enterText(find.byType(TextField), 'leanne');
    await tester.pump();
    expect(find.byType(UserCard), findsOneWidget);

    await tester.tap(find.text('Leanne Graham'));
    await tester.pumpAndSettle();
    expect(find.byType(UserProfilePage), findsOneWidget);

    await tester.pageBack();
    await tester.pumpAndSettle();

    expect(find.widgetWithText(TextField, 'leanne'), findsOneWidget);
    expect(find.byType(UserCard), findsOneWidget);
    expect(find.text('Ervin Howell'), findsNothing);
  });

  testWidgets('a direct route load fetches the user via getUser', (
    tester,
  ) async {
    when(
      () => usersRepository.getUsers(),
    ).thenAnswer((_) => Completer<List<User>>().future);
    when(() => usersRepository.getUser(2)).thenAnswer((_) async => _users[1]);

    await pumpApp(tester);
    routerOf(tester).go('/users/2');
    await tester.pumpAndSettle();

    expect(find.text('Ervin Howell'), findsOneWidget);
    verify(() => usersRepository.getUser(2)).called(1);
  });

  testWidgets('an invalid route ID shows user-friendly content', (
    tester,
  ) async {
    await pumpApp(tester);

    routerOf(tester).go('/users/abc');
    await tester.pumpAndSettle();
    expect(find.text('This profile is not available.'), findsOneWidget);
    expect(tester.takeException(), isNull);

    routerOf(tester).go('/users/0');
    await tester.pumpAndSettle();
    expect(find.text('This profile is not available.'), findsOneWidget);
    expect(tester.takeException(), isNull);
    verifyNever(() => usersRepository.getUser(any()));
  });

  testWidgets('shows a skeleton while the user is loading', (tester) async {
    when(
      () => usersRepository.getUsers(),
    ).thenAnswer((_) => Completer<List<User>>().future);
    final userCompleter = Completer<User>();
    when(
      () => usersRepository.getUser(2),
    ).thenAnswer((_) => userCompleter.future);
    when(
      () => postsRepository.getPostsForUser(2),
    ).thenAnswer((_) async => const []);

    await pumpApp(tester);
    routerOf(tester).go('/users/2');
    await tester.pumpAndSettle();

    expect(find.byType(SkeletonBar), findsWidgets);
    expect(find.text('Ervin Howell'), findsNothing);

    userCompleter.complete(_users[1]);
    await tester.pumpAndSettle();
    expect(find.text('Ervin Howell'), findsOneWidget);
  });

  testWidgets('user failure shows a retryable error and recovers', (
    tester,
  ) async {
    when(
      () => usersRepository.getUsers(),
    ).thenAnswer((_) => Completer<List<User>>().future);
    var calls = 0;
    when(() => usersRepository.getUser(2)).thenAnswer((_) async {
      calls++;
      if (calls == 1) {
        throw const NetworkFailure();
      }
      return _users[1];
    });

    await pumpApp(tester);
    routerOf(tester).go('/users/2');
    await tester.pumpAndSettle();

    expect(find.text('Couldn’t load this profile'), findsOneWidget);
    expect(find.text('Retry'), findsOneWidget);

    await tester.tap(find.text('Retry'));
    await tester.pumpAndSettle();

    expect(find.text('Ervin Howell'), findsOneWidget);
    expect(find.text('Couldn’t load this profile'), findsNothing);
  });

  testWidgets('renders the contact and company sections', (tester) async {
    await pumpApp(tester);
    await openFirstUser(tester);

    expect(find.text('Contact'), findsOneWidget);
    expect(find.text('1-770-736-8031'), findsOneWidget);
    expect(find.text('hildegard.org'), findsOneWidget);
    expect(find.textContaining('Kulas Light, Apt. 556'), findsOneWidget);
    expect(find.textContaining('Gwenborough, 92998-3874'), findsOneWidget);

    expect(find.text('Company'), findsOneWidget);
    expect(find.text('Romaguera-Crona'), findsOneWidget);
    expect(find.text('Multi-layered client-server neural-net'), findsOneWidget);
    expect(find.text('harness real-time e-markets'), findsOneWidget);
  });

  testWidgets('publications loading keeps the user visible', (tester) async {
    final postsCompleter = Completer<List<Post>>();
    when(
      () => postsRepository.getPostsForUser(any()),
    ).thenAnswer((_) => postsCompleter.future);

    await pumpApp(tester);
    await openFirstUser(tester);

    expect(find.text('Leanne Graham'), findsOneWidget);
    await scrollToPublications(tester);
    expect(find.text('Publications'), findsOneWidget);
    expect(find.byType(SkeletonBar), findsWidgets);

    postsCompleter.complete(_userPosts);
    await tester.pumpAndSettle();
    expect(find.byType(PostCard), findsNWidgets(2));
  });

  testWidgets('publications failure shows inline retry and recovers', (
    tester,
  ) async {
    var calls = 0;
    when(() => postsRepository.getPostsForUser(any())).thenAnswer((_) async {
      calls++;
      if (calls == 1) {
        throw const ServerFailure(statusCode: 500);
      }
      return _userPosts;
    });

    await pumpApp(tester);
    await openFirstUser(tester);

    expect(find.text('Leanne Graham'), findsOneWidget);
    await scrollToPublications(tester);
    expect(find.text('Couldn’t load publications'), findsOneWidget);
    expect(find.text('Retry'), findsOneWidget);

    await tester.tap(find.text('Retry'));
    await tester.pumpAndSettle();

    expect(find.byType(PostCard), findsNWidgets(2));
    expect(find.text('Couldn’t load publications'), findsNothing);
  });

  testWidgets('shows the empty state when there are no publications', (
    tester,
  ) async {
    when(
      () => postsRepository.getPostsForUser(any()),
    ).thenAnswer((_) async => const []);

    await pumpApp(tester);
    await openFirstUser(tester);
    await scrollToPublications(tester);

    expect(find.text('No publications yet'), findsOneWidget);
    expect(find.byType(PostCard), findsNothing);
  });

  testWidgets('renders publications below the profile', (tester) async {
    await pumpApp(tester);
    await openFirstUser(tester);
    await scrollToPublications(tester);

    expect(find.text('Publications'), findsOneWidget);
    expect(find.byType(PostCard), findsNWidgets(2));
    expect(find.text('First publication'), findsOneWidget);
  });

  testWidgets('pull-to-refresh reloads the publications list', (tester) async {
    var calls = 0;
    when(() => postsRepository.getPostsForUser(any())).thenAnswer((_) async {
      calls++;
      if (calls == 1) {
        return [_userPosts.first];
      }
      return _userPosts;
    });

    await pumpApp(tester);
    await openFirstUser(tester);

    await tester.fling(find.text('Leanne Graham'), const Offset(0, 300), 1000);
    await tester.pump();
    await tester.pump(const Duration(seconds: 1));
    await tester.pump(const Duration(seconds: 1));

    verify(() => postsRepository.getPostsForUser(1)).called(2);
    await scrollToPublications(tester);
    expect(find.byType(PostCard), findsNWidgets(2));
  });

  testWidgets('refresh failure keeps publications and shows a snackbar', (
    tester,
  ) async {
    var calls = 0;
    when(() => postsRepository.getPostsForUser(any())).thenAnswer((_) async {
      calls++;
      if (calls == 1) {
        return _userPosts;
      }
      throw const TimeoutFailure();
    });

    await pumpApp(tester);
    await openFirstUser(tester);

    await tester.fling(find.text('Leanne Graham'), const Offset(0, 300), 1000);
    await tester.pump();
    await tester.pump(const Duration(seconds: 1));
    await tester.pump(const Duration(seconds: 1));

    expect(find.byType(SnackBar), findsOneWidget);
    expect(
      find.text('The request took too long. Please try again.'),
      findsOneWidget,
    );

    await scrollToPublications(tester);
    expect(find.byType(PostCard), findsNWidgets(2));
  });

  testWidgets('tapping a publication opens the post details route', (
    tester,
  ) async {
    when(
      () => postsRepository.getPost(11),
    ).thenAnswer((_) async => _userPosts.first);

    await pumpApp(tester);
    await openFirstUser(tester);
    await scrollToPublications(tester);

    await tester.tap(find.text('First publication'));
    await tester.pumpAndSettle();

    expect(find.byType(PostDetailsPage), findsOneWidget);
    expect(find.text('Body one'), findsOneWidget);
    expect(find.byType(NavigationBar), findsOneWidget);
  });
}
