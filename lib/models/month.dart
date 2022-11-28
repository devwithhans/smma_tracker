import 'package:agency_time/features/client/data_processing/get_mrr.dart';
import 'package:agency_time/models/company.dart';

import 'package:agency_time/models/employee.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class Month {
  DateTime date;
  Duration duration;
  double mrr;
  double hourlyRate;
  double hourlyRateTarget;
  List<Employee> employees;
  Map tags;
  bool paused;
  DateTime updatedAt;

  Month({
    required this.date,
    this.mrr = 0,
    this.paused = false,
    this.hourlyRateTarget = 0,
    this.hourlyRate = 0,
    this.duration = const Duration(),
    this.employees = const [],
    required this.updatedAt,
    this.tags = const {},
  });

  static Month? getCompanyMonth({
    required String monthId,
    required Map<String, dynamic> monthMap,
    required Company company,
  }) {
    double mrr = monthMap['mrr'] != null ? monthMap['mrr'].toDouble() : 0;
    Duration duration = Duration(seconds: monthMap['duration'] ?? 0);
    Timestamp updatedAtStamp = monthMap['updatedAt'] ?? Timestamp.now();

    List<Employee> employees = [];
    Map employeesData = monthMap['employees'] ?? {};
    company.members.forEach((member) {
      Map? employeeMap = employeesData[member.id];
      employees.add(Employee.getEmployeeFromMap(employeeMap, member));
    });
    return Month(
      date: DateTime(int.parse(monthId.split('-').first),
          int.parse(monthId.split('-').last)),
      duration: duration,
      mrr: mrr,
      // employees: employees,
      hourlyRate: mrr / duration.inHours,
      hourlyRateTarget: monthMap['target_hourly_rate'] ?? 0,
      tags: monthMap['tags'] ?? {},
      updatedAt: DateTime.fromMicrosecondsSinceEpoch(
          updatedAtStamp.microsecondsSinceEpoch),
    );
  }

  static Month? convertMonth({
    Map<String, dynamic>? value,
    required Fee fee,
    required String monthId,
    required Company company,
  }) {
    if (value == null || value.isEmpty) {
      return null;
    }

    double newMrr = 0;

    fee.services.forEach((key, value) {
      newMrr = newMrr + value.mrr;
    });

    Duration duration = Duration(seconds: value['duration'] ?? 0);

    List<Employee> employees = [];
    Map employeesData = value['employees'] ?? {};
    company.members.forEach((member) {
      Map? employeeMap = employeesData[member.id];
      employees.add(Employee.getEmployeeFromMap(employeeMap, member));
    });

    Timestamp updatedAtStamp = value['updatedAt'] ?? Timestamp.now();
    bool paused = value['paused'] ?? false;
    return Month(
      date: DateTime(int.parse(monthId.split('-').first),
          int.parse(monthId.split('-').last)),
      duration: duration,
      paused: paused,
      mrr: newMrr,
      employees: employees,
      hourlyRate: newMrr / (duration.inSeconds / 3600),
      hourlyRateTarget: value['target_hourly_rate'] ?? 0,
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
