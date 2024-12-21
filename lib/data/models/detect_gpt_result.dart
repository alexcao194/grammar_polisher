import 'package:freezed_annotation/freezed_annotation.dart';

import 'sentence.dart';
import 'result.dart';

part 'generated/detect_gpt_result.freezed.dart';

part 'generated/detect_gpt_result.g.dart';

@freezed
class DetectGptResult extends Result with _$DetectGptResult {
  const factory DetectGptResult({
    @Default(0.0) @JsonKey(name: "completely_generated_prob") double generatedProb,
    @Default([]) @JsonKey(name: "sentences") List<Sentence> sentences,
  }) = _DetectGptResult;

  factory DetectGptResult.fromJson(Map<String, dynamic> json) => _$DetectGptResultFromJson(json);
}
