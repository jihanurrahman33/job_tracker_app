import '../../../../core/error/failures.dart';
import '../../../../core/utils/either.dart';
import '../entities/statistics_entity.dart';

abstract class StatisticsRepository {
  Future<Either<Failure, StatisticsEntity>> getStatistics();
}
