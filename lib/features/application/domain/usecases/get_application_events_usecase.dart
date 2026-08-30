import 'package:equatable/equatable.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../../../../core/utils/either.dart';
import '../entities/application_event_entity.dart';
import '../repositories/application_repository.dart';

class GetApplicationEventsParams extends Equatable {
  final String id;
  const GetApplicationEventsParams({required this.id});

  @override
  List<Object?> get props => [id];
}

class GetApplicationEventsUseCase
    implements
        UseCase<List<ApplicationEventEntity>, GetApplicationEventsParams> {
  final ApplicationRepository repository;

  GetApplicationEventsUseCase(this.repository);

  @override
  Future<Either<Failure, List<ApplicationEventEntity>>> call(
    GetApplicationEventsParams params,
  ) {
    return repository.getApplicationEvents(params.id);
  }
}
