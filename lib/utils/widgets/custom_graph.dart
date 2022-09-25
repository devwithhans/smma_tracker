import 'package:agency_time/utils/constants/text_styles.dart';
import 'package:agency_time/utils/functions/print_duration.dart';
import 'package:agency_time/utils/widgets/custom_graph/get_main_data.dart';
import 'package:agency_time/utils/widgets/custom_toggl_button.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class UniversalGraph extends StatelessWidget {
  const UniversalGraph({
    required this.graphDataSpots,
    required this.title,
    required this.moneyFormatter,
    Key? key,
  }) : super(key: key);
  final List<GraphDataSpots> graphDataSpots;
  final String title;

  final NumberFormat moneyFormatter;
  @override
  Widget build(BuildContext context) {
    bool noData = graphDataSpots.length == 1 &&
        (graphDataSpots.first.value == 0 ||
            graphDataSpots.first.value == Duration());

    List<GraphDataSpots> sortetMonth = [];
    sortetMonth.addAll(graphDataSpots);
    sortetMonth.sort(
      (a, b) => a.date.day.compareTo(b.date.day),
    );

    return Container(
      decoration: const BoxDecoration(
        borderRadius: BorderRadius.all(
          Radius.circular(18),
        ),
      ),
      child: noData || graphDataSpots.isEmpty
          ? Center(
              child: Text(
                'Not enough data to show $title graph',
                style: const TextStyle(
                  fontSize: 20,
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            )
          : Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: AppTextStyle.boldMedium,
                ),
                Text(
                  'Tap on the cards above to change data',
                  style: AppTextStyle.fatGray,
                ),
                const SizedBox(height: 10),
                SizedBox(
                  width: 300,
                  child: CustomToggl(
                    buttons: const ['Week', 'Month', 'Year'],
                    selected: 'selected',
                    onPressed: (v) {},
                  ),
                ),
                const SizedBox(height: 10),
                Expanded(
                  child: LineChart(
                    mainData(
                      moneyFormatter: moneyFormatter,
                      months: sortetMonth,
                      getBottomTitleWidgets: getBottomTitleWidgets(sortetMonth),
                      getLeftTitleWidgets:
                          getLeftTitleWidgets(sortetMonth, moneyFormatter),
                      spots: getFlSpots(sortetMonth),
                    ),
                  ),
                ),
              ],
            ),
    );
  }
}

Widget Function(double, TitleMeta)? getBottomTitleWidgets(months) {
  return (double value, TitleMeta meta) {
    DateTime date = months[value.toInt()].date;
    Widget text;
    text = Text(
      DateFormat('d/M').format(date),
      style: AppTextStyle.fatGray,
      textAlign: TextAlign.right,
    );
    return SideTitleWidget(
      axisSide: meta.axisSide,
      space: 8.0,
      child: text,
    );
  };
}

List<FlSpot> getFlSpots(List<GraphDataSpots> months) {
  List<FlSpot> result = [];

  dynamic maxValue = getMaxValue(months).value;
  for (var element in months) {
    result.add(
      FlSpot(
        months.indexOf(element).toDouble(),
        getValueAsDouble(
          maxValue: maxValue,
          value: element.value,
          totalSpots: 5,
        ),
      ),
    );
  }

  return result;
}

dynamic getValueAsDouble({
  required dynamic maxValue,
  required int totalSpots,
  required dynamic value,
}) {
  if (value is Duration) {
    if (value == Duration()) {
      return 0;
    }
    Duration roundedValue =
        Duration(seconds: (maxValue.inSeconds / 36000).ceil() * 36000);

    // Duration valueDuration = value;
    return ((value.inMilliseconds / roundedValue.inMilliseconds) * totalSpots);
  } else {
    double num = value;
    double roundedValue = (maxValue / 10000).ceil() * 10000;

    return (num / roundedValue) * totalSpots;
  }
}

GraphDataSpots getMaxValue(List<GraphDataSpots> months) {
  List<GraphDataSpots> sortedList = [];
  sortedList.addAll(months);
  sortedList.sort((a, b) => a.value.compareTo(b.value));

  return sortedList.last;
}

String getValueAsString(
    dynamic maxValue, int totalSpots, double spot, moneyFormatter) {
  if (maxValue is Duration) {
    Duration roundedMaxValue =
        Duration(seconds: (maxValue.inSeconds / 36000).ceil() * 36000);
    return printDuration(Duration(
        milliseconds:
            ((roundedMaxValue.inMilliseconds / totalSpots) * spot).toInt()));
  } else {
    double roundedNum = (maxValue / 10000).ceil() * 10000;
    return moneyFormatter.format((roundedNum / totalSpots) * spot);
  }
}

Widget Function(double, TitleMeta)? getLeftTitleWidgets(
    List<GraphDataSpots> months, moneyFormatter) {
  return (dynamic value, TitleMeta meta) {
    const style = TextStyle(
      color: Color(0xff67727d),
      fontWeight: FontWeight.bold,
      fontSize: 15,
    );

    dynamic maxValue = getMaxValue(months).value;

    if (maxValue is num) {
      if (value == 0) {
        return Text(moneyFormatter.format(0),
            style: style, textAlign: TextAlign.left);
      }

      double roundedValue = (maxValue / 10000).ceil() * 10000;

      return Text(moneyFormatter.format((roundedValue / 5) * value),
          style: style, textAlign: TextAlign.left);
    } else if (maxValue is Duration) {
      int maxValueRound = (maxValue.inSeconds / 36000).ceil() * 36000;
      print(maxValueRound);

      Duration duration = Duration(seconds: maxValueRound);
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
  };
}

class GraphDataSpots {
  DateTime date;
  dynamic value;
  GraphDataSpots({required this.date, required this.value});
}
