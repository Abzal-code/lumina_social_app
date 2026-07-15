import '../../../../core/error/app_exception.dart';
import '../../domain/entities/address.dart';
import '../../domain/entities/company.dart';
import '../../domain/entities/geo_location.dart';
import '../../domain/entities/user.dart';
import '../dto/address_dto.dart';
import '../dto/company_dto.dart';
import '../dto/geo_dto.dart';
import '../dto/user_dto.dart';

User userFromDto(UserDto dto) => User(
  id: dto.id,
  name: dto.name,
  username: dto.username,
  email: dto.email,
  phone: dto.phone,
  website: dto.website,
  address: _addressFromDto(dto.address),
  company: _companyFromDto(dto.company),
);

Address _addressFromDto(AddressDto dto) => Address(
  street: dto.street,
  suite: dto.suite,
  city: dto.city,
  zipcode: dto.zipcode,
  geo: _geoFromDto(dto.geo),
);

GeoLocation _geoFromDto(GeoDto dto) => GeoLocation(
  latitude: _parseCoordinate(dto.lat, 'latitude'),
  longitude: _parseCoordinate(dto.lng, 'longitude'),
);

double _parseCoordinate(String raw, String coordinate) {
  final value = double.tryParse(raw);
  if (value == null) {
    throw ParsingException('Invalid $coordinate value: "$raw"');
  }
  return value;
}

Company _companyFromDto(CompanyDto dto) => Company(
  name: dto.name,
  catchPhrase: dto.catchPhrase,
  businessSummary: dto.bs,
);
