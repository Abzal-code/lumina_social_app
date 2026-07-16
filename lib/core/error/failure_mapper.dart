import 'app_exception.dart';
import 'app_failure.dart';

AppFailure mapExceptionToFailure(AppException exception) => switch (exception) {
  NetworkException() => const NetworkFailure(),
  RequestTimeoutException() => const TimeoutFailure(),
  ServerException(:final statusCode) => ServerFailure(statusCode: statusCode),
  NotFoundException() => const NotFoundFailure(),
  ParsingException() => const DataParsingFailure(),
  UnexpectedException() => const UnexpectedFailure(),
  ValidationException() => const ValidationFailure(),
};
