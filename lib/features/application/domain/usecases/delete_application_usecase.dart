import 'package:equatable/equatable.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../../../../core/utils/either.dart';
import '../repositories/application_repository.dart';

class DeleteApplicationParams extends Equatable {
  final String id;
  const DeleteApplicationParams({required this.id});

  @override
  List<Object?> get props => [id];
}

class DeleteApplicationUseCase
    implements UseCase<void, DeleteApplicationParams> {
  final ApplicationRepository repository;

  DeleteApplicationUseCase(this.repository);

  @override
  Future<Either<Failure, void>> call(DeleteApplicationParams params) {
    return repository.deleteApplication(params.id);
  }
}
