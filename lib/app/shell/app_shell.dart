import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../features/favorites/application/favorites_controller.dart';
import '../../features/favorites/application/favorites_state.dart';

class AppShell extends ConsumerWidget {
  const AppShell({super.key, required this.navigationShell});

  final StatefulNavigationShell navigationShell;

  void _onDestinationSelected(int index) {
    navigationShell.goBranch(
      index,
      // Re-selecting the active tab returns to that branch's initial location.
      initialLocation: index == navigationShell.currentIndex,
    );
  }

  void _listenForFavoriteFailures(WidgetRef ref, BuildContext context) {
    ref.listen<FavoritesState>(favoritesControllerProvider, (previous, next) {
      final toggleFailed =
          previous?.updatingPostId != null &&
          next.updatingPostId == null &&
          next.toggleFailure != null;

      if (!toggleFailed) return;

      ScaffoldMessenger.of(context)
        ..hideCurrentSnackBar()
        ..showSnackBar(
          const SnackBar(
            content: Text('Couldn’t update favorites. Please try again.'),
          ),
        );
    });
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Single app-level listener: pages on several tabs stay alive at once,
    // so per-page listeners would show duplicate SnackBars for one failure.
    _listenForFavoriteFailures(ref, context);

    return Scaffold(
      body: navigationShell,
      bottomNavigationBar: NavigationBar(
        selectedIndex: navigationShell.currentIndex,
        onDestinationSelected: _onDestinationSelected,
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.home_outlined),
            selectedIcon: Icon(Icons.home),
            label: 'Home',
          ),
          NavigationDestination(
            icon: Icon(Icons.article_outlined),
            selectedIcon: Icon(Icons.article),
            label: 'Posts',
          ),
          NavigationDestination(
            icon: Icon(Icons.people_outlined),
            selectedIcon: Icon(Icons.people),
            label: 'Users',
          ),
          NavigationDestination(
            icon: Icon(Icons.favorite_outline),
            selectedIcon: Icon(Icons.favorite),
            label: 'Favorites',
          ),
        ],
      ),
    );
  }
}
