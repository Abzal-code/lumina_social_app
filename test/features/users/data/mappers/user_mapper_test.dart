import 'package:flutter_test/flutter_test.dart';
import 'package:lumina/core/error/app_exception.dart';
import 'package:lumina/features/users/data/dto/address_dto.dart';
import 'package:lumina/features/users/data/dto/company_dto.dart';
import 'package:lumina/features/users/data/dto/geo_dto.dart';
import 'package:lumina/features/users/data/dto/user_dto.dart';
import 'package:lumina/features/users/data/mappers/user_mapper.dart';
import 'package:lumina/features/users/domain/entities/address.dart';
import 'package:lumina/features/users/domain/entities/company.dart';
import 'package:lumina/features/users/domain/entities/geo_location.dart';
import 'package:lumina/features/users/domain/entities/user.dart';

UserDto _dto({String lat = '-37.3159', String lng = '81.1496'}) => UserDto(
  id: 1,
  name: 'Leanne Graham',
  username: 'Bret',
  email: 'Sincere@april.biz',
  address: AddressDto(
    street: 'Kulas Light',
    suite: 'Apt. 556',
    city: 'Gwenborough',
    zipcode: '92998-3874',
    geo: GeoDto(lat: lat, lng: lng),
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
  group('userFromDto', () {
    test('maps all nested fields to the domain entity', () {
      final user = userFromDto(_dto());

      expect(
        user,
        const User(
          id: 1,
          name: 'Leanne Graham',
          username: 'Bret',
          email: 'Sincere@april.biz',
          phone: '1-770-736-8031 x56442',
          website: 'hildegard.org',
          address: Address(
            street: 'Kulas Light',
            suite: 'Apt. 556',
            city: 'Gwenborough',
            zipcode: '92998-3874',
            geo: GeoLocation(latitude: -37.3159, longitude: 81.1496),
          ),
          company: Company(
            name: 'Romaguera-Crona',
            catchPhrase: 'Multi-layered client-server neural-net',
            businessSummary: 'harness real-time e-markets',
          ),
        ),
      );
    });

    test('converts lat/lng strings into doubles', () {
      final user = userFromDto(_dto(lat: '12.5', lng: '-0.25'));

      expect(
        user.address.geo,
        const GeoLocation(latitude: 12.5, longitude: -0.25),
      );
    });

    test('throws ParsingException for an unparseable latitude', () {
      expect(
        () => userFromDto(_dto(lat: 'north')),
        throwsA(isA<ParsingException>()),
      );
    });

    test('throws ParsingException for an unparseable longitude', () {
      expect(
        () => userFromDto(_dto(lng: '')),
        throwsA(isA<ParsingException>()),
      );
    });

    test('maps company.bs to businessSummary', () {
      final user = userFromDto(_dto());

      expect(user.company.businessSummary, 'harness real-time e-markets');
    });
  });
}
