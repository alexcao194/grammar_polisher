part of 'home_bloc.dart';

@freezed
class HomeEvent with _$HomeEvent {
  const factory HomeEvent.improveWriting(String text) = ImproveWriting;
  const factory HomeEvent.checkGrammar(String text) = CheckGrammar;
  const factory HomeEvent.detectGpt(String text) = DetectGpt;
  const factory HomeEvent.checkLevel(String text) = CheckLevel;
}
