import '../../configs/hive/app_hive.dart';
import '../models/scheduled_notification.dart';
import '../models/settings_snapshot.dart';
import '../models/word.dart';

abstract interface class LocalData {
  Future<void> saveWords(List<Word> words);

  List<Word> getWords();

  Future<void> saveWord(Word word);

  SettingsSnapshot getSettingsSnapshot();

  Future<void> saveSettingsSnapshot(SettingsSnapshot settingsSnapshot);

  Future<void> saveScheduledNotification(ScheduledNotification scheduledNotification);

  Future<void> removeScheduledNotification(int id);

  List<ScheduledNotification> getScheduledNotifications();
}

class HiveDatabase implements LocalData {
  static const String _settingsSnapshotKey = 'settingsSnapshot';
  final AppHive _appHive;

  HiveDatabase({
    required AppHive appHive,
  }) : _appHive = appHive;

  @override
  List<Word> getWords() {
    return _appHive.wordBox.values.toList();
  }

  @override
  Future<void> saveWords(List<Word> words) async {
    await _appHive.wordBox.putAll(
      Map.fromEntries(
        words.map(
          (word) => MapEntry(word.index, word),
        ),
      ),
    );
  }

  @override
  Future<void> saveWord(Word word) {
    return _appHive.wordBox.put(word.index, word);
  }

  @override
  SettingsSnapshot getSettingsSnapshot() {
    return _appHive.settingsBox.get(_settingsSnapshotKey) ?? SettingsSnapshot();
  }

  @override
  Future<void> saveSettingsSnapshot(SettingsSnapshot settingsSnapshot) {
    return _appHive.settingsBox.put(_settingsSnapshotKey, settingsSnapshot);
  }

  @override
  List<ScheduledNotification> getScheduledNotifications() {
    return _appHive.scheduledNotificationBox.values.toList();
  }

  @override
  Future<void> saveScheduledNotification(ScheduledNotification scheduledNotification) {
    return _appHive.scheduledNotificationBox.put(scheduledNotification.id, scheduledNotification);
  }

  @override
  Future<void> removeScheduledNotification(int id) {
    return _appHive.scheduledNotificationBox.delete(id);
  }
}