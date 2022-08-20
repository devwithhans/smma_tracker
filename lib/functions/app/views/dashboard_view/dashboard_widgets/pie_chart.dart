import 'package:agency_time/functions/app/models/company_month.dart';
import 'package:agency_time/functions/clients/models/client.dart';
import 'package:agency_time/functions/tracking/models/tag.dart';
import 'package:agency_time/utils/constants/colors.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

class CustomPieChart extends StatefulWidget {
  const CustomPieChart({
    Key? key,
    required this.chartData,
    this.thickness = 0,
    this.size = 50,
    required this.title,
  }) : super(key: key);
  final List<PieChartSectionData> chartData;
  final String title;
  final double size;
  final double thickness;
  @override
  State<CustomPieChart> createState() => _CustomPieChartState();
}

class _CustomPieChartState extends State<CustomPieChart> {
  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;

    List<PieChartSectionData> chartData = widget.chartData;
    if (chartData.isEmpty) {
      return SizedBox();
    }
    return Container(
      padding: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
      decoration: BoxDecoration(
        border: Border.all(color: kColorGrey),
        borderRadius: BorderRadius.circular(15),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          SizedBox(),
          Align(
            alignment: Alignment.topLeft,
            child: Text(
              widget.title,
              style: TextStyle(fontWeight: FontWeight.w600, fontSize: 20),
            ),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                SizedBox(
                  width: width * 0.07,
                  child: AspectRatio(
                    aspectRatio: 1,
                    child: PieChart(
                      PieChartData(
                        borderData: FlBorderData(
                          show: false,
                        ),
                        sectionsSpace: 0,
                        centerSpaceRadius: widget.size,
                        sections: chartData,
                      ),
                    ),
                  ),
                ),
                SizedBox(width: 20),
                Expanded(
                  child: Column(
                    mainAxisSize: MainAxisSize.max,
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: chartData
                        .map(
                          (e) => Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Row(
                              children: [
                                Container(
                                  height: 20,
                                  width: 20,
                                  decoration: BoxDecoration(
                                      color: e.color,
                                      borderRadius: BorderRadius.circular(5)),
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
                                Text(
                                  '${e.value.toStringAsFixed(1)}%',
                                  maxLines: 1,
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                  overflow: TextOverflow.clip,
                                ),
                              ],
                            ),
                          ),
                        )
                        .toList(),
                  ),
                ),
              ],
            ),
          ),
          SizedBox(),
        ],
      ),
    );
  }
}

List<PieChartSectionData> overviewShowingSections({
  required List<Client> internals,
  String? userId,
  double thickness = 10,
  required Duration clientsDuration,
  required Duration internalDuration,
}) {
  int index = 0;

  Duration totalDuration = clientsDuration + internalDuration;

  double clientsProcentage =
      (clientsDuration.inSeconds / totalDuration.inSeconds) * 100;

  List<PieChartSectionData> result = [];

  if (clientsDuration > Duration()) {
    result.add(
      PieChartSectionData(
        showTitle: false,
        radius: thickness,
        badgePositionPercentageOffset: 3,
        value: clientsProcentage,
        title:
            '${clientsProcentage.isFinite ? clientsProcentage.toInt() : 0}%) Clients',
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
          radius: thickness,
          badgePositionPercentageOffset: 3,
          value: internalProcentage.isFinite ? internalProcentage : 0,
          title: '${element.name} ',

          // badgeWidget: Text('$procentage%'),
          color: kChartColors[index],
        ));
      }
    },
  );
  return result;
}

List<PieChartSectionData> tagsShowingSections(
    {required List<Tag> tags, required Map tagsMap, double thickness = 10}) {
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
      radius: thickness,
      badgePositionPercentageOffset: 3,
      value: procentage,
      title: '${e.tag}',
      // badgeWidget: Text('$procentage%'),
      color: kChartColors[index],
    );
  }).toList();

  return result;
}

List<PieChartSectionData> employeesShowingSections(
    {required List<Employee> employees, double thickness = 10}) {
  List<Tag> tagsWithData = [];
  int totalValue = 0;

  List<PieChartSectionData> result = [];

  int index = 0;

  employees.forEach((e) => totalValue += e.totalDuration.inMilliseconds);

  employees.forEach((e) {
    index++;
    double procentage = ((e.totalDuration.inMilliseconds / totalValue) * 100);
    if (e.totalDuration > Duration()) {
      result.add(PieChartSectionData(
        showTitle: false,
        radius: thickness,
        badgePositionPercentageOffset: 3,
        value: procentage,
        title: '${e.member.firstName}',
        // badgeWidget: Text('$procentage%'),
        color: kChartColors[index],
      ));
    }
  });

  return result;
}
