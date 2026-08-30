import 'package:get_it/get_it.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'core/networking/api_client.dart';
import 'features/application/di.dart';
import 'features/auth/di.dart';
import 'features/dashboard/di.dart';
import 'features/interview/di.dart';
import 'features/reminder/di.dart';
import 'features/settings/di.dart';

final sl = GetIt.instance;

Future<void> initDependencies() async {
  final sharedPreferences = await SharedPreferences.getInstance();
  sl.registerLazySingleton<SharedPreferences>(() => sharedPreferences);
  sl.registerLazySingleton<http.Client>(() => http.Client());

  sl.registerLazySingleton<ApiClient>(
    () => ApiClient(client: sl<http.Client>()),
  );

  initAuthFeature(sl);
  initApplicationFeature(sl);
  initInterviewFeature(sl);
  initReminderFeature(sl);
  initDashboardFeature(sl);
  initSettingsFeature(sl);
}
