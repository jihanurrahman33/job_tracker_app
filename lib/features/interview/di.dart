import 'package:get_it/get_it.dart';
import '../../core/networking/api_client.dart';
import 'data/datasources/interview_remote_data_source.dart';
import 'data/repositories/interview_repository_impl.dart';
import 'domain/repositories/interview_repository.dart';
import 'domain/usecases/create_interview_usecase.dart';
import 'domain/usecases/delete_interview_usecase.dart';
import 'domain/usecases/get_interview_detail_usecase.dart';
import 'domain/usecases/get_interviews_by_app_usecase.dart';
import 'domain/usecases/update_interview_usecase.dart';
import 'presentation/bloc/interview_bloc.dart';

void initInterviewFeature(GetIt sl) {
  // Data source
  sl.registerLazySingleton<InterviewRemoteDataSource>(
    () => InterviewRemoteDataSourceImpl(apiClient: sl<ApiClient>()),
  );

  // Repository
  sl.registerLazySingleton<InterviewRepository>(
    () => InterviewRepositoryImpl(remoteDataSource: sl()),
  );

  // Use cases
  sl.registerLazySingleton(() => GetInterviewsByAppUseCase(sl()));
  sl.registerLazySingleton(() => GetInterviewDetailUseCase(sl()));
  sl.registerLazySingleton(() => CreateInterviewUseCase(sl()));
  sl.registerLazySingleton(() => UpdateInterviewUseCase(sl()));
  sl.registerLazySingleton(() => DeleteInterviewUseCase(sl()));

  // BLoC
  sl.registerFactory(
    () => InterviewBloc(
      getInterviewsByAppUseCase: sl(),
      deleteInterviewUseCase: sl(),
    ),
  );
}
