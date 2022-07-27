import 'package:agency_time/utils/constants/colors.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class StatCard extends StatelessWidget {
  const StatCard({
    Key? key,
    required this.change,
    required this.title,
    required this.value,
    this.procentage = false,
  }) : super(key: key);

  final String title;
  final String value;
  final int change;
  final bool procentage;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: Colors.black, width: 2),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Padding(
            padding: EdgeInsets.fromLTRB(20, 20, 20, 20),
            child: Column(
              children: [
                Text(
                  title,
                  style: TextStyle(color: kColorGreyText, fontSize: 12),
                ),
                Text(
                  value,
                  style: TextStyle(
                    fontSize: value.length > 5 ? 20 : 30,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                !procentage
                    ? Text(
                        '+${change}h/last mth. ',
                        style: TextStyle(color: kColorGreyText, fontSize: 12),
                      )
                    : SizedBox(),
              ],
            ),
          ),
          procentage
              ? Container(
                  decoration: BoxDecoration(
                      color: change.isNegative ? Colors.red : Colors.green,
                      borderRadius: BorderRadius.only(
                          bottomLeft: Radius.circular(8),
                          bottomRight: Radius.circular(8))),
                  child: Padding(
                    padding: const EdgeInsets.only(right: 8),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SizedBox(
                          width: 25,
                          child: Icon(
                            change.isNegative
                                ? Icons.arrow_drop_down_rounded
                                : Icons.arrow_drop_up_rounded,
                            color: Colors.white,
                            size: 30,
                          ),
                        ),
                        Text(
                          '${change.abs().toString()}%',
                          style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                              color: Colors.white),
                        ),
                      ],
                    ),
                  ),
                )
              : SizedBox(),
        ],
      ),
    );
  }
}
