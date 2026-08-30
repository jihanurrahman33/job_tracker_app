abstract class AppException implements Exception {
  final String message;
  const AppException({required this.message});

  @override
  String toString() => message;
}

class ServerException extends AppException {
  final int? statusCode;
  final dynamic details;

  const ServerException({
    required super.message,
    this.statusCode,
    this.details,
  });

  @override
  String toString() =>
      'ServerException: $message (code: $statusCode, details: $details)';
}

class NetworkException extends AppException {
  const NetworkException({
    super.message =
        'Unable to connect to server. Please check your internet connection.',
  });

  @override
  String toString() => 'NetworkException: $message';
}

class CacheException extends AppException {
  const CacheException({
    super.message = 'Cache failure occurred.',
  });

  @override
  String toString() => 'CacheException: $message';
}

class AuthException extends AppException {
  final int? statusCode;

  const AuthException({
    super.message = 'Authentication failed. Please log in again.',
    this.statusCode = 401,
  });

  @override
  String toString() => 'AuthException: $message (code: $statusCode)';
}
