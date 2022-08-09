import 'package:cloud_firestore/cloud_firestore.dart';

class Month {
  DateTime month;
  Duration duration;
  double mrr;
  double hourlyRate;
  double hourlyRateTarget;
  List<ClientMonthEmployee> employees;
  Map tags;
  DateTime updatedAt;

  Month({
    required this.month,
    this.mrr = 0,
    this.hourlyRateTarget = 0,
    this.hourlyRate = 0,
    this.duration = const Duration(),
    this.employees = const [],
    required this.updatedAt,
    this.tags = const {},
  });
  static Month? convertMonth(Map<String, dynamic>? value, String monthId) {
    if (value == null || value.isEmpty) {
      return null;
    }

    Duration duration = Duration(seconds: value['duration'] ?? 0);

    double newMrr = value['mrr'] != null ? value['mrr'].toDouble() : 0;

    List<ClientMonthEmployee> employees = [];
    if (value['employees'] != null) {
      value['employees'].forEach((key, value) {});
    }

    Timestamp updatedAtStamp = value['updatedAt'] ?? Timestamp.now();

    return Month(
      month: DateTime(int.parse(monthId.split('-').first),
          int.parse(monthId.split('-').last)),
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
