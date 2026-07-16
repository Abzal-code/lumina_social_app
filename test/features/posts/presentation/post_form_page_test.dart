import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:lumina/app/app.dart';
import 'package:lumina/app/router/app_router.dart';
import 'package:lumina/core/error/app_failure.dart';
import 'package:lumina/features/comments/di.dart';
import 'package:lumina/features/comments/domain/repositories/comments_repository.dart';
import 'package:lumina/features/favorites/di.dart';
import 'package:lumina/features/favorites/presentation/widgets/favorite_icon_button.dart';
import 'package:lumina/features/posts/di.dart';
import 'package:lumina/features/posts/domain/entities/post.dart';
import 'package:lumina/features/posts/domain/repositories/posts_repository.dart';
import 'package:lumina/features/posts/presentation/post_details_page.dart';
import 'package:lumina/features/posts/presentation/post_form_page.dart';
import 'package:lumina/features/posts/presentation/posts_page.dart';
import 'package:lumina/features/users/di.dart';
import 'package:mocktail/mocktail.dart';

import '../../../helpers/fake_repositories.dart';

class _MockPostsRepository extends Mock implements PostsRepository {}

class _MockCommentsRepository extends Mock implements CommentsRepository {}

const _posts = [
  Post(id: 1, authorId: 1, title: 'Morning notes', body: 'Coffee and code'),
  Post(id: 2, authorId: 2, title: 'Evening reads', body: 'Books and tea'),
];

const _created = Post(
  id: -1,
  authorId: 1,
  title: 'Fresh thoughts',
  body: 'Written locally',
);

