import 'package:freezed_annotation/freezed_annotation.dart';

import 'address.dart';
import 'company.dart';

part 'user.freezed.dart';

@freezed
abstract class User with _$User {
  const factory User({
    required int id,
    required String name,
    required String username,
    required String email,
    required String phone,
    required String website,
    required Address address,
    required Company company,
  }) = _User;
}
