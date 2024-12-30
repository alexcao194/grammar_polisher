import '../data_sources/local_data.dart';
import '../models/settings_snapshot.dart';

abstract interface class SettingsRepository {
  SettingsSnapshot getSettingsSnapshot();
  Future<void> saveSettingsSnapshot(SettingsSnapshot settingsSnapshot);
}

class SettingsRepositoryImpl implements SettingsRepository {
  final LocalData _localData;

  SettingsRepositoryImpl({
    required LocalData localData,
  }) : _localData = localData;

  @override
  SettingsSnapshot getSettingsSnapshot() {
    return _localData.getSettingsSnapshot();
  }

  @override
  Future<void> saveSettingsSnapshot(SettingsSnapshot settingsSnapshot) {
    return _localData.saveSettingsSnapshot(settingsSnapshot);
  }
}