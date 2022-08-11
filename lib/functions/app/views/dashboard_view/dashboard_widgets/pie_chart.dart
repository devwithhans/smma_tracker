import 'package:agency_time/functions/app/models/company_month.dart';
import 'package:agency_time/functions/clients/models/client.dart';
import 'package:agency_time/functions/clients/models/month.dart';
import 'package:agency_time/functions/tracking/models/tag.dart';
import 'package:agency_time/utils/constants/colors.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

class CustomPieChart extends StatefulWidget {
  const CustomPieChart({Key? key, required this.chartData, required this.title})
      : super(key: key);
  final List<PieChartSectionData> chartData;
  final String title;
  @override
  State<CustomPieChart> createState() => _CustomPieChartState();
}

class _CustomPieChartState extends State<CustomPieChart> {
  @override
  Widget build(BuildContext context) {
    List<PieChartSectionData> chartData = widget.chartData;
    if (chartData.isEmpty) {
      return SizedBox();
    }
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          widget.title,
          style: TextStyle(color: kColorGreyText, fontWeight: FontWeight.w600),
        ),
        const SizedBox(
          height: 10,
        ),
        Container(
          padding: EdgeInsets.symmetric(vertical: 20),
          decoration: BoxDecoration(
            border: Border.all(color: kColorGrey),
            borderRadius: BorderRadius.circular(15),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  Expanded(
                    child: AspectRatio(
                      aspectRatio: 1.2,
                      child: PieChart(
                        PieChartData(
                            borderData: FlBorderData(
                              show: false,
                            ),
                            sectionsSpace: 0,
                            centerSpaceRadius: 50,
                            sections: chartData),
                      ),
                    ),
                  ),
                  Expanded(
                    child: Column(
                      mainAxisSize: MainAxisSize.max,
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: chartData
                          .map(
                            (e) => Row(
                              children: [
                                Container(
                                  height: 10,
                                  width: 10,
                                  decoration: BoxDecoration(color: e.color),
                                ),
                                SizedBox(
                                  width: 10,
                                ),
                                Expanded(
                                  child: SizedBox(
                                    child: Text(
                                      e.title,
                                      maxLines: 1,
                                      overflow: TextOverflow.clip,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          )
                          .toList(),
                    ),
                  ),
                  const SizedBox(
                    width: 28,
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }
}

List<PieChartSectionData> overviewShowingSections(
    {required List<Client> internals,
    String? userId,
    required Duration clientsDuration,
    required Duration internalDuration}) {
  int index = 0;

  Duration totalDuration = clientsDuration + internalDuration;

  double clientsProcentage =
      (clientsDuration.inSeconds / totalDuration.inSeconds) * 100;

  List<PieChartSectionData> result = [];

  if (clientsDuration > Duration()) {
    result.add(
      PieChartSectionData(
        showTitle: false,
        radius: 10,
        badgePositionPercentageOffset: 3,
        value: clientsDuration.inSeconds.toDouble(),
        title:
            '(${clientsProcentage.isFinite ? clientsProcentage.toInt() : 0}%) Clients',
        // badgeWidget: Text('$procentage%'),
        color: kChartColors[0],
      ),
    );
  }

  internals.forEach(
    (element) {
      Duration duration = Duration();
      if (userId != null) {
        List<Employee> employeeTestList = element.selectedMonth.employees
            .where((element) => element.member.id == userId)
            .toList();
        if (employeeTestList.isNotEmpty) {
          duration = employeeTestList.first.totalDuration;
        }
      } else {
        duration = element.selectedMonth.duration;
      }
      if (duration > Duration()) {
        double internalProcentage = ((element.selectedMonth.duration.inSeconds /
                totalDuration.inSeconds) *
            100);
        index++;
        result.add(PieChartSectionData(
          showTitle: false,
          radius: 10,
          badgePositionPercentageOffset: 3,
          value: element.selectedMonth.duration.inSeconds.toDouble(),
          title:
              '(${internalProcentage.isFinite ? internalProcentage.toStringAsFixed(1) : 0}%) ${element.name} ',

          // badgeWidget: Text('$procentage%'),
          color: kChartColors[index],
        ));
      }
    },
  );

  return result;
}

List<PieChartSectionData> tagsShowingSections(
    {required List<Tag> tags, required Map tagsMap}) {
  List<Tag> tagsWithData = [];
  int totalValue = 0;

  tags.forEach(
    (element) {
      int? elementValue = tagsMap[element.id.toString()];
      if (elementValue != null && elementValue != 0) {
        totalValue += elementValue;
        tagsWithData.add(
          element.copyWith(
            value: tagsMap[element.id.toString()],
          ),
        );
      }
    },
  );

  List<PieChartSectionData> result = [];

  int index = 0;

  result = tagsWithData.map((e) {
    index++;
    double procentage = ((e.value! / totalValue) * 100);
    return PieChartSectionData(
      showTitle: false,
      radius: 10,
      badgePositionPercentageOffset: 3,
      value: e.value!.toDouble(),
      title: '(${procentage.toStringAsFixed(1)}%) ${e.tag}',
      // badgeWidget: Text('$procentage%'),
      color: kChartColors[index],
    );
  }).toList();

  return result;
}
