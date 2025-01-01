import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/timezone.dart' as tz;

import '../constants/notification_category.dart';

class LocalNotificationsTools {
  LocalNotificationsTools._();

  static LocalNotificationsTools? _instance;

  factory LocalNotificationsTools() {
    _instance ??= LocalNotificationsTools._();
    return _instance!;
  }

  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

  Future<bool?> requestPermissions() async {
    switch (Platform.operatingSystem) {
      case 'ios':
        return await flutterLocalNotificationsPlugin.resolvePlatformSpecificImplementation<IOSFlutterLocalNotificationsPlugin>()?.requestPermissions(
              alert: true,
              badge: true,
              sound: true,
            );
      case 'macos':
        return await flutterLocalNotificationsPlugin.resolvePlatformSpecificImplementation<MacOSFlutterLocalNotificationsPlugin>()?.requestPermissions(
              alert: true,
              badge: true,
              sound: true,
            );
      case 'android':
        final AndroidFlutterLocalNotificationsPlugin? androidImplementation = flutterLocalNotificationsPlugin.resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>();
        return await androidImplementation?.requestNotificationsPermission();
      default:
        return null;
    }
  }

  Future<void> initialize({
    void Function(NotificationResponse notificationResponse)? onDidReceiveNotificationResponse,
    void Function(NotificationResponse notificationResponse)? onDidReceiveBackgroundNotificationResponse,
  }) async {
    final DarwinInitializationSettings initializationSettingsDarwin = DarwinInitializationSettings(
      requestAlertPermission: false,
      requestBadgePermission: false,
      requestSoundPermission: false,
    );
    final AndroidInitializationSettings initializationSettingsAndroid = AndroidInitializationSettings('launcher');
    final initializationSettings = InitializationSettings(
      android: initializationSettingsAndroid,
      iOS: initializationSettingsDarwin,
    );
    await flutterLocalNotificationsPlugin.initialize(
      initializationSettings,
      onDidReceiveNotificationResponse: onDidReceiveNotificationResponse,
      onDidReceiveBackgroundNotificationResponse: onDidReceiveBackgroundNotificationResponse,
    );
  }

  Future<void> showNotification({
    required int id,
    required String title,
    required String body,
    required NotificationCategory category,
    required String threadIdentifier,
    String? payload,
  }) async {
    final AndroidNotificationDetails androidNotificationDetails = AndroidNotificationDetails(
      category.id,
      category.name,
      channelDescription: category.description,
      importance: Importance.defaultImportance,
      priority: Priority.defaultPriority,
    );

    final DarwinNotificationDetails iosNotificationDetails = DarwinNotificationDetails(
      categoryIdentifier: category.id,
      threadIdentifier: threadIdentifier,
    );

    final NotificationDetails notificationDetails = NotificationDetails(
      android: androidNotificationDetails,
      iOS: iosNotificationDetails,
    );

    await flutterLocalNotificationsPlugin.show(
      id,
      title,
      "$body${kDebugMode ? ' - ${DateTime.now().toIso8601String()}' : ''}",
      notificationDetails,
      payload: payload,
    );
  }

  Future<void> scheduleNotification({
    required int id,
    required String title,
    required String body,
    required DateTime scheduledDate,
    required NotificationCategory category,
    required String threadIdentifier,
    String? payload,
  }) async {
    final AndroidNotificationDetails androidNotificationDetails = AndroidNotificationDetails(
      category.id,
      category.name,
      channelDescription: category.description,
      importance: Importance.defaultImportance,
      priority: Priority.defaultPriority,
    );

    final DarwinNotificationDetails iosNotificationDetails = DarwinNotificationDetails(
      categoryIdentifier: category.id,
      threadIdentifier: threadIdentifier,
    );

    final NotificationDetails notificationDetails = NotificationDetails(
      android: androidNotificationDetails,
      iOS: iosNotificationDetails,
    );

    await flutterLocalNotificationsPlugin.zonedSchedule(
        id,
        title,
        "$body${kDebugMode ? ' - ${scheduledDate.toIso8601String()}' : ''}",
        payload: payload,
        tz.TZDateTime.from(scheduledDate, tz.local),
        notificationDetails,
        androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
        uiLocalNotificationDateInterpretation:
        UILocalNotificationDateInterpretation.absoluteTime,
    );
  }

  Future<List<PendingNotificationRequest>> pendingNotifications() async {
    return await flutterLocalNotificationsPlugin.pendingNotificationRequests();
  }

  Future<void> cancelNotification(int id) async {
    await flutterLocalNotificationsPlugin.cancel(id);
  }

  Future<void> cancelAllNotifications() async {
    await flutterLocalNotificationsPlugin.cancelAll();
  }

  Future<NotificationAppLaunchDetails?> getNotificationAppLaunchDetails() async {
    return await flutterLocalNotificationsPlugin.getNotificationAppLaunchDetails();
  }
}
