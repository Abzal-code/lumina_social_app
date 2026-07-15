import 'package:freezed_annotation/freezed_annotation.dart';

part 'company.freezed.dart';

@freezed
abstract class Company with _$Company {
  const factory Company({
    required String name,
    required String catchPhrase,
    required String businessSummary,
  }) = _Company;
}
