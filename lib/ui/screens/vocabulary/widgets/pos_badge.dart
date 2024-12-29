import 'package:flutter/material.dart';

import '../../../../constants/word_pos.dart';

class PosBadge extends StatelessWidget {
  final String pos;
  const PosBadge({super.key, required this.pos});

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8),
      decoration: BoxDecoration(
        color: WordPos.fromString(pos).color,
        borderRadius: BorderRadius.circular(6),
      ),
      child: Text(
        pos,
        style: textTheme.titleSmall?.copyWith(
          color: Colors.white,
        ),
      ),
    );
  }
}
