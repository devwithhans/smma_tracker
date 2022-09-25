import 'package:agency_time/models/day.dart';
import 'package:agency_time/new_data_handling/models/duration_data.dart';
import 'package:agency_time/new_data_handling/models/user_tracking.dart';

class Day {
  final DateTime dayDate;
  final double revenue;
  final DurationData durationData;
  final List<UserTracking> userTrackings;
  Day({
    required this.dayDate,
    this.durationData = const DurationData(),
    this.userTrackings = const [],
    this.revenue = 0,
  });

  static List<Day> getListOfDaysFromMap(
      {required Map daysMap,
      required DateTime monthDate,
      required double mrr}) {
    List<Day> days = [];
    int daysInMonth = getDaysInMonth(monthDate.year, monthDate.month);
    DateTime today = DateTime.now();
    if (today.year == monthDate.year && today.month == monthDate.month) {
      daysInMonth = today.day;
      print(daysInMonth);
    }

    for (int i = 1; i <= daysInMonth; i++) {
      Map<String, dynamic>? rawDay = daysMap[i.toString()];
      Day day = Day(
        dayDate: DateTime.utc(monthDate.year, monthDate.month, i),
        revenue: mrr / daysInMonth,
      );
      if (rawDay != null) {
        day = Day.fromMap(rawDay, mrr / daysInMonth);
      }
      days.add(day);
    }
    print(days.last.dayDate);
    return days;
  }

  static Day fromMap(Map<String, dynamic> value, double revenue) {
    return Day(
        dayDate: value['updatedAt'].toDate(),
        revenue: revenue,
        durationData: DurationData.fromMap(value: value, revenue: revenue),
        userTrackings: UserTracking.toList(value['employees']));
  }
}

getLastValueInMap(Map map) {
  List mapValues = [];

  map.forEach((key, value) {
    mapValues.add(value);
  });
  return mapValues.last;
}
