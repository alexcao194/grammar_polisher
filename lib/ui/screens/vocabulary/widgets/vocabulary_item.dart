import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../data/models/word.dart';
import '../../../../data/models/word_status.dart';
import '../../../../generated/assets.dart';
import '../../../commons/dialogs/request_notifications_permission_dialog.dart';
import '../../../commons/dialogs/word_details_dialog.dart';
import '../../../commons/svg_button.dart';
import '../../notifications/bloc/notifications_bloc.dart';
import '../bloc/vocabulary_bloc.dart';
import 'phonetic.dart';
import 'pos_badge.dart';

class VocabularyItem extends StatelessWidget {
  final Word word;
  final bool viewOnly;
  final bool showReviewButton;
  final VoidCallback? onMastered;
  final VoidCallback? onStar;
  final VoidCallback? onReminder;

  const VocabularyItem({
    super.key,
    required this.word,
    this.showReviewButton = true,
    this.viewOnly = false,
    this.onMastered,
    this.onStar,
    this.onReminder,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    final pos = word.pos.split(', ');
    return GestureDetector(
      onTap: () => _openWordDetails(context),
      child: Padding(
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
                  SelectableText(
                    word.word,
                    style: textTheme.titleLarge?.copyWith(
                      color: colorScheme.onPrimaryContainer,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(width: 8),
                  if (showReviewButton) SvgButton(
                    backgroundColor: word.status == WordStatus.star ? colorScheme.primary : colorScheme.surface,
                    color: word.status == WordStatus.star ? colorScheme.primaryContainer : colorScheme.onPrimaryContainer,
                    svg: Assets.svgStar,
                    size: 16,
                    onPressed: () => _startWord(context),
                  ) else Spacer(),
                  if (word.status == WordStatus.star && showReviewButton)
                    ...[
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          'studying...',
                          style: textTheme.bodySmall?.copyWith(
                            color: colorScheme.onPrimaryContainer,
                          ),
                        ),
                      ),
                    ]
                  else Spacer(),
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
                        if (word.senses.isNotEmpty && word.status != WordStatus.mastered)
                          SelectableText(
                            word.senses.first.definition,
                            style: textTheme.bodyMedium?.copyWith(
                              color: colorScheme.onPrimaryContainer,
                            ),
                          )
                      ],
                    ),
                  ),
                  Row(
                    children: [
                      if (word.status == WordStatus.mastered) Text(
                        "Mastered",
                        style: textTheme.bodyMedium?.copyWith(
                          color: colorScheme.onPrimaryContainer.withValues(alpha: 0.4),
                        ),
                      ),
                      const SizedBox(width: 8),
                      SvgButton(
                        backgroundColor: word.status == WordStatus.mastered ? colorScheme.primary : colorScheme.surface,
                        color: word.status == WordStatus.mastered ? colorScheme.primaryContainer : colorScheme.onPrimaryContainer,
                        svg: Assets.svgCheck,
                        size: 16,
                        onPressed: () => _masteredWord(context),
                      ),
                    ],
                  )
                ],
              )
            ],
          ),
        ),
      ),
    );
  }

  void _masteredWord(BuildContext context) {
    onMastered?.call();
    if (viewOnly) {
      return;
    }
    if (word.status == WordStatus.mastered) {
      context.read<VocabularyBloc>().add(VocabularyEvent.changeStatus(word, WordStatus.unknown));
      return;
    }
    context.read<VocabularyBloc>().add(VocabularyEvent.changeStatus(word, WordStatus.mastered));
  }

  void _startWord(BuildContext context) {
    onStar?.call();
    if (viewOnly) {
      return;
    }
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
        return colorScheme.secondaryContainer.withAlpha(100);
      case WordStatus.star:
        return colorScheme.tertiaryContainer;
    }
  }

  void _openWordDetails(BuildContext context) {
    if (viewOnly) {
      return;
    }
    showDialog(
      context: context,
      builder: (context) => WordDetailsDialog(
        word: word,
      ),
    );
  }

  _reminderTomorrow(BuildContext context) async {
    if (viewOnly) {
      return;
    }
    final isGrantedPermission = context.read<NotificationsBloc>().state.isNotificationsGranted;
    if (!isGrantedPermission) {
      showDialog(
        context: context,
        builder: (context) => RequestNotificationsPermissionDialog(),
      );
      return;
    }
    onReminder?.call();
    context.read<NotificationsBloc>().add(NotificationsEvent.reminderWordTomorrow(word: word));
  }
}
