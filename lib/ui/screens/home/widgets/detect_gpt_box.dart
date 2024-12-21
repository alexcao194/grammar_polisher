import 'package:flutter/material.dart';

import '../../../../data/models/detect_gpt_result.dart';

class DetectGptBox extends StatelessWidget {
  final DetectGptResult result;
  const DetectGptBox({super.key, required this.result});

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final colorScheme = Theme.of(context).colorScheme;
    final totalProb = result.generatedProb * 100;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(
          'Overall probability of GPT use: ${totalProb.toStringAsFixed(2)}%',
          style: textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 16),
        Text(
          'Sentences:',
          style: textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
        ...List.generate(
          result.sentences.length,
          (index) {
            final prob = result.sentences[index].generatedProb * 100;
            return Padding(
              padding: const EdgeInsets.symmetric(vertical: 8.0),
              child: SelectableText(
                "${index + 1}. ${result.sentences[index].content} - ${prob.toStringAsFixed(2)}%",
                style: textTheme.bodyMedium?.copyWith(
                  color: prob > 50 ? colorScheme.error : colorScheme.onSurface,
                ),
              ),
            );
          }
        ),
      ]
    );
  }
}
