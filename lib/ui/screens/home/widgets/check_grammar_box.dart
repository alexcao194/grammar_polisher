import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';

import '../../../../data/models/check_grammar_result.dart';
import 'error_count_item.dart';
import 'error_details_item.dart';

class CheckGrammarBox extends StatelessWidget {
  final CheckGrammarResult result;
  const CheckGrammarBox({super.key, required this.result});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ...List.generate(result.errorDetails.length, (index) {
          return ErrorDetailsItem(
            index: index,
            error: result.errorDetails[index],
          );
        }),
        ...List.generate(result.errorCounts.length, (index) {
          return ErrorCountItem(
            errorCount: result.errorCounts[index],
          );
        }),
      ],
    );
  }
}
