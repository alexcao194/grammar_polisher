import 'package:freezed_annotation/freezed_annotation.dart';

import 'result.dart';

part 'generated/check_level_result.freezed.dart';

part 'generated/check_level_result.g.dart';

@freezed
class CheckLevelResult extends Result with _$CheckLevelResult {
  const factory CheckLevelResult({
    @Default({}) @JsonKey(name: "cefrFeedback") Map<String, dynamic> cefrFeedback,
    @Default("") @JsonKey(name: "cefr_level") String cefrLevel,
  }) = _CheckLevelResult;

  factory CheckLevelResult.fromJson(Map<String, dynamic> json) => _$CheckLevelResultFromJson(json);
}