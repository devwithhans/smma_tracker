import 'package:flutter/material.dart';

class WebMenuButton extends StatelessWidget {
  const WebMenuButton({
    Key? key,
    required this.onPressed,
    required this.icon,
    required this.text,
    this.dropDownIcon,
    this.selected = '',
  }) : super(key: key);
  final void Function(String selected) onPressed;
  final IconData icon;
  final String text;
  final IconData? dropDownIcon;
  final String selected;
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(5.0),
          child: TextButton(
              style: ButtonStyle(
                backgroundColor: selected == text
                    ? MaterialStateProperty.all<Color>(
                        Colors.white.withOpacity(0.1))
                    : MaterialStateProperty.all<Color>(Colors.transparent),
                overlayColor: MaterialStateProperty.all<Color>(
                    Colors.white.withOpacity(0.1)),
                // minimumSize:
                //     MaterialStateProperty.all<Size>(const Size(100, 55)),
              ),
              onPressed: () {
                onPressed(text);
              },
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Row(
                      children: [
                        Icon(
                          icon,
                          color: Colors.white,
                        ),
                        // SizedBox(width: 10),
                        // Text(
                        //   text,
                        //   style: TextStyle(color: Colors.white),
                        // ),
                      ],
                    ),
                  ],
                ),
              )),
        ),
      ],
    );
  }
}
