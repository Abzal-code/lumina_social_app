// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_UserDto _$UserDtoFromJson(Map<String, dynamic> json) => _UserDto(
  id: (json['id'] as num).toInt(),
  name: json['name'] as String,
  username: json['username'] as String,
  email: json['email'] as String,
  address: AddressDto.fromJson(json['address'] as Map<String, dynamic>),
  phone: json['phone'] as String,
  website: json['website'] as String,
  company: CompanyDto.fromJson(json['company'] as Map<String, dynamic>),
);

Map<String, dynamic> _$UserDtoToJson(_UserDto instance) => <String, dynamic>{
  'id': instance.id,
  'name': instance.name,
  'username': instance.username,
  'email': instance.email,
  'address': instance.address,
  'phone': instance.phone,
  'website': instance.website,
  'company': instance.company,
};
