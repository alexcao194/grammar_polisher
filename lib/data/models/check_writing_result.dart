import 'package:freezed_annotation/freezed_annotation.dart';

import 'cohesion.dart';
import 'variance.dart';
import 'vocabulary_profile.dart';
import 'result.dart';

part 'generated/check_writing_result.freezed.dart';

part 'generated/check_writing_result.g.dart';

@freezed
class CheckWritingResult extends Result with _$CheckWritingResult {
  const factory CheckWritingResult({
    @Default([]) @JsonKey(name: "variance") List<Variance> variance,
    @Default([]) @JsonKey(name: "cohesion") List<Cohesion> cohesion,
    @Default([]) @JsonKey(name: "vocabulary_profile") List<VocabularyProfile> vocabularyProfile,
  }) = _CheckWritingResult;

  factory CheckWritingResult.fromJson(Map<String, dynamic> json) => _$CheckWritingResultFromJson(json);
}