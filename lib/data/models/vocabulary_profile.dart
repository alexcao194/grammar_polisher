import 'package:freezed_annotation/freezed_annotation.dart';

part 'generated/vocabulary_profile.freezed.dart';

part 'generated/vocabulary_profile.g.dart';

@freezed
class VocabularyProfile with _$VocabularyProfile {
  const factory VocabularyProfile({
    @Default(0) @JsonKey(name: "count") int count,
    @Default("") @JsonKey(name: "label") String label,
    @Default("") @JsonKey(name: "type") String type,
    @Default([]) @JsonKey(name: "words") List<String> words,
  }) = _VocabularyProfile;

  factory VocabularyProfile.fromJson(Map<String, dynamic> json) => _$VocabularyProfileFromJson(json);
}
