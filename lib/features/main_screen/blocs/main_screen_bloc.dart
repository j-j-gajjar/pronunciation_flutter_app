// ignore_for_file: invalid_use_of_visible_for_testing_member

import 'dart:async';
import 'dart:math';

import 'package:english_words/english_words.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:rive/rive.dart';
import 'package:speech_to_text/speech_recognition_result.dart';
import 'package:speech_to_text/speech_to_text.dart';

part 'main_screen_bloc.freezed.dart';
part 'main_screen_event.dart';
part 'main_screen_state.dart';

class MainScreenBloc extends Bloc<MainScreenEvent, MainScreenState> {
  MainScreenBloc() : super(const _Loading()) {
    on<Initial>(_init);
    on<_Start>(_start);
    on<_Stop>(_stop);
    on<_Restart>(_createNewGame);
  }

  late RiveAnimationController<dynamic> _controller;
  final SpeechToText _speechToText = SpeechToText();
  bool _speechEnabled = false;
  String _lastWords = '';
  List<String> allNouns = <String>[];
  List<int> checkIsValid = <int>[];
  // ignore: unused_field
  bool _isPlaying = false;

  Future<void> _init(
    Initial event,
    Emitter<MainScreenState> emit,
  ) async {
    emit(const _Loading());
    getNewText();
    _controller = OneShotAnimation(
      'walk',
      autoplay: false,
      onStop: () => _isPlaying = false,
      onStart: () => _isPlaying = true,
    );
    _speechEnabled = await _speechToText.initialize();
    emitListened();
  }

  Future<void> _start(
    _Start event,
    Emitter<MainScreenState> emit,
  ) async {
    await _speechToText.listen(
      onResult: _listen,
      listenFor: const Duration(seconds: 40),
    );
    getNewText(clearText: true);
    _controller.isActive = true;
    emitListened();
  }

  Future<void> _stop(
    _Stop event,
    Emitter<MainScreenState> emit,
  ) async {
    await _speechToText.stop();
    _controller.isActive = false;
    emitListened();
  }

  bool checkAllTrue() {
    return checkIsValid.contains(0) &&
        checkIsValid.contains(1) &&
        checkIsValid.contains(2) &&
        checkIsValid.contains(3);
  }

  void getNewText({bool clearText = false}) {
    if (clearText && !checkAllTrue()) {
      return;
    }
    final int startTextIndex = Random().nextInt(4300) + 10;
    allNouns = all
        .take(4320)
        .toList()
        .getRange(startTextIndex, startTextIndex + 4)
        .toList();
    checkIsValid = <int>[];
  }

  void _listen(SpeechRecognitionResult result) {
    _lastWords = result.recognizedWords;
    emitListened();

    for (int i = 0; i < allNouns.length; i++) {
      if (_lastWords.toLowerCase().contains(allNouns[i].toLowerCase())) {
        if (!checkIsValid.contains(i)) {
          checkIsValid.add(i);
        }
      }
      if (checkAllTrue()) {
        // getNewText(clearText:true);
        _restart();
        break;
      }
    }
    emitListened();
  }

  Future<void> _restart() async {
    await _speechToText.stop();
    _controller.isActive = false;
  }

  void emitListened() {
    emit(
      MainScreenState.listened(
        listenedValue: _lastWords,
        word: allNouns,
        correctIndex: checkIsValid,
        riveAnimationController: _controller,
        isListening: _speechToText.isListening,
        speechEnabled: _speechEnabled,
      ),
    );
  }

  Future<void> _createNewGame(
    _Restart event,
    Emitter<MainScreenState> emit,
  ) async {
    await _restart();
    getNewText();
    emitListened();
  }
}
