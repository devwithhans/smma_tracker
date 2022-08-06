import 'package:cloud_firestore/cloud_firestore.dart';

class CompanyMonth {
  final DateTime? month;
  final Duration internalDuration;
  final Duration clientsDuration;
  final Duration totalDuration;
  final double mrr;
  final double hourlyRate;
  final double totalHourlyRate;
  final double hourlyRateTarget;
  final List<ClientMonthEmployee> employees;
  final Map tags;
  final DateTime? updatedAt;

  const CompanyMonth({
    this.month,
    this.mrr = 0,
    this.hourlyRateTarget = 0,
    this.hourlyRate = 0,
    this.totalHourlyRate = 0,
    this.internalDuration = const Duration(),
    this.clientsDuration = const Duration(),
    this.totalDuration = const Duration(),
    this.employees = const [],
    this.updatedAt,
    this.tags = const {},
  });
  static CompanyMonth? convertMonth(
      Map<String, dynamic>? value, String monthId) {
    if (value == null) {
      return null;
    }
    Duration internalDuration =
        Duration(seconds: value['internalDuration'] ?? 0);
    Duration clientsDuration = Duration(seconds: value['c'] ?? 0);
    Duration totalDuration = internalDuration + clientsDuration;

    double newMrr = value['mrr'] != null ? value['mrr'].toDouble() : 0;

    List<ClientMonthEmployee> employees = [];
    if (value['employees'] != null) {
      value['employees'].forEach((key, value) {});
    }

    Timestamp updatedAtStamp = value['updatedAt'];

    return CompanyMonth(
      month: DateTime(int.parse(monthId.split('-').first),
          int.parse(monthId.split('-').last)),
      internalDuration: internalDuration,
      totalDuration: totalDuration,
      mrr: newMrr,
      hourlyRate: newMrr / (clientsDuration.inSeconds / 3600),
      totalHourlyRate: newMrr / (totalDuration.inSeconds / 3600),
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
