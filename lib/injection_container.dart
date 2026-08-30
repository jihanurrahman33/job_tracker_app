import 'package:get_it/get_it.dart';
import 'package:http/http.dart' as http;
import 'package:job_tracker/core/constants/api_endpoints.dart';
import 'package:job_tracker/core/networking/api_client.dart';
import 'package:job_tracker/features/application/di.dart';
import 'package:job_tracker/features/auth/di.dart';
import 'package:job_tracker/features/dashboard/di.dart';
import 'package:job_tracker/features/interview/di.dart';
import 'package:job_tracker/features/reminder/di.dart';
import 'package:job_tracker/features/settings/di.dart';
import 'package:shared_preferences/shared_preferences.dart';

final sl = GetIt.instance;

Future<void> initDependencies() async {
  final sharedPreferences = await SharedPreferences.getInstance();
  sl.registerLazySingleton<SharedPreferences>(() => sharedPreferences);
  sl.registerLazySingleton<http.Client>(() => http.Client());

  final savedToken = sharedPreferences.getString(ApiEndpoints.authTokenStorageKey);
  final savedBaseUrl = sharedPreferences.getString(ApiEndpoints.baseUrlStorageKey) ?? ApiEndpoints.defaultBaseUrl;

  final apiClient = ApiClient(
    client: sl<http.Client>(),
    baseUrl: savedBaseUrl,
  );
  if (savedToken != null && savedToken.isNotEmpty) {
    apiClient.setAuthToken(savedToken);
  }

  sl.registerLazySingleton<ApiClient>(() => apiClient);

  initAuthFeature(sl);
  initApplicationFeature(sl);
  initInterviewFeature(sl);
  initReminderFeature(sl);
  initDashboardFeature(sl);
  initSettingsFeature(sl);
}
