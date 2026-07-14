import 'package:flutter_test/flutter_test.dart';
import 'package:lumina/core/error/app_exception.dart';
import 'package:lumina/core/error/app_failure.dart';
import 'package:lumina/features/comments/data/datasources/comments_remote_data_source.dart';
import 'package:lumina/features/comments/data/dto/comment_dto.dart';
import 'package:lumina/features/comments/data/repositories/comments_repository_impl.dart';
import 'package:lumina/features/comments/domain/entities/comment.dart';
import 'package:mocktail/mocktail.dart';

class _MockCommentsRemoteDataSource extends Mock
    implements CommentsRemoteDataSource {}

void main() {
  late _MockCommentsRemoteDataSource dataSource;
  late CommentsRepositoryImpl repository;

  setUp(() {
    dataSource = _MockCommentsRemoteDataSource();
    repository = CommentsRepositoryImpl(dataSource);
  });

  group('CommentsRepositoryImpl.getCommentsForPost', () {
    test('maps DTOs to domain entities preserving order', () async {
      when(() => dataSource.getCommentsForPost(1)).thenAnswer(
        (_) async => const [
          CommentDto(
            postId: 1,
            id: 5,
            name: 'First',
            email: 'first@example.com',
            body: 'body one',
          ),
          CommentDto(
            postId: 1,
            id: 2,
            name: 'Second',
            email: 'second@example.com',
            body: 'body two',
          ),
        ],
      );

      final comments = await repository.getCommentsForPost(1);

      expect(comments, const [
        Comment(
          id: 5,
          postId: 1,
          name: 'First',
          email: 'first@example.com',
          body: 'body one',
        ),
        Comment(
          id: 2,
          postId: 1,
          name: 'Second',
          email: 'second@example.com',
          body: 'body two',
        ),
      ]);
    });

    test('maps ParsingException to DataParsingFailure', () {
      when(
        () => dataSource.getCommentsForPost(1),
      ).thenThrow(const ParsingException());

      expect(
        repository.getCommentsForPost(1),
        throwsA(isA<DataParsingFailure>()),
      );
    });

    test('maps ServerException to ServerFailure keeping the status code', () {
      when(
        () => dataSource.getCommentsForPost(1),
      ).thenThrow(const ServerException(statusCode: 502));

      expect(
        repository.getCommentsForPost(1),
        throwsA(
          isA<ServerFailure>().having(
            (failure) => failure.statusCode,
            'statusCode',
            502,
          ),
        ),
      );
    });
  });
}
