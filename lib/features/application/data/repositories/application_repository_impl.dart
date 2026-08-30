import '../../../../core/error/exceptions.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/networking/api_response.dart';
import '../../../../core/utils/either.dart';
import '../../domain/entities/application_entity.dart';
import '../../domain/entities/application_event_entity.dart';
import '../../domain/repositories/application_repository.dart';
import '../datasources/application_remote_data_source.dart';

class ApplicationRepositoryImpl implements ApplicationRepository {
  final ApplicationRemoteDataSource remoteDataSource;

  ApplicationRepositoryImpl({required this.remoteDataSource});

  @override
  Future<Either<Failure, (List<ApplicationEntity>, PaginationMeta)>>
      getApplications({
    int page = 1,
    int limit = 20,
    String? status,
    String? search,
    String? sort,
  }) async {
    try {
      final (apps, meta) = await remoteDataSource.getApplications(
        page: page,
        limit: limit,
        status: status,
        search: search,
        sort: sort,
      );
      return Right((apps, meta));
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
  Future<Either<Failure, ApplicationEntity>> getApplicationDetail(
      String id) async {
    try {
      final app = await remoteDataSource.getApplicationDetail(id);
      return Right(app);
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
  Future<Either<Failure, ApplicationEntity>> createApplication({
    required String company,
    required String position,
    String? location,
    String? jobUrl,
    int? salaryMin,
    int? salaryMax,
    String? salaryCurrency,
    required String status,
    DateTime? appliedAt,
    String? notes,
  }) async {
    try {
      final app = await remoteDataSource.createApplication(
        company: company,
        position: position,
        location: location,
        jobUrl: jobUrl,
        salaryMin: salaryMin,
        salaryMax: salaryMax,
        salaryCurrency: salaryCurrency,
        status: status,
        appliedAt: appliedAt,
        notes: notes,
      );
      return Right(app);
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
  Future<Either<Failure, ApplicationEntity>> updateApplication({
    required String id,
    String? company,
    String? position,
    String? location,
    String? jobUrl,
    int? salaryMin,
    int? salaryMax,
    String? salaryCurrency,
    String? status,
    DateTime? appliedAt,
    String? notes,
  }) async {
    try {
      final app = await remoteDataSource.updateApplication(
        id: id,
        company: company,
        position: position,
        location: location,
        jobUrl: jobUrl,
        salaryMin: salaryMin,
        salaryMax: salaryMax,
        salaryCurrency: salaryCurrency,
        status: status,
        appliedAt: appliedAt,
        notes: notes,
      );
      return Right(app);
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
  Future<Either<Failure, void>> deleteApplication(String id) async {
    try {
      await remoteDataSource.deleteApplication(id);
      return const Right(null);
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
  Future<Either<Failure, List<ApplicationEventEntity>>> getApplicationEvents(
    String id,
  ) async {
    try {
      final events = await remoteDataSource.getApplicationEvents(id);
      return Right(events);
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
}
