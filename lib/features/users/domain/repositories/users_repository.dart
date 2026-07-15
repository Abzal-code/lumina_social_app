import '../entities/user.dart';

/// Implementations throw [AppFailure] subtypes on error; they never expose
/// infrastructure exceptions.
abstract interface class UsersRepository {
  Future<List<User>> getUsers();

  Future<User> getUser(int userId);
}
