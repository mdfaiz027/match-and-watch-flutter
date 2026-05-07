import 'dart:async';
import 'dart:math';

import 'package:dio/dio.dart';

class ApiClient {
  late final Dio _dio;

  ApiClient() {
    _dio = Dio(
      BaseOptions(
        connectTimeout: const Duration(seconds: 5),
        receiveTimeout: const Duration(seconds: 3),
      ),
    );

    _dio.interceptors.addAll([
      FailureSimulatorInterceptor(),
      RetryInterceptor(dio: _dio),
      LogInterceptor(responseBody: true, requestBody: true),
    ]);
  }

  Dio get dio => _dio;
}

/// Interceptor that randomly fails 30% of requests to simulate a bad connection.
class FailureSimulatorInterceptor extends Interceptor {
  final _random = Random();

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    if (_random.nextDouble() < 0.3) {
      handler.reject(
        DioException(
          requestOptions: options,
          error: 'Simulated Network Failure (30% probability)',
          type: DioExceptionType.connectionError,
        ),
      );
    } else {
      super.onRequest(options, handler);
    }
  }
}

/// Interceptor that retries failed requests with exponential backoff.
class RetryInterceptor extends Interceptor {
  final Dio dio;
  final int maxRetries;

  RetryInterceptor({
    required this.dio,
    this.maxRetries = 3,
  });

  @override
  Future<void> onError(DioException err, ErrorInterceptorHandler handler) async {
    var extra = err.requestOptions.extra;
    var retryCount = extra['retryCount'] ?? 0;

    if (_shouldRetry(err) && retryCount < maxRetries) {
      retryCount++;
      extra['retryCount'] = retryCount;

      // Exponential backoff: 1s, 2s, 4s...
      final delay = Duration(seconds: pow(2, retryCount - 1).toInt());
      await Future.delayed(delay);

      try {
        final response = await dio.request(
          err.requestOptions.path,
          data: err.requestOptions.data,
          queryParameters: err.requestOptions.queryParameters,
          options: Options(
            method: err.requestOptions.method,
            headers: err.requestOptions.headers,
            extra: extra,
          ),
        );
        return handler.resolve(response);
      } on DioException catch (e) {
        return super.onError(e, handler);
      }
    }

    return super.onError(err, handler);
  }

  bool _shouldRetry(DioException err) {
    return err.type == DioExceptionType.connectionTimeout ||
        err.type == DioExceptionType.receiveTimeout ||
        err.type == DioExceptionType.connectionError ||
        (err.error?.toString().contains('Simulated Network Failure') ?? false);
  }
}
