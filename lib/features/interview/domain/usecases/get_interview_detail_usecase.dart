import 'package:equatable/equatable.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../../../../core/utils/either.dart';
import '../entities/interview_entity.dart';
import '../repositories/interview_repository.dart';

class GetInterviewDetailParams extends Equatable {
  final String id;
  const GetInterviewDetailParams({required this.id});

  @override
  List<Object?> get props => [id];
}

class GetInterviewDetailUseCase
    implements UseCase<InterviewEntity, GetInterviewDetailParams> {
  final InterviewRepository repository;

  GetInterviewDetailUseCase(this.repository);

  @override
  Future<Either<Failure, InterviewEntity>> call(
    GetInterviewDetailParams params,
  ) {
    return repository.getInterviewDetail(params.id);
  }
}
