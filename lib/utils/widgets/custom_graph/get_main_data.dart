import 'package:agency_time/utils/constants/colors.dart';
import 'package:agency_time/utils/widgets/custom_graph.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

LineChartData mainData({
  Widget Function(double, TitleMeta)? getLeftTitleWidgets,
  Widget Function(double, TitleMeta)? getBottomTitleWidgets,
  List<FlSpot>? spots,
  required List<GraphDataSpots> months,
  required NumberFormat moneyFormatter,
}) {
  return LineChartData(
    minX: 0,
    maxX: months.length.toDouble() - 1,
    minY: 0,
    maxY: 6,
    lineTouchData: LineTouchData(
      touchTooltipData: LineTouchTooltipData(
          tooltipBgColor: Color(0xff23b6e6),
          getTooltipItems: (List<LineBarSpot> touchedBarSpots) {
            return touchedBarSpots.map((barSpot) {
              final flSpot = barSpot;
              return LineTooltipItem(
                '',
                const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
                children: [
                  TextSpan(
                    text: getValueAsString(
                        getMaxValue(months).value, 5, flSpot.y, moneyFormatter),
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
    titlesData: FlTitlesData(
      show: true,
      rightTitles: AxisTitles(
        sideTitles: SideTitles(showTitles: false),
      ),
      topTitles: AxisTitles(
        sideTitles: SideTitles(showTitles: false),
      ),
      leftTitles: AxisTitles(
        sideTitles: SideTitles(
          showTitles: true,
          interval: 1,
          getTitlesWidget: getLeftTitleWidgets,
          reservedSize: 100,
        ),
      ),
      bottomTitles: AxisTitles(
        sideTitles: SideTitles(
          showTitles: true,
          reservedSize: 50,
          interval: 1,
          getTitlesWidget: getBottomTitleWidgets,
        ),
      ),
    ),
    lineBarsData: [
      LineChartBarData(
        spots: spots,
        isCurved: false,
        preventCurveOverShooting: true,
        preventCurveOvershootingThreshold: 0,
        gradient: LinearGradient(
          colors: kGradientColors,
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
            colors:
                kGradientColors.map((color) => color.withOpacity(0.3)).toList(),
            begin: Alignment.centerLeft,
            end: Alignment.centerRight,
          ),
        ),
      ),
    ],
  );
}
