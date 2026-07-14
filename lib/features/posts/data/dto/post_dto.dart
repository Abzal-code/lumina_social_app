import 'package:freezed_annotation/freezed_annotation.dart';

part 'post_dto.freezed.dart';
part 'post_dto.g.dart';

/// Wire format of a post as returned by JSONPlaceholder.
@freezed
abstract class PostDto with _$PostDto {
  const factory PostDto({
    required int userId,
    required int id,
    required String title,
    required String body,
  }) = _PostDto;

  factory PostDto.fromJson(Map<String, dynamic> json) =>
      _$PostDtoFromJson(json);
}
