import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../error/app_exception.dart';
import 'dio_provider.dart';
import 'network_exception_mapper.dart';

/// Thin HTTP boundary: performs requests and converts every [DioException]
/// into an [AppException], so callers never handle Dio types.
class ApiClient {
  const ApiClient(this._dio);

  final Dio _dio;

  /// Returns the decoded JSON body; callers validate its shape.
  Future<Object?> get(
    String path, {
    Map<String, Object?>? queryParameters,
  }) async {
    try {
      final response = await _dio.get<Object?>(
        path,
        queryParameters: queryParameters,
      );
      return response.data;
    } on DioException catch (exception) {
      throw mapDioException(exception);
    }
  }
}

final apiClientProvider = Provider<ApiClient>(
  (ref) => ApiClient(ref.watch(dioProvider)),
);
