import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../users/application/users_controller.dart';

const int postTitleMaxLength = 120;
const int postBodyMaxLength = 5000;

class PostTitleField extends StatelessWidget {
  const PostTitleField({super.key, required this.controller, this.enabled});

  final TextEditingController controller;
  final bool? enabled;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      enabled: enabled,
      maxLength: postTitleMaxLength,
      textInputAction: .next,
      decoration: const InputDecoration(
        labelText: 'Title',
        border: OutlineInputBorder(),
      ),
      validator: (value) {
        if (value == null || value.trim().isEmpty) {
          return 'Enter a title.';
        }
        return null;
      },
    );
  }
}

class PostBodyField extends StatelessWidget {
  const PostBodyField({super.key, required this.controller, this.enabled});

  final TextEditingController controller;
  final bool? enabled;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      enabled: enabled,
      maxLength: postBodyMaxLength,
      minLines: 5,
      maxLines: 12,
      decoration: const InputDecoration(
        labelText: 'Text',
        alignLabelWithHint: true,
        border: OutlineInputBorder(),
      ),
      validator: (value) {
        if (value == null || value.trim().isEmpty) {
          return 'Enter the post text.';
        }
        return null;
      },
    );
  }
}

/// Author selection backed by the loaded users list; while users are loading
/// the field is disabled, and if they cannot be loaded it falls back to a
/// validated numeric author ID input so the form never blocks on the list.
class PostAuthorField extends ConsumerWidget {
  const PostAuthorField({
    super.key,
    required this.selectedAuthorId,
    required this.fallbackController,
    required this.onChanged,
    this.enabled = true,
  });

  final int? selectedAuthorId;
  final TextEditingController fallbackController;
  final ValueChanged<int?> onChanged;
  final bool enabled;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final usersState = ref.watch(usersControllerProvider);

    if (usersState.users.isNotEmpty) {
      final knownIds = {for (final user in usersState.users) user.id};
      return DropdownButtonFormField<int>(
        key: const ValueKey('post_author_options'),
        initialValue: knownIds.contains(selectedAuthorId)
            ? selectedAuthorId
            : null,
        items: [
          for (final user in usersState.users)
            DropdownMenuItem(value: user.id, child: Text(user.name)),
        ],
        onChanged: enabled ? onChanged : null,
        decoration: const InputDecoration(
          labelText: 'Author',
          border: OutlineInputBorder(),
        ),
        validator: (value) => value == null ? 'Select an author.' : null,
      );
    }

    if (usersState.isInitialLoading) {
      return DropdownButtonFormField<int>(
        key: const ValueKey('post_author_loading'),
        items: const [],
        onChanged: null,
        hint: const Text('Loading authors…'),
        decoration: const InputDecoration(
          labelText: 'Author',
          border: OutlineInputBorder(),
        ),
        validator: (value) => 'Select an author.',
      );
    }

    return TextFormField(
      key: const ValueKey('post_author_id'),
      controller: fallbackController,
      enabled: enabled,
      keyboardType: TextInputType.number,
      decoration: const InputDecoration(
        labelText: 'Author ID',
        helperText: 'The authors list is unavailable; enter the ID directly.',
        border: OutlineInputBorder(),
      ),
      validator: (value) {
        final authorId = int.tryParse(value?.trim() ?? '');
        if (authorId == null || authorId <= 0) {
          return 'Enter a valid author ID.';
        }
        return null;
      },
      onChanged: (value) => onChanged(int.tryParse(value.trim())),
    );
  }
}
