import 'package:flutter/material.dart';

class CustomMonthButton extends StatelessWidget {
  const CustomMonthButton({
    Key? key,
    required this.icon,
    required this.onPressed,
    required this.text,
  }) : super(key: key);

  final String text;
  final IconData icon;
  final void Function()? onPressed;

  @override
  Widget build(BuildContext context) {
    return RawMaterialButton(
        elevation: 0,
        highlightElevation: 0,
        padding: EdgeInsets.symmetric(vertical: 5),
        // fillColor: Colors.black.withOpacity(0.04),
        focusElevation: 0,
        hoverElevation: 0,
        shape: RoundedRectangleBorder(
            side: BorderSide(color: Colors.grey),
            borderRadius: BorderRadius.circular(5)),
        onPressed: onPressed,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10.0),
          child: Row(
            children: [
              Icon(
                icon,
                color: Colors.black,
                size: 20,
              ),
              SizedBox(width: 10),
              Text(
                text,
                style: TextStyle(
                    color: Colors.black,
                    fontSize: 12,
                    fontWeight: FontWeight.w500),
              ),
            ],
          ),
        ));
  }
}
