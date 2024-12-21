import 'dart:math';

import 'package:flutter/material.dart';

class CounterItem extends StatelessWidget {
  final String label;
  final int count;
  final int max;
  final Color? color;
  final List<String> details;

  const CounterItem({
    super.key,
    required this.label,
    required this.count,
    required this.max,
    this.color,
    this.details = const [],
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    final progressValue = count / max;
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
              '$label: $count',
              style: textTheme.titleSmall?.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 8),
            LinearProgressIndicator(
              borderRadius: BorderRadius.circular(8),
              value: min(progressValue, 1),
              backgroundColor: colorScheme.secondaryContainer,
              valueColor: AlwaysStoppedAnimation<Color>(
                color ?? colorScheme.primary,
              ),
            ),
            if (details.isNotEmpty) ...[
              const SizedBox(height: 8),
              SelectableText(
                details.join(', ')
              ),
            ],
          ],
        ),
      ),
    );
  }
}
