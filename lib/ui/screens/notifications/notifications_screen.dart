import 'package:app_settings/app_settings.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../constants/notification_category.dart';
import '../../../utils/local_notifications_tools.dart';
import 'bloc/notifications_bloc.dart';

class NotificationsScreen extends StatefulWidget {
  const NotificationsScreen({super.key});

  @override
  State<NotificationsScreen> createState() => _NotificationsScreenState();
}

class _NotificationsScreenState extends State<NotificationsScreen> {
  late final AppLifecycleListener _appLifecycleListener;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<NotificationsBloc, NotificationsState>(
      builder: (context, state) {
        return Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text("Notifications permission: ${state.isNotificationsGranted}"),
            ElevatedButton(
              onPressed: () {
                AppSettings.openAppSettings(type: AppSettingsType.notification);
              },
              child: const Text("Open notifications settings"),
            ),
            ElevatedButton(
              onPressed: () {
                LocalNotificationsTools().showNotification(
                  title: "Test notification",
                  body: "This is a test notification",
                  category: NotificationCategory.vocabulary,
                  threadIdentifier: "test",
                  id: 5646,
                  payload: "test",
                );
              },
              child: const Text("Push notification"),
            ),
          ],
        );
      },
    );
  }

  @override
  void initState() {
    super.initState();
    context.read<NotificationsBloc>().add(const NotificationsEvent.requestPermissions());
    _appLifecycleListener = AppLifecycleListener(
      onShow: () {
        debugPrint('NotificationsScreen: onShow');
        // this is needed to update the permissions status when the user returns to the app after changing the notification settings
        context.read<NotificationsBloc>().add(const NotificationsEvent.requestPermissions());
      },
    );
  }

  @override
  void dispose() {
    _appLifecycleListener.dispose();
    super.dispose();
  }
}
