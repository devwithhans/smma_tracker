import 'package:agency_time/utils/functions/data_explanation.dart';
import 'package:agency_time/utils/functions/print_duration.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:shimmer/shimmer.dart';

class CustomGraphModel {
  DateTime date;
  dynamic value;

  CustomGraphModel({required this.date, required this.value});
}

class CustomGraph extends StatefulWidget {
  const CustomGraph({required this.months, required this.title, Key? key})
      : super(key: key);

  final List<CustomGraphModel> months;
  final String title;

  @override
  _CustomGraphState createState() => _CustomGraphState();
}

CustomGraphModel getMaxValue(List<CustomGraphModel> months) {
  List<CustomGraphModel> sortedList = [];
  sortedList.addAll(months);
  sortedList.sort((a, b) => a.value.compareTo(b.value));
  return sortedList.last;
}

String getValueAsString(dynamic value, int totalSpots, double spot) {
  if (value is Duration) {
    Duration duration = value;
    // printDuration(
    //     Duration(seconds: ((duration.inSeconds / 5) * value).toInt()));

    return printDuration(Duration(
        milliseconds: ((duration.inMilliseconds / totalSpots) * spot).toInt()));
  } else {
    double num = value;
    return moneyFormatter.format((num / totalSpots) * spot);
  }
}

dynamic getValueAsDouble({
  required dynamic maxValue,
  required int totalSpots,
  required dynamic value,
}) {
  if (value is Duration) {
    Duration maxDuration = maxValue;
    Duration valueDuration = value;
    return ((value.inMilliseconds / maxDuration.inMilliseconds) * totalSpots);
  } else {
    double num = maxValue;
    return (value / num) * totalSpots;
  }
}

int getFirstMonth(List<CustomGraphModel> months) {
  List<CustomGraphModel> sortedList = [];
  sortedList.addAll(months);
  sortedList.sort((a, b) => a.date.compareTo(b.date));
  return sortedList.last.date.month;
}

class _CustomGraphState extends State<CustomGraph> {
  List<Color> gradientColors = [
    const Color(0xff23b6e6),
    const Color(0xff02d39a),
  ];

  bool showAvg = false;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
          borderRadius: BorderRadius.all(
            Radius.circular(18),
          ),
          color: Color(0xff2C2C2C)),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(20, 20, 40, 20),
        child: Column(
          children: [
            Text(
              widget.title,
              style: TextStyle(
                fontSize: 20,
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 20),
            Expanded(
              child: LineChart(
                mainData(),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget bottomTitleWidgets(double value, TitleMeta meta) {
    const style = TextStyle(
      color: Color(0xff68737d),
      fontWeight: FontWeight.bold,
      fontSize: 16,
    );

    DateTime date = widget.months[value.toInt()].date;

    Widget text;

    text = Text('${DateFormat('MMM, y').format(date)}', style: style);

    return SideTitleWidget(
      axisSide: meta.axisSide,
      space: 8.0,
      child: text,
    );
  }

  Widget moneyLeftTitleWidgets(dynamic value, TitleMeta meta) {
    dynamic maxValue = getMaxValue(widget.months).value;
    const style = TextStyle(
      color: Color(0xff67727d),
      fontWeight: FontWeight.bold,
      fontSize: 15,
    );

    if (maxValue is num) {
      if (value == 0) {
        return Text(moneyFormatter.format(0),
            style: style, textAlign: TextAlign.left);
      }

      return Text(moneyFormatter.format((maxValue / 5) * value),
          style: style, textAlign: TextAlign.left);
    } else if (maxValue is Duration) {
      Duration duration = maxValue;
      if (duration == Duration()) {
        return Text(printDuration(duration),
            style: style, textAlign: TextAlign.left);
      }

      return Text(
          printDuration(
              Duration(seconds: ((duration.inSeconds / 5) * value).toInt())),
          style: style,
          textAlign: TextAlign.left);
    }
    return SizedBox();
  }

  LineChartData mainData() {
    return LineChartData(
      lineTouchData: LineTouchData(
        touchTooltipData: LineTouchTooltipData(
            tooltipBgColor: Color(0xff23b6e6),
            getTooltipItems: (List<LineBarSpot> touchedBarSpots) {
              return touchedBarSpots.map((barSpot) {
                final flSpot = barSpot;
                // if (flSpot.x == 0 || flSpot.x == 6) {
                //   return null;
                // }

                return LineTooltipItem(
                  '',
                  const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                  children: [
                    TextSpan(
                      text: getValueAsString(
                          getMaxValue(widget.months).value, 5, flSpot.y),
                      style: TextStyle(
                        color: Colors.grey[100],
                        fontWeight: FontWeight.normal,
                      ),
                    ),
                    const TextSpan(
                      text: ' ',
                      style: TextStyle(
                        fontStyle: FontStyle.italic,
                        fontWeight: FontWeight.normal,
                      ),
                    ),
                  ],
                );
              }).toList();
            }),
      ),
      gridData: FlGridData(
        show: true,
        drawVerticalLine: true,
        horizontalInterval: 1,
        verticalInterval: 1,
        getDrawingHorizontalLine: (value) {
          return FlLine(
            color: const Color(0xff37434d),
            strokeWidth: 1,
          );
        },
        getDrawingVerticalLine: (value) {
          return FlLine(
            color: const Color(0xff37434d),
            strokeWidth: 1,
          );
        },
      ),
      titlesData: FlTitlesData(
        show: true,
        rightTitles: AxisTitles(
          sideTitles: SideTitles(showTitles: false),
        ),
        topTitles: AxisTitles(
          sideTitles: SideTitles(showTitles: false),
        ),
        bottomTitles: AxisTitles(
          sideTitles: SideTitles(
            showTitles: true,
            reservedSize: 50,
            interval: 1,
            getTitlesWidget: bottomTitleWidgets,
          ),
        ),
        leftTitles: AxisTitles(
          sideTitles: SideTitles(
            showTitles: true,
            interval: 1,
            getTitlesWidget: moneyLeftTitleWidgets,
            reservedSize: 100,
          ),
        ),
      ),
      borderData: FlBorderData(
          show: true,
          border: Border.all(color: const Color(0xff37434d), width: 1)),
      minX: 0,
      maxX: widget.months.length.toDouble() - 1,
      minY: 0,
      maxY: 6,
      lineBarsData: [
        LineChartBarData(
          spots: widget.months.map((e) {
            return FlSpot(
                widget.months.indexOf(e).toDouble(),
                getValueAsDouble(
                    maxValue: getMaxValue(widget.months).value,
                    value: e.value,
                    totalSpots: 5));
          }).toList(),
          isCurved: false,
          preventCurveOverShooting: true,
          preventCurveOvershootingThreshold: 0,
          gradient: LinearGradient(
            colors: gradientColors,
            begin: Alignment.centerLeft,
            end: Alignment.centerRight,
          ),
          barWidth: 5,
          isStrokeCapRound: true,
          dotData: FlDotData(
            show: true,
          ),
          belowBarData: BarAreaData(
            show: true,
            gradient: LinearGradient(
              colors: gradientColors
                  .map((color) => color.withOpacity(0.3))
                  .toList(),
              begin: Alignment.centerLeft,
              end: Alignment.centerRight,
            ),
          ),
        ),
      ],
    );
  }
}
