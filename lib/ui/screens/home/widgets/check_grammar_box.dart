import 'package:flutter/material.dart';

import '../../../../data/models/check_grammar_result.dart';
import 'counter_item.dart';
import 'error_details_item.dart';

class CheckGrammarBox extends StatelessWidget {
  final CheckGrammarResult result;
  const CheckGrammarBox({super.key, required this.result});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return Column(
      children: [
        ...List.generate(result.errorDetails.length, (index) {
          return ErrorDetailsItem(
            index: index,
            error: result.errorDetails[index],
          );
        }),
        ...List.generate(result.errorCounts.length, (index) {
          final errorCount = result.errorCounts[index];
          return CounterItem(
            label: errorCount.label,
            count: errorCount.count,
            max: 10,
            color: colorScheme.error,
          );
        }),
      ],
    );
  }
}
