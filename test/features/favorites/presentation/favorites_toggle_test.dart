import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lumina/app/app.dart';
import 'package:lumina/core/error/app_failure.dart';
import 'package:lumina/features/comments/di.dart';
import 'package:lumina/features/comments/domain/repositories/comments_repository.dart';
import 'package:lumina/features/favorites/di.dart';
import 'package:lumina/features/favorites/domain/repositories/favorites_repository.dart';
import 'package:lumina/features/favorites/presentation/widgets/favorite_icon_button.dart';
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
import 'package:mocktail/mocktail.dart';

import '../../../helpers/fake_repositories.dart';

class _MockPostsRepository extends Mock implements PostsRepository {}

class _MockCommentsRepository extends Mock implements CommentsRepository {}

class _MockUsersRepository extends Mock implements UsersRepository {}

class _MockFavoritesRepository extends Mock implements FavoritesRepository {}

const _posts = [
  Post(id: 1, authorId: 1, title: 'Morning notes', body: 'Coffee and code'),
  Post(id: 2, authorId: 1, title: 'Evening reads', body: 'Books and tea'),
];

const _user = User(
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
);

void main() {
  late _MockPostsRepository postsRepository;
  late _MockCommentsRepository commentsRepository;
  late _MockUsersRepository usersRepository;
  late FavoritesRepository favoritesRepository;

  setUp(() {
    postsRepository = _MockPostsRepository();
    commentsRepository = _MockCommentsRepository();
    usersRepository = _MockUsersRepository();
    favoritesRepository = FakeFavoritesRepository();
    when(() => postsRepository.getPosts()).thenAnswer((_) async => _posts);
    when(
      () => postsRepository.getPostsForUser(1),
    ).thenAnswer((_) async => _posts);
    when(
      () => commentsRepository.getCommentsForPost(any()),
    ).thenAnswer((_) async => const []);
    when(() => usersRepository.getUsers()).thenAnswer((_) async => [_user]);
  });

  Future<void> pumpApp(WidgetTester tester) async {
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          postsRepositoryProvider.overrideWithValue(postsRepository),
          commentsRepositoryProvider.overrideWithValue(commentsRepository),
          usersRepositoryProvider.overrideWithValue(usersRepository),
          favoritesRepositoryProvider.overrideWithValue(favoritesRepository),
        ],
        child: const LuminaApp(),
      ),
    );
    await tester.pumpAndSettle();
  }

  Future<void> openPostsTab(WidgetTester tester) async {
    await tester.tap(find.text('Posts'));
    await tester.pumpAndSettle();
  }

  testWidgets('posts render with non-favorite icons by default', (
    tester,
  ) async {
    await pumpApp(tester);
    await openPostsTab(tester);

    expect(find.byIcon(Icons.bookmark_outline), findsNWidgets(2));
    expect(find.byIcon(Icons.bookmark), findsNothing);
  });

  testWidgets('tapping the favorite button fills the icon in place', (
    tester,
  ) async {
    await pumpApp(tester);
    await openPostsTab(tester);

    await tester.tap(find.byTooltip('Add Morning notes to favorites'));
    await tester.pumpAndSettle();

    expect(find.byIcon(Icons.bookmark), findsOneWidget);
    expect(
      find.byTooltip('Remove Morning notes from favorites'),
      findsOneWidget,
    );
    expect(find.byType(PostDetailsPage), findsNothing);
  });

  testWidgets('tapping the card body still opens details', (tester) async {
    await pumpApp(tester);
    await openPostsTab(tester);

    await tester.tap(find.text('Morning notes'));
    await tester.pumpAndSettle();

    expect(find.byType(PostDetailsPage), findsOneWidget);
  });

  testWidgets('persistence failure rolls the icon back and shows a snackbar', (
    tester,
  ) async {
    final failingRepository = _MockFavoritesRepository();
    when(
      () => failingRepository.getFavoritePostIds(),
    ).thenAnswer((_) async => {});
    when(
      () => failingRepository.addFavorite(any()),
    ).thenThrow(const UnexpectedFailure());
    favoritesRepository = failingRepository;

    await pumpApp(tester);
    await openPostsTab(tester);

    await tester.tap(find.byTooltip('Add Morning notes to favorites'));
    await tester.pump();
    await tester.pump();

    expect(find.byIcon(Icons.bookmark), findsNothing);
    expect(find.byIcon(Icons.bookmark_outline), findsNWidgets(2));
    expect(find.byType(SnackBar), findsOneWidget);
    expect(
      find.text('Couldn’t update favorites. Please try again.'),
      findsOneWidget,
    );
  });

  testWidgets('the details action toggles state shared with the list', (
    tester,
  ) async {
    await pumpApp(tester);
    await openPostsTab(tester);

    await tester.tap(find.text('Morning notes'));
    await tester.pumpAndSettle();

    await tester.tap(find.byTooltip('Add Morning notes to favorites'));
    await tester.pumpAndSettle();
    expect(find.byIcon(Icons.bookmark), findsOneWidget);

    await tester.pageBack();
    await tester.pumpAndSettle();

    expect(
      find.byTooltip('Remove Morning notes from favorites'),
      findsOneWidget,
    );
  });

  testWidgets('a profile publication toggles the shared state', (tester) async {
    await pumpApp(tester);
    await tester.tap(find.text('Users'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Leanne Graham'));
    await tester.pumpAndSettle();

    await tester.drag(find.byType(ListView).first, const Offset(0, -600));
    await tester.pumpAndSettle();

    await tester.tap(find.byTooltip('Add Morning notes to favorites'));
    await tester.pumpAndSettle();

    expect(
      find.byTooltip('Remove Morning notes from favorites'),
      findsOneWidget,
    );

    await tester.pageBack();
    await tester.pumpAndSettle();
    await openPostsTab(tester);

    expect(
      find.byTooltip('Remove Morning notes from favorites'),
      findsOneWidget,
    );
  });

  testWidgets('pending favorites restore does not block posts', (tester) async {
    final pendingRepository = _MockFavoritesRepository();
    final completer = Completer<Set<int>>();
    when(
      () => pendingRepository.getFavoritePostIds(),
    ).thenAnswer((_) => completer.future);
    favoritesRepository = pendingRepository;

    await pumpApp(tester);
    await openPostsTab(tester);

    expect(find.byType(PostCard), findsNWidgets(2));
    final button = tester.widget<IconButton>(
      find.descendant(
        of: find.byType(FavoriteIconButton).first,
        matching: find.byType(IconButton),
      ),
    );
    expect(button.onPressed, isNull);

    completer.complete({2});
    await tester.pumpAndSettle();

    expect(find.byIcon(Icons.bookmark), findsOneWidget);
    final enabledButton = tester.widget<IconButton>(
      find.descendant(
        of: find.byType(FavoriteIconButton).first,
        matching: find.byType(IconButton),
      ),
    );
    expect(enabledButton.onPressed, isNotNull);
  });
}
