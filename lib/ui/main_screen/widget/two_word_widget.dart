import 'package:flutter/material.dart';
import 'package:pronunciation/ui/main_screen/main_screen.dart';

class TwoWordsWidget extends StatelessWidget {
  const TwoWordsWidget({
    Key? key,
    required this.firstIsChecked,
    required this.secondIsChecked,
    required this.firstWord,
    required this.secondWord,
  }) : super(key: key);
  final bool firstIsChecked;
  final bool secondIsChecked;
  final String firstWord;
  final String secondWord;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          DisplayWordWidget(
            isChecked: firstIsChecked,
            word: firstWord,
          ),
          DisplayWordWidget(
            isChecked: secondIsChecked,
            word: secondWord,
          ),
        ],
      ),
    );
  }
}
