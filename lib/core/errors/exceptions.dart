// lib/core/errors/exceptions.dart

class ServerException implements Exception {
  final String message;
  final int? statusCode;
  const ServerException({required this.message, this.statusCode});
  @override
  String toString() => 'ServerException: $message (status: $statusCode)';
}

class NoInternetException implements Exception {
  const NoInternetException();
  @override
  String toString() => 'NoInternetException: No internet connection';
}

class TimeoutException implements Exception {
  const TimeoutException();
  @override
  String toString() => 'TimeoutException: Request timed out';
}

class ApiRateLimitException implements Exception {
  final String source;
  const ApiRateLimitException({required this.source});
  @override
  String toString() => 'ApiRateLimitException: Rate limit exceeded for $source';
}

class ParseException implements Exception {
  final String message;
  const ParseException({required this.message});
  @override
  String toString() => 'ParseException: $message';
}

class EmptyResponseException implements Exception {
  const EmptyResponseException();
  @override
  String toString() => 'EmptyResponseException: API returned empty response';
}

class CacheException implements Exception {
  final String message;
  const CacheException({required this.message});
  @override
  String toString() => 'CacheException: $message';
}
