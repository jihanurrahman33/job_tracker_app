import 'package:equatable/equatable.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../../../../core/utils/either.dart';
import '../entities/application_entity.dart';
import '../repositories/application_repository.dart';

class CreateApplicationParams extends Equatable {
  final String company;
  final String position;
  final String? location;
  final String? jobUrl;
  final int? salaryMin;
  final int? salaryMax;
  final String? salaryCurrency;
  final String status;
  final DateTime? appliedAt;
  final String? notes;

  const CreateApplicationParams({
    required this.company,
    required this.position,
    this.location,
    this.jobUrl,
    this.salaryMin,
    this.salaryMax,
    this.salaryCurrency,
    required this.status,
    this.appliedAt,
    this.notes,
  });

  @override
  List<Object?> get props => [
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

class CreateApplicationUseCase
    implements UseCase<ApplicationEntity, CreateApplicationParams> {
  final ApplicationRepository repository;

  CreateApplicationUseCase(this.repository);

  @override
  Future<Either<Failure, ApplicationEntity>> call(
    CreateApplicationParams params,
  ) {
    return repository.createApplication(
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
