import 'package:bloc/bloc.dart';
import 'package:flutter/foundation.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../../data/models/settings_snapshot.dart';
import '../../../../data/repositories/settings_repository.dart';

part 'settings_event.dart';

part 'settings_state.dart';

part 'generated/settings_bloc.freezed.dart';

class SettingsBloc extends Bloc<SettingsEvent, SettingsState> {
  final SettingsRepository _settingsRepository;

  SettingsBloc({
    required SettingsRepository settingsRepository,
  })  : _settingsRepository = settingsRepository,
        super(const SettingsState()) {
    on<SettingsEvent>((event, emit) async {
      await event.map(
        getSettings: (event) => _onGetSettings(event, emit),
        saveSettings: (event) => _onSaveSettings(event, emit),
      );
    });
  }

  _onGetSettings(_GetSettings event, Emitter<SettingsState> emit) {
    debugPrint('SettingsBloc: _onGetSettings');
    final settingsSnapshot = _settingsRepository.getSettingsSnapshot();
    emit(SettingsState(settingsSnapshot: settingsSnapshot));
  }

  _onSaveSettings(_SaveSettings event, Emitter<SettingsState> emit) {
    debugPrint('SettingsBloc: _onSaveSettings');
    final settingsSnapshot = SettingsSnapshot(
      seek: event.seek ?? state.settingsSnapshot.seek,
      themeMode: event.themeMode ?? state.settingsSnapshot.themeMode,
    );

    _settingsRepository.saveSettingsSnapshot(settingsSnapshot);
    emit(SettingsState(settingsSnapshot: settingsSnapshot));
  }
}
