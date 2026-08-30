import '../../../../core/constants/api_endpoints.dart';
import '../../../../core/error/exceptions.dart';
import '../../../../core/networking/api_client.dart';
import '../models/user_model.dart';

abstract class AuthRemoteDataSource {
  Future<(UserModel, String)> login({
    required String email,
    required String password,
  });

  Future<(UserModel, String)> register({
    required String email,
    required String password,
    required String name,
  });

  Future<void> logout();

  Future<UserModel> getMe();
}

class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  final ApiClient apiClient;

  AuthRemoteDataSourceImpl({required this.apiClient});

  @override
  Future<(UserModel, String)> login({
    required String email,
    required String password,
  }) async {
    final response = await apiClient.post(
      ApiEndpoints.login,
      body: {
        'email': email.trim(),
        'password': password,
      },
    );

    if (response is Map<String, dynamic>) {
      final data = (response.containsKey('data') && response['data'] is Map<String, dynamic>)
          ? response['data'] as Map<String, dynamic>
          : response;

      final token = (data['token'] ?? response['token'] ?? '') as String;
      final userJson = data['user'] is Map<String, dynamic>
          ? data['user'] as Map<String, dynamic>
          : (data.containsKey('email') ? data : null);

      if (userJson != null) {
        final user = UserModel.fromJson(userJson);
        return (user, token);
      }
    }

    throw const ServerException(
        message: 'Invalid response format from server.');
  }

  @override
  Future<(UserModel, String)> register({
    required String email,
    required String password,
    required String name,
  }) async {
    final response = await apiClient.post(
      ApiEndpoints.register,
      body: {
        'email': email.trim(),
        'password': password,
        'name': name.trim(),
      },
    );

    if (response is Map<String, dynamic>) {
      final data = (response.containsKey('data') && response['data'] is Map<String, dynamic>)
          ? response['data'] as Map<String, dynamic>
          : response;

      final token = (data['token'] ?? response['token'] ?? '') as String;
      final userJson = data['user'] is Map<String, dynamic>
          ? data['user'] as Map<String, dynamic>
          : (data.containsKey('email') ? data : null);

      if (userJson != null) {
        final user = UserModel.fromJson(userJson);
        return (user, token);
      }
    }

    throw const ServerException(
        message: 'Invalid response format from server.');
  }

  @override
  Future<void> logout() async {
    try {
      await apiClient.post(ApiEndpoints.logout);
    } catch (_) {
      // Best-effort logout on backend
    }
  }

  @override
  Future<UserModel> getMe() async {
    final response = await apiClient.get(ApiEndpoints.me);

    if (response is Map<String, dynamic>) {
      final data = (response.containsKey('data') && response['data'] is Map<String, dynamic>)
          ? response['data'] as Map<String, dynamic>
          : response;

      final userJson = data['user'] is Map<String, dynamic>
          ? data['user'] as Map<String, dynamic>
          : (data.containsKey('email') ? data : null);

      if (userJson != null) {
        return UserModel.fromJson(userJson);
      }
      return UserModel.fromJson(data);
    }

    throw const ServerException(
        message: 'Invalid profile response from server.');
  }
}
