import 'package:cloud_firestore/cloud_firestore.dart';

class Month {
  Duration duration;
  double mrr;
  double hourlyRate;
  double hourlyRateTarget;
  List<ClientMonthEmployee> employees;
  Map tags;
  DateTime updatedAt;

  Month({
    this.mrr = 0,
    this.hourlyRateTarget = 0,
    this.hourlyRate = 0,
    this.duration = const Duration(),
    this.employees = const [],
    required this.updatedAt,
    this.tags = const {},
  });
  static Month? convertClient(Map<String, dynamic>? value) {
    if (value == null) {
      return null;
    }

    Duration duration = Duration(seconds: value['duration'] ?? 0);

    double newMrr = value['mrr'] != null ? value['mrr'].toDouble() : 0;

    List<ClientMonthEmployee> employees = [];
    if (value['employees'] != null) {
      value['employees'].forEach((key, value) {
        print(value);
      });
      // for (var employee in value['employees']) {
      // }
    }

    Timestamp updatedAtStamp = value['updatedAt'];

    return Month(
      duration: duration,
      mrr: newMrr,
      hourlyRate: newMrr / duration.inHours,
      hourlyRateTarget: value['hourlyRateTarget'] ?? 0,
      tags: value['tags'] ?? {},
      updatedAt: DateTime.fromMicrosecondsSinceEpoch(
          updatedAtStamp.microsecondsSinceEpoch),
    );
  }
}

class ClientMonthEmployee {
  final String id;
  final int duration;
  final Map<String, int> tags;
  final DateTime stopped;
  ClientMonthEmployee({
    required this.id,
    required this.stopped,
    required this.duration,
    required this.tags,
  });
}
