import 'package:bloc/bloc.dart';
import 'package:flutter/foundation.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../../constants/notification_category.dart';
import '../../../../utils/local_notifications_tools.dart';

part 'notifications_event.dart';

part 'notifications_state.dart';

part 'generated/notifications_bloc.freezed.dart';

class NotificationsBloc extends Bloc<NotificationsEvent, NotificationsState> {
  final LocalNotificationsTools _localNotificationsTools;

  NotificationsBloc({
    required LocalNotificationsTools localNotificationsTools,
  })  : _localNotificationsTools = localNotificationsTools,
        super(const NotificationsState()) {
    on<NotificationsEvent>((event, emit) async {
      await event.map(
        requestPermissions: (event) => _requestPermissions(event, emit),
        scheduleNextDayReminder: (event) => _scheduleNextDayReminder(event, emit),
      );
    });
  }

  _requestPermissions(_RequestPermissions event, Emitter<NotificationsState> emit) async {
    debugPrint('NotificationsBloc: requestPermissions');
    final oldGrantedState = state.isNotificationsGranted;
    final isGranted = await _localNotificationsTools.requestPermissions();
    debugPrint('NotificationsBloc: requestPermissions isGranted: $isGranted');
    if (oldGrantedState == false && isGranted == true) {
      add(const NotificationsEvent.scheduleNextDayReminder());
    }
    emit(state.copyWith(isNotificationsGranted: isGranted ?? false));
  }

  _scheduleNextDayReminder(_ScheduleNextDayReminder event, Emitter<NotificationsState> emit) async {
    debugPrint('NotificationsBloc: scheduleNextDayReminder');
    final isGranted = state.isNotificationsGranted;
    debugPrint('NotificationsBloc: scheduleNextDayReminder isGranted: $isGranted');
    if (isGranted) {
      final now = DateTime.now();
      await _localNotificationsTools.scheduleNotification(
        id: -1,
        title: 'Boost your vocabulary daily!',
        body: 'Don\'t miss the chance to learn new words today. Small steps lead to big changes!',
        scheduledDate: DateTime(now.year, now.month, now.day, 8, 0).add(const Duration(days: 1)),
        category: NotificationCategory.dailyReminder,
        threadIdentifier: 'daily_reminder',
      );
    }
  }
}
