import '../../../../core/error/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../../../../core/utils/either.dart';
import '../entities/statistics_entity.dart';
import '../repositories/statistics_repository.dart';

class GetStatisticsUseCase implements UseCase<StatisticsEntity, NoParams> {
  final StatisticsRepository repository;

  GetStatisticsUseCase(this.repository);

  @override
  Future<Either<Failure, StatisticsEntity>> call(NoParams params) {
    return repository.getStatistics();
  }
}
