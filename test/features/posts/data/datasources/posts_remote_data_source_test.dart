import 'dart:convert';
import 'dart:typed_data';

import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lumina/core/error/app_exception.dart';
import 'package:lumina/core/network/api_client.dart';
import 'package:lumina/features/posts/data/datasources/posts_remote_data_source.dart';
import 'package:lumina/features/posts/data/dto/post_dto.dart';

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

PostsRemoteDataSource _dataSourceWith(_ResponseHandler handler) {
  final dio = Dio(
    BaseOptions(baseUrl: 'https://posts.test', responseType: ResponseType.json),
  )..httpClientAdapter = _FakeHttpClientAdapter(handler);
  return PostsRemoteDataSourceImpl(ApiClient(dio));
}

ResponseBody _jsonResponse(Object body, {int statusCode = 200}) =>
    ResponseBody.fromString(
      jsonEncode(body),
      statusCode,
      headers: {
        Headers.contentTypeHeader: [Headers.jsonContentType],
      },
    );

void main() {
  group('PostsRemoteDataSourceImpl.getPosts', () {
    test('parses a JSON list into PostDto objects', () async {
      final dataSource = _dataSourceWith(
        (_) async => _jsonResponse([
          {'userId': 1, 'id': 10, 'title': 'first', 'body': 'body one'},
          {'userId': 2, 'id': 20, 'title': 'second', 'body': 'body two'},
        ]),
      );

      final posts = await dataSource.getPosts();

      expect(posts, const [
        PostDto(userId: 1, id: 10, title: 'first', body: 'body one'),
        PostDto(userId: 2, id: 20, title: 'second', body: 'body two'),
      ]);
    });

    test('throws ParsingException when the body is not a list', () {
      final dataSource = _dataSourceWith(
        (_) async => _jsonResponse({'unexpected': 'object'}),
      );

      expect(dataSource.getPosts(), throwsA(isA<ParsingException>()));
    });

    test('throws ParsingException when a list item is malformed', () {
      final dataSource = _dataSourceWith(
        (_) async => _jsonResponse([
          {'userId': 1, 'id': 10, 'title': 'valid', 'body': 'valid'},
          {'userId': 'not-a-number', 'id': 20, 'title': 't', 'body': 'b'},
        ]),
      );

      expect(dataSource.getPosts(), throwsA(isA<ParsingException>()));
    });

    test('maps Dio timeouts to RequestTimeoutException', () {
      final dataSource = _dataSourceWith(
        (options) => throw DioException.connectionTimeout(
          timeout: const Duration(seconds: 1),
          requestOptions: options,
        ),
      );

      expect(dataSource.getPosts(), throwsA(isA<RequestTimeoutException>()));
    });

    test('maps HTTP 404 to NotFoundException', () {
      final dataSource = _dataSourceWith(
        (_) async => _jsonResponse({'error': 'missing'}, statusCode: 404),
      );

      expect(dataSource.getPosts(), throwsA(isA<NotFoundException>()));
    });

    test('maps HTTP 500 to ServerException with the status code', () {
      final dataSource = _dataSourceWith(
        (_) async => _jsonResponse({'error': 'boom'}, statusCode: 500),
      );

      expect(
        dataSource.getPosts(),
        throwsA(
          isA<ServerException>().having(
            (exception) => exception.statusCode,
            'statusCode',
            500,
          ),
        ),
      );
    });
  });

  group('PostsRemoteDataSourceImpl.getPost', () {
    test('parses a JSON object into a PostDto', () async {
      final dataSource = _dataSourceWith((options) async {
        expect(options.path, '/posts/10');
        return _jsonResponse({
          'userId': 1,
          'id': 10,
          'title': 'single',
          'body': 'one post',
        });
      });

      final post = await dataSource.getPost(10);

      expect(
        post,
        const PostDto(userId: 1, id: 10, title: 'single', body: 'one post'),
      );
    });

    test('throws ParsingException when the body is not an object', () {
      final dataSource = _dataSourceWith((_) async => _jsonResponse([1, 2]));

      expect(dataSource.getPost(10), throwsA(isA<ParsingException>()));
    });

    test('maps HTTP 404 to NotFoundException', () {
      final dataSource = _dataSourceWith(
        (_) async => _jsonResponse({}, statusCode: 404),
      );

      expect(dataSource.getPost(999), throwsA(isA<NotFoundException>()));
    });

    test('rejects non-positive IDs without performing a request', () {
      var requested = false;
      final dataSource = _dataSourceWith((_) async {
        requested = true;
        return _jsonResponse({});
      });

      expect(dataSource.getPost(0), throwsA(isA<NotFoundException>()));
      expect(dataSource.getPost(-3), throwsA(isA<NotFoundException>()));
      expect(requested, isFalse);
    });
  });

  group('PostsRemoteDataSourceImpl.createPost', () {
    test('POSTs trimmed fields and parses the response object', () async {
      final dataSource = _dataSourceWith((options) async {
        expect(options.method, 'POST');
        expect(options.path, '/posts');
        expect(options.data, {
          'userId': 3,
          'title': 'fresh title',
          'body': 'fresh body',
        });
        return _jsonResponse({
          'userId': 3,
          'id': 101,
          'title': 'fresh title',
          'body': 'fresh body',
        });
      });

      final post = await dataSource.createPost(
        authorId: 3,
        title: '  fresh title  ',
        body: '\nfresh body ',
      );

      expect(
        post,
        const PostDto(
          userId: 3,
          id: 101,
          title: 'fresh title',
          body: 'fresh body',
        ),
      );
    });

    test('rejects a non-positive author ID without a request', () async {
      var requested = false;
      final dataSource = _dataSourceWith((_) async {
        requested = true;
        return _jsonResponse({});
      });

      await expectLater(
        dataSource.createPost(authorId: 0, title: 't', body: 'b'),
        throwsA(isA<NotFoundException>()),
      );
      expect(requested, isFalse);
    });

    test('rejects blank title or body without a request', () async {
      var requested = false;
      final dataSource = _dataSourceWith((_) async {
        requested = true;
        return _jsonResponse({});
      });

      await expectLater(
        dataSource.createPost(authorId: 1, title: '   ', body: 'b'),
        throwsA(isA<UnexpectedException>()),
      );
      await expectLater(
        dataSource.createPost(authorId: 1, title: 't', body: ''),
        throwsA(isA<UnexpectedException>()),
      );
      expect(requested, isFalse);
    });

    test('throws ParsingException when the response is not an object', () {
      final dataSource = _dataSourceWith((_) async => _jsonResponse([1]));

      expect(
        dataSource.createPost(authorId: 1, title: 't', body: 'b'),
        throwsA(isA<ParsingException>()),
      );
    });

    test('maps HTTP 500 to ServerException', () {
      final dataSource = _dataSourceWith(
        (_) async => _jsonResponse({}, statusCode: 500),
      );

      expect(
        dataSource.createPost(authorId: 1, title: 't', body: 'b'),
        throwsA(isA<ServerException>()),
      );
    });
  });

  group('PostsRemoteDataSourceImpl.updatePost', () {
    test('PATCHes trimmed fields and parses the response object', () async {
      final dataSource = _dataSourceWith((options) async {
        expect(options.method, 'PATCH');
        expect(options.path, '/posts/9');
        expect(options.data, {
          'userId': 2,
          'title': 'edited',
          'body': 'edited body',
        });
        return _jsonResponse({
          'userId': 2,
          'id': 9,
          'title': 'edited',
          'body': 'edited body',
        });
      });

      final post = await dataSource.updatePost(
        postId: 9,
        authorId: 2,
        title: ' edited ',
        body: 'edited body',
      );

      expect(
        post,
        const PostDto(userId: 2, id: 9, title: 'edited', body: 'edited body'),
      );
    });

    test('rejects non-positive IDs without a request', () async {
      var requested = false;
      final dataSource = _dataSourceWith((_) async {
        requested = true;
        return _jsonResponse({});
      });

      await expectLater(
        dataSource.updatePost(postId: 0, authorId: 1, title: 't', body: 'b'),
        throwsA(isA<NotFoundException>()),
      );
      await expectLater(
        dataSource.updatePost(postId: 9, authorId: -1, title: 't', body: 'b'),
        throwsA(isA<NotFoundException>()),
      );
      expect(requested, isFalse);
    });

    test('rejects blank title or body without a request', () async {
      var requested = false;
      final dataSource = _dataSourceWith((_) async {
        requested = true;
        return _jsonResponse({});
      });

      await expectLater(
        dataSource.updatePost(postId: 9, authorId: 1, title: ' ', body: 'b'),
        throwsA(isA<UnexpectedException>()),
      );
      expect(requested, isFalse);
    });

    test('maps HTTP 404 to NotFoundException', () {
      final dataSource = _dataSourceWith(
        (_) async => _jsonResponse({}, statusCode: 404),
      );

      expect(
        dataSource.updatePost(postId: 9, authorId: 1, title: 't', body: 'b'),
        throwsA(isA<NotFoundException>()),
      );
    });
  });

  group('PostsRemoteDataSourceImpl.deletePost', () {
    test('DELETEs the post and accepts an empty object response', () async {
      RequestOptions? captured;
      final dataSource = _dataSourceWith((options) async {
        captured = options;
        return _jsonResponse({});
      });

      await dataSource.deletePost(9);

      expect(captured?.method, 'DELETE');
      expect(captured?.path, '/posts/9');
    });

    test('rejects non-positive IDs without a request', () async {
      var requested = false;
      final dataSource = _dataSourceWith((_) async {
        requested = true;
        return _jsonResponse({});
      });

      await expectLater(
        dataSource.deletePost(0),
        throwsA(isA<NotFoundException>()),
      );
      await expectLater(
        dataSource.deletePost(-2),
        throwsA(isA<NotFoundException>()),
      );
      expect(requested, isFalse);
    });

    test('maps Dio connection errors to NetworkException', () {
      final dataSource = _dataSourceWith(
        (options) => throw DioException.connectionError(
          requestOptions: options,
          reason: 'refused',
        ),
      );

      expect(dataSource.deletePost(9), throwsA(isA<NetworkException>()));
    });
  });

  group('PostsRemoteDataSourceImpl.getPostsForUser', () {
    test('requests /users/{id}/posts and parses the list in order', () async {
      final dataSource = _dataSourceWith((options) async {
        expect(options.path, '/users/7/posts');
        return _jsonResponse([
          {'userId': 7, 'id': 30, 'title': 'third', 'body': 'body three'},
          {'userId': 7, 'id': 10, 'title': 'first', 'body': 'body one'},
        ]);
      });

      final posts = await dataSource.getPostsForUser(7);

      expect(posts, const [
        PostDto(userId: 7, id: 30, title: 'third', body: 'body three'),
        PostDto(userId: 7, id: 10, title: 'first', body: 'body one'),
      ]);
    });

    test('throws ParsingException when the body is not a list', () {
      final dataSource = _dataSourceWith(
        (_) async => _jsonResponse({'unexpected': 'object'}),
      );

      expect(dataSource.getPostsForUser(7), throwsA(isA<ParsingException>()));
    });

    test('throws ParsingException when a list item is malformed', () {
      final dataSource = _dataSourceWith(
        (_) async => _jsonResponse([
          {'userId': 'not-a-number', 'id': 20, 'title': 't', 'body': 'b'},
        ]),
      );

      expect(dataSource.getPostsForUser(7), throwsA(isA<ParsingException>()));
    });

    test('rejects non-positive user IDs without performing a request', () {
      var requested = false;
      final dataSource = _dataSourceWith((_) async {
        requested = true;
        return _jsonResponse([]);
      });

      expect(dataSource.getPostsForUser(0), throwsA(isA<NotFoundException>()));
      expect(dataSource.getPostsForUser(-1), throwsA(isA<NotFoundException>()));
      expect(requested, isFalse);
    });
  });
}
