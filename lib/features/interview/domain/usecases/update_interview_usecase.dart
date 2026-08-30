import 'package:equatable/equatable.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../../../../core/utils/either.dart';
import '../entities/interview_entity.dart';
import '../repositories/interview_repository.dart';

class UpdateInterviewParams extends Equatable {
  final String id;
  final String? type;
  final DateTime? scheduledAt;
  final int? durationMinutes;
  final String? location;
  final String? meetingUrl;
  final String? notes;

  const UpdateInterviewParams({
    required this.id,
    this.type,
    this.scheduledAt,
    this.durationMinutes,
    this.location,
    this.meetingUrl,
    this.notes,
  });

  @override
  List<Object?> get props => [
        id,
        type,
        scheduledAt,
        durationMinutes,
        location,
        meetingUrl,
        notes,
      ];
}

class UpdateInterviewUseCase
    implements UseCase<InterviewEntity, UpdateInterviewParams> {
  final InterviewRepository repository;

  UpdateInterviewUseCase(this.repository);

  @override
  Future<Either<Failure, InterviewEntity>> call(UpdateInterviewParams params) {
    return repository.updateInterview(
      id: params.id,
      type: params.type,
      scheduledAt: params.scheduledAt,
      durationMinutes: params.durationMinutes,
      location: params.location,
      meetingUrl: params.meetingUrl,
      notes: params.notes,
    );
  }
}
