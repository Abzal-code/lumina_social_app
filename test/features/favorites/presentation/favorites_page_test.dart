import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lumina/app/app.dart';
import 'package:lumina/features/comments/di.dart';
import 'package:lumina/features/comments/domain/repositories/comments_repository.dart';
import 'package:lumina/features/favorites/di.dart';
import 'package:lumina/features/favorites/presentation/favorites_page.dart';
import 'package:lumina/features/posts/di.dart';
import 'package:lumina/features/posts/domain/entities/post.dart';
import 'package:lumina/features/posts/domain/repositories/posts_repository.dart';
import 'package:lumina/features/posts/presentation/post_details_page.dart';
import 'package:lumina/features/posts/presentation/posts_page.dart';
import 'package:lumina/features/posts/presentation/widgets/post_card.dart';
import 'package:lumina/features/users/di.dart';
import 'package:lumina/features/users/domain/repositories/users_repository.dart';
import 'package:mocktail/mocktail.dart';

import '../../../helpers/fake_repositories.dart';

class _MockPostsRepository extends Mock implements PostsRepository {}

class _MockCommentsRepository extends Mock implements CommentsRepository {}

class _MockUsersRepository extends Mock implements UsersRepository {}

const _posts = [
  Post(id: 1, authorId: 7, title: 'Morning notes', body: 'Coffee and code'),
  Post(id: 2, authorId: 8, title: 'Evening reads', body: 'Books and tea'),
];

void main() {
  late _MockPostsRepository postsRepository;
  late _MockCommentsRepository commentsRepository;
  late _MockUsersRepository usersRepository;
  late FakeFavoritesRepository favoritesRepository;

  setUp(() {
    postsRepository = _MockPostsRepository();
    commentsRepository = _MockCommentsRepository();
    usersRepository = _MockUsersRepository();
    favoritesRepository = FakeFavoritesRepository();
    when(() => usersRepository.getUsers()).thenAnswer((_) async => const []);
    when(() => postsRepository.getPosts()).thenAnswer((_) async => _posts);
    when(() => postsRepository.getPost(1)).thenAnswer((_) async => _posts[0]);
    when(() => postsRepository.getPost(2)).thenAnswer((_) async => _posts[1]);
    when(
      () => commentsRepository.getCommentsForPost(any()),
    ).thenAnswer((_) async => const []);
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

  Future<void> openFavoritesTab(WidgetTester tester) async {
    await tester.tap(find.text('Favorites'));
    await tester.pumpAndSettle();
  }

  testWidgets('restores persisted favorites through getPost', (tester) async {
    favoritesRepository = FakeFavoritesRepository(initialIds: {2});

    await pumpApp(tester);
    await openFavoritesTab(tester);

    expect(find.byType(FavoritesPage), findsOneWidget);
    expect(find.text('Evening reads'), findsOneWidget);
    expect(find.byType(NavigationBar), findsOneWidget);
    verify(() => postsRepository.getPost(2)).called(1);
    verifyNever(() => postsRepository.getPosts());
  });

  testWidgets('empty state offers to browse posts', (tester) async {
    await pumpApp(tester);
    await openFavoritesTab(tester);

    expect(find.text('No favorites yet'), findsOneWidget);
    expect(find.byType(PostCard), findsNothing);

    await tester.tap(find.text('Browse posts'));
    await tester.pumpAndSettle();

    expect(find.byType(PostsPage), findsOneWidget);
  });

  testWidgets('renders all favorited posts sorted by ID', (tester) async {
    favoritesRepository = FakeFavoritesRepository(initialIds: {2, 1});

    await pumpApp(tester);
    await openFavoritesTab(tester);

    expect(find.byType(PostCard), findsNWidgets(2));
    final firstCardTop = tester.getTopLeft(find.text('Morning notes')).dy;
    final secondCardTop = tester.getTopLeft(find.text('Evening reads')).dy;
    expect(firstCardTop, lessThan(secondCardTop));
  });

  testWidgets('removing a favorite removes its card immediately', (
    tester,
  ) async {
    favoritesRepository = FakeFavoritesRepository(initialIds: {1, 2});

    await pumpApp(tester);
    await openFavoritesTab(tester);
    expect(find.byType(PostCard), findsNWidgets(2));

    await tester.tap(find.byTooltip('Remove Morning notes from favorites'));
    await tester.pump();

    expect(find.byType(PostCard), findsOneWidget);
    expect(find.text('Morning notes'), findsNothing);
    expect(find.text('Evening reads'), findsOneWidget);

    await tester.pumpAndSettle();
    expect(await favoritesRepository.getFavoritePostIds(), {2});
  });

  testWidgets('a favorite card opens post details', (tester) async {
    favoritesRepository = FakeFavoritesRepository(initialIds: {1});

    await pumpApp(tester);
    await openFavoritesTab(tester);

    await tester.tap(find.text('Morning notes'));
    await tester.pumpAndSettle();

    expect(find.byType(PostDetailsPage), findsOneWidget);
    expect(find.text('Coffee and code'), findsOneWidget);
    expect(find.byType(NavigationBar), findsOneWidget);

    await tester.pageBack();
    await tester.pumpAndSettle();

    expect(find.byType(FavoritesPage), findsOneWidget);
    expect(find.text('Morning notes'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });

  testWidgets('visiting every tab never touches the real plugin', (
    tester,
  ) async {
    await pumpApp(tester);

    for (final tab in ['Posts', 'Users', 'Favorites', 'Home']) {
      await tester.tap(find.text(tab).last);
      await tester.pumpAndSettle();
      expect(tester.takeException(), isNull);
    }
  });
}
