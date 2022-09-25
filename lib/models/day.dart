import 'package:agency_time/models/company.dart';
import 'package:agency_time/models/employee.dart';

import 'package:cloud_firestore/cloud_firestore.dart';

class DayOld {
  final Duration internalDuration;
  final DateTime day;
  final Duration clientsDuration;
  final Duration totalDuration;
  final double dailyRevenue;
  final double totalHourlyRate;
  final double clientsHourlyRate;
  final List<Employee> employees;
  final Map tags;

  const DayOld({
    required this.day,
    this.internalDuration = const Duration(seconds: 0),
    this.clientsDuration = const Duration(),
    this.totalDuration = const Duration(),
    this.dailyRevenue = 0,
    this.clientsHourlyRate = 0,
    this.totalHourlyRate = 0,
    this.employees = const [],
    this.tags = const {},
  });

  static DayOld? convertDay(
    Map<String, dynamic>? value,
    Company company,
    double mrr,
  ) {
    if (value == null) return null;

    DateTime dayDate = value['updatedAt'];
    double dailyRevenue = mrr / getDaysInMonth(dayDate.year, dayDate.month);

    Duration internalDuration =
        Duration(seconds: value['internalDuration'] ?? 0);
    Duration clientsDuration = Duration(seconds: value['clientsDuration'] ?? 0);
    Duration totalDuration = internalDuration + clientsDuration;

    List<Employee> employees = [];
    Map employeesData = value['employees'] ?? {};
    company.members.forEach((element) {
      Map? employeeData = employeesData[element.id];
      employees.add(Employee.getEmployeeFromMap(employeeData, element));
    });

    Timestamp updatedAtStamp = value['updatedAt'];
    double totalHourlyRate = (dailyRevenue / (totalDuration.inSeconds / 3600));
    double clientsHourlyRate =
        (dailyRevenue / (clientsDuration.inSeconds / 3600));
    return DayOld(
      internalDuration: internalDuration,
      totalDuration: totalDuration,
      clientsDuration: clientsDuration,
      dailyRevenue: dailyRevenue,
      employees: employees,
      clientsHourlyRate: clientsHourlyRate.isFinite ? clientsHourlyRate : 0,
      totalHourlyRate: totalHourlyRate.isFinite ? totalHourlyRate : 0,
      tags: value['tags'] ?? {},
      day: DateTime.fromMicrosecondsSinceEpoch(
          updatedAtStamp.microsecondsSinceEpoch),
    );
  }
}

int getDaysInMonth(int year, int month) {
  if (month == DateTime.february) {
    final bool isLeapYear =
        (year % 4 == 0) && (year % 100 != 0) || (year % 400 == 0);
    return isLeapYear ? 29 : 28;
  }
  const List<int> daysInMonth = <int>[
    31,
    -1,
    31,
    30,
    31,
    30,
    31,
    31,
    30,
    31,
    30,
    31
  ];
  return daysInMonth[month - 1];
}
