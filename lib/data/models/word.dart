import 'package:freezed_annotation/freezed_annotation.dart';

import 'sense.dart';

part 'generated/word.freezed.dart';

part 'generated/word.g.dart';

@freezed
class Word with _$Word {
  const factory Word({
    @Default("") String word,
    @Default("") String pos,
    @Default("") String phonetic,
    @Default("") String phoneticText,
    @Default("") String phoneticAm,
    @Default("") String phoneticAmText,
    @Default([]) List<Sense> senses,
  }) = _Word;

  factory Word.fromJson(Map<String, dynamic> json) => _$WordFromJson(json);
}