part of 'settings_bloc.dart';

@freezed
class SettingsEvent with _$SettingsEvent {
  const factory SettingsEvent.getSettings() = _GetSettings;

  const factory SettingsEvent.saveSettings({
    int? seek,
    int? themeMode,
  }) = _SaveSettings;
}
