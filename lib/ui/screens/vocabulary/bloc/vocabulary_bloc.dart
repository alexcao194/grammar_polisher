import 'package:bloc/bloc.dart';
import 'package:flutter/cupertino.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../../data/models/word.dart';
import '../../../../data/models/word_status.dart';
import '../../../../data/repositories/oxford_words_repository.dart';

part 'vocabulary_event.dart';

part 'vocabulary_state.dart';

part 'generated/vocabulary_bloc.freezed.dart';

class VocabularyBloc extends Bloc<VocabularyEvent, VocabularyState> {
  final OxfordWordsRepository _oxfordWordsRepository;

  VocabularyBloc({
    required OxfordWordsRepository oxfordWordsRepository,
  })  : _oxfordWordsRepository = oxfordWordsRepository,
        super(const VocabularyState()) {
    on<VocabularyEvent>((event, emit) async {
      await event.map(
        getAllOxfordWords: (event) => _onGetAllOxfordWords(event, emit),
        changeStatus: (event) => _onChangeStatus(event, emit),
      );
    });
  }

  _onGetAllOxfordWords(_GetAllOxfordWords event, Emitter<VocabularyState> emit) {
    debugPrint('VocabularyBloc: getAllOxfordWords');
    if (state.words.isNotEmpty) {
      debugPrint('VocabularyBloc: words is not empty - skip');
      return;
    }
    final words = _oxfordWordsRepository.getAllOxfordWords();
    debugPrint('VocabularyBloc: getAllOxfordWords - success - words ${words.length}');
    emit(state.copyWith(words: words));
  }

  _onChangeStatus(_ChangeStatus event, Emitter<VocabularyState> emit) {
    debugPrint('VocabularyBloc: changeStatus - word ${event.word.status} - status ${event.status}');
    final newWord = event.word.copyWith(status: event.status);
    final words = state.words.map((word) {
      if (word == event.word) {
        return newWord;
      }
      return word;
    }).toList();
    _oxfordWordsRepository.saveWord(newWord);
    emit(state.copyWith(words: words));
  }
}
