import 'package:agency_time/models/company.dart';
import 'package:agency_time/models/user.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class CompanyMonth {
  final DateTime? date;
  final String? id;
  final Duration internalDuration;
  final Duration clientsDuration;
  final Duration totalDuration;
  final double clientsHourlyRate;
  final double totalHourlyRate;
  final List<Employee> employees;
  final Map tags;
  final double mrr;
  final DateTime? updatedAt;

  const CompanyMonth({
    this.id,
    this.date,
    this.mrr = 0,
    this.clientsHourlyRate = 0,
    this.totalHourlyRate = 0,
    this.internalDuration = const Duration(seconds: 0),
    this.clientsDuration = const Duration(),
    this.totalDuration = const Duration(),
    this.employees = const [],
    this.updatedAt,
    this.tags = const {},
  });

  static CompanyMonth? convertMonth(
    Map<String, dynamic>? value,
    String monthId,
    Company company,
  ) {
    if (value == null) return null;

    Duration internalDuration =
        Duration(seconds: value['internalDuration'] ?? 0);
    Duration clientsDuration = Duration(seconds: value['clientsDuration'] ?? 0);
    Duration totalDuration = internalDuration + clientsDuration;
    double newMrr = value['mrr'] != null ? value['mrr'].toDouble() : 0;
    List<Employee> employees = [];
    Map employeesData = value['employees'] ?? {};
    company.members.forEach((element) {
      Map? employeeData = employeesData[element.id];
      employees.add(Employee.getEmployeeFromMap(employeeData, element));
    });

    Timestamp updatedAtStamp = value['updatedAt'];
    double totalHourlyRate = (newMrr / (totalDuration.inSeconds / 3600));
    double clientsHourlyRate = (newMrr / (clientsDuration.inSeconds / 3600));
    return CompanyMonth(
      id: monthId,
      date: DateTime(int.parse(monthId.split('-').first),
          int.parse(monthId.split('-').last)),
      internalDuration: internalDuration,
      totalDuration: totalDuration,
      clientsDuration: clientsDuration,
      mrr: newMrr,
      employees: employees,
      clientsHourlyRate: clientsHourlyRate.isFinite ? clientsHourlyRate : 0,
      totalHourlyRate: totalHourlyRate.isFinite ? totalHourlyRate : 0,
      tags: value['tags'] ?? {},
      updatedAt: DateTime.fromMicrosecondsSinceEpoch(
          updatedAtStamp.microsecondsSinceEpoch),
    );
  }
}

class Employee {
  final Member member;
  Duration internalDuration;
  Duration clientsDuration;
  Duration totalDuration;
  DateTime? lastActivity;
  final Map tags;
  Employee({
    required this.member,
    this.lastActivity,
    required this.clientsDuration,
    required this.totalDuration,
    required this.internalDuration,
    required this.tags,
  });

  static getEmployeeFromMap(Map? employeeMap, Member member) {
    if (employeeMap != null) {
      Duration totalDuration = employeeMap['duration'] != null
          ? Duration(seconds: employeeMap['duration'])
          : const Duration();
      return Employee(
          member: member,
          lastActivity: employeeMap['updatedAt'] != null
              ? DateTime.fromMicrosecondsSinceEpoch(
                  employeeMap['updatedAt'].microsecondsSinceEpoch)
              : null,
          totalDuration: totalDuration,
          clientsDuration: Duration(),
          internalDuration: Duration(),
          tags: employeeMap['tags'] ?? {});
    } else {
      return Employee(
        member: member,
        totalDuration: Duration(),
        clientsDuration: Duration(),
        internalDuration: Duration(),
        tags: {},
      );
    }
  }
}
