import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';

import '../../../../data/models/check_level_result.dart';

class CheckLevelBox extends StatelessWidget {
  final CheckLevelResult result;
  const CheckLevelBox({super.key, required this.result});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return SelectionArea(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Html(
            data: "<b>Overall CEFR level: <span>${result.cefrLevel.toUpperCase()}</span></b>",
            style: {
              "span": Style(
                color: colorScheme.primary,
              ),
            },
          ),
          ...result.cefrFeedback.entries.map(
            (entry) => Padding(
              padding: const EdgeInsets.symmetric(vertical: 8.0),
              child: Html(
                data: "<b>${entry.key.toUpperCase()}</b>: ${entry.value}",
                style: {
                  "b": Style(
                    color: colorScheme.primary,
                  ),
                },
              )
            ),
          ),
        ],
      ),
    );
  }
}
