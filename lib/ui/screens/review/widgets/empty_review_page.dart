import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../generated/assets.dart';
import '../../../../navigation/app_router.dart';
import '../../../commons/rounded_button.dart';

class EmptyReviewPage extends StatelessWidget {
  const EmptyReviewPage({super.key});

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final colorScheme = Theme.of(context).colorScheme;
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          'No words to review',
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
            'You can add some words to your review list and use flashcards (coming soon) to memorize them.',
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
          onPressed: () => _onAddWords(context),
          child: Text(
            'Add words to review',
          ),
        ),
      ],
    );
  }

  void _onAddWords(BuildContext context) {
    context.go(RoutePaths.vocabulary);
  }
}
