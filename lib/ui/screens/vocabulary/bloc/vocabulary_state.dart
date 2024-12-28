part of 'vocabulary_bloc.dart';

@freezed
class VocabularyState with _$VocabularyState {
  const factory VocabularyState({
    @Default(false) bool isLoading,
    @Default(null) Failure? failure,
    @Default([]) List<Word> words,
  }) = _VocabularyState;
}
