import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:flutter/foundation.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../../core/failure.dart';
import '../../../../data/models/result.dart';
import '../../../../data/repositories/polisher_repository.dart';

part 'home_event.dart';

part 'home_state.dart';

part 'generated/home_bloc.freezed.dart';

class HomeBloc extends Bloc<HomeEvent, HomeState> {
  final PolisherRepository _polisherRepository;

  HomeBloc({
    required PolisherRepository polisherRepository,
  })  : _polisherRepository = polisherRepository,
        super(const HomeState()) {
    on<HomeEvent>((event, emit) async {
      await event.map(
        improveWriting: (event) => _improveWriting(event, emit),
        checkGrammar: (event) => _checkGrammar(event, emit),
      );
    });
  }

  FutureOr<void> _improveWriting(ImproveWriting event, Emitter<HomeState> emit) async {
    emit(state.copyWith(isLoading: true));
    debugPrint('HomeBloc: _improveWriting');
    final result = await _polisherRepository.improveWriting(event.text);
    result.fold(
      (failure) {
        debugPrint('HomeBloc: _improveWriting: $failure');
        emit(state.copyWith(isLoading: false, failure: failure));
        emit(state.copyWith(failure: null));
      },
      (improveWritingResult) {
        debugPrint('HomeBloc: _improveWriting - success');
        emit(state.copyWith(isLoading: false, result: improveWritingResult));
      }
    );
  }

  FutureOr<void> _checkGrammar(CheckGrammar event, Emitter<HomeState> emit) async {
    emit(state.copyWith(isLoading: true));
    debugPrint('HomeBloc: _checkGrammar');
    final result = await _polisherRepository.checkGrammar(event.text);
    result.fold(
      (failure) {
        debugPrint('HomeBloc: _checkGrammar: $failure');
        emit(state.copyWith(isLoading: false, failure: failure));
        emit(state.copyWith(failure: null));
      },
      (checkGrammarResult) {
        debugPrint('HomeBloc: _checkGrammar - success');
        emit(state.copyWith(isLoading: false, result: checkGrammarResult));
      }
    );
  }
}
