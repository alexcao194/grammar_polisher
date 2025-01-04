import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../data/models/word.dart';
import '../../../data/models/word_status.dart';
import '../../../navigation/app_router.dart';
import '../../../utils/ads_tools.dart';
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
    return BasePage(
      title: 'Review',
      child: reviewWords.isNotEmpty
          ? Column(
        crossAxisAlignment: CrossAxisAlignment.start,
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
            onPressed: () => _showScheduleModal(context, reviewWords),
            borderRadius: 16,
            child: Text("Schedule reminders"),
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

  void _startFlashcards(BuildContext context, List<Word> reviewWords) async {
    await context.push(RoutePaths.flashcards, extra: {'words': reviewWords});
    AdsTools.requestNewInterstitial();
  }
}