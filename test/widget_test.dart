import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lumina/app/app.dart';
import 'package:lumina/features/home/presentation/home_page.dart';
import 'package:lumina/features/posts/data/repositories/posts_repository_impl.dart';
import 'package:lumina/features/posts/domain/entities/post.dart';
import 'package:lumina/features/posts/domain/repositories/posts_repository.dart';
import 'package:lumina/features/posts/presentation/posts_page.dart';

class _FakePostsRepository implements PostsRepository {
  static const _post = Post(
    id: 1,
    authorId: 1,
    title: 'Hello Lumina',
    body: 'Welcome post',
  );

  @override
  Future<List<Post>> getPosts() async => const [_post];

  @override
  Future<Post> getPost(int postId) async => _post;
}

Future<void> pumpApp(WidgetTester tester) async {
  await tester.pumpWidget(
    ProviderScope(
      overrides: [
        postsRepositoryProvider.overrideWithValue(_FakePostsRepository()),
      ],
      child: const LuminaApp(),
    ),
  );
  await tester.pumpAndSettle();
}

void main() {
  testWidgets('starts on the Home destination with Lumina content', (
    tester,
  ) async {
    await pumpApp(tester);

    final navigationBar = tester.widget<NavigationBar>(
      find.byType(NavigationBar),
    );
    expect(navigationBar.selectedIndex, 0);
    expect(find.byType(HomePage), findsOneWidget);
    expect(find.text('Welcome to Lumina'), findsOneWidget);
  });

  testWidgets('tapping Posts shows PostsPage and keeps the NavigationBar', (
    tester,
  ) async {
    await pumpApp(tester);

    await tester.tap(find.text('Posts'));
    await tester.pumpAndSettle();

    expect(find.byType(PostsPage), findsOneWidget);
    expect(find.text('Hello Lumina'), findsOneWidget);
    expect(find.byType(NavigationBar), findsOneWidget);
    final navigationBar = tester.widget<NavigationBar>(
      find.byType(NavigationBar),
    );
    expect(navigationBar.selectedIndex, 1);
  });

  testWidgets('navigating Home -> Posts -> Home works without exceptions', (
    tester,
  ) async {
    await pumpApp(tester);

    await tester.tap(find.text('Posts'));
    await tester.pumpAndSettle();
    expect(find.byType(PostsPage), findsOneWidget);

    await tester.tap(find.text('Home'));
    await tester.pumpAndSettle();

    expect(find.byType(HomePage), findsOneWidget);
    expect(tester.takeException(), isNull);
  });
}
