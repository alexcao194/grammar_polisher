import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../data/models/word_status.dart';
import '../../commons/base_page.dart';
import '../../commons/dialogs/word_details_dialog.dart';
import '../notifications/bloc/notifications_bloc.dart';
import '../vocabulary/bloc/vocabulary_bloc.dart';
import '../vocabulary/widgets/vocabulary_item.dart';
import 'widgets/empty_review_page.dart';

class ReviewScreen extends StatefulWidget {
  final int? wordId;

  const ReviewScreen({super.key, this.wordId});

  @override
  State<ReviewScreen> createState() => _ReviewScreenState();
}

class _ReviewScreenState extends State<ReviewScreen> {
  late final AppLifecycleListener _appLifecycleListener;

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
    _appLifecycleListener = AppLifecycleListener(
      onShow: () {
        debugPrint('NotificationsScreen: onShow');
        // this is needed to update the permissions status when the user returns to the app after changing the notification settings
        context.read<NotificationsBloc>().add(const NotificationsEvent.requestPermissions());
      },
    );
    if (widget.wordId != null) {
      final word = context.read<VocabularyBloc>().state.words.firstWhere(
            (element) => element.index == widget.wordId,
          );
      WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
        showDialog(
          context: context,
          builder: (context) => WordDetailsDialog(word: word),
        );
      });
    }
  }

  @override
  void dispose() {
    _appLifecycleListener.dispose();
    super.dispose();
  }
}
