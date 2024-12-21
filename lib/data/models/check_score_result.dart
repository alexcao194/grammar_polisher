import 'package:freezed_annotation/freezed_annotation.dart';

import 'result.dart';

part 'generated/check_score_result.freezed.dart';

part 'generated/check_score_result.g.dart';

@freezed
class CheckScoreResult extends Result with _$CheckScoreResult {
  const factory CheckScoreResult({
    @Default("") @JsonKey(name: "result") String result,
    @Default(0) @JsonKey(name: "score") int score,
  }) = _CheckScoreResult;

  factory CheckScoreResult.fromJson(Map<String, dynamic> json) => _$CheckScoreResultFromJson(json);
}