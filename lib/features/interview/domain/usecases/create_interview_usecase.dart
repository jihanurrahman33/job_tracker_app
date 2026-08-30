import 'package:equatable/equatable.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../../../../core/utils/either.dart';
import '../entities/interview_entity.dart';
import '../repositories/interview_repository.dart';

class CreateInterviewParams extends Equatable {
  final String applicationId;
  final String type;
  final DateTime scheduledAt;
  final int durationMinutes;
  final String? location;
  final String? meetingUrl;
  final String? notes;

  const CreateInterviewParams({
    required this.applicationId,
    required this.type,
    required this.scheduledAt,
    required this.durationMinutes,
    this.location,
    this.meetingUrl,
    this.notes,
  });

  @override
  List<Object?> get props => [
        applicationId,
        type,
        scheduledAt,
        durationMinutes,
        location,
        meetingUrl,
        notes,
      ];
}

class CreateInterviewUseCase
    implements UseCase<InterviewEntity, CreateInterviewParams> {
  final InterviewRepository repository;

  CreateInterviewUseCase(this.repository);

  @override
  Future<Either<Failure, InterviewEntity>> call(CreateInterviewParams params) {
    return repository.createInterview(
      applicationId: params.applicationId,
      type: params.type,
      scheduledAt: params.scheduledAt,
      durationMinutes: params.durationMinutes,
      location: params.location,
      meetingUrl: params.meetingUrl,
      notes: params.notes,
    );
  }
}
