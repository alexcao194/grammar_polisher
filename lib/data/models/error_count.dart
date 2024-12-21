import 'package:freezed_annotation/freezed_annotation.dart';

part 'generated/error_count.freezed.dart';

part 'generated/error_count.g.dart';

@freezed
class ErrorCount with _$ErrorCount {
  const factory ErrorCount({
    @Default(0) @JsonKey(name: "count") int count,
    @Default("") @JsonKey(name: "label") String label,
    @Default("") @JsonKey(name: "type") String type,
  }) = _ErrorCount;

  factory ErrorCount.fromJson(Map<String, dynamic> json) => _$ErrorCountFromJson(json);
}
