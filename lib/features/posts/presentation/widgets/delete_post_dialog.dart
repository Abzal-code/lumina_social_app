import 'package:flutter/material.dart';

/// Asks the user to confirm deleting the post named [postTitle]; resolves to
/// true only when deletion is confirmed.
Future<bool> showDeletePostDialog(
  BuildContext context, {
  required String postTitle,
}) async {
  final confirmed = await showDialog<bool>(
    context: context,
    builder: (dialogContext) => AlertDialog(
      title: const Text('Delete post?'),
      content: Text(
        '“$postTitle” will be removed. This cannot be undone.',
        maxLines: 4,
        overflow: .ellipsis,
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(dialogContext).pop(false),
          child: const Text('Cancel'),
        ),
        FilledButton(
          onPressed: () => Navigator.of(dialogContext).pop(true),
          child: const Text('Delete'),
        ),
      ],
    ),
  );
  return confirmed ?? false;
}
