import 'package:freezed_annotation/freezed_annotation.dart';

part 'company_dto.freezed.dart';
part 'company_dto.g.dart';

/// Wire format of a user company as returned by JSONPlaceholder.
@freezed
abstract class CompanyDto with _$CompanyDto {
  const factory CompanyDto({
    required String name,
    required String catchPhrase,
    required String bs,
  }) = _CompanyDto;

  factory CompanyDto.fromJson(Map<String, dynamic> json) =>
      _$CompanyDtoFromJson(json);
}