void main() {
  late _MockPostsRepository postsRepository;
  late _MockCommentsRepository commentsRepository;

  setUp(() {
    postsRepository = _MockPostsRepository();
    commentsRepository = _MockCommentsRepository();
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
          favoritesRepositoryProvider.overrideWithValue(
            FakeFavoritesRepository(),
          ),
          usersRepositoryProvider.overrideWithValue(FakeUsersRepository()),
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

  Future<void> openPostsTab(WidgetTester tester) async {
    await tester.tap(find.text('Posts'));
    await tester.pumpAndSettle();
  }

  Future<void> openCreateForm(WidgetTester tester) async {
    await openPostsTab(tester);
    await tester.tap(find.byType(FloatingActionButton));
    await tester.pumpAndSettle();
  }

  Future<void> selectAuthor(WidgetTester tester, String name) async {
    await tester.tap(find.byKey(const ValueKey('post_author_options')));
    await tester.pumpAndSettle();
    await tester.tap(find.text(name).last);
    await tester.pumpAndSettle();
  }

  Future<void> fillCreateForm(WidgetTester tester) async {
    await selectAuthor(tester, 'Leanne Graham');
    await tester.enterText(
      find.widgetWithText(TextFormField, 'Title'),
      'Fresh thoughts',
    );
    await tester.enterText(
      find.widgetWithText(TextFormField, 'Text'),
      'Written locally',
    );
  }

  group('create form', () {
    testWidgets('the posts FAB opens the create form', (tester) async {
      await pumpApp(tester);
      await openCreateForm(tester);

      expect(find.byType(PostFormPage), findsOneWidget);
      expect(find.text('New post'), findsOneWidget);
      expect(find.text('Create post'), findsOneWidget);
    });

    testWidgets('validation blocks an empty submission', (tester) async {
      await pumpApp(tester);
      await openCreateForm(tester);

      await tester.tap(find.text('Create post'));
      await tester.pumpAndSettle();

      expect(find.text('Select an author.'), findsOneWidget);
      expect(find.text('Enter a title.'), findsOneWidget);
      expect(find.text('Enter the post text.'), findsOneWidget);
      verifyNever(
        () => postsRepository.createPost(
          authorId: any(named: 'authorId'),
          title: any(named: 'title'),
          body: any(named: 'body'),
        ),
      );
    });

    testWidgets('a successful create closes the form and shows the post', (
      tester,
    ) async {
      when(
        () => postsRepository.createPost(
          authorId: 1,
          title: 'Fresh thoughts',
          body: 'Written locally',
        ),
      ).thenAnswer((_) async => _created);

      await pumpApp(tester);
      await openCreateForm(tester);
      await fillCreateForm(tester);

      await tester.tap(find.text('Create post'));
      await tester.pumpAndSettle();

      expect(find.byType(PostFormPage), findsNothing);
      expect(find.byType(PostsPage), findsOneWidget);
      expect(find.text('Post created'), findsOneWidget);
      expect(find.text('Fresh thoughts'), findsOneWidget);
    });

    testWidgets('a created post opens its details page', (tester) async {
      when(
        () => postsRepository.createPost(
          authorId: 1,
          title: 'Fresh thoughts',
          body: 'Written locally',
        ),
      ).thenAnswer((_) async => _created);
      when(() => postsRepository.getPost(-1)).thenAnswer((_) async => _created);

      await pumpApp(tester);
      await openCreateForm(tester);
      await fillCreateForm(tester);
      await tester.tap(find.text('Create post'));
      await tester.pumpAndSettle();

      await tester.tap(find.text('Fresh thoughts'));
      await tester.pumpAndSettle();

      expect(find.byType(PostDetailsPage), findsOneWidget);
      expect(find.text('Written locally'), findsOneWidget);
      // Locally created posts cannot be bookmarked.
      expect(find.byType(FavoriteIconButton), findsNothing);
      expect(find.byIcon(Icons.edit_outlined), findsOneWidget);
    });

    testWidgets('a failed create stays on the form and keeps input', (
      tester,
    ) async {
      when(
        () => postsRepository.createPost(
          authorId: any(named: 'authorId'),
          title: any(named: 'title'),
          body: any(named: 'body'),
        ),
      ).thenThrow(const NetworkFailure());

      await pumpApp(tester);
      await openCreateForm(tester);
      await fillCreateForm(tester);

      await tester.tap(find.text('Create post'));
      await tester.pumpAndSettle();

      expect(find.byType(PostFormPage), findsOneWidget);
      expect(find.text('Couldn’t create post.'), findsOneWidget);
      expect(find.text('Fresh thoughts'), findsOneWidget);
      expect(find.text('Written locally'), findsOneWidget);
    });
  });

  group('edit form', () {
    Future<void> openFirstPostDetails(WidgetTester tester) async {
      await openPostsTab(tester);
      await tester.tap(find.text('Morning notes'));
      await tester.pumpAndSettle();
    }

    testWidgets('the details edit action opens a prefilled form', (
      tester,
    ) async {
      await pumpApp(tester);
      await openFirstPostDetails(tester);

      await tester.tap(find.byIcon(Icons.edit_outlined));
      await tester.pumpAndSettle();

      expect(find.text('Edit post'), findsOneWidget);
      expect(find.text('Morning notes'), findsOneWidget);
      expect(find.text('Coffee and code'), findsOneWidget);
      expect(find.text('Leanne Graham'), findsOneWidget);
    });

    testWidgets('a successful edit returns to updated details', (tester) async {
      const edited = Post(
        id: 1,
        authorId: 1,
        title: 'Calm notes',
        body: 'Tea and rest',
      );
      when(
        () => postsRepository.updatePost(
          postId: 1,
          authorId: 1,
          title: 'Calm notes',
          body: 'Tea and rest',
        ),
      ).thenAnswer((_) async => edited);

      await pumpApp(tester);
      await openFirstPostDetails(tester);
      await tester.tap(find.byIcon(Icons.edit_outlined));
      await tester.pumpAndSettle();

      await tester.enterText(
        find.widgetWithText(TextFormField, 'Title'),
        'Calm notes',
      );
      await tester.enterText(
        find.widgetWithText(TextFormField, 'Text'),
        'Tea and rest',
      );
      await tester.tap(find.text('Save changes'));
      await tester.pumpAndSettle();

      expect(find.byType(PostDetailsPage), findsOneWidget);
      expect(find.text('Post updated'), findsOneWidget);
      expect(find.text('Calm notes'), findsOneWidget);
      expect(find.text('Tea and rest'), findsOneWidget);

      await tester.pageBack();
      await tester.pumpAndSettle();
      expect(find.byType(PostsPage), findsOneWidget);
      expect(find.text('Calm notes'), findsOneWidget);
      expect(find.text('Morning notes'), findsNothing);
    });

    testWidgets('a failed edit stays on the form and keeps input', (
      tester,
    ) async {
      when(
        () => postsRepository.updatePost(
          postId: any(named: 'postId'),
          authorId: any(named: 'authorId'),
          title: any(named: 'title'),
          body: any(named: 'body'),
        ),
      ).thenThrow(const TimeoutFailure());

      await pumpApp(tester);
      await openFirstPostDetails(tester);
      await tester.tap(find.byIcon(Icons.edit_outlined));
      await tester.pumpAndSettle();

      await tester.enterText(
        find.widgetWithText(TextFormField, 'Title'),
        'Calm notes',
      );
      await tester.tap(find.text('Save changes'));
      await tester.pumpAndSettle();

      expect(find.text('Edit post'), findsOneWidget);
      expect(find.text('Couldn’t update post.'), findsOneWidget);
      expect(find.text('Calm notes'), findsOneWidget);
    });

    testWidgets('a direct edit route resolves the post', (tester) async {
      await pumpApp(tester);

      routerOf(tester).go('/posts/2/edit');
      await tester.pumpAndSettle();

      expect(find.text('Edit post'), findsOneWidget);
      expect(find.text('Evening reads'), findsOneWidget);
      // Both the form prefill and the details page beneath it resolve the
      // post through the repository.
      verify(() => postsRepository.getPost(2)).called(greaterThanOrEqualTo(1));
    });

    testWidgets('an invalid edit route shows friendly content', (tester) async {
      await pumpApp(tester);

      routerOf(tester).go('/posts/abc/edit');
      await tester.pumpAndSettle();
      expect(find.text('This post is no longer available.'), findsOneWidget);

      routerOf(tester).go('/posts/0/edit');
      await tester.pumpAndSettle();
      expect(find.text('This post is no longer available.'), findsOneWidget);
      expect(tester.takeException(), isNull);
    });

    testWidgets('an edit deep link to a missing post is friendly', (
      tester,
    ) async {
      when(
        () => postsRepository.getPost(99),
      ).thenThrow(const NotFoundFailure());

      await pumpApp(tester);
      routerOf(tester).go('/posts/99/edit');
      await tester.pumpAndSettle();

      expect(find.text('This post is no longer available.'), findsOneWidget);
      expect(find.text('Back to posts'), findsOneWidget);
    });
  });

  group('delete', () {
    setUp(() {
      when(() => postsRepository.deletePost(any())).thenAnswer((_) async {});
    });

    Future<void> openFirstPostDetails(WidgetTester tester) async {
      await openPostsTab(tester);
      await tester.tap(find.text('Morning notes'));
      await tester.pumpAndSettle();
    }

    testWidgets('cancelling the confirmation keeps the post', (tester) async {
      await pumpApp(tester);
      await openFirstPostDetails(tester);

      await tester.tap(find.byIcon(Icons.delete_outline));
      await tester.pumpAndSettle();
      expect(find.text('Delete post?'), findsOneWidget);
      expect(find.textContaining('Morning notes'), findsWidgets);

      await tester.tap(find.text('Cancel'));
      await tester.pumpAndSettle();

      expect(find.byType(PostDetailsPage), findsOneWidget);
      verifyNever(() => postsRepository.deletePost(any()));
    });

    testWidgets('confirming removes the post and leaves the page', (
      tester,
    ) async {
      await pumpApp(tester);
      await openFirstPostDetails(tester);

      await tester.tap(find.byIcon(Icons.delete_outline));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Delete'));
      await tester.pumpAndSettle();

      expect(find.byType(PostsPage), findsOneWidget);
      expect(find.text('Post deleted'), findsOneWidget);
      expect(find.text('Morning notes'), findsNothing);
      expect(find.text('Evening reads'), findsOneWidget);
      verify(() => postsRepository.deletePost(1)).called(1);
    });

    testWidgets('a failed delete keeps the details page visible', (
      tester,
    ) async {
      when(
        () => postsRepository.deletePost(1),
      ).thenThrow(const ServerFailure(statusCode: 500));

      await pumpApp(tester);
      await openFirstPostDetails(tester);

      await tester.tap(find.byIcon(Icons.delete_outline));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Delete'));
      await tester.pumpAndSettle();

      expect(find.byType(PostDetailsPage), findsOneWidget);
      expect(find.textContaining('Couldn’t delete post.'), findsOneWidget);
      expect(find.text('Morning notes'), findsOneWidget);
    });
  });
}
