import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lumina/app/app.dart';
import 'package:lumina/features/comments/di.dart';
import 'package:lumina/features/comments/domain/entities/comment.dart';
import 'package:lumina/features/comments/domain/repositories/comments_repository.dart';
import 'package:lumina/features/favorites/di.dart';
import 'package:lumina/features/posts/di.dart';
import 'package:lumina/features/posts/domain/entities/post.dart';
import 'package:lumina/features/posts/domain/repositories/posts_repository.dart';
import 'package:lumina/features/posts/presentation/post_details_page.dart';
import 'package:lumina/features/posts/presentation/post_form_page.dart';
import 'package:lumina/features/users/di.dart';
import 'package:lumina/features/users/presentation/user_profile_page.dart';
import 'package:lumina/features/users/presentation/widgets/user_card.dart';

import 'helpers/fake_repositories.dart';

const _longTitle =
    'An unusually long publication title that should wrap across several '
    'lines without overflowing on narrow screens';

const _longBody =
    'A long body paragraph that keeps going for a while to exercise text '
    'wrapping, padding, and constrained widths on every supported screen '
    'size, from a small phone in landscape up to a large tablet.';

const _posts = [
  Post(id: 1, authorId: 1, title: _longTitle, body: _longBody),
  Post(id: 2, authorId: 2, title: 'Short one', body: 'Tiny body'),
];

class _FakePostsRepository implements PostsRepository {
  @override
  Future<List<Post>> getPosts() async => _posts;

  @override
  Future<Post> getPost(int postId) async =>
      _posts.firstWhere((post) => post.id == postId);

  @override
  Future<List<Post>> getPostsForUser(int userId) async =>
      [for (final post in _posts) if (post.authorId == userId) post];

  @override
  Future<Post> createPost({
    required int authorId,
    required String title,
    required String body,
  }) async => Post(id: -1, authorId: authorId, title: title, body: body);

  @override
  Future<Post> updatePost({
    required int postId,
    required int authorId,
    required String title,
    required String body,
  }) async => Post(id: postId, authorId: authorId, title: title, body: body);

  @override
  Future<void> deletePost(int postId) async {}
}

class _FakeCommentsRepository implements CommentsRepository {
  @override
  Future<List<Comment>> getCommentsForPost(int postId) async => const [
    Comment(
      id: 1,
      postId: 1,
      name: _longTitle,
      email: 'commenter@example.org',
      body: _longBody,
    ),
  ];
}

/// (logical width, logical height) per device class.
const _sizes = {
  'small phone': Size(320, 568),
  'small phone landscape': Size(640, 360),
  'large phone': Size(430, 932),
  'tablet': Size(1024, 1366),
};

void main() {
  Future<void> pumpApp(WidgetTester tester, Size logicalSize) async {
    tester.view.physicalSize = logicalSize * tester.view.devicePixelRatio;
    addTearDown(tester.view.resetPhysicalSize);
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          postsRepositoryProvider.overrideWithValue(_FakePostsRepository()),
          commentsRepositoryProvider.overrideWithValue(
            _FakeCommentsRepository(),
          ),
          usersRepositoryProvider.overrideWithValue(FakeUsersRepository()),
          favoritesRepositoryProvider.overrideWithValue(
            FakeFavoritesRepository(initialIds: {1}),
          ),
        ],
        child: const LuminaApp(),
      ),
    );
    await tester.pumpAndSettle();
  }

  for (final MapEntry(key: device, value: size) in _sizes.entries) {
    testWidgets('screens lay out without overflow on a $device', (
      tester,
    ) async {
      await pumpApp(tester, size);

      await tester.tap(find.text('Posts'));
      await tester.pumpAndSettle();

      // On short screens the second card starts below the fold.
      await tester.dragUntilVisible(
        find.text('Short one'),
        find.byType(ListView),
        const Offset(0, -200),
      );
      await tester.pumpAndSettle();
      await tester.tap(find.text('Short one'));
      await tester.pumpAndSettle();
      expect(find.byType(PostDetailsPage), findsOneWidget);
      await tester.pageBack();
      await tester.pumpAndSettle();

      await tester.tap(find.byType(FloatingActionButton));
      await tester.pumpAndSettle();
      expect(find.byType(PostFormPage), findsOneWidget);
      await tester.pageBack();
      await tester.pumpAndSettle();

      await tester.tap(find.text('Users'));
      await tester.pumpAndSettle();

      await tester.tap(find.byType(UserCard).first);
      await tester.pumpAndSettle();
      expect(find.byType(UserProfilePage), findsOneWidget);
      await tester.pageBack();
      await tester.pumpAndSettle();

      await tester.tap(find.text('Favorites'));
      await tester.pumpAndSettle();
      expect(find.text(_longTitle), findsOneWidget);

      expect(tester.takeException(), isNull);
    });
  }
}
