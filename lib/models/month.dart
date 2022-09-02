import 'package:agency_time/functions/statistics/models/company_month.dart';
import 'package:agency_time/models/company.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class Month {
  DateTime date;
  Duration duration;
  double mrr;
  double hourlyRate;
  double hourlyRateTarget;
  List<Employee> employees;
  Map tags;
  DateTime updatedAt;

  Month({
    required this.date,
    this.mrr = 0,
    this.hourlyRateTarget = 0,
    this.hourlyRate = 0,
    this.duration = const Duration(),
    this.employees = const [],
    required this.updatedAt,
    this.tags = const {},
  });
  static Month? convertMonth(
    Map<String, dynamic>? value,
    String monthId,
    Company company,
  ) {
    if (value == null || value.isEmpty) {
      return null;
    }

    Duration duration = Duration(seconds: value['duration'] ?? 0);

    double newMrr = value['mrr'] != null ? value['mrr'].toDouble() : 0;

    List<Employee> employees = [];
    Map employeesData = value['employees'] ?? {};
    company.members.forEach((element) {
      Map? employeeData = employeesData[element.id];
      if (employeeData != null) {
        Duration totalDuration = employeeData['duration'] != null
            ? Duration(seconds: employeeData['duration'])
            : const Duration();

        employees.add(Employee(
            member: element,
            lastActivity: employeeData['updatedAt'] != null
                ? DateTime.fromMicrosecondsSinceEpoch(
                    employeeData['updatedAt'].microsecondsSinceEpoch)
                : null,
            totalDuration: totalDuration,
            clientsDuration: Duration(),
            totalHourlyRate: 0,
            clientsHourlyRate: newMrr / (totalDuration.inSeconds / 3600),
            internalDuration: Duration(),
            tags: employeeData['tags'] ?? {}));
      } else {
        employees.add(
          Employee(
            member: element,
            totalDuration: Duration(),
            clientsDuration: Duration(),
            totalHourlyRate: 0,
            clientsHourlyRate: 0,
            internalDuration: Duration(),
            tags: {},
          ),
        );
      }
    });

    Timestamp updatedAtStamp = value['updatedAt'] ?? Timestamp.now();

    return Month(
      date: DateTime(int.parse(monthId.split('-').first),
          int.parse(monthId.split('-').last)),
      duration: duration,
      mrr: newMrr,
      employees: employees,
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
