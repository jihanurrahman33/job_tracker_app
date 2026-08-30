import '../../../../core/error/failures.dart';
import '../../../../core/utils/either.dart';
import '../entities/interview_entity.dart';

abstract class InterviewRepository {
  Future<Either<Failure, List<InterviewEntity>>> getInterviewsByApplication(
    String applicationId,
  );

  Future<Either<Failure, InterviewEntity>> getInterviewDetail(String id);

  Future<Either<Failure, InterviewEntity>> createInterview({
    required String applicationId,
    required String type,
    required DateTime scheduledAt,
    required int durationMinutes,
    String? location,
    String? meetingUrl,
    String? notes,
  });

  Future<Either<Failure, InterviewEntity>> updateInterview({
    required String id,
    String? type,
    DateTime? scheduledAt,
    int? durationMinutes,
    String? location,
    String? meetingUrl,
    String? notes,
  });

  Future<Either<Failure, void>> deleteInterview(String id);
}
