import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../core/error/app_failure.dart';
import '../domain/entities/user.dart';

part 'users_state.freezed.dart';

@freezed
abstract class UsersState with _$UsersState {
  const UsersState._();

  const factory UsersState({
    @Default(<User>[]) List<User> users,
    @Default('') String query,
    @Default(false) bool isInitialLoading,
    @Default(false) bool isRefreshing,
    AppFailure? failure,
  }) = _UsersState;

  /// [users] filtered by the trimmed, case-insensitive [query] across name,
  /// username, email, and company name; original order is preserved.
  List<User> get visibleUsers {
    final normalizedQuery = query.trim().toLowerCase();
    if (normalizedQuery.isEmpty) {
      return users;
    }
    return users
        .where(
          (user) =>
              user.name.toLowerCase().contains(normalizedQuery) ||
              user.username.toLowerCase().contains(normalizedQuery) ||
              user.email.toLowerCase().contains(normalizedQuery) ||
              user.company.name.toLowerCase().contains(normalizedQuery),
        )
        .toList(growable: false);
  }
}
