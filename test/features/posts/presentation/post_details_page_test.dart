import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:lumina/app/app.dart';
import 'package:lumina/app/router/app_router.dart';
import 'package:lumina/core/error/app_failure.dart';
import 'package:lumina/features/comments/data/repositories/comments_repository_impl.dart';
import 'package:lumina/features/comments/domain/entities/comment.dart';
import 'package:lumina/features/comments/domain/repositories/comments_repository.dart';
import 'package:lumina/features/comments/presentation/widgets/comment_card.dart';
import 'package:lumina/features/comments/presentation/widgets/comments_loading_view.dart';
import 'package:lumina/features/favorites/data/repositories/favorites_repository_impl.dart';
import 'package:lumina/features/posts/data/repositories/posts_repository_impl.dart';
import 'package:lumina/features/posts/domain/entities/post.dart';
import 'package:lumina/features/posts/domain/repositories/posts_repository.dart';
import 'package:lumina/features/posts/presentation/post_details_page.dart';
import 'package:lumina/features/posts/presentation/widgets/post_card.dart';
import 'package:mocktail/mocktail.dart';

import '../../../helpers/fake_repositories.dart';

class _MockPostsRepository extends Mock implements PostsRepository {}

class _MockCommentsRepository extends Mock implements CommentsRepository {}

const _posts = [
  Post(
    id: 1,
    authorId: 7,
    title: 'Morning notes',
    body: 'A long story about coffee and code that fills the page.',
  ),
  Post(id: 2, authorId: 8, title: 'Evening reads', body: 'Books and tea'),
];

const _comments = [
  Comment(
    id: 1,
    postId: 1,
    name: 'Ada',
    email: 'ada@example.com',
    body: 'Wonderful post',
  ),
  Comment(
    id: 2,
    postId: 1,
    name: 'Grace',
    email: 'grace@example.com',
    body: 'Very insightful',
  ),
];

