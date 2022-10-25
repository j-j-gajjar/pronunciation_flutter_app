part of 'main_screen_bloc.dart';

@freezed
class MainScreenState with _$MainScreenState {
  const factory MainScreenState.loading() = _Loading;
  const factory MainScreenState.generatedList({
    required List<String> word,
  }) = _GeneratedList;
  const factory MainScreenState.listened({
    required String listenedValue,
    required List<String> word,
    required List<int> correctIndex,
    required RiveAnimationController<dynamic> riveAnimationController,
    required bool isListening,
    required bool speechEnabled,
  }) = _Listened;
}
