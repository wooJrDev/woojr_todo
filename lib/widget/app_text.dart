import 'package:flutter/material.dart';
import 'package:woojr_todo/constants.dart';

class AppText extends StatelessWidget {
  final String text;
  final double? fontSize;
  const AppText({required this.text, this.fontSize, super.key});

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: TextStyle(fontFamily: 'MavenPro', fontSize: fontSize, color: AppColour.darkBlue),
    );
  }
}
