// lib/core/network/dio_client.dart
import 'package:dio/dio.dart';
import '../errors/exceptions.dart';

class DioClient {
  late final Dio _dio;

  DioClient() {
    _dio = Dio(
      BaseOptions(
        connectTimeout: const Duration(seconds: 30),
        receiveTimeout: const Duration(seconds: 30),
        sendTimeout: const Duration(seconds: 30),
        headers: {
          'Accept': 'application/json',
          'Content-Type': 'application/json',
          'User-Agent':
              'Mozilla/5.0 (Linux; Android 11; Pixel 5) AppleWebKit/537.36 '
              '(KHTML, like Gecko) Chrome/90.0.4430.91 Mobile Safari/537.36',
        },
      ),
    );

    _dio.interceptors.addAll([
      LogInterceptor(
        requestBody: false,
        responseBody: false,
        logPrint: (obj) => null, // suppress in release, enable in debug
      ),
      _RetryInterceptor(_dio),
      _ErrorInterceptor(),
    ]);
  }

  Dio get dio => _dio;

  Future<Response> get(
    String url, {
    Map<String, dynamic>? queryParameters,
    Map<String, String>? extraHeaders,
    Options? options,
  }) async {
    final mergedOptions = options ?? Options();
    if (extraHeaders != null) {
      mergedOptions.headers = {
        ...?mergedOptions.headers,
        ...extraHeaders,
      };
    }
    return _dio.get(
      url,
      queryParameters: queryParameters,
      options: mergedOptions,
    );
  }
}

class _RetryInterceptor extends Interceptor {
  final Dio dio;
  static const int maxRetries = 3;

  _RetryInterceptor(this.dio);

  @override
  Future<void> onError(
    DioException err,
    ErrorInterceptorHandler handler,
  ) async {
    final extraData = err.requestOptions.extra;
    final retryCount = (extraData['retryCount'] as int?) ?? 0;

    final shouldRetry = retryCount < maxRetries &&
        (err.type == DioExceptionType.connectionTimeout ||
            err.type == DioExceptionType.receiveTimeout ||
            err.type == DioExceptionType.connectionError ||
            (err.response?.statusCode != null &&
                err.response!.statusCode! >= 500));

    if (!shouldRetry) {
      return handler.next(err);
    }

    final waitMs = (1 << retryCount) * 1000; // 1s, 2s, 4s
    await Future.delayed(Duration(milliseconds: waitMs));

    err.requestOptions.extra['retryCount'] = retryCount + 1;
    try {
      final response = await dio.fetch(err.requestOptions);
      return handler.resolve(response);
    } catch (e) {
      return handler.next(err);
    }
  }
}

class _ErrorInterceptor extends Interceptor {
  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    switch (err.type) {
      case DioExceptionType.connectionError:
        throw const NoInternetException();
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.receiveTimeout:
      case DioExceptionType.sendTimeout:
        throw const TimeoutException();
      case DioExceptionType.badResponse:
        final statusCode = err.response?.statusCode;
        if (statusCode == 429) {
          throw ApiRateLimitException(
            source: err.requestOptions.uri.host,
          );
        }
        throw ServerException(
          message: err.response?.statusMessage ?? 'Server error',
          statusCode: statusCode,
        );
      default:
        handler.next(err);
    }
  }
}

/// A separate Dio instance configured for NSE India that requires
/// specific browser-like headers and a session cookie workaround.
class NseDioClient {
  late final Dio _dio;

  NseDioClient() {
    _dio = Dio(
      BaseOptions(
        baseUrl: 'https://www.nseindia.com',
        connectTimeout: const Duration(seconds: 30),
        receiveTimeout: const Duration(seconds: 30),
        headers: {
          'User-Agent':
              'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 '
              '(KHTML, like Gecko) Chrome/112.0.0.0 Safari/537.36',
          'Accept':
              'text/html,application/xhtml+xml,application/xml;q=0.9,image/avif,'
              'image/webp,*/*;q=0.8',
          'Accept-Language': 'en-US,en;q=0.5',
          'Accept-Encoding': 'gzip, deflate, br',
          'Referer': 'https://www.nseindia.com/',
          'Connection': 'keep-alive',
        },
      ),
    );
    _dio.interceptors.add(_ErrorInterceptor());
  }

  Dio get dio => _dio;
}
