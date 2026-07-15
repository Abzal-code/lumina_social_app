# Lumina

A Flutter client for the [JSONPlaceholder](https://jsonplaceholder.typicode.com) API: browse posts, comments, and users, search and filter content, and keep local favorites.

## Current status

The application foundation, design system, and navigation shell are implemented: centralized design tokens, reusable layout widgets, and four-tab bottom navigation (Home, Posts, Users, Favorites).

The posts domain and data layers are in place: a Dio-based API client, DTO-to-entity mapping (`PostDto` → `Post`), and typed exception-to-failure mapping so repositories surface `AppFailure` values instead of raw transport errors.

The Posts tab shows the live publications list with local case-insensitive title/body search, pull-to-refresh, and distinct loading, empty, and error states with retry.

Each post opens a deep-link-compatible details route (`/posts/:id`) with the full text and its comments, which load independently with their own loading, empty, error/retry, and pull-to-refresh states.

The Users tab lists all authors with local search across name, username, email, and company, plus pull-to-refresh and dedicated loading, empty, and error states. Each user opens a deep-link-compatible profile route (`/users/:id`) with contact and company details and the user's publications, which load independently with their own loading, empty, error/retry, and pull-to-refresh states.

Posts can be bookmarked as favorites from the posts list, post details, and user profiles. Favorite post IDs are persisted with SharedPreferences and restored on startup; favorite state lives separately from `Post` entities and is derived by post ID, so toggling a bookmark updates every screen at once without refetching content. The Favorites tab shows the bookmarked posts in ascending post ID order, reusing already loaded posts and fetching the rest individually.

## Upcoming

- At least one create/edit/delete operation

## Tech stack

- **Flutter** 3.44.0 (stable) / **Dart** 3.12.0
- Riverpod (state management & DI), Dio (networking), go_router (navigation)
- go_router `StatefulShellRoute.indexedStack` for state-preserving bottom-tab navigation
- Centralized design tokens (colors, spacing, radius, typography) feeding a single Material 3 theme
- Freezed + json_serializable (immutable models & DTO parsing)
- SharedPreferences (local persistence of favorite post IDs)

## Getting started

```sh
flutter pub get
dart run build_runner build --delete-conflicting-outputs
flutter run
```
