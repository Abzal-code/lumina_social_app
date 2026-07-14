import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../features/home/presentation/home_page.dart';

/// Exposes the application router so widgets and (later) other providers
/// can depend on it through Riverpod.
final appRouterProvider = Provider<GoRouter>((ref) {
  return GoRouter(
    routes: [GoRoute(path: '/', builder: (context, state) => const HomePage())],
    errorBuilder: (context, state) => const _NavigationErrorPage(),
  );
});

/// Shown when navigation fails (e.g. an unknown route).
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
                onPressed: () => context.go('/'),
                child: const Text('Go home'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
