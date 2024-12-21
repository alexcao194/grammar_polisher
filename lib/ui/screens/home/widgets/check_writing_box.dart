import 'package:flutter/material.dart';

import '../../../../data/models/check_writing_result.dart';
import 'counter_item.dart';

class CheckWritingBox extends StatelessWidget {
  final CheckWritingResult result;

  const CheckWritingBox({super.key, required this.result});

  @override
  Widget build(BuildContext context) {
    final cohesion = result.cohesion.where((element) => element.count > 0).toList();
    final variance = result.variance.where((element) => element.count > 0).toList();
    final vocabularyProfile = result.vocabularyProfile.where((element) => element.count > 0).toList();
    final textTheme = Theme.of(context).textTheme;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Cohesion: ",
          style: textTheme.titleSmall?.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
        ...List.generate(cohesion.length, (index) {
          final data = cohesion[index];
          return CounterItem(
            label: data.label,
            count: data.count,
            max: 10,
            details: data.words,
          );
        }),
        const SizedBox(height: 16),
        Text(
          "Variance: ",
          style: textTheme.titleSmall?.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
        ...List.generate(variance.length, (index) {
          final data = variance[index];
          return CounterItem(
            label: data.label,
            count: data.rCount,
            max: data.max,
          );
        }),
        const SizedBox(height: 16),
        Text(
          "Vocabulary Profile: ",
          style: textTheme.titleSmall?.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
        ...List.generate(vocabularyProfile.length, (index) {
          final data = vocabularyProfile[index];
          return CounterItem(
            label: data.label,
            count: data.count,
            max: 10,
            details: data.words,
          );
        }),
      ],
    );
  }
}
