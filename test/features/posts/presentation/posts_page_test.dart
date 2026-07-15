import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lumina/app/theme/app_theme.dart';
import 'package:lumina/core/error/app_failure.dart';
import 'package:lumina/features/favorites/data/repositories/favorites_repository_impl.dart';
import 'package:lumina/features/posts/data/repositories/posts_repository_impl.dart';
import 'package:lumina/features/posts/domain/entities/post.dart';
import 'package:lumina/features/posts/domain/repositories/posts_repository.dart';
import 'package:lumina/features/posts/presentation/posts_page.dart';
import 'package:lumina/features/posts/presentation/widgets/post_card.dart';
import 'package:lumina/features/posts/presentation/widgets/posts_loading_view.dart';
import 'package:mocktail/mocktail.dart';

import '../../../helpers/fake_repositories.dart';

class _MockPostsRepository extends Mock implements PostsRepository {}

const _posts = [
  Post(id: 1, authorId: 7, title: 'Morning notes', body: 'Coffee and code'),
  Post(id: 2, authorId: 8, title: 'Evening reads', body: 'Books and tea'),
];

void main() {
  late _MockPostsRepository repository;

  setUp(() {
    repository = _MockPostsRepository();
  });

  Future<void> pumpPostsPage(WidgetTester tester) {
    return tester.pumpWidget(
      ProviderScope(
        overrides: [
          postsRepositoryProvider.overrideWithValue(repository),
          favoritesRepositoryProvider.overrideWithValue(
            FakeFavoritesRepository(),
          ),
        ],
        child: MaterialApp(theme: AppTheme.light, home: const PostsPage()),
      ),
    );
  }

  testWidgets('shows the loading view while the request is pending', (
    tester,
  ) async {
    final completer = Completer<List<Post>>();
    when(() => repository.getPosts()).thenAnswer((_) => completer.future);

    await pumpPostsPage(tester);

    expect(find.byType(PostsLoadingView), findsOneWidget);
    expect(find.byType(PostCard), findsNothing);

    completer.complete(_posts);
    await tester.pump();
    expect(find.byType(PostsLoadingView), findsNothing);
  });

  testWidgets('renders title, body preview, and author indicator', (
    tester,
  ) async {
    when(() => repository.getPosts()).thenAnswer((_) async => _posts);

    await pumpPostsPage(tester);
    await tester.pump();

    expect(find.text('Morning notes'), findsOneWidget);
    expect(find.text('Coffee and code'), findsOneWidget);
    expect(find.text('Author 7'), findsOneWidget);
    expect(find.byType(PostCard), findsNWidgets(2));
  });

  testWidgets('shows a retryable error state and recovers on retry', (
    tester,
  ) async {
    var calls = 0;
    when(() => repository.getPosts()).thenAnswer((_) async {
      calls++;
      if (calls == 1) {
        throw const NetworkFailure();
      }
      return _posts;
    });

    await pumpPostsPage(tester);
    await tester.pump();

    expect(find.text('Couldn’t load posts'), findsOneWidget);
    expect(find.text('Retry'), findsOneWidget);
    expect(find.byType(PostCard), findsNothing);

    await tester.tap(find.text('Retry'));
    await tester.pump();
    await tester.pump();

    expect(find.byType(PostCard), findsNWidgets(2));
    expect(find.text('Retry'), findsNothing);
  });

  testWidgets('typing in search filters the visible cards', (tester) async {
    when(() => repository.getPosts()).thenAnswer((_) async => _posts);

    await pumpPostsPage(tester);
    await tester.pump();

    await tester.enterText(find.byType(TextField), 'evening');
    await tester.pump();

    expect(find.text('Evening reads'), findsOneWidget);
    expect(find.text('Morning notes'), findsNothing);
    expect(find.byType(PostCard), findsOneWidget);
  });

  testWidgets('shows the filtered-empty state and clears it', (tester) async {
    when(() => repository.getPosts()).thenAnswer((_) async => _posts);

    await pumpPostsPage(tester);
    await tester.pump();

    await tester.enterText(find.byType(TextField), 'zzz');
    await tester.pump();

    expect(find.text('No matching posts'), findsOneWidget);
    expect(find.byType(PostCard), findsNothing);

    await tester.tap(find.text('Clear search'));
    await tester.pump();

    expect(find.byType(PostCard), findsNWidgets(2));
    expect(find.text('No matching posts'), findsNothing);
  });

  testWidgets('pull-to-refresh fetches again and updates the list', (
    tester,
  ) async {
    var calls = 0;
    when(() => repository.getPosts()).thenAnswer((_) async {
      calls++;
      if (calls == 1) {
        return [_posts.first];
      }
      return _posts;
    });

    await pumpPostsPage(tester);
    await tester.pump();
    expect(find.byType(PostCard), findsOneWidget);

    await tester.fling(find.text('Morning notes'), const Offset(0, 300), 1000);
    await tester.pump();
    await tester.pump(const Duration(seconds: 1));
    await tester.pump(const Duration(seconds: 1));

    verify(() => repository.getPosts()).called(2);
    expect(find.byType(PostCard), findsNWidgets(2));
    expect(find.text('Evening reads'), findsOneWidget);
  });

  testWidgets('refresh failure keeps cards and shows a snackbar', (
    tester,
  ) async {
    var calls = 0;
    when(() => repository.getPosts()).thenAnswer((_) async {
      calls++;
      if (calls == 1) {
        return _posts;
      }
      throw const TimeoutFailure();
    });

    await pumpPostsPage(tester);
    await tester.pump();
    expect(find.byType(PostCard), findsNWidgets(2));

    await tester.fling(find.text('Morning notes'), const Offset(0, 300), 1000);
    await tester.pump();
    await tester.pump(const Duration(seconds: 1));
    await tester.pump(const Duration(seconds: 1));

    expect(find.byType(PostCard), findsNWidgets(2));
    expect(find.byType(SnackBar), findsOneWidget);
    expect(
      find.text('The request took too long. Please try again.'),
      findsOneWidget,
    );
    expect(find.text('Retry'), findsNothing);
  });
}
