import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../app/router/app_routes.dart';
import '../../../../app/theme/app_spacing.dart';
import '../../../favorites/presentation/widgets/favorite_icon_button.dart';
import '../../domain/entities/post.dart';

class PostCard extends StatelessWidget {
  const PostCard({
    super.key,
    required this.post,
    this.isFavorite = false,
    this.onFavoritePressed,
    this.isFavoriteUpdating = false,
  });

  final Post post;
  final bool isFavorite;
  final VoidCallback? onFavoritePressed;
  final bool isFavoriteUpdating;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Semantics(
      button: true,
      label: 'Open post: ${post.title}',
      child: Card(
        clipBehavior: Clip.antiAlias,
        child: InkWell(
          onTap: () => context.push(AppRoutes.postDetails(post.id)),
          child: Padding(
            padding: const EdgeInsets.all(AppSpacing.md),
            child: Column(
              crossAxisAlignment: .start,
              children: [
                Row(
                  children: [
                    Icon(
                      Icons.person_outline,
                      size: 16,
                      color: colorScheme.onSurfaceVariant,
                    ),
                    const SizedBox(width: AppSpacing.xs),
                    Expanded(
                      child: Text(
                        'Author ${post.authorId}',
                        style: textTheme.labelMedium?.copyWith(
                          color: colorScheme.onSurfaceVariant,
                        ),
                        maxLines: 1,
                        overflow: .ellipsis,
                      ),
                    ),
                    FavoriteIconButton(
                      postTitle: post.title,
                      isFavorite: isFavorite,
                      onPressed: isFavoriteUpdating ? null : onFavoritePressed,
                    ),
                  ],
                ),
                const SizedBox(height: AppSpacing.sm),
                Text(
                  post.title,
                  style: textTheme.titleMedium,
                  maxLines: 2,
                  overflow: .ellipsis,
                ),
                const SizedBox(height: AppSpacing.xs),
                Text(
                  post.body,
                  style: textTheme.bodyMedium?.copyWith(
                    color: colorScheme.onSurfaceVariant,
                  ),
                  maxLines: 3,
                  overflow: .ellipsis,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
