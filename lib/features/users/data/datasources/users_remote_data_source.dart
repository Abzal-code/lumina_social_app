import '../../../../core/error/app_exception.dart';
import '../../../../core/network/api_client.dart';
import '../dto/user_dto.dart';

/// Implementations throw [AppException] subtypes on error.
abstract interface class UsersRemoteDataSource {
  Future<List<UserDto>> getUsers();

  Future<UserDto> getUser(int userId);
}

class UsersRemoteDataSourceImpl implements UsersRemoteDataSource {
  const UsersRemoteDataSourceImpl(this._client);

  final ApiClient _client;

  @override
  Future<List<UserDto>> getUsers() async {
    final data = await _client.get('/users');
    if (data is! List) {
      throw ParsingException(
        'Expected a JSON list for /users, got ${data.runtimeType}',
      );
    }
    return data.map(_parseUser).toList(growable: false);
  }

  @override
  Future<UserDto> getUser(int userId) async {
    if (userId <= 0) {
      throw NotFoundException('Invalid user id: $userId');
    }
    final data = await _client.get('/users/$userId');
    return _parseUser(data);
  }

  UserDto _parseUser(Object? element) {
    if (element is! Map) {
      throw ParsingException(
        'Expected a JSON object in /users, got ${element.runtimeType}',
      );
    }
    try {
      return UserDto.fromJson(Map<String, dynamic>.from(element));
    } on TypeError catch (error) {
      throw ParsingException('Malformed user payload: $error');
    } on FormatException catch (error) {
      throw ParsingException('Malformed user payload: ${error.message}');
    }
  }
}
