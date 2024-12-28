import 'package:bloc/bloc.dart';
import 'package:flutter/cupertino.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../../core/failure.dart';
import '../../../../data/models/word.dart';
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
        getOxfordWordsByLetter: (event) => _onGetOxfordWordsByLetter(event, emit),
        getAllOxfordWords: (event) => _onGetAllOxfordWords(event, emit),
      );
    });
  }

  _onGetOxfordWordsByLetter(_GetOxfordWordsByLetter event, Emitter<VocabularyState> emit) async {
    debugPrint('VocabularyBloc: getOxfordWordsByLetter: ${event.letter}');
    final result = await _oxfordWordsRepository.getOxfordWordsByLetter(event.letter);
    result.fold(
      (failure) {
        debugPrint('VocabularyBloc: getOxfordWordsByLetter: failure: $failure');
        emit(state.copyWith(failure: failure));
        emit(state.copyWith(failure: null));
      },
      (words) {
        debugPrint('VocabularyBloc: getOxfordWordsByLetter: success: ${words.length}');
        final List<Word> newWords = [...state.words, ...words]..sort((a, b) => a.word.compareTo(b.word));
        emit(state.copyWith(words: newWords));
      },
    );
  }

  _onGetAllOxfordWords(_GetAllOxfordWords event, Emitter<VocabularyState> emit) async {
    debugPrint('VocabularyBloc: getAllOxfordWords');
    final result = await _oxfordWordsRepository.getAllOxfordWords();
    result.fold(
      (failure) {
        debugPrint('VocabularyBloc: getAllOxfordWords: failure: $failure');
        emit(state.copyWith(failure: failure));
        emit(state.copyWith(failure: null));
      },
      (words) {
        debugPrint('VocabularyBloc: getAllOxfordWords: success: ${words.length}');
        emit(state.copyWith(words: words));
      },
    );
  }
}
