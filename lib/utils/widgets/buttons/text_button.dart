import 'package:flutter/material.dart';

class CustomTextButton extends StatelessWidget {
  const CustomTextButton(
      {Key? key,
      required this.text,
      required this.onPressed,
      this.backgroundColor = Colors.black,
      this.textColor = Colors.black})
      : super(key: key);

  final void Function() onPressed;
  final String text;
  final Color backgroundColor;
  final Color textColor;

  @override
  Widget build(BuildContext context) {
    return TextButton(
      style: ButtonStyle(
        minimumSize: MaterialStateProperty.all<Size>(Size(100, 45)),
        overlayColor:
            MaterialStateProperty.all<Color>(backgroundColor.withOpacity(0.1)),
      ),
      child: Text(
        text,
        style: TextStyle(color: textColor),
      ),
      onPressed: onPressed,
    );
  }
}
