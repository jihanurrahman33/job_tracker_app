import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../../core/constants/api_endpoints.dart';
import '../../../../core/error/exceptions.dart';
import '../models/user_model.dart';

abstract class AuthLocalDataSource {
  Future<void> saveAuthToken(String token);
  Future<String?> getAuthToken();
  Future<void> removeAuthToken();

  Future<void> saveUser(UserModel user);
  Future<UserModel?> getUser();
  Future<void> removeUser();

  Future<void> clearAuthSession();
}

class AuthLocalDataSourceImpl implements AuthLocalDataSource {
  final SharedPreferences sharedPreferences;

  AuthLocalDataSourceImpl({required this.sharedPreferences});

  @override
  Future<void> saveAuthToken(String token) async {
    final success = await sharedPreferences.setString(
      ApiEndpoints.authTokenStorageKey,
      token,
    );
    if (!success) {
      throw const CacheException(message: 'Failed to cache authentication token.');
    }
  }

  @override
  Future<String?> getAuthToken() async {
    return sharedPreferences.getString(ApiEndpoints.authTokenStorageKey);
  }

  @override
  Future<void> removeAuthToken() async {
    await sharedPreferences.remove(ApiEndpoints.authTokenStorageKey);
  }

  @override
  Future<void> saveUser(UserModel user) async {
    final jsonStr = jsonEncode(user.toJson());
    final success = await sharedPreferences.setString(
      ApiEndpoints.authUserStorageKey,
      jsonStr,
    );
    if (!success) {
      throw const CacheException(message: 'Failed to cache user profile.');
    }
  }

  @override
  Future<UserModel?> getUser() async {
    final jsonStr = sharedPreferences.getString(ApiEndpoints.authUserStorageKey);
    if (jsonStr == null || jsonStr.isEmpty) return null;

    try {
      final map = jsonDecode(jsonStr) as Map<String, dynamic>;
      return UserModel.fromJson(map);
    } catch (_) {
      return null;
    }
  }

  @override
  Future<void> removeUser() async {
    await sharedPreferences.remove(ApiEndpoints.authUserStorageKey);
  }

  @override
  Future<void> clearAuthSession() async {
    await removeAuthToken();
    await removeUser();
  }
}
