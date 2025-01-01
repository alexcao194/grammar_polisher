part of 'notifications_bloc.dart';

@freezed
class NotificationsState with _$NotificationsState {
  const factory NotificationsState({
    @Default(null) Failure? failure,
    @Default(null) String? message,
    @Default(false) bool isNotificationsGranted,
    @Default(null) int? wordIdFromNotification,
    @Default([]) List<ScheduledNotification> scheduledNotifications,
  }) = _NotificationsState;
}
