import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lumina/features/comments/di.dart';
import 'package:lumina/features/comments/domain/repositories/comments_repository.dart';
import 'package:lumina/features/favorites/di.dart';
import 'package:lumina/features/posts/application/post_details_controller.dart';
import 'package:lumina/features/posts/application/post_form_controller.dart';
import 'package:lumina/features/posts/application/posts_controller.dart';
import 'package:lumina/features/posts/data/datasources/posts_remote_data_source.dart';
import 'package:lumina/features/posts/data/dto/post_dto.dart';
import 'package:lumina/features/posts/data/repositories/posts_repository_impl.dart';
import 'package:lumina/features/posts/di.dart';
import 'package:lumina/features/users/di.dart';
import 'package:mocktail/mocktail.dart';

import '../../../helpers/fake_repositories.dart';

class _MockPostsRemoteDataSource extends Mock
    implements PostsRemoteDataSource {}

class _MockCommentsRepository extends Mock implements CommentsRepository {}

const _remoteDtos = [
  PostDto(userId: 1, id: 1, title: 'Remote one', body: 'r1'),
  PostDto(userId: 2, id: 2, title: 'Remote two', body: 'r2'),
];

void main() {
  late _MockPostsRemoteDataSource remoteDataSource;
  late FakePostsLocalDataSource localDataSource;

  setUp(() {
    remoteDataSource = _MockPostsRemoteDataSource();
    localDataSource = FakePostsLocalDataSource();
    when(
      () => remoteDataSource.getPosts(),
    ).thenAnswer((_) async => _remoteDtos);
    when(
      () => remoteDataSource.getPost(1),
    ).thenAnswer((_) async => _remoteDtos[0]);
    when(
      () => remoteDataSource.getPost(2),
    ).thenAnswer((_) async => _remoteDtos[1]);
    when(
      () => remoteDataSource.createPost(
        authorId: any(named: 'authorId'),
        title: any(named: 'title'),
        body: any(named: 'body'),
      ),
    ).thenAnswer(
      (_) async => const PostDto(userId: 1, id: 101, title: 't', body: 'b'),
    );
    when(
      () => remoteDataSource.updatePost(
        postId: any(named: 'postId'),
        authorId: any(named: 'authorId'),
        title: any(named: 'title'),
        body: any(named: 'body'),
      ),
    ).thenAnswer(
      (_) async => const PostDto(userId: 1, id: 1, title: 't', body: 'b'),
    );
    when(() => remoteDataSource.deletePost(any())).thenAnswer((_) async {});
  });

  ProviderContainer createContainer() {
    final commentsRepository = _MockCommentsRepository();
    when(
      () => commentsRepository.getCommentsForPost(any()),
    ).thenAnswer((_) async => const []);
    final container = ProviderContainer(
      overrides: [
        postsRepositoryProvider.overrideWithValue(
          PostsRepositoryImpl(remoteDataSource, localDataSource),
        ),
        commentsRepositoryProvider.overrideWithValue(commentsRepository),
        favoritesRepositoryProvider.overrideWithValue(
          FakeFavoritesRepository(),
        ),
        usersRepositoryProvider.overrideWithValue(FakeUsersRepository()),
      ],
    );
    addTearDown(container.dispose);
    final subscription = container.listen(
      postsControllerProvider,
      (previous, next) {},
    );
    addTearDown(subscription.close);
    return container;
  }

  test('a refresh keeps created and edited posts in the list', () async {
    final container = createContainer();
    await pumpEventQueue();

    final created = await container
        .read(postFormControllerProvider(null).notifier)
        .submit(authorId: 1, title: 'Created', body: 'cb');
    final editFormSubscription = container.listen(
      postFormControllerProvider(1),
      (previous, next) {},
    );
    addTearDown(editFormSubscription.close);
    // Submitting is ignored until the edit form finishes prefilling.
    await pumpEventQueue();
    await container
        .read(postFormControllerProvider(1).notifier)
        .submit(authorId: 1, title: 'Edited one', body: 'e1');

    await container.read(postsControllerProvider.notifier).refresh();

    final titles = container
        .read(postsControllerProvider)
        .posts
        .map((post) => post.title);
    expect(titles, ['Created', 'Edited one', 'Remote two']);
    expect(created?.id, -1);
  });

  test('a locally deleted post does not reappear after refresh', () async {
    final container = createContainer();
    await pumpEventQueue();

    await container.read(postsRepositoryProvider).deletePost(2);
    await container.read(postsControllerProvider.notifier).refresh();

    final ids = container
        .read(postsControllerProvider)
        .posts
        .map((post) => post.id);
    expect(ids, [1]);
  });

  test('details resolves an edited post from the overlay', () async {
    final container = createContainer();
    await pumpEventQueue();

    final editFormSubscription = container.listen(
      postFormControllerProvider(2),
      (previous, next) {},
    );
    addTearDown(editFormSubscription.close);
    // Submitting is ignored until the edit form finishes prefilling.
    await pumpEventQueue();
    // The edit form itself fetches the post once for prefill.
    verify(() => remoteDataSource.getPost(2)).called(1);
    await container
        .read(postFormControllerProvider(2).notifier)
        .submit(authorId: 2, title: 'Edited two', body: 'e2');
    await pumpEventQueue();

    final detailsSubscription = container.listen(
      postDetailsControllerProvider(2),
      (previous, next) {},
    );
    addTearDown(detailsSubscription.close);
    await pumpEventQueue();

    expect(
      container.read(postDetailsControllerProvider(2)).post?.title,
      'Edited two',
    );
    verifyNever(() => remoteDataSource.getPost(any()));
  });

  test('details opens a locally created post without network', () async {
    final container = createContainer();
    await pumpEventQueue();

    final created = await container
        .read(postFormControllerProvider(null).notifier)
        .submit(authorId: 1, title: 'Created', body: 'cb');

    final detailsSubscription = container.listen(
      postDetailsControllerProvider(created!.id),
      (previous, next) {},
    );
    addTearDown(detailsSubscription.close);
    await pumpEventQueue();

    final details = container.read(postDetailsControllerProvider(created.id));
    expect(details.post, created);
    expect(details.comments, isEmpty);
    expect(details.areCommentsLoading, isFalse);
    verifyNever(() => remoteDataSource.getPost(any()));
  });
}
