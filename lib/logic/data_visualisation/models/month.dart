import 'package:agency_time/logic/data_visualisation/models/day.dart';
import 'package:agency_time/logic/data_visualisation/models/duration_data.dart';
import 'package:agency_time/logic/data_visualisation/models/user_tracking.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class Month {
  DateTime monthDate;
  double mrr;
  DurationData durationData;
  double? hourlyRateTarget;
  List<UserTracking> userTracking;
  List<Day> days;
  Map tags;
  Month({
    required this.monthDate,
    required this.durationData,
    this.days = const [],
    this.userTracking = const [],
    this.mrr = 0,
    this.tags = const {},
    this.hourlyRateTarget,
  });

  static Month fromMap(Map<String, dynamic> value) {
    Timestamp monthDate = value['updatedAt'];
    return Month(
      days: Day.getListOfDaysFromMap(
        daysMap: value['days'] ?? {},
        monthDate: monthDate.toDate(),
        mrr: value['mrr'] ?? {},
      ),
      userTracking: UserTracking.toList(value['employees'] ?? {}),
      monthDate: monthDate.toDate(),
      durationData:
          DurationData.fromMap(value: value, revenue: value['mrr'] ?? 0),
      mrr: value['mrr'] ?? 0,
      tags: value['tags'] ?? {},
    );
  }
}
