import '../../../../core/error/exceptions.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/networking/api_client.dart';
import '../../../../core/utils/either.dart';
import '../../domain/entities/user_entity.dart';
import '../../domain/repositories/auth_repository.dart';
import '../datasources/auth_local_data_source.dart';
import '../datasources/auth_remote_data_source.dart';

class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteDataSource remoteDataSource;
  final AuthLocalDataSource localDataSource;
  final ApiClient apiClient;

  AuthRepositoryImpl({
    required this.remoteDataSource,
    required this.localDataSource,
    required this.apiClient,
  });

  @override
  Future<Either<Failure, (UserEntity, String)>> login({
    required String email,
    required String password,
  }) async {
    try {
      final (user, token) = await remoteDataSource.login(
        email: email,
        password: password,
      );

      await localDataSource.saveAuthToken(token);
      await localDataSource.saveUser(user);
      apiClient.setAuthToken(token);

      return Right((user, token));
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message, code: e.statusCode));
    } on NetworkException catch (e) {
      return Left(NetworkFailure(message: e.message));
    } on AuthException catch (e) {
      return Left(AuthFailure(message: e.message, code: e.statusCode));
    } catch (e) {
      return Left(UnknownFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, (UserEntity, String)>> register({
    required String email,
    required String password,
    required String name,
  }) async {
    try {
      final (user, token) = await remoteDataSource.register(
        email: email,
        password: password,
        name: name,
      );

      await localDataSource.saveAuthToken(token);
      await localDataSource.saveUser(user);
      apiClient.setAuthToken(token);

      return Right((user, token));
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message, code: e.statusCode));
    } on NetworkException catch (e) {
      return Left(NetworkFailure(message: e.message));
    } on AuthException catch (e) {
      return Left(AuthFailure(message: e.message, code: e.statusCode));
    } catch (e) {
      return Left(UnknownFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> logout() async {
    try {
      await remoteDataSource.logout();
      await localDataSource.clearAuthSession();
      apiClient.setAuthToken(null);
      return const Right(null);
    } catch (e) {
      await localDataSource.clearAuthSession();
      apiClient.setAuthToken(null);
      return const Right(null);
    }
  }

  @override
  Future<Either<Failure, UserEntity>> getMe() async {
    try {
      final user = await remoteDataSource.getMe();
      await localDataSource.saveUser(user);
      return Right(user);
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message, code: e.statusCode));
    } on NetworkException catch (e) {
      return Left(NetworkFailure(message: e.message));
    } on AuthException catch (e) {
      return Left(AuthFailure(message: e.message, code: e.statusCode));
    } catch (e) {
      return Left(UnknownFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, String?>> getStoredToken() async {
    try {
      final token = await localDataSource.getAuthToken();
      if (token != null && token.isNotEmpty) {
        apiClient.setAuthToken(token);
      }
      return Right(token);
    } catch (e) {
      return Left(CacheFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, UserEntity?>> getStoredUser() async {
    try {
      final user = await localDataSource.getUser();
      return Right(user);
    } catch (e) {
      return Left(CacheFailure(message: e.toString()));
    }
  }
}
