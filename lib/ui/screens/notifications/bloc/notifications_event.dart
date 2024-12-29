part of 'notifications_bloc.dart';

@freezed
class NotificationsEvent with _$NotificationsEvent {
  const factory NotificationsEvent.requestPermissions() = _RequestPermissions;
  const factory NotificationsEvent.scheduleNextDayReminder() = _ScheduleNextDayReminder;
}
