part of 'notifications_bloc.dart';

@freezed
class NotificationsEvent with _$NotificationsEvent {
  const factory NotificationsEvent.requestPermissions() = _RequestPermissions;
  const factory NotificationsEvent.handleOpenAppFromNotification() = _HandleOpenAppFromNotification;
  const factory NotificationsEvent.clearWordIdFromNotification() = _ClearWordIdFromNotification;
  const factory NotificationsEvent.scheduleNextDayReminder() = _ScheduleNextDayReminder;
  const factory NotificationsEvent.scheduleWordsReminder({
    required List<Word> words,
    required DateTime scheduledTime,
    required Duration interval,
  }) = _ScheduleWordReminder;
  const factory NotificationsEvent.reminderWordTomorrow({required Word word}) = _ReminderWordTomorrow;
  const factory NotificationsEvent.getScheduledNotifications() = _GetScheduledNotifications;
  const factory NotificationsEvent.removeScheduledNotifications(int id) = _RemoveScheduledNotifications;
  const factory NotificationsEvent.emitState(NotificationsState state) = _EmitState;
}
