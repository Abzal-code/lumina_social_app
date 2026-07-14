import 'dart:convert';
import 'dart:typed_data';

import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lumina/core/error/app_exception.dart';
import 'package:lumina/core/network/api_client.dart';
import 'package:lumina/features/comments/data/datasources/comments_remote_data_source.dart';
import 'package:lumina/features/comments/data/dto/comment_dto.dart';

typedef _ResponseHandler = Future<ResponseBody> Function(RequestOptions);

class _FakeHttpClientAdapter implements HttpClientAdapter {
  _FakeHttpClientAdapter(this._handler);

  final _ResponseHandler _handler;

  @override
  Future<ResponseBody> fetch(
    RequestOptions options,
    Stream<Uint8List>? requestStream,
    Future<void>? cancelFuture,
  ) => _handler(options);

  @override
  void close({bool force = false}) {}
}

CommentsRemoteDataSource _dataSourceWith(_ResponseHandler handler) {
  final dio = Dio(
    BaseOptions(
      baseUrl: 'https://comments.test',
      responseType: ResponseType.json,
    ),
  )..httpClientAdapter = _FakeHttpClientAdapter(handler);
  return CommentsRemoteDataSourceImpl(ApiClient(dio));
}

ResponseBody _jsonResponse(Object body, {int statusCode = 200}) =>
    ResponseBody.fromString(
      jsonEncode(body),
      statusCode,
      headers: {
        Headers.contentTypeHeader: [Headers.jsonContentType],
      },
    );

Map<String, Object?> _commentJson(int id) => {
  'postId': 1,
  'id': id,
  'name': 'Commenter $id',
  'email': 'user$id@example.com',
  'body': 'Comment body $id',
};

void main() {
  group('CommentsRemoteDataSourceImpl.getCommentsForPost', () {
    test('parses a JSON list into CommentDto objects', () async {
      final dataSource = _dataSourceWith((options) async {
        expect(options.path, '/posts/1/comments');
        return _jsonResponse([_commentJson(1), _commentJson(2)]);
      });

      final comments = await dataSource.getCommentsForPost(1);

      expect(comments, const [
        CommentDto(
          postId: 1,
          id: 1,
          name: 'Commenter 1',
          email: 'user1@example.com',
          body: 'Comment body 1',
        ),
        CommentDto(
          postId: 1,
          id: 2,
          name: 'Commenter 2',
          email: 'user2@example.com',
          body: 'Comment body 2',
        ),
      ]);
    });

    test('throws ParsingException when the body is not a list', () {
      final dataSource = _dataSourceWith(
        (_) async => _jsonResponse({'unexpected': 'object'}),
      );

      expect(
        dataSource.getCommentsForPost(1),
        throwsA(isA<ParsingException>()),
      );
    });

    test('throws ParsingException when a list item is malformed', () {
      final dataSource = _dataSourceWith(
        (_) async => _jsonResponse([
          _commentJson(1),
          {'postId': 1, 'id': 'not-a-number', 'name': 'x'},
        ]),
      );

      expect(
        dataSource.getCommentsForPost(1),
        throwsA(isA<ParsingException>()),
      );
    });

    test('maps Dio timeouts to RequestTimeoutException', () {
      final dataSource = _dataSourceWith(
        (options) => throw DioException.connectionTimeout(
          timeout: const Duration(seconds: 1),
          requestOptions: options,
        ),
      );

      expect(
        dataSource.getCommentsForPost(1),
        throwsA(isA<RequestTimeoutException>()),
      );
    });

    test('maps HTTP 404 to NotFoundException', () {
      final dataSource = _dataSourceWith(
        (_) async => _jsonResponse({}, statusCode: 404),
      );

      expect(
        dataSource.getCommentsForPost(999),
        throwsA(isA<NotFoundException>()),
      );
    });

    test('maps HTTP 500 to ServerException with the status code', () {
      final dataSource = _dataSourceWith(
        (_) async => _jsonResponse({}, statusCode: 500),
      );

      expect(
        dataSource.getCommentsForPost(1),
        throwsA(
          isA<ServerException>().having(
            (exception) => exception.statusCode,
            'statusCode',
            500,
          ),
        ),
      );
    });

    test('rejects non-positive IDs without performing a request', () {
      var requested = false;
      final dataSource = _dataSourceWith((_) async {
        requested = true;
        return _jsonResponse([]);
      });

      expect(
        dataSource.getCommentsForPost(0),
        throwsA(isA<NotFoundException>()),
      );
      expect(
        dataSource.getCommentsForPost(-1),
        throwsA(isA<NotFoundException>()),
      );
      expect(requested, isFalse);
    });
  });
}
