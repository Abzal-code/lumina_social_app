import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/error/app_exception.dart';
import '../../../../core/error/failure_mapper.dart';
import '../../domain/entities/user.dart';
import '../../domain/repositories/users_repository.dart';
import '../datasources/users_remote_data_source.dart';
import '../mappers/user_mapper.dart';

class UsersRepositoryImpl implements UsersRepository {
  const UsersRepositoryImpl(this._remoteDataSource);

  final UsersRemoteDataSource _remoteDataSource;

  @override
  Future<List<User>> getUsers() async {
    try {
      final dtos = await _remoteDataSource.getUsers();
      return dtos.map(userFromDto).toList(growable: false);
    } on AppException catch (exception) {
      throw mapExceptionToFailure(exception);
    }
  }

  @override
  Future<User> getUser(int userId) async {
    try {
      final dto = await _remoteDataSource.getUser(userId);
      return userFromDto(dto);
    } on AppException catch (exception) {
      throw mapExceptionToFailure(exception);
    }
  }
}

final usersRepositoryProvider = Provider<UsersRepository>(
  (ref) => UsersRepositoryImpl(ref.watch(usersRemoteDataSourceProvider)),
);
