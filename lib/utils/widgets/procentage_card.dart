import 'package:agency_time/utils/constants/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class ProcentageChange extends StatelessWidget {
  const ProcentageChange({
    Key? key,
    required this.procentage,
  }) : super(key: key);

  final double procentage;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 8, vertical: 1),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(100),
        border: Border.all(
            color: procentage.isNegative ? kColorRed : kColorGreen, width: 2),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          RotatedBox(
            quarterTurns: procentage.isNegative ? 2 : 0,
            child: SvgPicture.asset(
              'assets/indicator.svg',
              color: procentage.isNegative ? kColorRed : kColorGreen,
            ),
          ),
          SizedBox(width: 2),
          Text(
            '${procentage.abs().toStringAsFixed(0)}%',
            style: TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w600,
              color: procentage.isNegative ? kColorRed : kColorGreen,
            ),
          ),
        ],
      ),
    );
  }
}
