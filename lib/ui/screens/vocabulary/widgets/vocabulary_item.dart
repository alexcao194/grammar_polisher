import 'package:flutter/material.dart';

import '../../../../data/models/word.dart';
import 'phonetic.dart';
import 'pos_badge.dart';

class VocabularyItem extends StatelessWidget {
  final Word word;

  const VocabularyItem({super.key, required this.word});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    final pos = word.pos.split(', ');
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Container(
        decoration: BoxDecoration(
          color: colorScheme.primaryContainer,
          borderRadius: BorderRadius.circular(8),
        ),
        padding: const EdgeInsets.all(8),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text(
                        word.word,
                        style: textTheme.titleLarge?.copyWith(
                          color: colorScheme.onPrimaryContainer,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const Spacer(),
                      ...List.generate(
                        pos.length,
                        (index) => Padding(
                          padding: const EdgeInsets.only(right: 4),
                          child: PosBadge(pos: pos[index]),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Row(
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
                  if (word.senses.isNotEmpty)
                    SelectableText(
                      word.senses.first.definition,
                      style: textTheme.bodyMedium?.copyWith(
                        color: colorScheme.onPrimaryContainer,
                      ),
                    ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
