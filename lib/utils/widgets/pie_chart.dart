import 'package:agency_time/models/company_month.dart';
import 'package:agency_time/models/employee.dart';
import 'package:agency_time/models/tag.dart';
import 'package:agency_time/models/client.dart';
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
    // if (chartData.isEmpty) {
    //   return SizedBox();
    // }
    return Container(
      padding: EdgeInsets.symmetric(vertical: 20, horizontal: 20),
      decoration: BoxDecoration(
        border: Border.all(color: kColorGrey),
        borderRadius: BorderRadius.circular(15),
      ),
      child: chartData.isEmpty
          ? Center(
              child: Text('No data to show ${widget.title}'),
            )
          : Column(
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
                SizedBox(height: 10),
                Align(
                  alignment: Alignment.bottomCenter,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Container(
                        constraints: BoxConstraints(maxWidth: 140),
                        child: AspectRatio(
                          aspectRatio: 1,
                          child: PieChart(
                            PieChartData(
                              borderData: FlBorderData(
                                show: false,
                              ),
                              sectionsSpace: 0,
                              // centerSpaceRadius: 100,
                              sections: chartData,
                            ),
                          ),
                        ),
                      ),
                      SizedBox(width: 20),
                      Expanded(
                        flex: 7,
                        child: Container(
                          constraints:
                              BoxConstraints(minHeight: 100, maxHeight: 140),
                          child: ListView(
                            // mainAxisSize: MainAxisSize.max,
                            // mainAxisAlignment: MainAxisAlignment.center,
                            // crossAxisAlignment: CrossAxisAlignment.start,
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
                                              borderRadius:
                                                  BorderRadius.circular(5)),
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
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold),
                                          overflow: TextOverflow.clip,
                                        ),
                                      ],
                                    ),
                                  ),
                                )
                                .toList(),
                          ),
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
        radius: 15,

        value: clientsProcentage,
        title: 'Clients',
        // badgeWidget: Text('$procentage%'),
        color: kChartColors[0],
      ),
    );
  }

  internals.forEach(
    (element) {
      Duration duration = Duration();
      if (userId != null) {
        List<Employee> employeeTestList = element.selectedMonth!.employees
            .where((element) => element.member.id == userId)
            .toList();
        if (employeeTestList.isNotEmpty) {
          duration = employeeTestList.first.totalDuration;
        }
      } else {
        duration = element.selectedMonth!.duration;
      }
      if (duration > Duration()) {
        double internalProcentage =
            ((element.selectedMonth!.duration.inSeconds /
                    totalDuration.inSeconds) *
                100);
        index++;
        result.add(PieChartSectionData(
          showTitle: false,

          value: internalProcentage.isFinite ? internalProcentage : 0,
          title: '${element.name} ',
          radius: 15,

          // badgeWidget: Text('$procentage%'),
          color: kChartColors[index],
        ));
      }
    },
  );
  result.sort((a, b) => b.value.compareTo(a.value));

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
      radius: 15,

      value: procentage,
      title: '${e.tag}',
      // badgeWidget: Text('$procentage%'),
      color: kChartColors[index],
    );
  }).toList();
  result.sort((a, b) => b.value.compareTo(a.value));

  return result;
}

List<PieChartSectionData> employeesShowingSections(
    {required List<Employee> employees}) {
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
        radius: 15,
        value: procentage,
        title: '${e.member.firstName}',
        // badgeWidget: Text('$procentage%'),
        color: kChartColors[index],
      ));
    }
  });
  result.sort((a, b) => b.value.compareTo(a.value));

  return result;
}
