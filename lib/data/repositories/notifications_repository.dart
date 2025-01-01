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
    final scheduledNotifications = _localData.getScheduledNotifications();
    final now = DateTime.now();
    final expiredNotifications = scheduledNotifications
        .where(
          (notification) => DateTime.parse(notification.scheduledDate).isBefore(now),
        )
        .toList();
    for (final notification in expiredNotifications) {
      _localData.removeScheduledNotification(notification.id);
    }
    final validNotifications = scheduledNotifications
        .where(
          (notification) => DateTime.parse(notification.scheduledDate).isAfter(now),
        )
        .toList();
    return validNotifications;
  }

  @override
  Future<void> saveScheduledNotification(ScheduledNotification scheduledNotification) {
    return _localData.saveScheduledNotification(scheduledNotification);
  }
}
