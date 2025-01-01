part of 'notifications_bloc.dart';

@freezed
class NotificationsState with _$NotificationsState {
  const factory NotificationsState({
    @Default(false) bool isNotificationsGranted,
    @Default(null) int? wordIdFromNotification,
  }) = _NotificationsState;
}
