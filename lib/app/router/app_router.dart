import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../features/favorites/presentation/favorites_page.dart';
import '../../features/home/presentation/home_page.dart';
import '../../features/posts/presentation/post_details_page.dart';
import '../../features/posts/presentation/posts_page.dart';
import '../../features/users/presentation/users_page.dart';
import '../shell/app_shell.dart';
import 'app_routes.dart';

final appRouterProvider = Provider<GoRouter>((ref) {
  return GoRouter(
    initialLocation: AppRoutes.home,
    routes: [
      StatefulShellRoute.indexedStack(
        builder: (context, state, navigationShell) =>
            AppShell(navigationShell: navigationShell),
        branches: [
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: AppRoutes.home,
                builder: (context, state) => const HomePage(),
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: AppRoutes.posts,
                builder: (context, state) => const PostsPage(),
                routes: [
                  GoRoute(
                    path: AppRoutes.postDetailsSegment,
                    builder: (context, state) {
                      final postId = int.tryParse(
                        state.pathParameters['postId'] ?? '',
                      );
                      if (postId == null || postId <= 0) {
                        return const PostUnavailablePage();
                      }
                      return PostDetailsPage(postId: postId);
                    },
                  ),
                ],
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: AppRoutes.users,
                builder: (context, state) => const UsersPage(),
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: AppRoutes.favorites,
                builder: (context, state) => const FavoritesPage(),
              ),
            ],
          ),
        ],
      ),
    ],
    errorBuilder: (context, state) => const _NavigationErrorPage(),
  );
});

class _NavigationErrorPage extends StatelessWidget {
  const _NavigationErrorPage();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Page not found')),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisAlignment: .center,
            children: [
              const Icon(Icons.explore_off_outlined, size: 64),
              const SizedBox(height: 16),
              const Text(
                'The page you are looking for does not exist.',
                textAlign: .center,
              ),
              const SizedBox(height: 16),
              FilledButton(
                onPressed: () => context.go(AppRoutes.home),
                child: const Text('Go home'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
