import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';

import '../../../../data/models/check_score_result.dart';

class CheckScoreBox extends StatelessWidget {
  final CheckScoreResult result;
  const CheckScoreBox({super.key, required this.result});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SelectionArea(
          child: Html(
            data: result.result,
          ),
        )
      ],
    );
  }
}
