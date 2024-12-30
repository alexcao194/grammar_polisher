part of 'settings_bloc.dart';

@freezed
class SettingsState with _$SettingsState {
  const factory SettingsState({
    @Default(SettingsSnapshot()) SettingsSnapshot settingsSnapshot,
  }) = _SettingsState;
}