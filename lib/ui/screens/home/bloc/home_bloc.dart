import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:flutter/foundation.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../../core/failure.dart';
import '../../../../data/models/result.dart';
import '../../../../data/repositories/home_repository.dart';

part 'home_event.dart';

part 'home_state.dart';

part 'generated/home_bloc.freezed.dart';

class HomeBloc extends Bloc<HomeEvent, HomeState> {
  final HomeRepository _homeRepository;

  HomeBloc({
    required HomeRepository polisherRepository,
  })  : _homeRepository = polisherRepository,
        super(const HomeState()) {
    on<HomeEvent>((event, emit) async {
      await event.map(
        improveWriting: (event) => _onImproveWriting(event, emit),
        checkGrammar: (event) => _onCheckGrammar(event, emit),
        detectGpt: (event) => _onDetectGpt(event, emit),
        checkLevel: (event) => _onCheckLevel(event, emit),
        checkScore: (event) => _onCheckScore(event, emit),
        checkWriting: (event) => _onCheckWriting(event, emit),
      );
    });
  }

  FutureOr<void> _onImproveWriting(ImproveWriting event, Emitter<HomeState> emit) async {
    emit(state.copyWith(isLoading: true));
    debugPrint('HomeBloc: _improveWriting');
    final result = await _homeRepository.improveWriting(event.text);
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

  FutureOr<void> _onCheckGrammar(CheckGrammar event, Emitter<HomeState> emit) async {
    emit(state.copyWith(isLoading: true));
    debugPrint('HomeBloc: _checkGrammar');
    final result = await _homeRepository.checkGrammar(event.text);
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

  FutureOr<void> _onDetectGpt(DetectGpt event, Emitter<HomeState> emit) async {
    emit(state.copyWith(isLoading: true));
    debugPrint('HomeBloc: _detectGpt');
    final result = await _homeRepository.detectGpt(event.text);
    result.fold(
      (failure) {
        debugPrint('HomeBloc: _detectGpt: $failure');
        emit(state.copyWith(isLoading: false, failure: failure));
        emit(state.copyWith(failure: null));
      },
      (detectGptResult) {
        debugPrint('HomeBloc: _detectGpt - success');
        emit(state.copyWith(isLoading: false, result: detectGptResult));
      }
    );
  }

  FutureOr<void> _onCheckLevel(CheckLevel event, Emitter<HomeState> emit) async {
    emit(state.copyWith(isLoading: true));
    debugPrint('HomeBloc: _checkLevel');
    final result = await _homeRepository.checkLevel(event.text);
    result.fold(
      (failure) {
        debugPrint('HomeBloc: _checkLevel: $failure');
        emit(state.copyWith(isLoading: false, failure: failure));
        emit(state.copyWith(failure: null));
      },
      (checkLevelResult) {
        debugPrint('HomeBloc: _checkLevel - success');
        emit(state.copyWith(isLoading: false, result: checkLevelResult));
      }
    );
  }

  FutureOr<void> _onCheckScore(CheckScore event, Emitter<HomeState> emit) async {
    emit(state.copyWith(isLoading: true));
    debugPrint('HomeBloc: _checkScore');
    final result = await _homeRepository.checkScore(text: event.text, type: event.type);
    result.fold(
      (failure) {
        debugPrint('HomeBloc: _checkScore: $failure');
        emit(state.copyWith(isLoading: false, failure: failure));
        emit(state.copyWith(failure: null));
      },
      (checkScoreResult) {
        debugPrint('HomeBloc: _checkScore - success');
        emit(state.copyWith(isLoading: false, result: checkScoreResult));
      }
    );
  }

  FutureOr<void> _onCheckWriting(CheckWriting event, Emitter<HomeState> emit) async {
    emit(state.copyWith(isLoading: true));
    debugPrint('HomeBloc: _checkWriting');
    final result = await _homeRepository.checkWriting(event.text);
    result.fold(
      (failure) {
        debugPrint('HomeBloc: _checkWriting: $failure');
        emit(state.copyWith(isLoading: false, failure: failure));
        emit(state.copyWith(failure: null));
      },
      (result) {
        debugPrint('HomeBloc: _checkWriting - success');
        emit(state.copyWith(isLoading: false, result: result));
      }
    );
  }
}
