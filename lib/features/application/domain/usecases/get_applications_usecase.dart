import 'package:equatable/equatable.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/networking/api_response.dart';
import '../../../../core/usecases/usecase.dart';
import '../../../../core/utils/either.dart';
import '../entities/application_entity.dart';
import '../repositories/application_repository.dart';

class GetApplicationsParams extends Equatable {
  final int page;
  final int limit;
  final String? status;
  final String? search;
  final String? sort;

  const GetApplicationsParams({
    this.page = 1,
    this.limit = 20,
    this.status,
    this.search,
    this.sort,
  });

  @override
  List<Object?> get props => [page, limit, status, search, sort];
}

class GetApplicationsUseCase
    implements
        UseCase<(List<ApplicationEntity>, PaginationMeta),
            GetApplicationsParams> {
  final ApplicationRepository repository;

  GetApplicationsUseCase(this.repository);

  @override
  Future<Either<Failure, (List<ApplicationEntity>, PaginationMeta)>> call(
    GetApplicationsParams params,
  ) {
    return repository.getApplications(
      page: params.page,
      limit: params.limit,
      status: params.status,
      search: params.search,
      sort: params.sort,
    );
  }
}
