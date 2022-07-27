import 'package:flutter/material.dart';

enum CustomButtonStyle { blackborder, black, white }

class CustomButton extends StatelessWidget {
  const CustomButton({
    Key? key,
    required this.text,
    required this.onPressed,
    this.buttonStyle = CustomButtonStyle.black,
    this.image,
    this.active = true,
  }) : super(key: key);

  final void Function() onPressed;
  final bool active;
  final String text;
  final Image? image;
  final CustomButtonStyle buttonStyle;

  @override
  Widget build(BuildContext context) {
    final Color color = buttonStyle == CustomButtonStyle.black
        ? Colors.black
        : buttonStyle == CustomButtonStyle.blackborder
            ? Colors.transparent
            : Colors.white;

    final Color textColor = buttonStyle == CustomButtonStyle.black
        ? Colors.white
        : buttonStyle == CustomButtonStyle.blackborder
            ? Colors.black
            : Colors.black;

    return RawMaterialButton(
      hoverElevation: 0,
      onPressed: active ? onPressed : () {},
      elevation: buttonStyle == CustomButtonStyle.blackborder ? 0 : 5,
      child: Container(
        height: 50,
        decoration: BoxDecoration(
          color: active ? color : Colors.grey,
          borderRadius: BorderRadius.circular(10),
          border: buttonStyle == CustomButtonStyle.blackborder
              ? Border.all(color: Colors.black)
              : null,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            image ?? const SizedBox(),
            SizedBox(width: image != null ? 5 : 0),
            Text(
              text,
              textAlign: TextAlign.center,
              style: TextStyle(color: textColor, fontSize: 15),
            ),
          ],
        ),
      ),
    );
  }
}
