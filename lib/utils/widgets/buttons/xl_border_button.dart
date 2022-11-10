import 'package:agency_time/utils/constants/colors.dart';
import 'package:flutter/material.dart';

class BigBorderButton extends StatelessWidget {
  const BigBorderButton({
    required this.mainText,
    required this.onPressed,
    this.selected = false,
    this.subText,
    Key? key,
  }) : super(key: key);

  final String mainText;
  final bool selected;
  final String? subText;
  final void Function()? onPressed;

  @override
  Widget build(BuildContext context) {
    return RawMaterialButton(
      fillColor: selected ? Colors.blue : Colors.white,
      padding: EdgeInsets.all(20),
      constraints: BoxConstraints(minHeight: 100),
      onPressed: onPressed,
      shape: RoundedRectangleBorder(
          side: BorderSide(color: kColorGrey),
          borderRadius: BorderRadius.circular(15)),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            mainText,
            textAlign: TextAlign.center,
            style: TextStyle(
              color: selected ? Colors.white : Colors.black,
              fontSize: 20,
              fontWeight: FontWeight.w600,
            ),
          ),
          subText == null
              ? SizedBox()
              : Text(
                  subText!,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: selected ? Colors.white : Colors.black,
                    fontSize: 16,
                  ),
                ),
        ],
      ),
    );
  }
}
