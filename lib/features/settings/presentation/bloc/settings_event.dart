import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

abstract class SettingsEvent extends Equatable {
  const SettingsEvent();

  @override
  List<Object?> get props => [];
}

class LoadSettingsEvent extends SettingsEvent {
  const LoadSettingsEvent();
}

class ServerUrlChangedEvent extends SettingsEvent {
  final String url;
  const ServerUrlChangedEvent(this.url);

  @override
  List<Object?> get props => [url];
}

class ThemeModeChangedEvent extends SettingsEvent {
  final ThemeMode mode;
  const ThemeModeChangedEvent(this.mode);

  @override
  List<Object?> get props => [mode];
}
