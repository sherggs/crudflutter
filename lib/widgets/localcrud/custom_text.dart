import 'package:flutter/material.dart';

class CustomText extends StatelessWidget {
  final String text;
  final double textSize;
  final FontWeight fontWeight;
  final Color textColor;
  final TextAlign? aligment;

  const CustomText(
      {required this.text,
      required this.textSize,
      required this.fontWeight,
      required this.textColor,
      this.aligment = TextAlign.start});

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      textAlign: aligment,
      style: TextStyle(
          fontSize: textSize, fontWeight: fontWeight, color: textColor),
    );
  }
}
