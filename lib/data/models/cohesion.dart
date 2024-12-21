import 'package:freezed_annotation/freezed_annotation.dart';

part 'generated/cohesion.freezed.dart';

part 'generated/cohesion.g.dart';

@freezed
class Cohesion with _$Cohesion {
  const factory Cohesion({
    @Default(0) @JsonKey(name: "count") int count,
    @Default("") @JsonKey(name: "label") String label,
    @Default("") @JsonKey(name: "type") String type,
    @Default([]) @JsonKey(name: "words") List<String> words,
  }) = _Cohesion;

  factory Cohesion.fromJson(Map<String, dynamic> json) => _$CohesionFromJson(json);
}
