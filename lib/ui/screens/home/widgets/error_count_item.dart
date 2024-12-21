import 'dart:math';

import 'package:flutter/material.dart';

import '../../../../data/models/error_count.dart';

class ErrorCountItem extends StatelessWidget {
  final ErrorCount errorCount;
  const ErrorCountItem({super.key, required this.errorCount});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    final progressValue = errorCount.count / 10;
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Container(
        decoration: BoxDecoration(
          color: colorScheme.secondaryContainer,
          borderRadius: BorderRadius.circular(8),
        ),
        padding: const EdgeInsets.all(16),
        width: double.infinity,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '${errorCount.label}: ${errorCount.count}',
              style: textTheme.titleSmall?.copyWith(
                fontWeight: FontWeight.w600,
              )
            ),
            const SizedBox(height: 8),
            LinearProgressIndicator(
              borderRadius: BorderRadius.circular(8),
              value: min(progressValue, 1),
              backgroundColor: colorScheme.secondaryContainer,
              valueColor: AlwaysStoppedAnimation<Color>(colorScheme.error),
            )
          ],
        ),
      ),
    );
  }
}
