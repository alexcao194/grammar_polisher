import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../navigation/app_router.dart';
import '../../commons/base_page.dart';
import '../../commons/rounded_button.dart';
import 'bloc/notifications_bloc.dart';
import 'widgets/empty_notifications_page.dart';
import 'widgets/notification_item.dart';

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
          title: "Reminders",
          child: state.isNotificationsGranted
              ? Column(
                  children: [
                    Text("The scheduled notifications will appear here. You can view and delete any unnecessary notifications."),
                    const SizedBox(height: 16),
                    Expanded(
                      child: ListView.builder(
                        itemCount: state.scheduledNotifications.length,
                        itemBuilder: (context, index) {
                          final notification = state.scheduledNotifications[index];
                          return Padding(
                            padding: const EdgeInsets.symmetric(vertical: 8.0),
                            child: NotificationItem(notification: notification),
                          );
                        },
                      ),
                    ),
                    const SizedBox(height: 8),
                    RoundedButton(
                      onPressed: _openReviewScreen,
                      borderRadius: 16,
                      child: Text("New Reminder"),
                    ),
                  ],
                )
              : EmptyNotificationsPage(),
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

  void _openReviewScreen() {
    context.go(RoutePaths.review);
  }
}
