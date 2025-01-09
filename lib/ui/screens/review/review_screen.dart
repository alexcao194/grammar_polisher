import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../data/models/word.dart';
import '../../../data/models/word_status.dart';
import '../../../navigation/app_router.dart';
import '../../commons/base_page.dart';
import '../../commons/rounded_button.dart';
import '../vocabulary/bloc/vocabulary_bloc.dart';
import '../vocabulary/widgets/vocabulary_item.dart';
import 'widgets/empty_review_page.dart';
import 'widgets/schedule_modal.dart';

class ReviewScreen extends StatelessWidget {
  const ReviewScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final vocabularyState = context.watch<VocabularyBloc>().state;
    final reviewWords = vocabularyState.words.where((word) => word.status == WordStatus.star).toList();
    final textTheme = Theme.of(context).textTheme;
    final colorScheme = Theme.of(context).colorScheme;
    return BasePage(
      title: 'Review',
      actions: [
        GestureDetector(
          onTap: () => _showScheduleModal(context, reviewWords),
          child: Padding(
            padding: const EdgeInsets.fromLTRB(8, 4, 0, 4),
            child: Text(
              'Schedule',
              style: textTheme.titleSmall?.copyWith(
                color: colorScheme.primary,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        )
      ],
      child: reviewWords.isNotEmpty
          ? Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Expanded(
                  child: ListView.builder(
                    itemCount: reviewWords.length,
                    itemBuilder: (context, index) {
                      final word = reviewWords[index];
                      return VocabularyItem(
                        word: word,
                        showReviewButton: false,
                      );
                    },
                  ),
                ),
                const SizedBox(height: 8),
                RoundedButton(
                  onPressed: () => _startFlashcards(context, reviewWords),
                  borderRadius: 16,
                  child: Text("Flashcards"),
                ),
                const SizedBox(height: 16),
              ],
            )
          : EmptyReviewPage(),
    );
  }

  void _showScheduleModal(BuildContext context, List<Word> reviewWords) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) => ScheduleModal(
        reviewWords: reviewWords,
      ),
    );
  }

  void _startFlashcards(BuildContext context, List<Word> reviewWords) {
    context.push(RoutePaths.flashcards, extra: {'words': reviewWords});
  }
}
