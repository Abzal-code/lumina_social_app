import 'package:freezed_annotation/freezed_annotation.dart';

part 'comment_dto.freezed.dart';
part 'comment_dto.g.dart';

/// Wire format of a comment as returned by JSONPlaceholder.
@freezed
abstract class CommentDto with _$CommentDto {
  const factory CommentDto({
    required int postId,
    required int id,
    required String name,
    required String email,
    required String body,
  }) = _CommentDto;

  factory CommentDto.fromJson(Map<String, dynamic> json) =>
      _$CommentDtoFromJson(json);
}
