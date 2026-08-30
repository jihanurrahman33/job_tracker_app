import 'package:equatable/equatable.dart';

abstract class Failure extends Equatable {
  final String message;
  final int? code;
  final dynamic details;

  const Failure({
    required this.message,
    this.code,
    this.details,
  });

  @override
  List<Object?> get props => [message, code, details];
}

class ServerFailure extends Failure {
  const ServerFailure({
    required super.message,
    super.code,
    super.details,
  });
}

class NetworkFailure extends Failure {
  const NetworkFailure({
    super.message = 'Please check your internet connection and try again.',
    super.code,
    super.details,
  });
}

class CacheFailure extends Failure {
  const CacheFailure({
    super.message = 'Failed to read or write local data.',
    super.code,
    super.details,
  });
}

class ValidationFailure extends Failure {
  const ValidationFailure({
    required super.message,
    super.code,
    super.details,
  });
}

class AuthFailure extends Failure {
  const AuthFailure({
    super.message = 'Authentication failed. Please sign in.',
    super.code = 401,
    super.details,
  });
}

class UnknownFailure extends Failure {
  const UnknownFailure({
    super.message = 'An unexpected error occurred. Please try again.',
    super.code,
    super.details,
  });
}
