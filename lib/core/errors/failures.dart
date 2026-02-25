// lib/core/errors/failures.dart

abstract class Failure {
  final String message;
  const Failure({required this.message});
}

class ServerFailure extends Failure {
  const ServerFailure({required super.message});
}

class NetworkFailure extends Failure {
  const NetworkFailure({required super.message});
}

class TimeoutFailure extends Failure {
  const TimeoutFailure() : super(message: 'Request timed out. Please check your connection.');
}

class RateLimitFailure extends Failure {
  final String source;
  const RateLimitFailure({required this.source})
      : super(message: 'Rate limit exceeded for $source. Switching sources...');
}

class ParseFailure extends Failure {
  const ParseFailure({required super.message});
}

class EmptyResponseFailure extends Failure {
  const EmptyResponseFailure() : super(message: 'No articles found.');
}

class CacheFailure extends Failure {
  const CacheFailure({required super.message});
}

class UnknownFailure extends Failure {
  const UnknownFailure({required super.message});
}
