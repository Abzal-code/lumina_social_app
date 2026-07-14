import '../../domain/entities/comment.dart';
import '../dto/comment_dto.dart';

Comment commentFromDto(CommentDto dto) => Comment(
  id: dto.id,
  postId: dto.postId,
  name: dto.name,
  email: dto.email,
  body: dto.body,
);
