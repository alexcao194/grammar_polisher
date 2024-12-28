part of 'vocabulary_bloc.dart';

@freezed
class VocabularyEvent with _$VocabularyEvent {
  const factory VocabularyEvent.getOxfordWordsByLetter(String letter) = _GetOxfordWordsByLetter;
  const factory VocabularyEvent.getAllOxfordWords() = _GetAllOxfordWords;
}
