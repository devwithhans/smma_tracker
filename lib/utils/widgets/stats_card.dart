import 'package:agency_time/utils/constants/colors.dart';
import 'package:agency_time/utils/widgets/procentage_card.dart';
import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

enum StatCardType { black, white }

class StatCard extends StatelessWidget {
  const StatCard(
      {Key? key,
      required this.title,
      required this.value,
      this.expanded = false,
      this.responsive = false,
      required this.subText,
      this.loading = false,
      this.type = StatCardType.black})
      : super(key: key);

  final StatCardType type;
  final String title;
  final String value;
  final dynamic subText;
  final bool loading;
  final bool expanded;
  final bool responsive;

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double largeTextSize = responsive ? screenWidth * 0.017 : 45;
    double smallTextSize = responsive ? screenWidth * 0.011 : 12;
    if (loading) {
      return Shimmer.fromColors(
        baseColor: Colors.grey[300]!,
        highlightColor: Colors.grey[100]!,
        child: Container(
          height: 150,
          decoration: BoxDecoration(
            border: type == StatCardType.white
                ? Border.all(color: kColorGrey)
                : null,
            borderRadius: BorderRadius.circular(15),
            color: Colors.black,
          ),
        ),
      );
    }
    return Container(
      height: expanded ? null : 150,
      decoration: BoxDecoration(
          border:
              type == StatCardType.white ? Border.all(color: kColorGrey) : null,
          borderRadius: BorderRadius.circular(15),
          color: type == StatCardType.black
              ? const Color(
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
                  fontSize: smallTextSize > 16
                      ? 16
                      : smallTextSize < 16
                          ? 16
                          : smallTextSize,
                  color: type == StatCardType.black
                      ? Colors.white70
                      : kColorGreyText),
            ),
            const SizedBox(height: 10),
            Text(
              value,
              style: TextStyle(
                  fontSize: largeTextSize,
                  height: responsive ? screenWidth * 0.00055 : 1,
                  fontWeight: FontWeight.w500,
                  color:
                      type == StatCardType.black ? Colors.white : Colors.black),
            ),
            subText is String
                ? Text(
                    subText,
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: kColorGreyText,
                    ),
                  )
                : subText.isNaN
                    ? const SizedBox()
                    : ProcentageChange(procentage: subText),
          ],
        ),
      ),
    );
  }
}
