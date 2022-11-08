import 'package:flutter/material.dart';

class CustomIconButton extends StatelessWidget {
  const CustomIconButton({
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
        padding: EdgeInsets.symmetric(vertical: 10),
        // fillColor: Colors.black.withOpacity(0.04),
        focusElevation: 0,
        hoverElevation: 0,
        onPressed: onPressed,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0),
          child: Row(
            children: [
              Icon(
                icon,
                color: Colors.black,
              ),
              SizedBox(width: 20),
              Text(
                text,
                style: TextStyle(
                    color: Colors.black,
                    fontSize: 15,
                    fontWeight: FontWeight.w500),
              ),
            ],
          ),
        ));
  }
}
