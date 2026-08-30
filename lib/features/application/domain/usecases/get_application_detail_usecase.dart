import 'package:equatable/equatable.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../../../../core/utils/either.dart';
import '../entities/application_entity.dart';
import '../repositories/application_repository.dart';

class GetApplicationDetailParams extends Equatable {
  final String id;
  const GetApplicationDetailParams({required this.id});

  @override
  List<Object?> get props => [id];
}

class GetApplicationDetailUseCase
    implements UseCase<ApplicationEntity, GetApplicationDetailParams> {
  final ApplicationRepository repository;

  GetApplicationDetailUseCase(this.repository);

  @override
  Future<Either<Failure, ApplicationEntity>> call(
    GetApplicationDetailParams params,
  ) {
    return repository.getApplicationDetail(params.id);
  }
}
