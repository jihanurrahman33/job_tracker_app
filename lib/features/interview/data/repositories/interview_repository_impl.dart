import '../../../../core/error/exceptions.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/utils/either.dart';
import '../../domain/entities/interview_entity.dart';
import '../../domain/repositories/interview_repository.dart';
import '../datasources/interview_remote_data_source.dart';

class InterviewRepositoryImpl implements InterviewRepository {
  final InterviewRemoteDataSource remoteDataSource;

  InterviewRepositoryImpl({required this.remoteDataSource});

  @override
  Future<Either<Failure, List<InterviewEntity>>> getInterviewsByApplication(
      String applicationId) async {
    try {
      final interviews =
          await remoteDataSource.getInterviewsByApplication(applicationId);
      return Right(interviews);
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
  Future<Either<Failure, InterviewEntity>> getInterviewDetail(String id) async {
    try {
      final interview = await remoteDataSource.getInterviewDetail(id);
      return Right(interview);
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
  Future<Either<Failure, InterviewEntity>> createInterview({
    required String applicationId,
    required String type,
    required DateTime scheduledAt,
    required int durationMinutes,
    String? location,
    String? meetingUrl,
    String? notes,
  }) async {
    try {
      final interview = await remoteDataSource.createInterview(
        applicationId: applicationId,
        type: type,
        scheduledAt: scheduledAt,
        durationMinutes: durationMinutes,
        location: location,
        meetingUrl: meetingUrl,
        notes: notes,
      );
      return Right(interview);
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
  Future<Either<Failure, InterviewEntity>> updateInterview({
    required String id,
    String? type,
    DateTime? scheduledAt,
    int? durationMinutes,
    String? location,
    String? meetingUrl,
    String? notes,
  }) async {
    try {
      final interview = await remoteDataSource.updateInterview(
        id: id,
        type: type,
        scheduledAt: scheduledAt,
        durationMinutes: durationMinutes,
        location: location,
        meetingUrl: meetingUrl,
        notes: notes,
      );
      return Right(interview);
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
  Future<Either<Failure, void>> deleteInterview(String id) async {
    try {
      await remoteDataSource.deleteInterview(id);
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
}
