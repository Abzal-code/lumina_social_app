import '../error/app_failure.dart';

extension AppFailureUserMessage on AppFailure {
  String get userMessage => switch (this) {
    NetworkFailure() =>
      'You appear to be offline. Check your connection and try again.',
    TimeoutFailure() => 'The request took too long. Please try again.',
    NotFoundFailure() => 'We could not find what you were looking for.',
    ServerFailure() =>
      'Something went wrong on our side. Please try again later.',
    DataParsingFailure() =>
      'We received an unexpected response. Please try again.',
    UnexpectedFailure() => 'Something unexpected happened. Please try again.',
    ValidationFailure() => 'Please fix the errors in the form.',
  };
}
