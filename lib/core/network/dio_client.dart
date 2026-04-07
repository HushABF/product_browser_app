import 'package:dio/dio.dart';
import 'package:product_browser_app/core/errors/failures.dart';

class DioClient {
  final Dio dio = Dio(
    BaseOptions(
      baseUrl: 'https://dummyjson.com',
      connectTimeout: const Duration(seconds: 10),
      receiveTimeout: const Duration(seconds: 10),
    ),
  )..interceptors.add(LogInterceptor(
      requestBody: false,
      responseBody: false,
    ));

  static Failure handleDioException(DioException e) {
    switch (e.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.receiveTimeout:
      case DioExceptionType.sendTimeout:
        return const NetworkTimeoutFailure();
      case DioExceptionType.badResponse:
        return ServerFailure.fromStatusCode(
            e.response?.statusCode, e.response?.data);
      default:
        return NetworkFailure(e.message ?? 'An unexpected error occurred.');
    }
  }
}
