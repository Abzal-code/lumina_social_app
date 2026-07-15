import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../app/theme/app_spacing.dart';
import '../../../core/presentation/failure_messages.dart';
import '../../../core/widgets/adaptive_content.dart';
import '../../../core/widgets/app_scaffold.dart';
import '../application/users_controller.dart';
import '../application/users_state.dart';
import '../domain/entities/user.dart';
import 'widgets/user_card.dart';
import 'widgets/users_empty_view.dart';
import 'widgets/users_loading_view.dart';
import 'widgets/users_search_field.dart';

class UsersPage extends ConsumerWidget {
  const UsersPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(usersControllerProvider);
    final controller = ref.read(usersControllerProvider.notifier);

    ref.listen<UsersState>(usersControllerProvider, (previous, next) {
      final refreshFailed =
          (previous?.isRefreshing ?? false) &&
          !next.isRefreshing &&
          next.failure != null &&
          next.users.isNotEmpty;
      if (refreshFailed) {
        ScaffoldMessenger.of(context)
          ..hideCurrentSnackBar()
          ..showSnackBar(SnackBar(content: Text(next.failure!.userMessage)));
      }
    });

    final hasInitialFailure = state.users.isEmpty && state.failure != null;
    final showSearch = !state.isInitialLoading && !hasInitialFailure;

    return AppScaffold(
      title: 'Users',
      body: AdaptiveContent(
        child: Column(
          children: [
            if (showSearch) ...[
              const SizedBox(height: AppSpacing.sm),
              UsersSearchField(
                query: state.query,
                onQueryChanged: controller.setQuery,
              ),
              const SizedBox(height: AppSpacing.md),
            ],
            Expanded(
              child: _UsersContent(state: state, controller: controller),
            ),
          ],
        ),
      ),
    );
  }
}

class _UsersContent extends StatelessWidget {
  const _UsersContent({required this.state, required this.controller});

  final UsersState state;
  final UsersController controller;

  @override
  Widget build(BuildContext context) {
    if (state.isInitialLoading) {
      return const UsersLoadingView();
    }
    if (state.users.isEmpty && state.failure != null) {
      return _UsersErrorView(
        message: state.failure!.userMessage,
        onRetry: controller.retry,
      );
    }
    return RefreshIndicator(
      onRefresh: controller.refresh,
      child: _buildScrollableContent(),
    );
  }

  Widget _buildScrollableContent() {
    if (state.users.isEmpty) {
      return _fillViewport(const UsersEmptyView.noUsers());
    }
    final visibleUsers = state.visibleUsers;
    if (visibleUsers.isEmpty) {
      return _fillViewport(
        UsersEmptyView.noResults(onClearSearch: controller.clearQuery),
      );
    }
    return LayoutBuilder(
      builder: (context, constraints) =>
          _UsersList(users: visibleUsers, maxWidth: constraints.maxWidth),
    );
  }

  Widget _fillViewport(Widget child) => CustomScrollView(
    physics: const AlwaysScrollableScrollPhysics(),
    slivers: [
      SliverFillRemaining(hasScrollBody: false, child: Center(child: child)),
    ],
  );
}

class _UsersList extends StatelessWidget {
  const _UsersList({required this.users, required this.maxWidth});

  static const double _twoColumnBreakpoint = 560;

  final List<User> users;
  final double maxWidth;

  @override
  Widget build(BuildContext context) {
    final columns = maxWidth >= _twoColumnBreakpoint ? 2 : 1;
    final rowCount = (users.length + columns - 1) ~/ columns;

    return ListView.separated(
      physics: const AlwaysScrollableScrollPhysics(),
      padding: const EdgeInsets.only(bottom: AppSpacing.lg),
      itemCount: rowCount,
      separatorBuilder: (context, index) =>
          const SizedBox(height: AppSpacing.sm),
      itemBuilder: (context, rowIndex) {
        if (columns == 1) {
          final user = users[rowIndex];
          return UserCard(key: ValueKey(user.id), user: user);
        }
        final start = rowIndex * columns;
        return Row(
          crossAxisAlignment: .start,
          children: [
            for (var column = 0; column < columns; column++) ...[
              if (column > 0) const SizedBox(width: AppSpacing.sm),
              Expanded(
                child: start + column < users.length
                    ? UserCard(
                        key: ValueKey(users[start + column].id),
                        user: users[start + column],
                      )
                    : const SizedBox.shrink(),
              ),
            ],
          ],
        );
      },
    );
  }
}

class _UsersErrorView extends StatelessWidget {
  const _UsersErrorView({required this.message, required this.onRetry});

  final String message;
  final VoidCallback onRetry;

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
            Icon(Icons.cloud_off_outlined, size: 56, color: colorScheme.error),
            const SizedBox(height: AppSpacing.md),
            Text(
              'Couldn’t load users',
              style: textTheme.titleLarge,
              textAlign: .center,
            ),
            const SizedBox(height: AppSpacing.sm),
            Text(
              message,
              style: textTheme.bodyMedium?.copyWith(
                color: colorScheme.onSurfaceVariant,
              ),
              textAlign: .center,
            ),
            const SizedBox(height: AppSpacing.lg),
            FilledButton(onPressed: onRetry, child: const Text('Retry')),
          ],
        ),
      ),
    );
  }
}
