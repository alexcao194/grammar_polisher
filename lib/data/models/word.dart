import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:hive_flutter/hive_flutter.dart';

import '../../configs/hive/hive_types.dart';
import 'sense.dart';
import 'word_status.dart';

part 'generated/word.freezed.dart';

part 'generated/word.g.dart';

@freezed
@HiveType(typeId: HiveTypes.word)
class Word with _$Word {
  const factory Word({
    @HiveField(0) @Default("") String word,
    @HiveField(1) @Default("") String pos,
    @HiveField(2) @Default("") String phonetic,
    @HiveField(3) @Default("") String phoneticText,
    @HiveField(4) @Default("") String phoneticAm,
    @HiveField(5) @Default("") String phoneticAmText,
    @HiveField(6) @Default([]) List<Sense> senses,
    @HiveField(7) @Default(WordStatus.unknown) WordStatus status,
    @HiveField(8) @Default(0) int index,
    @HiveField(9) @Default(null) String? userDefinition,
  }) = _Word;

  factory Word.fromJson(Map<String, dynamic> json) => _$WordFromJson(json);
}