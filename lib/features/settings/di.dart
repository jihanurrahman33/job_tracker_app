import 'package:get_it/get_it.dart';
import '../../core/networking/api_client.dart';
import 'presentation/bloc/settings_bloc.dart';

void initSettingsFeature(GetIt sl) {
  sl.registerLazySingleton(
    () => SettingsBloc(
      sharedPreferences: sl(),
      apiClient: sl<ApiClient>(),
    ),
  );
}
