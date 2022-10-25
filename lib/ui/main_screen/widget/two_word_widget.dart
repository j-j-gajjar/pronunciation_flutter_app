import 'package:flutter/material.dart';
import 'package:pronunciation/ui/main_screen/main_screen.dart';

class TwoWordsWidget extends StatelessWidget {
  const TwoWordsWidget({
    super.key,
    required this.firstIsChecked,
    required this.secondIsChecked,
    required this.firstword,
    required this.secondword,
  });
  final bool firstIsChecked;
  final bool secondIsChecked;
  final String firstword;
  final String secondword;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          DisplayWordWidget(
            isChecked: firstIsChecked,
            word: firstword,
          ),
          DisplayWordWidget(
            isChecked: secondIsChecked,
            word: secondword,
          ),
        ],
      ),
    );
  }
}
