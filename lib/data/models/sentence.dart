import 'package:freezed_annotation/freezed_annotation.dart';

part 'generated/sentence.freezed.dart';

part 'generated/sentence.g.dart';

@freezed
class Sentence with _$Sentence {
  const factory Sentence({
    @Default(0.0) @JsonKey(name: "generated_prob") double generatedProb,
    @Default("") @JsonKey(name: "sentence") String content,
  }) = _Sentence;

  factory Sentence.fromJson(Map<String, dynamic> json) => _$SentenceFromJson(json);
}