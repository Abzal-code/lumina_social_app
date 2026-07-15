// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'company_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_CompanyDto _$CompanyDtoFromJson(Map<String, dynamic> json) => _CompanyDto(
  name: json['name'] as String,
  catchPhrase: json['catchPhrase'] as String,
  bs: json['bs'] as String,
);

Map<String, dynamic> _$CompanyDtoToJson(_CompanyDto instance) =>
    <String, dynamic>{
      'name': instance.name,
      'catchPhrase': instance.catchPhrase,
      'bs': instance.bs,
    };
