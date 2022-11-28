import 'package:agency_time/features/client/data_processing/get_mrr.dart';
import 'package:agency_time/features/insights/models/month.dart';
import 'package:agency_time/models/company.dart';
import 'package:agency_time/utils/functions/data_explanation.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';

class Client {
  bool activeMonth;
  bool internal;
  String id;
  String name;
  MonthData? selectedMonth;
  MonthData? compareMonth;
  Duration durationChange;
  double hourlyRateChange;
  bool paused;
  Map relations;

  DateTime? updatedAt;

  Client copyWith({
    Duration? durationChange,
    double? hourlyRateChange,
    bool? activeMonth,
    bool? internal,
    String? name,
    Map? relations,
    String? id,
    DateTime? updatedAt,
    MonthData? selectedMonth,
    MonthData? compareMonth,
  }) {
    return Client(
      durationChange: durationChange ?? this.durationChange,
      hourlyRateChange: hourlyRateChange ?? this.hourlyRateChange,
      internal: internal ?? this.internal,
      relations: relations ?? this.relations,
      activeMonth: activeMonth ?? this.activeMonth,
      updatedAt: updatedAt ?? this.updatedAt,
      id: id ?? this.id,
      name: name ?? this.name,
      selectedMonth: selectedMonth ?? this.selectedMonth,
      compareMonth: compareMonth ?? this.compareMonth,
    );
  }

  Client({
    this.internal = false,
    this.activeMonth = true,
    this.paused = false,
    this.relations = const {},
    this.durationChange = const Duration(),
    this.hourlyRateChange = 0,
    this.selectedMonth,
    this.compareMonth,
    this.updatedAt,
    this.id = '',
    this.name = '',
  });

  static Client fromFirestoreResult(
      QueryDocumentSnapshot<Map<String, dynamic>> clientSnapshot,
      Company company) {
    Map clientMap = clientSnapshot.data();

    List rawFee = clientMap['recurringRevenue'];
    List<Fee> fees = [];
    rawFee.forEach(
      (element) {
        fees.add(Fee.fromMap(element));
      },
    );

    List<Fee> filledFees = getAllMonths(fees);

    Map<String, dynamic> monthsAsMap = clientMap['months'] ?? [];
    List<MonthData> savedMonths = [];

    monthsAsMap.forEach((key, value) {
      MonthData? month = MonthData.getMonthData(
        fees: filledFees,
        monthId: key,
        monthMap: value,
      );

      if (month != null) savedMonths.add(month);
    });

    MonthData? lastMonth = savedMonths.length < 2 ? null : savedMonths[1];
    MonthData thisMonth = savedMonths[0];
    return Client(
      internal: clientMap['internal'] ?? false,
      id: clientSnapshot.id,
      name: clientMap['name'],
      relations: clientMap['relations'] ?? {},
      paused: savedMonths[0].paused,
      updatedAt: clientMap['updatedAt'],
      compareMonth: savedMonths.length < 2 ? null : savedMonths[1],
      selectedMonth: savedMonths[0],
      hourlyRateChange: getChangeProcentage(thisMonth.totalHourlyRate,
          lastMonth != null ? lastMonth.totalHourlyRate : 0),
      durationChange: lastMonth == null
          ? thisMonth.totalDuration
          : thisMonth.totalDuration - lastMonth.totalDuration,
    );
  }
}
