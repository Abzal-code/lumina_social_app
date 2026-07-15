import 'package:freezed_annotation/freezed_annotation.dart';

import 'address_dto.dart';
import 'company_dto.dart';

part 'user_dto.freezed.dart';
part 'user_dto.g.dart';

/// Wire format of a user as returned by JSONPlaceholder.
@freezed
abstract class UserDto with _$UserDto {
  const factory UserDto({
    required int id,
    required String name,
    required String username,
    required String email,
    required AddressDto address,
    required String phone,
    required String website,
    required CompanyDto company,
  }) = _UserDto;

  factory UserDto.fromJson(Map<String, dynamic> json) =>
      _$UserDtoFromJson(json);
}
