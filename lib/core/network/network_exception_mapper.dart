import 'package:dio/dio.dart';

import '../error/app_exception.dart';

AppException mapDioException(DioException exception) {
  switch (exception.type) {
    case DioExceptionType.connectionTimeout:
    case DioExceptionType.sendTimeout:
    case DioExceptionType.receiveTimeout:
    case DioExceptionType.transformTimeout:
      return const RequestTimeoutException();
    case DioExceptionType.connectionError:
    case DioExceptionType.badCertificate:
      return const NetworkException();
    case DioExceptionType.badResponse:
      final statusCode = exception.response?.statusCode;
      if (statusCode == 404) {
        return const NotFoundException();
      }
      return ServerException(statusCode: statusCode);
    case DioExceptionType.cancel:
    case DioExceptionType.unknown:
      return UnexpectedException(exception.message);
  }
}
