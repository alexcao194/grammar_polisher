import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../constants/date_formats.dart';
import '../../../../data/models/scheduled_notification.dart';
import '../../../../generated/assets.dart';
import '../../../commons/svg_button.dart';
import '../../vocabulary/bloc/vocabulary_bloc.dart';
import '../bloc/notifications_bloc.dart';

class NotificationItem extends StatelessWidget {
  final ScheduledNotification notification;

  const NotificationItem({
    super.key,
    required this.notification,
  });

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final colorScheme = Theme.of(context).colorScheme;
    final isFirst = notification.id == 0;
    return Container(
      decoration: BoxDecoration(
        color: isFirst ? colorScheme.tertiaryContainer : colorScheme.secondaryContainer,
        borderRadius: BorderRadius.circular(8),
      ),
      child: ListTile(
          title: Text(
            notification.title,
            style: textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.bold,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          subtitle: Text(
            DateFormats.fullDate.format(DateTime.parse(notification.scheduledDate)),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: textTheme.bodySmall?.copyWith(
              color: colorScheme.onSecondaryContainer,
            ),
          ),
          trailing: (isFirst)
              ? null
              : Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    SvgButton(
                      onPressed: () => _onReset(context),
                      svg: Assets.svgReset,
                      size: 16,
                    ),
                    const SizedBox(width: 8),
                    SvgButton(
                      onPressed: () => _onRemoveNotification(context),
                      svg: Assets.svgDelete,
                      size: 16,
                    ),
                  ],
                )),
    );
  }

  _onRemoveNotification(BuildContext context) {
    context.read<NotificationsBloc>().add(
          NotificationsEvent.removeScheduledNotifications(notification.id),
        );
  }

  _onReset(BuildContext context) {
    final words = context.read<VocabularyBloc>().state.words;
    context.read<NotificationsBloc>().add(
          NotificationsEvent.reminderWordTomorrow(
              word: words.firstWhere(
            (element) => element.index == notification.id,
          )),
        );
  }
}
