import 'package:agency_time/utils/constants/colors.dart';
import 'package:flutter/material.dart';

class CustomElevatedButton extends StatelessWidget {
  const CustomElevatedButton(
      {Key? key,
      required this.text,
      required this.onPressed,
      this.backgroundColor = Colors.black,
      this.textColor = Colors.white})
      : super(key: key);

  final void Function() onPressed;
  final String text;
  final Color backgroundColor;
  final Color textColor;

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      style: ButtonStyle(
          elevation: MaterialStateProperty.all<double>(0),
          backgroundColor: MaterialStateProperty.all<Color>(backgroundColor)),
      onPressed: onPressed,
      child: Text(
        text,
        style: TextStyle(color: textColor),
      ),
    );
  }
}

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
