import 'package:flutter/material.dart';
import 'package:pronunciation/utils/utils.dart';

class DisplayWordWidget extends StatelessWidget {
  const DisplayWordWidget({
    Key? key,
    required this.isChecked,
    required this.word,
  }) : super(key: key);
  final bool isChecked;
  final String word;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: whiteColor),
          color: isChecked ? whiteColor : Colors.transparent,
        ),
        margin: const EdgeInsets.symmetric(
          vertical: 8,
          horizontal: 8,
        ),
        padding: const EdgeInsets.symmetric(
          vertical: 8,
          horizontal: 8,
        ),
        child: Center(
          child: Text(
            word,
            style: TextStyle(
              fontSize: 20,
              color: isChecked ? blackColor : whiteColor,
            ),
          ),
        ),
      ),
    );
  }
}
