import 'package:equatable/equatable.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../../../../core/utils/either.dart';
import '../repositories/interview_repository.dart';

class DeleteInterviewParams extends Equatable {
  final String id;
  const DeleteInterviewParams({required this.id});

  @override
  List<Object?> get props => [id];
}

class DeleteInterviewUseCase implements UseCase<void, DeleteInterviewParams> {
  final InterviewRepository repository;

  DeleteInterviewUseCase(this.repository);

  @override
  Future<Either<Failure, void>> call(DeleteInterviewParams params) {
    return repository.deleteInterview(params.id);
  }
}
