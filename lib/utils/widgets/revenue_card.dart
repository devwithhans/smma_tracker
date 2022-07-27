import 'package:agency_time/utils/constants/colors.dart';
import 'package:agency_time/utils/widgets/procentage_card.dart';
import 'package:flutter/material.dart';

enum StatCardType { black, white }

class StatCard extends StatelessWidget {
  const StatCard(
      {Key? key,
      required this.title,
      required this.value,
      required this.subText,
      this.type = StatCardType.black})
      : super(key: key);

  final StatCardType type;
  final String title;
  final String value;
  final dynamic subText;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 150,
      decoration: BoxDecoration(
          border:
              type == StatCardType.white ? Border.all(color: kColorGrey) : null,
          borderRadius: BorderRadius.circular(15),
          color: type == StatCardType.black
              ? Color(
                  0xff2C2C2C,
                )
              : Colors.transparent),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              title,
              style: TextStyle(
                  color: type == StatCardType.black
                      ? Colors.white70
                      : kColorGreyText),
            ),
            SizedBox(height: 10),
            Text(
              value,
              style: TextStyle(
                  fontSize: value.length > 6 ? 25 : 35,
                  height: 1,
                  fontWeight: FontWeight.w600,
                  color:
                      type == StatCardType.black ? Colors.white : Colors.black),
            ),
            subText is String
                ? Text(
                    subText,
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: kColorGreyText,
                    ),
                  )
                : subText.isNaN
                    ? SizedBox()
                    : ProcentageChange(procentage: subText),
          ],
        ),
      ),
    );
  }
}
