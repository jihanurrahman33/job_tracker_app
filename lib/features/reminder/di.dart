import 'package:get_it/get_it.dart';
import '../../core/networking/api_client.dart';
import 'data/datasources/reminder_remote_data_source.dart';
import 'data/repositories/reminder_repository_impl.dart';
import 'domain/repositories/reminder_repository.dart';
import 'domain/usecases/create_reminder_usecase.dart';
import 'domain/usecases/delete_reminder_usecase.dart';
import 'domain/usecases/get_reminders_usecase.dart';
import 'domain/usecases/update_reminder_usecase.dart';
import 'presentation/bloc/reminder_bloc.dart';

void initReminderFeature(GetIt sl) {
  // Data source
  sl.registerLazySingleton<ReminderRemoteDataSource>(
    () => ReminderRemoteDataSourceImpl(apiClient: sl<ApiClient>()),
  );

  // Repository
  sl.registerLazySingleton<ReminderRepository>(
    () => ReminderRepositoryImpl(remoteDataSource: sl()),
  );

  // Use cases
  sl.registerLazySingleton(() => GetRemindersUseCase(sl()));
  sl.registerLazySingleton(() => CreateReminderUseCase(sl()));
  sl.registerLazySingleton(() => UpdateReminderUseCase(sl()));
  sl.registerLazySingleton(() => DeleteReminderUseCase(sl()));

  // BLoC
  sl.registerFactory(
    () => ReminderBloc(
      getRemindersUseCase: sl(),
      updateReminderUseCase: sl(),
      deleteReminderUseCase: sl(),
    ),
  );
}
