import 'package:app_settings/app_settings.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../generated/assets.dart';
import '../../../../navigation/app_router.dart';
import '../../../commons/rounded_button.dart';

class EmptyNotificationsPage extends StatelessWidget {
  const EmptyNotificationsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final colorScheme = Theme.of(context).colorScheme;
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          'Permission is not granted.',
          style: textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 16),
        Image.asset(
          Assets.pngBook,
        ),
        const SizedBox(height: 16),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Text(
            'To receive and manage reminders, please grant the permission.',
            style: textTheme.bodyMedium?.copyWith(
              color: colorScheme.onSurface.withAlpha(150),
            ),
            textAlign: TextAlign.center,
          ),
        ),
        const SizedBox(height: 8),
        RoundedButton(
          expand: false,
          padding: const EdgeInsets.symmetric(horizontal: 16),
          borderRadius: 8,
          onPressed: () => _onGrantPermission(context),
          child: Text(
            'Grant Permission',
          ),
        ),
      ],
    );
  }

  void _onGrantPermission(BuildContext context) {
    AppSettings.openAppSettings(type: AppSettingsType.notification);
  }
}
