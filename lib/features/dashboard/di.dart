import 'package:get_it/get_it.dart';
import '../../core/networking/api_client.dart';
import 'data/datasources/statistics_remote_data_source.dart';
import 'data/repositories/statistics_repository_impl.dart';
import 'domain/repositories/statistics_repository.dart';
import 'domain/usecases/get_statistics_usecase.dart';
import 'presentation/bloc/dashboard_bloc.dart';

void initDashboardFeature(GetIt sl) {
  // Data source
  sl.registerLazySingleton<StatisticsRemoteDataSource>(
    () => StatisticsRemoteDataSourceImpl(apiClient: sl<ApiClient>()),
  );

  // Repository
  sl.registerLazySingleton<StatisticsRepository>(
    () => StatisticsRepositoryImpl(remoteDataSource: sl()),
  );

  // Use cases
  sl.registerLazySingleton(() => GetStatisticsUseCase(sl()));

  // BLoC
  sl.registerFactory(
    () => DashboardBloc(getStatisticsUseCase: sl()),
  );
}
