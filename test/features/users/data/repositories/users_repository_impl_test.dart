import 'package:flutter_test/flutter_test.dart';
import 'package:lumina/core/error/app_exception.dart';
import 'package:lumina/core/error/app_failure.dart';
import 'package:lumina/features/users/data/datasources/users_remote_data_source.dart';
import 'package:lumina/features/users/data/dto/address_dto.dart';
import 'package:lumina/features/users/data/dto/company_dto.dart';
import 'package:lumina/features/users/data/dto/geo_dto.dart';
import 'package:lumina/features/users/data/dto/user_dto.dart';
import 'package:lumina/features/users/data/repositories/users_repository_impl.dart';
import 'package:mocktail/mocktail.dart';

class _MockUsersRemoteDataSource extends Mock
    implements UsersRemoteDataSource {}

UserDto _dto(int id, {String name = 'Leanne Graham'}) => UserDto(
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
  late _MockUsersRemoteDataSource dataSource;
  late UsersRepositoryImpl repository;

  setUp(() {
    dataSource = _MockUsersRemoteDataSource();
    repository = UsersRepositoryImpl(dataSource);
  });

  group('UsersRepositoryImpl.getUsers', () {
    test('maps DTOs to domain entities preserving order', () async {
      when(() => dataSource.getUsers()).thenAnswer(
        (_) async => [_dto(5, name: 'c'), _dto(2, name: 'a'), _dto(9)],
      );

      final users = await repository.getUsers();

      expect(users.map((user) => user.id), [5, 2, 9]);
      expect(users.first.name, 'c');
      expect(users.first.address.geo.latitude, -37.3159);
      expect(
        users.first.company.businessSummary,
        'harness real-time e-markets',
      );
    });

    test('maps NetworkException to NetworkFailure', () {
      when(() => dataSource.getUsers()).thenThrow(const NetworkException());

      expect(repository.getUsers(), throwsA(isA<NetworkFailure>()));
    });

    test('maps ParsingException to DataParsingFailure', () {
      when(() => dataSource.getUsers()).thenThrow(const ParsingException());

      expect(repository.getUsers(), throwsA(isA<DataParsingFailure>()));
    });

    test('maps ServerException to ServerFailure keeping the status code', () {
      when(
        () => dataSource.getUsers(),
      ).thenThrow(const ServerException(statusCode: 503));

      expect(
        repository.getUsers(),
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

  group('UsersRepositoryImpl.getUser', () {
    test('maps the DTO to a domain entity', () async {
      when(() => dataSource.getUser(1)).thenAnswer((_) async => _dto(1));

      final user = await repository.getUser(1);

      expect(user.id, 1);
      expect(user.name, 'Leanne Graham');
      expect(user.username, 'Bret');
      expect(user.address.city, 'Gwenborough');
      expect(user.address.geo.longitude, 81.1496);
      expect(user.company.name, 'Romaguera-Crona');
    });

    test('maps NotFoundException to NotFoundFailure', () {
      when(() => dataSource.getUser(999)).thenThrow(const NotFoundException());

      expect(repository.getUser(999), throwsA(isA<NotFoundFailure>()));
    });

    test('maps TimeoutException to TimeoutFailure', () {
      when(
        () => dataSource.getUser(1),
      ).thenThrow(const RequestTimeoutException());

      expect(repository.getUser(1), throwsA(isA<TimeoutFailure>()));
    });
  });
}
