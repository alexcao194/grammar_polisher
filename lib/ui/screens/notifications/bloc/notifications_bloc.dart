import 'package:bloc/bloc.dart';
import 'package:flutter/foundation.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../../constants/notification_category.dart';
import '../../../../constants/thread_identifiers.dart';
import '../../../../data/models/word.dart';
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
        scheduleWordsReminder: (event) => _scheduleWordsReminder(event, emit),
        reminderWordTomorrow: (event) => _reminderWordTomorrow(event, emit),
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
      const nextDayReminderId = -1;
      final scheduledDate = DateTime(now.year, now.month, now.day, 8, 0).add(const Duration(days: 1));
      await _localNotificationsTools.scheduleNotification(
        id: nextDayReminderId,
        title: 'Boost your vocabulary daily!',
        body: 'Don\'t miss the chance to learn new words today. Small steps lead to big changes!',
        scheduledDate: scheduledDate,
        category: NotificationCategory.dailyReminder,
        threadIdentifier: ThreadIdentifiers.dailyReminder,
      );
      debugPrint('NotificationsBloc: scheduleNextDayReminder scheduledDate: $scheduledDate');
    }
  }

  _scheduleWordsReminder(_ScheduleWordReminder event, Emitter<NotificationsState> emit) async {
    debugPrint('NotificationsBloc: scheduleWordsReminder');
    final isGranted = state.isNotificationsGranted;
    debugPrint('NotificationsBloc: scheduleWordsReminder isGranted: $isGranted');
    if (isGranted) {
      final pendingNotifications = await _localNotificationsTools.pendingNotifications();
      const maxWordReminderNotificationId = 6000; // we have nearly 6000 words
      for (final notification in pendingNotifications) {
        if (notification.id > maxWordReminderNotificationId) {
          await _localNotificationsTools.cancelNotification(notification.id);
        }
      }
      for (int i = 0; i < event.words.length; i++) {
        final word = event.words[i];
        final notificationTime = event.scheduledTime.add(event.interval * i);
        await _localNotificationsTools.scheduleNotification(
          id: notificationTime.millisecondsSinceEpoch ~/ 1000,
          title: word.word,
          body: word.senses.firstOrNull?.definition ?? 'Learn the meaning of this word!',
          scheduledDate: notificationTime,
          category: NotificationCategory.vocabulary,
          threadIdentifier: ThreadIdentifiers.wordInterval,
          payload: word.index.toString(),
        );
        debugPrint('NotificationsBloc: scheduleWordsReminder scheduledDate: $notificationTime');
      }
    }
  }

  _reminderWordTomorrow(_ReminderWordTomorrow event, Emitter<NotificationsState> emit) async {
    debugPrint('NotificationsBloc: reminderWordTomorrow');
    final isGranted = state.isNotificationsGranted;
    debugPrint('NotificationsBloc: reminderWordTomorrow isGranted: $isGranted');
    if (isGranted) {
      final now = DateTime.now();
      final randomHour = 8 + (now.millisecondsSinceEpoch % 12);
      final randomMinute = now.millisecondsSinceEpoch % 60;
      final scheduledDate = DateTime(now.year, now.month, now.day, randomHour, randomMinute).add(const Duration(days: 1));
      await _localNotificationsTools.scheduleNotification(
        id: event.word.index,
        title: event.word.word,
        body: event.word.senses.firstOrNull?.definition ?? 'Learn the meaning of this word!',
        scheduledDate: scheduledDate,
        category: NotificationCategory.vocabulary,
        threadIdentifier: ThreadIdentifiers.wordReminder,
        payload: event.word.index.toString(),
      );
      debugPrint('NotificationsBloc: reminderWordTomorrow scheduledDate: $scheduledDate');
    }
  }
}
