import 'package:equatable/equatable.dart';
import '../error/failures.dart';
import '../utils/either.dart';

/// Base contract for all single-responsibility Use Cases.
abstract class UseCase<Type, Params> {
  Future<Either<Failure, Type>> call(Params params);
}

/// Use when a UseCase does not require any parameters.
class NoParams extends Equatable {
  const NoParams();

  @override
  List<Object?> get props => [];
}