void main() {
  late _MockPostsRepository postsRepository;
  late _MockCommentsRepository commentsRepository;

  setUp(() {
    postsRepository = _MockPostsRepository();
    commentsRepository = _MockCommentsRepository();
    when(() => postsRepository.getPosts()).thenAnswer((_) async => _posts);
    when(
      () => commentsRepository.getCommentsForPost(any()),
    ).thenAnswer((_) async => _comments);
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

  Future<void> openFirstPost(WidgetTester tester) async {
    await tester.tap(find.text('Posts'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Morning notes'));
    await tester.pumpAndSettle();
  }

  testWidgets('tapping a post card opens details with the navigation bar', (
    tester,
  ) async {
    await pumpApp(tester);
    await openFirstPost(tester);

    expect(find.byType(PostDetailsPage), findsOneWidget);
    expect(find.byType(NavigationBar), findsOneWidget);
    expect(
      find.text('A long story about coffee and code that fills the page.'),
      findsOneWidget,
    );
    expect(find.text('Author 7'), findsOneWidget);
  });

  testWidgets('back returns to the posts list with search preserved', (
    tester,
  ) async {
    await pumpApp(tester);
    await tester.tap(find.text('Posts'));
    await tester.pumpAndSettle();

    await tester.enterText(find.byType(TextField), 'morning');
    await tester.pump();
    expect(find.byType(PostCard), findsOneWidget);

    await tester.tap(find.text('Morning notes'));
    await tester.pumpAndSettle();
    expect(find.byType(PostDetailsPage), findsOneWidget);

    await tester.pageBack();
    await tester.pumpAndSettle();

    expect(find.widgetWithText(TextField, 'morning'), findsOneWidget);
    expect(find.byType(PostCard), findsOneWidget);
    expect(find.text('Evening reads'), findsNothing);
  });

  testWidgets('a direct route load fetches the post via getPost', (
    tester,
  ) async {
    when(
      () => postsRepository.getPosts(),
    ).thenAnswer((_) => Completer<List<Post>>().future);
    when(() => postsRepository.getPost(2)).thenAnswer((_) async => _posts[1]);

    await pumpApp(tester);
    routerOf(tester).go('/posts/2');
    await tester.pumpAndSettle();

    expect(find.text('Evening reads'), findsOneWidget);
    verify(() => postsRepository.getPost(2)).called(1);
  });

  testWidgets('renders comments below the post', (tester) async {
    await pumpApp(tester);
    await openFirstPost(tester);

    expect(find.text('Comments'), findsOneWidget);
    expect(find.byType(CommentCard), findsNWidgets(2));
    expect(find.text('Ada'), findsOneWidget);
    expect(find.text('grace@example.com'), findsOneWidget);
  });

  testWidgets('comments loading keeps the post visible', (tester) async {
    final completer = Completer<List<Comment>>();
    when(
      () => commentsRepository.getCommentsForPost(any()),
    ).thenAnswer((_) => completer.future);

    await pumpApp(tester);
    await tester.tap(find.text('Posts'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Morning notes'));
    await tester.pumpAndSettle();

    expect(find.text('Morning notes'), findsOneWidget);
    expect(find.byType(CommentsLoadingView), findsOneWidget);

    completer.complete(_comments);
    await tester.pumpAndSettle();
    expect(find.byType(CommentCard), findsNWidgets(2));
  });

  testWidgets('comments failure shows inline retry and recovers', (
    tester,
  ) async {
    var calls = 0;
    when(() => commentsRepository.getCommentsForPost(any())).thenAnswer((
      _,
    ) async {
      calls++;
      if (calls == 1) {
        throw const ServerFailure(statusCode: 500);
      }
      return _comments;
    });

    await pumpApp(tester);
    await openFirstPost(tester);

    expect(find.text('Morning notes'), findsOneWidget);
    expect(find.text('Couldn’t load comments'), findsOneWidget);
    expect(find.text('Retry'), findsOneWidget);

    await tester.tap(find.text('Retry'));
    await tester.pumpAndSettle();

    expect(find.byType(CommentCard), findsNWidgets(2));
    expect(find.text('Couldn’t load comments'), findsNothing);
  });

  testWidgets('shows the empty state when there are no comments', (
    tester,
  ) async {
    when(
      () => commentsRepository.getCommentsForPost(any()),
    ).thenAnswer((_) async => const []);

    await pumpApp(tester);
    await openFirstPost(tester);

    expect(find.text('No comments yet'), findsOneWidget);
    expect(find.byType(CommentCard), findsNothing);
  });

  testWidgets('pull-to-refresh reloads the comments list', (tester) async {
    var calls = 0;
    when(() => commentsRepository.getCommentsForPost(any())).thenAnswer((
      _,
    ) async {
      calls++;
      if (calls == 1) {
        return [_comments.first];
      }
      return _comments;
    });

    await pumpApp(tester);
    await openFirstPost(tester);
    expect(find.byType(CommentCard), findsOneWidget);

    await tester.fling(find.text('Morning notes'), const Offset(0, 300), 1000);
    await tester.pump();
    await tester.pump(const Duration(seconds: 1));
    await tester.pump(const Duration(seconds: 1));

    verify(() => commentsRepository.getCommentsForPost(1)).called(2);
    expect(find.byType(CommentCard), findsNWidgets(2));
  });

  testWidgets('comments refresh failure keeps comments and shows a snackbar', (
    tester,
  ) async {
    var calls = 0;
    when(() => commentsRepository.getCommentsForPost(any())).thenAnswer((
      _,
    ) async {
      calls++;
      if (calls == 1) {
        return _comments;
      }
      throw const TimeoutFailure();
    });

    await pumpApp(tester);
    await openFirstPost(tester);
    expect(find.byType(CommentCard), findsNWidgets(2));

    await tester.fling(find.text('Morning notes'), const Offset(0, 300), 1000);
    await tester.pump();
    await tester.pump(const Duration(seconds: 1));
    await tester.pump(const Duration(seconds: 1));

    expect(find.byType(CommentCard), findsNWidgets(2));
    expect(find.byType(SnackBar), findsOneWidget);
    expect(
      find.text('The request took too long. Please try again.'),
      findsOneWidget,
    );
  });

  testWidgets('an invalid route ID shows user-friendly content', (
    tester,
  ) async {
    await pumpApp(tester);

    routerOf(tester).go('/posts/abc');
    await tester.pumpAndSettle();
    expect(find.text('This post is no longer available.'), findsOneWidget);
    expect(tester.takeException(), isNull);

    routerOf(tester).go('/posts/0');
    await tester.pumpAndSettle();
    expect(find.text('This post is no longer available.'), findsOneWidget);
    expect(tester.takeException(), isNull);
    verifyNever(() => postsRepository.getPost(any()));
  });
}
