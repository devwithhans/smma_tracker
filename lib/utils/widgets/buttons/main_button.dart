import 'package:flutter/material.dart';

class CustomElevatedButton extends StatelessWidget {
  const CustomElevatedButton({
    Key? key,
    required this.text,
    this.border = false,
    this.loading = false,
    required this.onPressed,
    this.backgroundColor = Colors.black,
    this.textColor = Colors.white,
  }) : super(key: key);

  final void Function() onPressed;
  final String text;
  final Color backgroundColor;
  final Color textColor;
  final bool loading;
  final bool border;

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      style: ButtonStyle(
          shape: MaterialStateProperty.all<RoundedRectangleBorder>(
            RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10.0),
              side: border
                  ? const BorderSide(color: Colors.black)
                  : const BorderSide(),
            ),
          ),
          minimumSize: MaterialStateProperty.all<Size>(Size(100, 60)),
          // elevation: MaterialStateProperty.all<double>(0),
          backgroundColor: MaterialStateProperty.all<Color>(backgroundColor)),
      onPressed: loading ? () {} : onPressed,
      child: loading
          ? const CircularProgressIndicator(
              color: Colors.white,
            )
          : Text(
              text,
              style: TextStyle(color: textColor, fontSize: 14),
            ),
    );
  }
}
