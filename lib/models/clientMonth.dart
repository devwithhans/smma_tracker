import 'package:cloud_firestore/cloud_firestore.dart';

class Month {
  Duration duration;
  double mrr;
  double hourlyRateTarget;
  double hourlyRate;
  DateTime? updatedAt;
  List<ClientMonthEmployee> employees;
  Map<String, dynamic> tags;

  Month({
    this.mrr = 0,
    this.hourlyRateTarget = 0,
    this.hourlyRate = 0,
    this.duration = const Duration(),
    this.employees = const [],
    this.updatedAt,
    this.tags = const {},
  });
  static Month convertClient(Map<String, dynamic> value, double mrr) {
    Timestamp updatedAt = value['updatedAt'];
    Duration _duration = Duration(seconds: value['duration'] ?? 0);
    return Month(
      hourlyRate: (value['mrr'] ?? mrr) / _duration.inHours,
      mrr: value['mrr'].toDouble() ?? mrr.toDouble(),
      hourlyRateTarget: value['hourlyRateTarget'] ?? 0,
      tags: value['tags'] ?? {},
      duration: _duration,
      updatedAt:
          DateTime.fromMillisecondsSinceEpoch(updatedAt.millisecondsSinceEpoch),
    );
  }
}

class ClientMonthEmployee {
  final String id;
  final int duration;
  final DateTime stopped;
  ClientMonthEmployee(
      {required this.id, required this.stopped, required this.duration});
}
