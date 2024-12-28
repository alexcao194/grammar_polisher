import 'package:bloc/bloc.dart';
import 'package:flutter/foundation.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../../utils/local_notifications_tools.dart';

part 'notifications_event.dart';

part 'notifications_state.dart';

part 'generated/notifications_bloc.freezed.dart';

class NotificationsBloc extends Bloc<NotificationsEvent, NotificationsState> {
  final LocalNotificationsTools _localNotificationsTools;

  NotificationsBloc({
    required LocalNotificationsTools localNotificationsTools,
  })
      : _localNotificationsTools = localNotificationsTools,
        super(const NotificationsState()) {
    on<NotificationsEvent>((event, emit) async {
      await event.map(
        requestPermissions: (event) => _requestPermissions(event, emit),
      );
    });
  }

  _requestPermissions(_RequestPermissions event, Emitter<NotificationsState> emit) async {
    debugPrint('NotificationsBloc: requestPermissions');
    await _localNotificationsTools.requestPermissions();
  }
}
