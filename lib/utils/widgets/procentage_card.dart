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
    return Row(
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
            fontSize: 12,
            fontWeight: FontWeight.w600,
            color: procentage.isNegative ? kColorRed : kColorGreen,
          ),
        ),
      ],
    );
  }
}
