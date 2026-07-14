# Lumina

A Flutter client for the [JSONPlaceholder](https://jsonplaceholder.typicode.com) API: browse posts, comments, and users, search and filter content, and keep local favorites.

## Status

✅ **Project foundation complete** — identifiers, dependencies, linting, theming, routing, and a placeholder home screen are in place. Feature implementation is next.

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
- Freezed + json_serializable (immutable models & DTO parsing)

## Getting started

```sh
flutter pub get
dart run build_runner build --delete-conflicting-outputs
flutter run
```
