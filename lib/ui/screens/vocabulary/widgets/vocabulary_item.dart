import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../data/models/word.dart';
import '../../../../data/models/word_status.dart';
import '../../../../generated/assets.dart';
import '../../../commons/svg_button.dart';
import '../bloc/vocabulary_bloc.dart';
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
          color: _getBackgroundColor(word.status, colorScheme),
          borderRadius: BorderRadius.circular(8),
        ),
        padding: const EdgeInsets.all(8),
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
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
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
                Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  mainAxisSize: MainAxisSize.max,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    SvgButton(
                      backgroundColor: word.status == WordStatus.mastered ? colorScheme.primary : colorScheme.surface,
                      color: word.status == WordStatus.mastered ? Colors.white : colorScheme.onPrimaryContainer,
                      svg: Assets.svgCheck,
                      size: 16,
                      onPressed: () => _masteredWord(context),
                    ),
                    const SizedBox(height: 8),
                    SvgButton(
                      backgroundColor: word.status == WordStatus.star ? colorScheme.primary : colorScheme.surface,
                      color: word.status == WordStatus.star ? Colors.white : colorScheme.onPrimaryContainer,
                      svg: Assets.svgStar,
                      size: 16,
                      onPressed: () => _startWord(context),
                    ),
                  ],
                )
              ],
            )
          ],
        ),
      ),
    );
  }

  void _masteredWord(BuildContext context) {
    if (word.status == WordStatus.mastered) {
      context.read<VocabularyBloc>().add(VocabularyEvent.changeStatus(word, WordStatus.unknown));
      return;
    }
    context.read<VocabularyBloc>().add(VocabularyEvent.changeStatus(word, WordStatus.mastered));
  }

  void _startWord(BuildContext context) {
    if (word.status == WordStatus.star) {
      context.read<VocabularyBloc>().add(VocabularyEvent.changeStatus(word, WordStatus.unknown));
      return;
    }
    context.read<VocabularyBloc>().add(VocabularyEvent.changeStatus(word, WordStatus.star));
  }

  _getBackgroundColor(WordStatus status, ColorScheme colorScheme) {
    switch (status) {
      case WordStatus.unknown:
        return colorScheme.primaryContainer;
      case WordStatus.mastered:
        return Colors.grey[300];
      case WordStatus.star:
        return colorScheme.tertiaryContainer;
    }
  }
}
