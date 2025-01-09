import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../../constants/date_formats.dart';
import '../../../../data/models/word.dart';
import '../../../../utils/app_snack_bar.dart';
import '../../../commons/banner_ads.dart';
import '../../../commons/dialogs/request_notifications_permission_dialog.dart';
import '../../../commons/rounded_button.dart';
import '../../notifications/bloc/notifications_bloc.dart';
import 'time_picker.dart';

class ScheduleModal extends StatefulWidget {
  final List<Word> reviewWords;
  const ScheduleModal ({super.key, required this.reviewWords});

  @override
  State<ScheduleModal> createState() => _ScheduleModalState();
}

class _ScheduleModalState extends State<ScheduleModal> {
  String _time = '08:00';
  String _minutes = '05';
  bool _isExpanded = false;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final colorScheme = Theme.of(context).colorScheme;
    final size = MediaQuery.of(context).size;
    return Container(
      height: size.height * 0.7,
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: [
          Text(
            "Scheduled Reminders",
            style: textTheme.titleMedium?.copyWith(
              color: colorScheme.primary,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            "Set up reminders to review your words",
            style: textTheme.bodyMedium?.copyWith(
              color: colorScheme.onSurface.withAlpha(150),
            ),
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              Expanded(
                flex: 2,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Start first reminder at",
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 8),
                    TimePicker(
                      value: _time,
                      hasPeriod: false,
                      isExpanded: _isExpanded,
                      onTap: _onExpand,
                      onChanged: (value) {
                        setState(() {
                          _time = value;
                        });
                      },
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Period (minutes)",
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 8),
                    TimePicker(
                      value: _minutes,
                      hasHour: false,
                      hasPeriod: false,
                      isExpanded: _isExpanded,
                      onTap: _onExpand,
                      onChanged: (value) {
                        setState(() {
                          _minutes = value;
                        });
                      },
                    ),
                  ],
                ),
              ),
            ],
          ),
          const Spacer(),
          BannerAds(),
          const SizedBox(height: 16),
          RoundedButton(
            onPressed: () => _scheduleNotifications(widget.reviewWords),
            borderRadius: 16,
            child: Text("Remind me"),
          ),
        ],
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    final now = DateTime.now();
    _time = DateFormats.timeWithOutSeconds.format(now.add(const Duration(minutes: 5)));
  }

  _scheduleNotifications(List<Word> words) {
    final isGrantedNotificationsPermission = context.read<NotificationsBloc>().state.isNotificationsGranted;
    if (!isGrantedNotificationsPermission) {
      showDialog(
        context: context,
        builder: (_) => const RequestNotificationsPermissionDialog(),
      );
      return;
    }
    final date = DateTime.now();
    final DateTime scheduledTime = DateFormats.timeWithOutSeconds.parse(_time).copyWith(
      day: date.day,
      month: date.month,
      year: date.year,
    );
    if (scheduledTime.isBefore(date)) {
      context.pop();
      AppSnackBar.showError(context, "Scheduled time must be in the future");
      return;
    }
    final Duration period = Duration(minutes: int.parse(_minutes));
    context.read<NotificationsBloc>().add(
      NotificationsEvent.scheduleWordsReminder(
        scheduledTime: scheduledTime,
        interval: period,
        words: words,
      ),
    );
    AppSnackBar.showSuccess(context, "Words reminder scheduled");
    context.pop();
    setState(() {
      _isExpanded = false;
    });
  }

  void _onExpand() {
    setState(() {
      _isExpanded = !_isExpanded;
    });
  }
}
