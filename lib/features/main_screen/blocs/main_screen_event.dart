part of 'main_screen_bloc.dart';

@freezed
class MainScreenEvent with _$MainScreenEvent {
  const factory MainScreenEvent.initial() = Initial;
  const factory MainScreenEvent.start() = _Start;
  const factory MainScreenEvent.stop() = _Stop;
  const factory MainScreenEvent.restart() = _Restart;
}
