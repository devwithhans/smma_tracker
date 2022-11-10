import 'package:agency_time/utils/constants/colors.dart';
import 'package:flutter/material.dart';

class CustomToggl extends StatelessWidget {
  const CustomToggl({
    required this.buttons,
    required this.selected,
    required this.onPressed,
    Key? key,
  }) : super(key: key);
  final List<String> buttons;
  final String selected;
  final void Function(String selected) onPressed;
  @override
  Widget build(BuildContext context) {
    return Row(
        children: buttons.map((e) {
      bool first = false;
      bool last = false;
      if (e == buttons.first) {
        first = true;
      }
      if (e == buttons.last) {
        last = true;
      }

      return Expanded(
        child: RawMaterialButton(
            elevation: 0,
            shape: RoundedRectangleBorder(
              borderRadius: first
                  ? firstBorder
                  : last
                      ? lastBorder
                      : BorderRadius.zero,
              side: BorderSide(
                width: 0.5,
                color: selected != e ? kColorGrey : Colors.transparent,
              ),
            ),
            fillColor: selected == e ? Colors.black : Colors.white,
            textStyle: TextStyle(
              fontWeight: FontWeight.w600,
              color: selected == e ? Colors.white : Colors.black,
            ),
            child: Text(
              e,
              style: TextStyle(
                fontWeight: FontWeight.w600,
              ),
            ),
            padding: EdgeInsets.symmetric(horizontal: 20, vertical: 5),
            onPressed: () {
              onPressed(e);
            }),
      );
    }).toList());
  }
}

BorderRadiusGeometry firstBorder = const BorderRadius.only(
    topLeft: Radius.circular(12), bottomLeft: Radius.circular(12));

BorderRadiusGeometry lastBorder = const BorderRadius.only(
    topRight: Radius.circular(12), bottomRight: Radius.circular(12));
