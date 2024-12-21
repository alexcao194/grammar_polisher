import 'package:freezed_annotation/freezed_annotation.dart';

import 'error_count.dart';
import 'error_details.dart';
import 'result.dart';

part 'generated/check_grammar_result.freezed.dart';

part 'generated/check_grammar_result.g.dart';

@freezed
class CheckGrammarResult extends Result with _$CheckGrammarResult {
  const factory CheckGrammarResult({
    @Default([]) @JsonKey(name: "error_dnsty") List<ErrorCount> errorCounts,
    @Default([]) @JsonKey(name: "result") List<ErrorDetails> errorDetails,
  }) = _CheckGrammarResult;

  factory CheckGrammarResult.fromJson(Map<String, dynamic> json) => _$CheckGrammarResultFromJson(json);
}