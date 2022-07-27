import 'package:agency_time/models/clientMonth.dart';

class Client {
  String id;
  String name;
  double hourlyRateTarget;
  double mrr;
  Month? thisMonth;
  Month? lastMonth;
  DateTime? updatedAt;

  double mrrChange;
  double durationChange;
  double hourlyRateChange;

  Client copyWith({
    String? id,
    DateTime? updatedAt,
    String? name,
    double? hourlyRateTarget,
    double? mrr,
    Month? thisMonth,
    Month? lastMonth,
    double? mrrChange,
    double? durationChange,
    double? hourlyRateChange,
  }) {
    return Client(
      updatedAt: updatedAt ?? this.updatedAt,
      id: id ?? this.id,
      name: name ?? this.name,
      mrr: mrr ?? this.mrr,
      hourlyRateTarget: hourlyRateTarget ?? this.hourlyRateTarget,
      thisMonth: thisMonth ?? this.thisMonth,
      lastMonth: lastMonth ?? this.lastMonth,
    );
  }

  Client({
    this.thisMonth,
    this.lastMonth,
    this.updatedAt,
    this.mrrChange = 100,
    this.durationChange = 100,
    this.hourlyRateChange = 100,
    required this.id,
    required this.name,
    required this.mrr,
    required this.hourlyRateTarget,
  });
}
