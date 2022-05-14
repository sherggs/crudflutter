import 'package:flutter/material.dart';
import 'custom_text.dart';

class CustomButton extends StatelessWidget {
  final double padding;
  final String text;
  final double buttonHeight;
  final double textSize;
  final FontWeight fontWeight;
  final Color textColor;
  final Color borderColor;
  final Color buttonColor;
  final double radius;
  final VoidCallback onPress;
  final double buttonWidth;
  final bool? isClicked;

  const CustomButton({
    Key? key,
    required this.padding,
    required this.text,
    required this.buttonHeight,
    required this.textSize,
    required this.fontWeight,
    required this.textColor,
    required this.borderColor,
    required this.buttonColor,
    required this.radius,
    required this.onPress,
    required this.buttonWidth,
    this.isClicked = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: padding),
      child: InkWell(
        onTap: () => onPress(),
        child: Container(
          height: buttonHeight,
          width: buttonWidth,
          decoration: BoxDecoration(
            color: buttonColor,
            borderRadius: BorderRadius.circular(radius),
            // border: Border.all(color: borderColor, width: borderWidth),
          ),
          child: isClicked!
              ? const Center(
                  child: SizedBox(
                    height: 16,
                    width: 16,
                    child: CircularProgressIndicator(
                      valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                    ),
                  ),
                )
              : Center(
                  child: CustomText(
                      text: text,
                      textSize: textSize,
                      fontWeight: fontWeight,
                      textColor: textColor)),
        ),
      ),
    );
  }
}
