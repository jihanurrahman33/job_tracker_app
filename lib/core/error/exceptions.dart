class ServerException implements Exception {
  final String message;
  final int? statusCode;
  final dynamic details;

  const ServerException({
    required this.message,
    this.statusCode,
    this.details,
  });

  @override
  String toString() =>
      'ServerException: $message (code: $statusCode, details: $details)';
}

class NetworkException implements Exception {
  final String message;

  const NetworkException({
    this.message =
        'Unable to connect to server. Please check your internet connection.',
  });

  @override
  String toString() => 'NetworkException: $message';
}

class CacheException implements Exception {
  final String message;

  const CacheException({
    this.message = 'Cache failure occurred.',
  });

  @override
  String toString() => 'CacheException: $message';
}

class AuthException implements Exception {
  final String message;
  final int? statusCode;

  const AuthException({
    this.message = 'Authentication failed. Please log in again.',
    this.statusCode = 401,
  });

  @override
  String toString() => 'AuthException: $message (code: $statusCode)';
}
