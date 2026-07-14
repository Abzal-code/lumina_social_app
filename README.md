# Lumina

A Flutter client for the [JSONPlaceholder](https://jsonplaceholder.typicode.com) API: browse posts, comments, and users, search and filter content, and keep local favorites.

## Current status

The application foundation, design system, and navigation shell are implemented: centralized design tokens, reusable layout widgets, and four-tab bottom navigation (Home, Posts, Users, Favorites).

The posts domain and data layers are also in place: a Dio-based API client, DTO-to-entity mapping (`PostDto` → `Post`), and typed exception-to-failure mapping so repositories surface `AppFailure` values instead of raw transport errors. UI integration for posts is next.

## Planned features

- Posts list with search/filtering and pull-to-refresh
- Post details with comments
- Users list and user profile with their posts
- At least one create/edit/delete operation
- Local favorites (persisted with SharedPreferences)
- Loading, empty, and error states with retry

## Tech stack

- **Flutter** 3.44.0 (stable) / **Dart** 3.12.0
- Riverpod (state management & DI), Dio (networking), go_router (navigation)
- go_router `StatefulShellRoute.indexedStack` for state-preserving bottom-tab navigation
- Centralized design tokens (colors, spacing, radius, typography) feeding a single Material 3 theme
- Freezed + json_serializable (immutable models & DTO parsing)

## Getting started

```sh
flutter pub get
dart run build_runner build --delete-conflicting-outputs
flutter run
```
