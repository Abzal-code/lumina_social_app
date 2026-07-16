/// Application-facing failures thrown by repositories.
///
/// Presentation code decides how each case is shown to the user; failures
/// deliberately carry no display text.
sealed class AppFailure implements Exception {
  const AppFailure();
}

final class NetworkFailure extends AppFailure {
  const NetworkFailure();
}

final class TimeoutFailure extends AppFailure {
  const TimeoutFailure();
}

final class ServerFailure extends AppFailure {
  const ServerFailure({this.statusCode});

  final int? statusCode;
}

final class NotFoundFailure extends AppFailure {
  const NotFoundFailure();
}

final class DataParsingFailure extends AppFailure {
  const DataParsingFailure();
}

final class UnexpectedFailure extends AppFailure {
  const UnexpectedFailure();
}

final class ValidationFailure extends AppFailure {
  const ValidationFailure();
}
