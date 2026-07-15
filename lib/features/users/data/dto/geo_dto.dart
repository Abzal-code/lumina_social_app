import 'package:freezed_annotation/freezed_annotation.dart';

part 'geo_dto.freezed.dart';
part 'geo_dto.g.dart';

/// Wire format of geo coordinates as returned by JSONPlaceholder; both
/// values arrive as strings.
@freezed
abstract class GeoDto with _$GeoDto {
  const factory GeoDto({required String lat, required String lng}) = _GeoDto;

  factory GeoDto.fromJson(Map<String, dynamic> json) => _$GeoDtoFromJson(json);
}
