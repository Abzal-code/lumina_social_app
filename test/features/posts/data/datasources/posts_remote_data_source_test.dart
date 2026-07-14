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
}
