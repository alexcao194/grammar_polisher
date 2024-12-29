import 'dart:ui';

enum WordPos {
  indefiniteArticle,
  verb,
  noun,
  adjective,
  adverb,
  preposition,
  conjunction,
  exclamation,
  determiner,
  pronoun,
  auxiliaryVerb,
  number,
  modalVerb,
  ordinalNumber,
  linkingVerb,
  definiteArticle,
  infinitiveMarker;

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
    'indefinite article',
    'verb',
    'noun',
    'adjective',
    'adverb',
    'preposition',
    'conjunction',
    'exclamation',
    'determiner',
    'pronoun',
    'auxiliary verb',
    'number',
    'modal verb',
    'ordinal number',
    'linking verb',
    'definite article',
    'infinitive marker',
  ];

  String get value => wordTypes[index];

  Color get color => badgeColors[index];

  static WordPos fromString(String pos) {
    return WordPos.values[wordTypes.indexOf(pos)];
  }
}