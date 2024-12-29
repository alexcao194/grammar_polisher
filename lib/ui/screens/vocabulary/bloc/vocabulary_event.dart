part of 'vocabulary_bloc.dart';

@freezed
class VocabularyEvent with _$VocabularyEvent {
  const factory VocabularyEvent.getAllOxfordWords() = _GetAllOxfordWords;
  const factory VocabularyEvent.changeStatus(Word word, WordStatus status) = _ChangeStatus;
}
