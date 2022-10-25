import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pronunciation/features/main_screen/main_screen.dart';
import 'package:pronunciation/ui/main_screen/main_screen.dart';
import 'package:pronunciation/utils/utils.dart';
import 'package:rive/rive.dart';

class MainScreenView extends StatelessWidget {
  const MainScreenView({super.key});

  @override
  Widget build(BuildContext context) {
    final MainScreenBloc mainScreenBloc = context.watch<MainScreenBloc>();

    return Scaffold(
      body: Stack(
        children: [
          const RiveAnimation.asset(
            backgroundRive,
            fit: BoxFit.fill,
          ),
          mainScreenBloc.state.maybeMap(
            loading: (_) => const SizedBox(),
            listened: (val) => Stack(
              children: [
                SizedBox(
                  height: MediaQuery.of(context).size.height * .6,
                  width: double.infinity,
                  child: RiveAnimation.asset(
                    robotRive,
                    animations: const ['idel'],
                    controllers: [val.riveAnimationController],
                  ),
                ),
                Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    TwoWordsWidget(
                      firstIsChecked: val.currectIndex!.contains(0),
                      secondIsChecked: val.currectIndex!.contains(1),
                      firstword: val.word![0],
                      secondword: val.word![1],
                    ),
                    const SizedBox(height: 12),
                    TwoWordsWidget(
                      firstIsChecked: val.currectIndex!.contains(2),
                      secondIsChecked: val.currectIndex!.contains(3),
                      firstword: val.word![2],
                      secondword: val.word![3],
                    ),
                    const SizedBox(height: 12),
                    Container(),
                    TextWidget(
                      text: val.isListening
                          ? val.listenedValue!
                          : val.speechEnabled
                              ? tapToStartText
                              : speechNotAvailableText,
                    ),
                    const SizedBox(height: 12),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        ButtonWidget(
                          child: const TextWidget(
                            text: skipText,
                            color: blackColor,
                          ),
                          onPressed: () {
                            mainScreenBloc.add(
                              const MainScreenEvent.restart(),
                            );
                          },
                        ),
                        ButtonWidget(
                          child: Icon(
                            val.isListening ? Icons.mic : Icons.mic_off,
                          ),
                          onPressed: () {
                            mainScreenBloc.add(
                              val.isListening
                                  ? const MainScreenEvent.stop()
                                  : const MainScreenEvent.start(),
                            );
                          },
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),
                  ],
                )
              ],
            ),
            orElse: () => const SizedBox(),
          )
        ],
      ),
    );
  }
}
