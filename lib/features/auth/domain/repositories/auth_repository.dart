import '../../../../core/error/failures.dart';
import '../../../../core/utils/either.dart';
import '../entities/user_entity.dart';

abstract class AuthRepository {
  Future<Either<Failure, (UserEntity, String)>> login({
    required String email,
    required String password,
  });

  Future<Either<Failure, (UserEntity, String)>> register({
    required String email,
    required String password,
    required String name,
  });

  Future<Either<Failure, void>> logout();

  Future<Either<Failure, UserEntity>> getMe();

  Future<Either<Failure, String?>> getStoredToken();

  Future<Either<Failure, UserEntity?>> getStoredUser();
}
