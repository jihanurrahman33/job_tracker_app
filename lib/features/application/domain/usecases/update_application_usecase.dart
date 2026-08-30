import 'package:equatable/equatable.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../../../../core/utils/either.dart';
import '../entities/application_entity.dart';
import '../repositories/application_repository.dart';

class UpdateApplicationParams extends Equatable {
  final String id;
  final String? company;
  final String? position;
  final String? location;
  final String? jobUrl;
  final int? salaryMin;
  final int? salaryMax;
  final String? salaryCurrency;
  final String? status;
  final DateTime? appliedAt;
  final String? notes;

  const UpdateApplicationParams({
    required this.id,
    this.company,
    this.position,
    this.location,
    this.jobUrl,
    this.salaryMin,
    this.salaryMax,
    this.salaryCurrency,
    this.status,
    this.appliedAt,
    this.notes,
  });

  @override
  List<Object?> get props => [
        id,
        company,
        position,
        location,
        jobUrl,
        salaryMin,
        salaryMax,
        salaryCurrency,
        status,
        appliedAt,
        notes,
      ];
}

class UpdateApplicationUseCase
    implements UseCase<ApplicationEntity, UpdateApplicationParams> {
  final ApplicationRepository repository;

  UpdateApplicationUseCase(this.repository);

  @override
  Future<Either<Failure, ApplicationEntity>> call(
    UpdateApplicationParams params,
  ) {
    return repository.updateApplication(
      id: params.id,
      company: params.company,
      position: params.position,
      location: params.location,
      jobUrl: params.jobUrl,
      salaryMin: params.salaryMin,
      salaryMax: params.salaryMax,
      salaryCurrency: params.salaryCurrency,
      status: params.status,
      appliedAt: params.appliedAt,
      notes: params.notes,
    );
  }
}
