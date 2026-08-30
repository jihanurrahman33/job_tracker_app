import '../../../../core/error/failures.dart';
import '../../../../core/networking/api_response.dart';
import '../../../../core/utils/either.dart';
import '../entities/application_entity.dart';
import '../entities/application_event_entity.dart';

abstract class ApplicationRepository {
  Future<Either<Failure, (List<ApplicationEntity>, PaginationMeta)>>
      getApplications({
    int page = 1,
    int limit = 20,
    String? status,
    String? search,
    String? sort,
  });

  Future<Either<Failure, ApplicationEntity>> getApplicationDetail(String id);

  Future<Either<Failure, ApplicationEntity>> createApplication({
    required String company,
    required String position,
    String? location,
    String? jobUrl,
    int? salaryMin,
    int? salaryMax,
    String? salaryCurrency,
    required String status,
    DateTime? appliedAt,
    String? notes,
  });

  Future<Either<Failure, ApplicationEntity>> updateApplication({
    required String id,
    String? company,
    String? position,
    String? location,
    String? jobUrl,
    int? salaryMin,
    int? salaryMax,
    String? salaryCurrency,
    String? status,
    DateTime? appliedAt,
    String? notes,
  });

  Future<Either<Failure, void>> deleteApplication(String id);

  Future<Either<Failure, List<ApplicationEventEntity>>> getApplicationEvents(
    String id,
  );
}
