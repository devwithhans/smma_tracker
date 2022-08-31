import 'package:agency_time/utils/widgets/stats_card.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class DataCard extends StatelessWidget {
  const DataCard({
    required this.onTap,
    required this.title,
    required this.selected,
    required this.value,
    required this.subValue,
    this.responsive = false,
    Key? key,
  }) : super(key: key);
  final void Function()? onTap;
  final String selected;
  final bool responsive;
  final String title;
  final String value;
  final dynamic subValue;
  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: InkWell(
        onTap: onTap,
        child: StatCard(
          responsive: responsive,
          expanded: true,
          type: selected == title ? StatCardType.black : StatCardType.white,
          title: title,
          value: value,
          subText: subValue,
        ),
      ),
    );
  }
}
