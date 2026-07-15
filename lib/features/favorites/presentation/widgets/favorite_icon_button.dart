import 'package:flutter/material.dart';

class FavoriteIconButton extends StatelessWidget {
  const FavoriteIconButton({
    super.key,
    required this.postTitle,
    required this.isFavorite,
    required this.onPressed,
  });

  final String postTitle;
  final bool isFavorite;
  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    return IconButton(
      tooltip: isFavorite
          ? 'Remove $postTitle from favorites'
          : 'Add $postTitle to favorites',
      onPressed: onPressed,
      icon: Icon(isFavorite ? Icons.bookmark : Icons.bookmark_outline),
    );
  }
}
