import 'package:get_it/get_it.dart';
import '../../core/networking/api_client.dart';
import 'data/datasources/application_remote_data_source.dart';
import 'data/repositories/application_repository_impl.dart';
import 'domain/repositories/application_repository.dart';
import 'domain/usecases/create_application_usecase.dart';
import 'domain/usecases/delete_application_usecase.dart';
import 'domain/usecases/get_application_detail_usecase.dart';
import 'domain/usecases/get_application_events_usecase.dart';
import 'domain/usecases/get_applications_usecase.dart';
import 'domain/usecases/update_application_usecase.dart';
import 'presentation/bloc/application_bloc.dart';
import 'presentation/bloc/application_detail_bloc.dart';

void initApplicationFeature(GetIt sl) {
  // Data source
  sl.registerLazySingleton<ApplicationRemoteDataSource>(
    () => ApplicationRemoteDataSourceImpl(apiClient: sl<ApiClient>()),
  );

  // Repository
  sl.registerLazySingleton<ApplicationRepository>(
    () => ApplicationRepositoryImpl(remoteDataSource: sl()),
  );

  // Use cases
  sl.registerLazySingleton(() => GetApplicationsUseCase(sl()));
  sl.registerLazySingleton(() => GetApplicationDetailUseCase(sl()));
  sl.registerLazySingleton(() => CreateApplicationUseCase(sl()));
  sl.registerLazySingleton(() => UpdateApplicationUseCase(sl()));
  sl.registerLazySingleton(() => DeleteApplicationUseCase(sl()));
  sl.registerLazySingleton(() => GetApplicationEventsUseCase(sl()));

  // BLoCs
  sl.registerFactory(
    () => ApplicationBloc(
      getApplicationsUseCase: sl(),
      deleteApplicationUseCase: sl(),
    ),
  );

  sl.registerFactory(
    () => ApplicationDetailBloc(
      getApplicationDetailUseCase: sl(),
      getApplicationEventsUseCase: sl(),
      updateApplicationUseCase: sl(),
    ),
  );
}
