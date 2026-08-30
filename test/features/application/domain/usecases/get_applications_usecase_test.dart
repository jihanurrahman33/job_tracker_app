import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:job_tracker/core/networking/api_response.dart';
import 'package:job_tracker/core/utils/either.dart';
import 'package:job_tracker/features/application/domain/entities/application_entity.dart';
import 'package:job_tracker/features/application/domain/repositories/application_repository.dart';
import 'package:job_tracker/features/application/domain/usecases/get_applications_usecase.dart';

class MockApplicationRepository extends Mock implements ApplicationRepository {}

void main() {
  late GetApplicationsUseCase useCase;
  late MockApplicationRepository mockRepository;

  setUp(() {
    mockRepository = MockApplicationRepository();
    useCase = GetApplicationsUseCase(mockRepository);
  });

  final tApplications = [
    ApplicationEntity(
      id: 'app_1',
      userId: 'user_1',
      company: 'Stripe',
      position: 'Staff Engineer',
      status: 'APPLIED',
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
    ),
  ];

  const tPagination = PaginationMeta(
    page: 1,
    limit: 20,
    total: 1,
    totalPages: 1,
  );

  test('should get list of applications from repository', () async {
    when(() => mockRepository.getApplications(
          page: 1,
          limit: 20,
          status: 'APPLIED',
          sort: '-applied_at',
        )).thenAnswer((_) async => Right((tApplications, tPagination)));

    final result = await useCase(const GetApplicationsParams(
      page: 1,
      limit: 20,
      status: 'APPLIED',
      sort: '-applied_at',
    ));

    expect(result, equals(Right((tApplications, tPagination))));
    verify(() => mockRepository.getApplications(
          page: 1,
          limit: 20,
          status: 'APPLIED',
          sort: '-applied_at',
        )).called(1);
    verifyNoMoreInteractions(mockRepository);
  });
}
