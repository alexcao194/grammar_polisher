import '../data_sources/local_data.dart';
import '../models/scheduled_notification.dart';

abstract interface class NotificationsRepository {
  Future<void> saveScheduledNotification(ScheduledNotification scheduledNotification);

  List<ScheduledNotification> getScheduledNotifications();
}

class NotificationsRepositoryImpl implements NotificationsRepository {
  final LocalData _localData;

  NotificationsRepositoryImpl({
    required LocalData localData,
  }) : _localData = localData;

  @override
  List<ScheduledNotification> getScheduledNotifications() {
    return _localData.getScheduledNotifications();
  }

  @override
  Future<void> saveScheduledNotification(ScheduledNotification scheduledNotification) {
    return _localData.saveScheduledNotification(scheduledNotification);
  }
}