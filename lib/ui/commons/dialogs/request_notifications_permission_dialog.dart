import 'package:app_settings/app_settings.dart';
import 'package:flutter/material.dart';

import '../../../generated/assets.dart';
import '../rounded_button.dart';

class RequestNotificationsPermissionDialog extends StatelessWidget {
  const RequestNotificationsPermissionDialog({super.key});

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final colorScheme = Theme.of(context).colorScheme;
    return Dialog(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              "Notifications",
              style: textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            Image.asset(
              Assets.pngBook,
              height: 100,
            ),
            const SizedBox(height: 16),
            Text(
              "Your notifications are disabled. We need your permission to send reminders. Please enable notifications in the app settings.",
              style: textTheme.bodyMedium,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),
            RoundedButton(
              onPressed: () {
                Navigator.of(context).pop();
                AppSettings.openAppSettings(type: AppSettingsType.notification);
              },
              child: Text("Open settings"),
            ),
            const SizedBox(height: 8),
            RoundedButton(
              backgroundColor: colorScheme.secondary,
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text("Not now"),
            ),
          ],
        ),
      ),
    );
  }
}
