part of 'notifications_bloc.dart';

@freezed
class NotificationsEvent with _$NotificationsEvent {
  const factory NotificationsEvent.requestPermissions() = _RequestPermissions;
  const factory NotificationsEvent.scheduleNextDayReminder() = _ScheduleNextDayReminder;
  const factory NotificationsEvent.scheduleWordsReminder({
    required List<Word> words,
    required DateTime scheduledTime,
    required Duration interval,
  }) = _ScheduleWordReminder;
  const factory NotificationsEvent.reminderWordTomorrow({required Word word}) = _ReminderWordTomorrow;
}
