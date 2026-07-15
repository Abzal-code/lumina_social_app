// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'address_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_AddressDto _$AddressDtoFromJson(Map<String, dynamic> json) => _AddressDto(
  street: json['street'] as String,
  suite: json['suite'] as String,
  city: json['city'] as String,
  zipcode: json['zipcode'] as String,
  geo: GeoDto.fromJson(json['geo'] as Map<String, dynamic>),
);

Map<String, dynamic> _$AddressDtoToJson(_AddressDto instance) =>
    <String, dynamic>{
      'street': instance.street,
      'suite': instance.suite,
      'city': instance.city,
      'zipcode': instance.zipcode,
      'geo': instance.geo,
    };
