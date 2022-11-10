import 'package:agency_time/logic/data_visualisation/models/duration_data.dart';

class GraphDataSpot {
  DurationData durationData;
  double mrr;
  String spotDayName;
  DateTime spotDay;

  GraphDataSpot({
    required this.durationData,
    required this.spotDay,
    this.mrr = 0,
    required this.spotDayName,
  });
}
