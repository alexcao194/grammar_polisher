import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../data/models/word_status.dart';
import '../../commons/base_page.dart';
import '../vocabulary/bloc/vocabulary_bloc.dart';
import '../vocabulary/widgets/vocabulary_item.dart';
import 'widgets/empty_review_page.dart';

class ReviewScreen extends StatefulWidget {
  const ReviewScreen({super.key});

  @override
  State<ReviewScreen> createState() => _ReviewScreenState();
}

class _ReviewScreenState extends State<ReviewScreen> {
  @override
  Widget build(BuildContext context) {
    final vocabularyState = context.watch<VocabularyBloc>().state;
    final reviewWords = vocabularyState.words.where((word) => word.status == WordStatus.star).toList();
    return BasePage(
      title: 'Review',
      child: reviewWords.isNotEmpty
          ? ListView.builder(
              itemCount: reviewWords.length,
              itemBuilder: (context, index) {
                final word = reviewWords[index];
                return VocabularyItem(word: word);
              },
            )
          : EmptyReviewPage(),
    );
  }

  @override
  void initState() {
    super.initState();
    context.read<VocabularyBloc>().add(const VocabularyEvent.getAllOxfordWords());
  }
}
