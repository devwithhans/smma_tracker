import 'package:agency_time/utils/constants/colors.dart';
import 'package:agency_time/utils/widgets/custom_graph.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

LineChartData mainData({
  Widget Function(double, TitleMeta)? getLeftTitleWidgets,
  Widget Function(double, TitleMeta)? getBottomTitleWidgets,
  List<FlSpot>? spots,
  required List<GraphDataSpots> graphDataSpots,
  required NumberFormat moneyFormatter,
}) {
  return LineChartData(
    borderData: FlBorderData(show: false),
    minX: 0,
    maxX: graphDataSpots.length.toDouble() - 1,
    minY: 0,
    maxY: 6,
    gridData: FlGridData(
      show: true,
      drawHorizontalLine: true,
      drawVerticalLine: false,
      getDrawingHorizontalLine: (value) {
        return FlLine(
          color: Colors.grey.shade300,
          strokeWidth: 1,
        );
      },
      horizontalInterval: 1,
    ),
    lineTouchData: LineTouchData(
      touchTooltipData: LineTouchTooltipData(
          fitInsideHorizontally: true,
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
                    text: getValueAsString(getMaxValue(graphDataSpots).value, 5,
                        flSpot.y, moneyFormatter),
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
          showTitles: false,
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
        isCurved: true,
        preventCurveOverShooting: true,
        preventCurveOvershootingThreshold: 0,
        gradient: LinearGradient(
          colors: kGradientColors,
          begin: Alignment.centerLeft,
          end: Alignment.centerRight,
        ),
        barWidth: 2,
        isStrokeCapRound: true,
        dotData: FlDotData(
          show: false,
        ),
        belowBarData: BarAreaData(
          show: true,
          gradient: LinearGradient(colors: [
            Colors.white.withOpacity(0.0001),
            kGradientColors[0].withOpacity(0.3),
          ], begin: Alignment.bottomCenter, end: Alignment.topCenter),
        ),
      ),
    ],
  );
}
