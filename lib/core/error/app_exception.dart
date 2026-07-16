/// Infrastructure-level errors thrown by data sources and the network layer.
///
/// The `message` is diagnostic detail for logs and debugging, never for
/// direct display to users.
sealed class AppException implements Exception {
  const AppException([this.message]);

  final String? message;

  @override
  String toString() =>
      message == null ? runtimeType.toString() : '$runtimeType: $message';
}

final class NetworkException extends AppException {
  const NetworkException([super.message]);
}

final class RequestTimeoutException extends AppException {
  const RequestTimeoutException([super.message]);
}

final class ServerException extends AppException {
  const ServerException({this.statusCode, String? message}) : super(message);

  final int? statusCode;
}

final class NotFoundException extends AppException {
  const NotFoundException([super.message]);
}

final class ParsingException extends AppException {
  const ParsingException([super.message]);
}

final class UnexpectedException extends AppException {
  const UnexpectedException([super.message]);
}

final class ValidationException extends AppException {
  const ValidationException([super.message]);
}
