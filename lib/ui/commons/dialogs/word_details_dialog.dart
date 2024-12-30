import 'package:flutter/material.dart';

import '../../../data/models/word.dart';
import '../../screens/vocabulary/widgets/phonetic.dart';
import '../../screens/vocabulary/widgets/vocabulary_item.dart';

class WordDetailsDialog extends StatelessWidget {
  final Word word;
  const WordDetailsDialog({super.key, required this.word});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SelectableText(
                word.word,
                style: textTheme.titleLarge?.copyWith(
                  color: colorScheme.onPrimaryContainer,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Phonetic(
                    phonetic: word.phonetic,
                    phoneticText: word.phoneticText,
                    backgroundColor: Color(0xFF3D9F50),
                  ),
                  const SizedBox(width: 8),
                  Phonetic(
                    phonetic: word.phoneticAm,
                    phoneticText: word.phoneticAmText,
                    backgroundColor: Color(0xFF9F3D3D),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              ...List.generate(
                word.senses.length,
                (index) {
                  final sense = word.senses[index];
                  return Align(
                    alignment: Alignment.centerLeft,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SelectableText(
                          '${index + 1}. ${sense.definition}',
                          style: textTheme.bodyMedium?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 8),
                        if (sense.examples.isNotEmpty) ...[
                          Text("Examples:"),
                          const SizedBox(height: 8),
                          ...List.generate(
                            sense.examples.length,
                                (index) {
                              final example = sense.examples[index];
                              return SelectableText(
                                '${index + 1}.${example.cf.isNotEmpty ? ' (${example.cf})' : ''} ${example.x}',
                                style: textTheme.bodyMedium,
                              );
                            },
                          ),
                          const SizedBox(height: 8),
                        ],
                      ],
                    ),
                  );
                }
              ),
            ],
          ),
        ),
      ),
    );
  }
}
