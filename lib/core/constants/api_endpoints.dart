class ApiEndpoints {
  static const String renderUrl = 'https://job-tracker-server-9drb.onrender.com';
  static const String vercelUrl = 'https://job-tracker-server-nu.vercel.app';
  static const String localUrl = 'http://localhost:8080';

  static const String defaultBaseUrl = renderUrl;

  static const String baseUrlStorageKey = 'custom_base_url';
  static const String authTokenStorageKey = 'auth_bearer_token';
  static const String authUserStorageKey = 'auth_user_data';
  static const String themeModeStorageKey = 'app_theme_mode';

  static const String register = '/api/v1/auth/register';
  static const String login = '/api/v1/auth/login';
  static const String logout = '/api/v1/auth/logout';
  static const String me = '/api/v1/me';

  static const String applications = '/api/v1/applications';
  static String applicationById(String id) => '/api/v1/applications/$id';
  static String applicationEvents(String id) => '/api/v1/applications/$id/events';
  static String applicationInterviews(String id) =>
      '/api/v1/applications/$id/interviews';

  static String interviewById(String id) => '/api/v1/interviews/$id';

  static const String reminders = '/api/v1/reminders';
  static String reminderById(String id) => '/api/v1/reminders/$id';

  static const String statistics = '/api/v1/statistics';

  static const String health = '/health';
  static const String ready = '/ready';
}
