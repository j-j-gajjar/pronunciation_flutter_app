import 'package:flutter/material.dart';
import 'package:pronunciation/utils/utils.dart';

class TextWidget extends StatelessWidget {
  const TextWidget({super.key, required this.text, this.color = whiteColor});
  final String text;
  final Color color;
  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: TextStyle(
        color: color,
      ),
    );
  }
}
