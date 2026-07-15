import 'package:freezed_annotation/freezed_annotation.dart';

import 'geo_location.dart';

part 'address.freezed.dart';

@freezed
abstract class Address with _$Address {
  const factory Address({
    required String street,
    required String suite,
    required String city,
    required String zipcode,
    required GeoLocation geo,
  }) = _Address;
}
