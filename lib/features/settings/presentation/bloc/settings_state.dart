import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import '../../../../core/constants/api_endpoints.dart';

class SettingsState extends Equatable {
  final String currentServerUrl;
  final ThemeMode themeMode;
  final bool isSaved;

  const SettingsState({
    this.currentServerUrl = ApiEndpoints.defaultBaseUrl,
    this.themeMode = ThemeMode.system,
    this.isSaved = false,
  });

  SettingsState copyWith({
    String? currentServerUrl,
    ThemeMode? themeMode,
    bool? isSaved,
  }) {
    return SettingsState(
      currentServerUrl: currentServerUrl ?? this.currentServerUrl,
      themeMode: themeMode ?? this.themeMode,
      isSaved: isSaved ?? this.isSaved,
    );
  }

  @override
  List<Object?> get props => [currentServerUrl, themeMode, isSaved];
}
