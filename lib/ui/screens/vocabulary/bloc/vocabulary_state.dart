part of 'vocabulary_bloc.dart';

@freezed
class VocabularyState with _$VocabularyState {
  const factory VocabularyState({
    @Default([]) List<Word> words,
  }) = _VocabularyState;
}
