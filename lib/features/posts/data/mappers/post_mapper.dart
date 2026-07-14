import '../../domain/entities/post.dart';
import '../dto/post_dto.dart';

Post postFromDto(PostDto dto) =>
    Post(id: dto.id, authorId: dto.userId, title: dto.title, body: dto.body);
