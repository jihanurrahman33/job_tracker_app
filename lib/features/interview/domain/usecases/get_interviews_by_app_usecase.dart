import 'package:equatable/equatable.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../../../../core/utils/either.dart';
import '../entities/interview_entity.dart';
import '../repositories/interview_repository.dart';

class GetInterviewsByAppParams extends Equatable {
  final String applicationId;
  const GetInterviewsByAppParams({required this.applicationId});

  @override
  List<Object?> get props => [applicationId];
}

class GetInterviewsByAppUseCase
    implements
        UseCase<List<InterviewEntity>, GetInterviewsByAppParams> {
  final InterviewRepository repository;

  GetInterviewsByAppUseCase(this.repository);

  @override
  Future<Either<Failure, List<InterviewEntity>>> call(
    GetInterviewsByAppParams params,
  ) {
    return repository.getInterviewsByApplication(params.applicationId);
  }
}
