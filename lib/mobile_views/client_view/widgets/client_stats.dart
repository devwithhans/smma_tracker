import 'package:agency_time/functions/data_explanation.dart';
import 'package:agency_time/models/client.dart';
import 'package:agency_time/utils/constants/colors.dart';
import 'package:agency_time/utils/functions/print_duration.dart';
import 'package:agency_time/utils/widgets/procentage_card.dart';
import 'package:agency_time/utils/widgets/revenue_card.dart';
import 'package:flutter/material.dart';

class ClientStats extends StatelessWidget {
  const ClientStats({
    Key? key,
    required this.client,
  }) : super(key: key);

  final Client client;

  @override
  Widget build(BuildContext context) {
    bool noCompareMonth = client.compareMonth == null;
    Duration durationChange = client.selectedMonth.duration -
        (noCompareMonth ? const Duration() : client.compareMonth!.duration);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        StatCard(
          title: 'Monthly revenue',
          value: moneyFormatter.format(client.selectedMonth.mrr),
          subText: getChangeProcentage(client.selectedMonth.mrr,
              noCompareMonth ? 0 : client.compareMonth!.mrr),
        ),
        SizedBox(height: 15),
        Row(
          children: [
            Expanded(
              child: StatCard(
                type: StatCardType.white,
                title: 'Total hours',
                value: printDuration(client.selectedMonth.duration),
                subText: durationChange.isNegative
                    ? 'h / last'
                    : '+${durationChange.inHours}h / last',
              ),
            ),
            SizedBox(width: 15),
            Expanded(
              child: StatCard(
                type: StatCardType.white,
                title: 'Hourly rate',
                value: moneyFormatter.format(getHourlyRate(
                    client.selectedMonth.mrr, client.selectedMonth.duration)),
                subText: getChangeProcentage(
                  client.selectedMonth.hourlyRate,
                  noCompareMonth ? 0 : client.compareMonth!.hourlyRate,
                ),
              ),
            ),
          ],
        ),
        SizedBox(height: 15),
      ],
    );
  }
}

class PieChartWidget extends StatefulWidget {
  const PieChartWidget({required this.client, Key? key}) : super(key: key);

  final Client client;

  @override
  State<PieChartWidget> createState() => _PieChartWidgetState();
}

class _PieChartWidgetState extends State<PieChartWidget> {
  int touchedIndex = -1;

  @override
  Widget build(BuildContext context) {
    return Container(
      // padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      decoration: BoxDecoration(
        border: Border.all(color: kColorGrey),
        borderRadius: BorderRadius.circular(15),
      ),

      child: Column(
        children: [
          Expanded(
            child: Stack(
              children: [
                Align(
                  alignment: Alignment.center,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'Total Hours',
                        style: TextStyle(color: kColorGreyText),
                      ),
                      SizedBox(height: 10),
                      Text(
                        printDuration(widget.client.selectedMonth.duration),
                        style: TextStyle(
                            fontSize: 35,
                            height: 1,
                            fontWeight: FontWeight.w600,
                            color: Colors.black),
                      ),
                      ProcentageChange(
                          procentage: getChangeProcentage(
                              widget.client.selectedMonth.duration,
                              widget.client.compareMonth!.duration)),
                    ],
                  ),
                ),
              ],
            ),
          ),
          Text('hi'),
        ],
      ),
      //   ],
      // ),
    );
  }
}
