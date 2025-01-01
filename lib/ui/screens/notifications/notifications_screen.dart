import 'package:app_settings/app_settings.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../constants/notification_category.dart';
import '../../../utils/local_notifications_tools.dart';
import '../../commons/base_page.dart';
import 'bloc/notifications_bloc.dart';

class NotificationsScreen extends StatefulWidget {
  const NotificationsScreen({super.key});

  @override
  State<NotificationsScreen> createState() => _NotificationsScreenState();
}

class _NotificationsScreenState extends State<NotificationsScreen> {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<NotificationsBloc, NotificationsState>(
      builder: (context, state) {
        return BasePage(
          title: "Notifications",
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Column(
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
                        payload: "23",
                      );
                    },
                    child: const Text("Push notification"),
                  ),
                ],
              ),
              Expanded(
                child: ListView.builder(
                  itemCount: state.scheduledNotifications.length,
                  itemBuilder: (context, index) {
                    final notification = state.scheduledNotifications[index];
                    return ListTile(
                      title: Text(notification.title),
                      subtitle: Text(notification.scheduledDate),
                      trailing: IconButton(
                        icon: const Icon(Icons.delete),
                        onPressed: () {
                          context.read<NotificationsBloc>().add(
                                NotificationsEvent.removeScheduledNotifications(notification.id),
                              );
                        },
                      ),
                    );
                  },
                ),
              )
            ],
          ),
        );
      },
    );
  }

  @override
  void initState() {
    super.initState();
    context.read<NotificationsBloc>().add(const NotificationsEvent.requestPermissions());
    context.read<NotificationsBloc>().add(const NotificationsEvent.getScheduledNotifications());
  }
}
