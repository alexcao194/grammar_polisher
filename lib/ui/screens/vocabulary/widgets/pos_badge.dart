import 'package:flutter/material.dart';

class PosBadge extends StatelessWidget {
  final String pos;
  const PosBadge({super.key, required this.pos});

  static List<Color> badgeColors = [
    Color(0xFF9F3892),
    Color(0xFFA53E3E),
    Color(0xFFAEA566),
    Color(0xFF8D81AD),
    Color(0xFF658CC8),
    Color(0xFFAE4C3F),
    Color(0xFFAF6B3C),
    Color(0xFF8F4D45),
    Color(0xFF3F8737),
    Color(0xFF37568F),
    Color(0xFFA67948),
    Color(0xFF969DCF),
    Color(0xFFA56940),
    Color(0xFF952D85),
    Color(0xFF498C42),
    Color(0xFF3E7B80),
    Color(0xFFAA786D),
  ];

  static List<String> wordTypes = [
    "indefinite article",
    "verb",
    "noun",
    "adjective",
    "adverb",
    "preposition",
    "conjunction",
    "exclamation",
    "determiner",
    "pronoun",
    "auxiliary verb",
    "number",
    "modal verb",
    "ordinal number",
    "linking verb",
    "definite article",
    "infinitive marker",
  ];

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8),
      decoration: BoxDecoration(
        color: badgeColors[wordTypes.indexOf(pos)],
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
