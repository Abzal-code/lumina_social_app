import 'package:flutter_test/flutter_test.dart';
import 'package:lumina/core/error/app_exception.dart';
import 'package:lumina/core/error/app_failure.dart';
import 'package:lumina/features/posts/data/datasources/posts_remote_data_source.dart';
import 'package:lumina/features/posts/data/dto/post_dto.dart';
import 'package:lumina/features/posts/data/repositories/posts_repository_impl.dart';
import 'package:lumina/features/posts/domain/entities/post.dart';
import 'package:mocktail/mocktail.dart';

class _MockPostsRemoteDataSource extends Mock
    implements PostsRemoteDataSource {}

void main() {
  late _MockPostsRemoteDataSource dataSource;
  late PostsRepositoryImpl repository;

  setUp(() {
    dataSource = _MockPostsRemoteDataSource();
    repository = PostsRepositoryImpl(dataSource);
  });

  group('PostsRepositoryImpl.getPosts', () {
    test('maps DTOs to domain entities with userId as authorId', () async {
      when(() => dataSource.getPosts()).thenAnswer(
        (_) async => const [
          PostDto(userId: 7, id: 1, title: 'first', body: 'body one'),
        ],
      );

      final posts = await repository.getPosts();

      expect(posts, const [
        Post(id: 1, authorId: 7, title: 'first', body: 'body one'),
      ]);
    });

    test('preserves the order returned by the data source', () async {
      when(() => dataSource.getPosts()).thenAnswer(
        (_) async => const [
          PostDto(userId: 1, id: 5, title: 'c', body: 'c'),
          PostDto(userId: 2, id: 2, title: 'a', body: 'a'),
          PostDto(userId: 3, id: 9, title: 'b', body: 'b'),
        ],
      );

      final posts = await repository.getPosts();

      expect(posts.map((post) => post.id), [5, 2, 9]);
    });

    test('maps NetworkException to NetworkFailure', () {
      when(() => dataSource.getPosts()).thenThrow(const NetworkException());

      expect(repository.getPosts(), throwsA(isA<NetworkFailure>()));
    });

    test('maps ParsingException to DataParsingFailure', () {
      when(() => dataSource.getPosts()).thenThrow(const ParsingException());

      expect(repository.getPosts(), throwsA(isA<DataParsingFailure>()));
    });

    test('maps ServerException to ServerFailure keeping the status code', () {
      when(
        () => dataSource.getPosts(),
      ).thenThrow(const ServerException(statusCode: 503));

      expect(
        repository.getPosts(),
        throwsA(
          isA<ServerFailure>().having(
            (failure) => failure.statusCode,
            'statusCode',
            503,
          ),
        ),
      );
    });
  });
}
