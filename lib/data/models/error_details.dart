import 'package:freezed_annotation/freezed_annotation.dart';

part 'generated/error_details.freezed.dart';

part 'generated/error_details.g.dart';

@freezed
class ErrorDetails with _$ErrorDetails {
  const factory ErrorDetails({
    @Default("") @JsonKey(name: "category_name") String category,
    @Default("") @JsonKey(name: "context") String context,
    @Default("") @JsonKey(name: "marked_text") String markedText,
    @Default("") @JsonKey(name: "msg") String message,
    @Default("") @JsonKey(name: "rule_id") String ruleId,
    @Default("") @JsonKey(name: "rule_sub_id") String ruleSubId,
    @Default([]) @JsonKey(name: "suggestions") List<Map<String, dynamic>> suggestions,
  }) = _ErrorDetails;

  factory ErrorDetails.fromJson(Map<String, dynamic> json) => _$ErrorDetailsFromJson(json);
}