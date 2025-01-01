import 'package:bloc/bloc.dart';
import 'package:flutter/foundation.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../../constants/notification_category.dart';
import '../../../../constants/thread_identifiers.dart';
import '../../../../core/failure.dart';
import '../../../../data/models/scheduled_notification.dart';
import '../../../../data/models/word.dart';
import '../../../../data/repositories/notifications_repository.dart';
import '../../../../utils/local_notifications_tools.dart';

part 'notifications_event.dart';

part 'notifications_state.dart';

part 'generated/notifications_bloc.freezed.dart';

class NotificationsBloc extends Bloc<NotificationsEvent, NotificationsState> {
  final LocalNotificationsTools _localNotificationsTools;
  final NotificationsRepository _notificationsRepository;

  NotificationsBloc({
    required LocalNotificationsTools localNotificationsTools,
    required NotificationsRepository notificationsRepository,
  })  : _localNotificationsTools = localNotificationsTools,
        _notificationsRepository = notificationsRepository,
        super(const NotificationsState()) {
    on<NotificationsEvent>((event, emit) async {
      await event.map(
        requestPermissions: (event) => _requestPermissions(event, emit),
        handleOpenAppFromNotification: (event) => _onHandleOpenAppFromNotification(event, emit),
        clearWordIdFromNotification: (event) => _onClearWordIdFromNotification(event, emit),
        scheduleNextDayReminder: (event) => _scheduleNextDayReminder(event, emit),
        scheduleWordsReminder: (event) => _scheduleWordsReminder(event, emit),
        reminderWordTomorrow: (event) => _reminderWordTomorrow(event, emit),
        getScheduledNotifications: (event) => _onGetScheduledNotifications(event, emit),
        removeScheduledNotifications: (event) => _onRemoveScheduledNotifications(event, emit),
        emitState: (event) => _onEmitState(event, emit),
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
      const nextDayReminderId = 0;
      final scheduledDate = DateTime(now.year, now.month, now.day, 8, 0).add(const Duration(days: 1));
      final title = '💪Boost your vocabulary daily!';
      final body = 'Don\'t miss the chance to learn new words today. Small steps lead to big changes!';
      await _localNotificationsTools.scheduleNotification(
        id: nextDayReminderId,
        title: title,
        body: body,
        scheduledDate: scheduledDate,
        category: NotificationCategory.dailyReminder,
        threadIdentifier: ThreadIdentifiers.dailyReminder,
      );
      await _notificationsRepository.saveScheduledNotification(ScheduledNotification(
        id: nextDayReminderId,
        title: title,
        body: body,
        scheduledDate: scheduledDate.toIso8601String(),
      ));
      debugPrint('NotificationsBloc: scheduleNextDayReminder scheduledDate: $scheduledDate');
    }
  }

  _scheduleWordsReminder(_ScheduleWordReminder event, Emitter<NotificationsState> emit) async {
    debugPrint('NotificationsBloc: scheduleWordsReminder');
    final isGranted = state.isNotificationsGranted;
    debugPrint('NotificationsBloc: scheduleWordsReminder isGranted: $isGranted');
    if (isGranted) {
      for (int i = 0; i < event.words.length; i++) {
        final word = event.words[i];
        final notificationTime = event.scheduledTime.add(event.interval * i);
        await _localNotificationsTools.scheduleNotification(
          id: word.index,
          title: word.word,
          body: word.senses.firstOrNull?.definition ?? 'Learn the meaning of this word!',
          scheduledDate: notificationTime,
          category: NotificationCategory.vocabulary,
          threadIdentifier: ThreadIdentifiers.wordInterval,
          payload: word.index.toString(),
        );
        await _notificationsRepository.saveScheduledNotification(ScheduledNotification(
          id: word.index,
          title: word.word,
          body: word.senses.firstOrNull?.definition ?? 'Learn the meaning of this word!',
          scheduledDate: notificationTime.toIso8601String(),
        ));
        debugPrint('NotificationsBloc: scheduleWordsReminder scheduledDate: $notificationTime');
      }
    }
  }

  _reminderWordTomorrow(_ReminderWordTomorrow event, Emitter<NotificationsState> emit) async {
    debugPrint('NotificationsBloc: reminderWordTomorrow');
    final isGranted = state.isNotificationsGranted;
    debugPrint('NotificationsBloc: reminderWordTomorrow isGranted: $isGranted');
    if (isGranted) {
      final pendingNotifications = await _localNotificationsTools.pendingNotifications();
      final isScheduled = pendingNotifications.any((element) => element.id == event.word.index);
      if (isScheduled) {
        debugPrint('NotificationsBloc: reminderWordTomorrow isScheduled: $isScheduled');
        emit(state.copyWith(failure: Failure(message: 'Notification is already scheduled')));
        emit(state.copyWith(failure: null));
        return;
      }
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
      await _notificationsRepository.saveScheduledNotification(ScheduledNotification(
        id: event.word.index,
        title: event.word.word,
        body: event.word.senses.firstOrNull?.definition ?? 'Learn the meaning of this word!',
        scheduledDate: scheduledDate.toIso8601String(),
      ));
      emit(state.copyWith(message: 'Notification scheduled for tomorrow'));
      emit(state.copyWith(message: null));
      debugPrint('NotificationsBloc: reminderWordTomorrow scheduledDate: $scheduledDate');
    }
  }

  _onHandleOpenAppFromNotification(_HandleOpenAppFromNotification event, Emitter<NotificationsState> emit) async {
    debugPrint('NotificationsBloc: handleOpenAppFromNotification');
    final notification = await _localNotificationsTools.getNotificationAppLaunchDetails();
    final notificationPayload = notification?.notificationResponse?.payload ?? '';
    final wordId = int.tryParse(notificationPayload);
    if (wordId != null) {
      debugPrint('NotificationsBloc: handleOpenAppFromNotification wordId: $wordId');
      emit(state.copyWith(wordIdFromNotification: wordId));
    }
  }

  _onClearWordIdFromNotification(_ClearWordIdFromNotification event, Emitter<NotificationsState> emit) {
    debugPrint('NotificationsBloc: clearWordIdFromNotification');
    emit(state.copyWith(wordIdFromNotification: null));
  }

  _onGetScheduledNotifications(_GetScheduledNotifications event, Emitter<NotificationsState> emit) {
    debugPrint('NotificationsBloc: getScheduledNotifications');
    final notifications = _notificationsRepository.getScheduledNotifications();
    emit(state.copyWith(scheduledNotifications: notifications));
  }

  _onRemoveScheduledNotifications(_RemoveScheduledNotifications event, Emitter<NotificationsState> emit) {
    debugPrint('NotificationsBloc: removeScheduledNotifications');
    _localNotificationsTools.cancelNotification(event.id);
    _notificationsRepository.removeScheduledNotification(event.id).then((result) {
      if (!isClosed) {
        result.fold(
          (failure) {
            debugPrint('NotificationsBloc: removeScheduledNotifications failure: $failure');
            emit(state.copyWith(failure: failure));
            emit(state.copyWith(failure: null));
          },
          (_) => debugPrint('NotificationsBloc: removeScheduledNotifications success'),
        );
      }
    });
    final notifications = state.scheduledNotifications
        .where(
          (notification) => notification.id != event.id,
        )
        .toList();
    emit(state.copyWith(scheduledNotifications: notifications));
  }

  _onEmitState(_EmitState event, Emitter<NotificationsState> emit) {
    debugPrint('NotificationsBloc: emitState');
    emit(event.state);
  }
}
