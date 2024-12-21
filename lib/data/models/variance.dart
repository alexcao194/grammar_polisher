import 'package:freezed_annotation/freezed_annotation.dart';

part 'generated/variance.freezed.dart';

part 'generated/variance.g.dart';

@freezed
class Variance with _$Variance {
  const factory Variance({
    @Default(0) @JsonKey(name: "count") double count,
    @Default("") @JsonKey(name: "label") String label,
    @Default("") @JsonKey(name: "type") String type,
    @Default(0) @JsonKey(name: "max") int max,
    @Default(0) @JsonKey(name: "r_count") int rCount,
  }) = _Variance;

  factory Variance.fromJson(Map<String, dynamic> json) => _$VarianceFromJson(json);
}
