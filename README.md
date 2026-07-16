# Lumina

A Flutter client for the [JSONPlaceholder](https://jsonplaceholder.typicode.com) API: browse posts, comments, and users, search and filter content, create, edit, and delete posts, and keep local favorites.

## Current status

The application foundation, design system, and navigation shell are implemented: centralized design tokens, reusable layout widgets, and four-tab bottom navigation (Home, Posts, Users, Favorites).

The posts domain and data layers are in place: a Dio-based API client, DTO-to-entity mapping (`PostDto` → `Post`), and typed exception-to-failure mapping so repositories surface `AppFailure` values instead of raw transport errors.

The Posts tab shows the live publications list with local case-insensitive title/body search, pull-to-refresh, and distinct loading, empty, and error states with retry.

Each post opens a deep-link-compatible details route (`/posts/:id`) with the full text and its comments, which load independently with their own loading, empty, error/retry, and pull-to-refresh states.

The Users tab lists all authors with local search across name, username, email, and company, plus pull-to-refresh and dedicated loading, empty, and error states. Each user opens a deep-link-compatible profile route (`/users/:id`) with contact and company details and the user's publications, which load independently with their own loading, empty, error/retry, and pull-to-refresh states.

Posts can be bookmarked as favorites from the posts list, post details, and user profiles. Favorite post IDs are persisted with SharedPreferences and restored on startup; favorite state lives separately from `Post` entities and is derived by post ID, so toggling a bookmark updates every screen at once without refetching content. The Favorites tab shows the bookmarked posts in ascending post ID order, reusing already loaded posts and fetching the rest individually.

Posts can be created from the Posts tab, and edited or deleted from their details page. Forms validate input inline, show submission progress, keep entered text on failure, and report success with product-level feedback. Deletion asks for confirmation and removes the post from every list, including Favorites.

## Mutations and the local overlay

JSONPlaceholder accepts `POST`, `PATCH`, and `DELETE` requests and answers them successfully, but never persists changes — every subsequent read returns the original data. To make mutations durable on the device, the app keeps a local overlay in SharedPreferences and merges it over every remote read:

- **Created posts** are sent to the server first, then stored locally with negative IDs allocated from a persisted counter (`-1`, `-2`, …), so they can never collide with server-assigned IDs. The ID echoed by the server is ignored because it is not unique across requests. Created posts survive app restarts.
- **Edited posts** are patched remotely first (skipped for locally created posts, which the server does not know), then the final version is stored locally: edits to created posts replace the stored original, edits to remote posts are kept in an updates map keyed by post ID.
- **Deleted posts** are deleted remotely first (again skipped for locally created posts, which are simply removed), then the ID is recorded so reads suppress the post.

Merge order for every read: locally created posts (newest first), followed by the remote list in its original order with deleted posts removed and edited posts replaced in place. Refreshing any screen re-applies the overlay, so local changes never disappear behind a pull-to-refresh. Single-post reads resolve created, edited, and deleted IDs from the overlay before touching the network.

Storage corruption is handled conservatively: individually malformed entries are skipped and cleaned up by the next write, unreadable top-level values surface a typed parsing failure, and the negative-ID counter is re-derived below the lowest stored ID if it is missing or corrupted.

Known limitation: if the remote call succeeds but local persistence then fails, the app reports the failure and does not pretend the mutation succeeded; there is no rollback of the (non-persistent) remote call.

## Deletion and favorites

Deleting a post also removes its bookmark, coordinated at the application layer — the posts repository knows nothing about favorites. If removing the bookmark fails, the deletion itself stands and the favorites failure is reported through the standard favorites feedback. Editing a post preserves its favorite status, and new posts start unbookmarked. Locally created posts cannot be bookmarked, since favorite storage validates server-assigned IDs.

## Architecture notes

- State synchronization after a mutation is push-based: active controllers are patched in place (posts list, open details, favorites feed cache) so screens update without refetch flicker and the search query survives, while user profiles are invalidated and re-read through the overlay because an edit can move a post between authors.
- Author selection in the post form uses the loaded users list; if it cannot be loaded, the form falls back to a validated numeric author ID field rather than blocking submission.
- Remote and local persistence stay in separate data sources behind a single repository; no DTOs or storage types leak past it.

## Tech stack

- **Flutter** 3.44.0 (stable) / **Dart** 3.12.0
- Riverpod (state management & DI), Dio (networking), go_router (navigation)
- go_router `StatefulShellRoute.indexedStack` for state-preserving bottom-tab navigation
- Centralized design tokens (colors, spacing, radius, typography) feeding a single Material 3 theme
- Freezed + json_serializable (immutable models & DTO parsing)
- SharedPreferences (local persistence of favorite post IDs and the post overlay)

## Getting started

```sh
flutter pub get
dart run build_runner build --delete-conflicting-outputs
flutter run
```
