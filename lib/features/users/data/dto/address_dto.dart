import 'package:freezed_annotation/freezed_annotation.dart';

import 'geo_dto.dart';

part 'address_dto.freezed.dart';
part 'address_dto.g.dart';

/// Wire format of a user address as returned by JSONPlaceholder.
@freezed
abstract class AddressDto with _$AddressDto {
  const factory AddressDto({
    required String street,
    required String suite,
    required String city,
    required String zipcode,
    required GeoDto geo,
  }) = _AddressDto;

  factory AddressDto.fromJson(Map<String, dynamic> json) =>
      _$AddressDtoFromJson(json);
}
