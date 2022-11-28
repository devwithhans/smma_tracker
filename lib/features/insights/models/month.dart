import 'package:agency_time/features/client/data_processing/get_mrr.dart';
import 'package:agency_time/features/insights/models/service.dart';
import 'package:agency_time/models/employee.dart';

class MonthData {
  DateTime date;
  Duration totalDuration;
  Duration internalDuration;
  Duration clientDuration;
  double totalMrr;
  double totalHourlyRate;
  double hourlyRateTarget;
  List<ServiceData> services;
  List<Employee> employees;

  Map tags;
  bool paused;
  DateTime? updatedAt;

  MonthData({
    required this.date,
    this.totalMrr = 0,
    this.services = const [],
    this.employees = const [],
    this.totalDuration = const Duration(),
    this.clientDuration = const Duration(),
    this.internalDuration = const Duration(),
    this.totalHourlyRate = 0,
    this.hourlyRateTarget = 0,
    this.paused = false,
    this.updatedAt,
    this.tags = const {},
  });

  static MonthData getMonthData({
    required String monthId,
    Map? monthMap,
    required List<Fee> fees,
  }) {
    Fee fee = fees.firstWhere(
        (element) => "${element.date.year}-${element.date.month}" == monthId);
    MonthData monthData = MonthData(date: fee.date);

    // if (monthMap == null || monthMap.isEmpty) {
    //   return monthData;
    // }

    double totalMrr = 0;
    fee.services.forEach((key, value) {
      totalMrr = totalMrr + value.mrr;
    });

    List<ServiceData> services =
        ServiceData.getService(fee: fee, services: monthMap!['services']);

    monthData = MonthData(
      date: fee.date,
      totalMrr: fee.totalMrr,
      services: services,
    );

    return monthData;
  }
}
