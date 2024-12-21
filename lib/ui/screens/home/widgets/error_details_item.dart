import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';

import '../../../../data/models/error_details.dart';

class ErrorDetailsItem extends StatelessWidget {
  final int index;
  final ErrorDetails error;
  const ErrorDetailsItem({super.key, required this.index, required this.error});

  @override
  Widget build(BuildContext context) {
    final suggestions = error.suggestions.map((entry) => entry.values.first).join(', ');
    final colorScheme = Theme.of(context).colorScheme;
    return SelectionArea(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8.0),
        child: Container(
          decoration: BoxDecoration(
            color: colorScheme.secondaryContainer.withAlpha(100),
            borderRadius: BorderRadius.circular(8),
          ),
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              Html(
                data: "<b>${index + 1}. You wrote:</b> ${error.markedText}",
              ),
              Html(
                data: "<b>Feedback:</b> ${error.message}",
              ),
              Html(
                data: "<b>Error type:</b> ${error.category}",
              ),
              Html(
                data: "<b>Suggestions:</b> $suggestions",
              ),
            ],
          ),
        ),
      ),
    );
  }
}
