import 'dart:convert';
import 'dart:typed_data';

import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lumina/core/error/app_exception.dart';
import 'package:lumina/core/network/api_client.dart';
import 'package:lumina/features/users/data/datasources/users_remote_data_source.dart';
import 'package:lumina/features/users/data/dto/address_dto.dart';
import 'package:lumina/features/users/data/dto/company_dto.dart';
import 'package:lumina/features/users/data/dto/geo_dto.dart';
import 'package:lumina/features/users/data/dto/user_dto.dart';

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

UsersRemoteDataSource _dataSourceWith(_ResponseHandler handler) {
  final dio = Dio(
    BaseOptions(baseUrl: 'https://users.test', responseType: ResponseType.json),
  )..httpClientAdapter = _FakeHttpClientAdapter(handler);
  return UsersRemoteDataSourceImpl(ApiClient(dio));
}

ResponseBody _jsonResponse(Object body, {int statusCode = 200}) =>
    ResponseBody.fromString(
      jsonEncode(body),
      statusCode,
      headers: {
        Headers.contentTypeHeader: [Headers.jsonContentType],
      },
    );

Map<String, Object?> _userJson(int id, {String name = 'Leanne Graham'}) => {
  'id': id,
  'name': name,
  'username': 'Bret',
  'email': 'Sincere@april.biz',
  'address': {
    'street': 'Kulas Light',
    'suite': 'Apt. 556',
    'city': 'Gwenborough',
    'zipcode': '92998-3874',
    'geo': {'lat': '-37.3159', 'lng': '81.1496'},
  },
  'phone': '1-770-736-8031 x56442',
  'website': 'hildegard.org',
  'company': {
    'name': 'Romaguera-Crona',
    'catchPhrase': 'Multi-layered client-server neural-net',
    'bs': 'harness real-time e-markets',
  },
};

UserDto _userDto(int id, {String name = 'Leanne Graham'}) => UserDto(
  id: id,
  name: name,
  username: 'Bret',
  email: 'Sincere@april.biz',
  address: const AddressDto(
    street: 'Kulas Light',
    suite: 'Apt. 556',
    city: 'Gwenborough',
    zipcode: '92998-3874',
    geo: GeoDto(lat: '-37.3159', lng: '81.1496'),
  ),
  phone: '1-770-736-8031 x56442',
  website: 'hildegard.org',
  company: const CompanyDto(
    name: 'Romaguera-Crona',
    catchPhrase: 'Multi-layered client-server neural-net',
    bs: 'harness real-time e-markets',
  ),
);

void main() {
  group('UsersRemoteDataSourceImpl.getUsers', () {
    test('parses a JSON list into UserDto objects', () async {
      final dataSource = _dataSourceWith((options) async {
        expect(options.path, '/users');
        return _jsonResponse([_userJson(1), _userJson(2, name: 'Ervin')]);
      });

      final users = await dataSource.getUsers();

      expect(users, [_userDto(1), _userDto(2, name: 'Ervin')]);
    });

    test('throws ParsingException when the body is not a list', () {
      final dataSource = _dataSourceWith(
        (_) async => _jsonResponse({'unexpected': 'object'}),
      );

      expect(dataSource.getUsers(), throwsA(isA<ParsingException>()));
    });

    test('throws ParsingException when a list item is malformed', () {
      final dataSource = _dataSourceWith(
        (_) async => _jsonResponse([
          _userJson(1),
          {'id': 'not-a-number', 'name': 'broken'},
        ]),
      );

      expect(dataSource.getUsers(), throwsA(isA<ParsingException>()));
    });

    test('throws ParsingException when a list item is not an object', () {
      final dataSource = _dataSourceWith(
        (_) async => _jsonResponse([_userJson(1), 42]),
      );

      expect(dataSource.getUsers(), throwsA(isA<ParsingException>()));
    });

    test('maps Dio timeouts to RequestTimeoutException', () {
      final dataSource = _dataSourceWith(
        (options) => throw DioException.connectionTimeout(
          timeout: const Duration(seconds: 1),
          requestOptions: options,
        ),
      );

      expect(dataSource.getUsers(), throwsA(isA<RequestTimeoutException>()));
    });

    test('maps HTTP 404 to NotFoundException', () {
      final dataSource = _dataSourceWith(
        (_) async => _jsonResponse({'error': 'missing'}, statusCode: 404),
      );

      expect(dataSource.getUsers(), throwsA(isA<NotFoundException>()));
    });

    test('maps HTTP 500 to ServerException with the status code', () {
      final dataSource = _dataSourceWith(
        (_) async => _jsonResponse({'error': 'boom'}, statusCode: 500),
      );

      expect(
        dataSource.getUsers(),
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

  group('UsersRemoteDataSourceImpl.getUser', () {
    test('parses a JSON object into a UserDto', () async {
      final dataSource = _dataSourceWith((options) async {
        expect(options.path, '/users/1');
        return _jsonResponse(_userJson(1));
      });

      final user = await dataSource.getUser(1);

      expect(user, _userDto(1));
    });

    test('throws ParsingException when the body is not an object', () {
      final dataSource = _dataSourceWith((_) async => _jsonResponse([1, 2]));

      expect(dataSource.getUser(1), throwsA(isA<ParsingException>()));
    });

    test('maps HTTP 404 to NotFoundException', () {
      final dataSource = _dataSourceWith(
        (_) async => _jsonResponse({}, statusCode: 404),
      );

      expect(dataSource.getUser(999), throwsA(isA<NotFoundException>()));
    });

    test('rejects non-positive IDs without performing a request', () {
      var requested = false;
      final dataSource = _dataSourceWith((_) async {
        requested = true;
        return _jsonResponse({});
      });

      expect(dataSource.getUser(0), throwsA(isA<NotFoundException>()));
      expect(dataSource.getUser(-3), throwsA(isA<NotFoundException>()));
      expect(requested, isFalse);
    });
  });
}
