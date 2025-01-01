import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:hive_flutter/hive_flutter.dart';

import '../../configs/hive/hive_types.dart';

part 'generated/scheduled_notification.freezed.dart';

part 'generated/scheduled_notification.g.dart';

@freezed
@HiveType(typeId: HiveTypes.scheduledNotification)
class ScheduledNotification with _$ScheduledNotification {
  const factory ScheduledNotification({
    @HiveField(0) @Default(0) int id,
    @HiveField(1) @Default("") String title,
    @HiveField(2) @Default("") String body,
    @HiveField(3) @Default("") String scheduledDate,
  }) = _ScheduledNotification;

  factory ScheduledNotification.fromJson(Map<String, dynamic> json) => _$ScheduledNotificationFromJson(json);
}