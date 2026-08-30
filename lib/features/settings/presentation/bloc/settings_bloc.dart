import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../../core/constants/api_endpoints.dart';
import '../../../../core/networking/api_client.dart';
import 'settings_event.dart';
import 'settings_state.dart';

class SettingsBloc extends Bloc<SettingsEvent, SettingsState> {
  final SharedPreferences sharedPreferences;
  final ApiClient apiClient;

  SettingsBloc({
    required this.sharedPreferences,
    required this.apiClient,
  }) : super(const SettingsState()) {
    on<LoadSettingsEvent>(_onLoadSettings);
    on<ServerUrlChangedEvent>(_onServerUrlChanged);
    on<ThemeModeChangedEvent>(_onThemeModeChanged);
  }

  void _onLoadSettings(
    LoadSettingsEvent event,
    Emitter<SettingsState> emit,
  ) {
    final savedUrl =
        sharedPreferences.getString(ApiEndpoints.baseUrlStorageKey) ??
            ApiEndpoints.defaultBaseUrl;
    final savedTheme =
        sharedPreferences.getString(ApiEndpoints.themeModeStorageKey);

    ThemeMode mode = ThemeMode.system;
    if (savedTheme == 'light') mode = ThemeMode.light;
    if (savedTheme == 'dark') mode = ThemeMode.dark;

    apiClient.setBaseUrl(savedUrl);

    emit(state.copyWith(
      currentServerUrl: savedUrl,
      themeMode: mode,
    ));
  }

  Future<void> _onServerUrlChanged(
    ServerUrlChangedEvent event,
    Emitter<SettingsState> emit,
  ) async {
    final cleanUrl = event.url.trim();
    await sharedPreferences.setString(ApiEndpoints.baseUrlStorageKey, cleanUrl);
    apiClient.setBaseUrl(cleanUrl);

    emit(state.copyWith(
      currentServerUrl: cleanUrl,
      isSaved: true,
    ));
  }

  Future<void> _onThemeModeChanged(
    ThemeModeChangedEvent event,
    Emitter<SettingsState> emit,
  ) async {
    String themeString = 'system';
    if (event.mode == ThemeMode.light) themeString = 'light';
    if (event.mode == ThemeMode.dark) themeString = 'dark';

    await sharedPreferences.setString(
        ApiEndpoints.themeModeStorageKey, themeString);

    emit(state.copyWith(
      themeMode: event.mode,
    ));
  }
}
