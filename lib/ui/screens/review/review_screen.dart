import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../constants/date_formats.dart';
import '../../../data/models/word.dart';
import '../../../data/models/word_status.dart';
import '../../../utils/app_snack_bar.dart';
import '../../commons/base_page.dart';
import '../../commons/rounded_button.dart';
import '../notifications/bloc/notifications_bloc.dart';
import '../vocabulary/bloc/vocabulary_bloc.dart';
import '../vocabulary/widgets/vocabulary_item.dart';
import 'widgets/empty_review_page.dart';
import 'widgets/time_picker.dart';

class ReviewScreen extends StatefulWidget {
  const ReviewScreen({super.key});

  @override
  State<ReviewScreen> createState() => _ReviewScreenState();
}

class _ReviewScreenState extends State<ReviewScreen> {
  String _time = '08:00';
  String _minutes = '05';
  bool _isExpanded = false;

  @override
  Widget build(BuildContext context) {
    final vocabularyState = context.watch<VocabularyBloc>().state;
    final reviewWords = vocabularyState.words.where((word) => word.status == WordStatus.star).toList();
    final textTheme = Theme.of(context).textTheme;
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
                      return VocabularyItem(word: word);
                    },
                  ),
                ),
                const SizedBox(height: 16),
                Text(
                  "Scheduled all words",
                  style: textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    Expanded(
                      flex: 2,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text("Start first notification at"),
                          const SizedBox(height: 8),
                          TimePicker(
                            value: _time,
                            hasPeriod: false,
                            isExpanded: _isExpanded,
                            onTap: _onExpand,
                            onChanged: (value) {
                              setState(() {
                                _time = value;
                              });
                            },
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text("Period (minutes)"),
                          const SizedBox(height: 8),
                          TimePicker(
                            value: _minutes,
                            hasHour: false,
                            hasPeriod: false,
                            isExpanded: _isExpanded,
                            onTap: _onExpand,
                            onChanged: (value) {
                              setState(() {
                                _minutes = value;
                              });
                            },
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                RoundedButton(
                  onPressed: () => _scheduleNotifications(reviewWords),
                  borderRadius: 16,
                  child: Text("Remind me"),
                ),
              ],
            )
          : EmptyReviewPage(),
    );
  }


  @override
  void initState() {
    super.initState();
    final now = DateTime.now();
    _time = DateFormats.timeWithOutSeconds.format(now);
  }

  _scheduleNotifications(List<Word> words) {
    final date = DateTime.now();
    final DateTime scheduledTime = DateFormats.timeWithOutSeconds.parse(_time).copyWith(
          day: date.day,
          month: date.month,
          year: date.year,
        );
    if (scheduledTime.isBefore(date)) {
      AppSnackBar.showError(context, "Scheduled time must be in the future");
      return;
    }
    final Duration period = Duration(minutes: int.parse(_minutes));
    context.read<NotificationsBloc>().add(
          NotificationsEvent.scheduleWordsReminder(
            scheduledTime: scheduledTime,
            interval: period,
            words: words,
          ),
        );
    AppSnackBar.showInfo(context, "Words reminder scheduled");
    setState(() {
      _isExpanded = false;
    });
  }

  void _onExpand() {
    setState(() {
      _isExpanded = !_isExpanded;
    });
  }
}
