import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../app/router/app_routes.dart';
import '../../../app/theme/app_spacing.dart';
import '../../../core/error/app_failure.dart';
import '../../../core/presentation/failure_messages.dart';
import '../../../core/widgets/adaptive_content.dart';
import '../../../core/widgets/app_scaffold.dart';
import '../../../core/widgets/error_state_view.dart';
import '../application/post_form_controller.dart';
import '../domain/entities/post.dart';
import 'widgets/post_form_fields.dart';

/// Create form when [postId] is null, edit form otherwise.
class PostFormPage extends ConsumerWidget {
  const PostFormPage({super.key, this.postId});

  final int? postId;

  bool get _isEditing => postId != null;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return AppScaffold(
      title: _isEditing ? 'Edit post' : 'New post',
      body: AdaptiveContent(child: _buildBody(ref)),
    );
  }

  Widget _buildBody(WidgetRef ref) {
    if (!_isEditing) {
      return const _PostFormView(postId: null, initialPost: null);
    }
    final state = ref.watch(postFormControllerProvider(postId));
    final initialPost = state.initialPost;
    if (initialPost != null) {
      return _PostFormView(postId: postId, initialPost: initialPost);
    }
    if (state.isLoadingPost) {
      return const Center(child: CircularProgressIndicator());
    }
    final failure = state.loadFailure;
    if (failure is NotFoundFailure) {
      return const _PostFormUnavailableView();
    }
    return ErrorStateView(
      title: 'Couldn’t load this post',
      message: (failure ?? const UnexpectedFailure()).userMessage,
      onRetry: ref.read(postFormControllerProvider(postId).notifier).retryLoad,
    );
  }
}

class _PostFormView extends ConsumerStatefulWidget {
  const _PostFormView({required this.postId, required this.initialPost});

  final int? postId;
  final Post? initialPost;

  @override
  ConsumerState<_PostFormView> createState() => _PostFormViewState();
}

class _PostFormViewState extends ConsumerState<_PostFormView> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _titleController;
  late final TextEditingController _bodyController;
  late final TextEditingController _authorIdController;
  int? _selectedAuthorId;

  bool get _isEditing => widget.postId != null;

  @override
  void initState() {
    super.initState();
    final post = widget.initialPost;
    _titleController = TextEditingController(text: post?.title ?? '');
    _bodyController = TextEditingController(text: post?.body ?? '');
    _authorIdController = TextEditingController(
      text: post == null ? '' : '${post.authorId}',
    );
    _selectedAuthorId = post?.authorId;
  }

  @override
  void dispose() {
    _titleController.dispose();
    _bodyController.dispose();
    _authorIdController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    final authorId = _selectedAuthorId;
    if (!(_formKey.currentState?.validate() ?? false) || authorId == null) {
      return;
    }
    final controller = ref.read(
      postFormControllerProvider(widget.postId).notifier,
    );
    final post = await controller.submit(
      authorId: authorId,
      title: _titleController.text,
      body: _bodyController.text,
    );
    if (!mounted || post == null) {
      return;
    }
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(content: Text(_isEditing ? 'Post updated' : 'Post created')),
      );
    if (context.canPop()) {
      context.pop();
    } else {
      context.go(AppRoutes.posts);
    }
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(postFormControllerProvider(widget.postId));
    final isSubmitting = state.isSubmitting;
    final failure = state.submitFailure;

    return Form(
      key: _formKey,
      child: ListView(
        padding: const EdgeInsets.only(
          top: AppSpacing.md,
          bottom: AppSpacing.lg,
        ),
        children: [
          PostAuthorField(
            selectedAuthorId: _selectedAuthorId,
            fallbackController: _authorIdController,
            enabled: !isSubmitting,
            onChanged: (authorId) =>
                setState(() => _selectedAuthorId = authorId),
          ),
          const SizedBox(height: AppSpacing.md),
          PostTitleField(controller: _titleController, enabled: !isSubmitting),
          const SizedBox(height: AppSpacing.sm),
          PostBodyField(controller: _bodyController, enabled: !isSubmitting),
          if (failure != null) ...[
            const SizedBox(height: AppSpacing.sm),
            _SubmitFailureCard(
              headline: _isEditing
                  ? 'Couldn’t update post.'
                  : 'Couldn’t create post.',
              message: failure.userMessage,
            ),
          ],
          const SizedBox(height: AppSpacing.lg),
          FilledButton(
            onPressed: isSubmitting ? null : _submit,
            child: isSubmitting
                ? const SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  )
                : Text(_isEditing ? 'Save changes' : 'Create post'),
          ),
        ],
      ),
    );
  }
}

class _SubmitFailureCard extends StatelessWidget {
  const _SubmitFailureCard({required this.headline, required this.message});

  final String headline;
  final String message;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Card(
      color: colorScheme.errorContainer,
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.md),
        child: Column(
          crossAxisAlignment: .start,
          children: [
            Text(
              headline,
              style: textTheme.titleSmall?.copyWith(
                color: colorScheme.onErrorContainer,
              ),
            ),
            const SizedBox(height: AppSpacing.xs),
            Text(
              message,
              style: textTheme.bodyMedium?.copyWith(
                color: colorScheme.onErrorContainer,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _PostFormUnavailableView extends StatelessWidget {
  const _PostFormUnavailableView();

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Center(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(AppSpacing.lg),
        child: Column(
          mainAxisSize: .min,
          children: [
            Icon(
              Icons.article_outlined,
              size: 56,
              color: colorScheme.onSurfaceVariant,
            ),
            const SizedBox(height: AppSpacing.md),
            Text(
              'This post is no longer available.',
              style: textTheme.titleLarge,
              textAlign: .center,
            ),
            const SizedBox(height: AppSpacing.lg),
            FilledButton(
              onPressed: () => context.go(AppRoutes.posts),
              child: const Text('Back to posts'),
            ),
          ],
        ),
      ),
    );
  }
}

