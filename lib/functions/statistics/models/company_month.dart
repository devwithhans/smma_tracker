import 'package:agency_time/functions/authentication/models/company.dart';
import 'package:agency_time/functions/authentication/models/user.dart';
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
    if (value == null) {
      return null;
    }
    Duration internalDuration =
        Duration(seconds: value['internalDuration'] ?? 0);
    Duration clientsDuration = Duration(seconds: value['clientsDuration'] ?? 0);
    Duration totalDuration = internalDuration + clientsDuration;

    double newMrr = value['mrr'] != null ? value['mrr'].toDouble() : 0;
    List<Employee> employees = [];
    Map employeesData = value['employees'] ?? {};
    company.members.forEach((element) {
      Map? employeeData = employeesData[element.id];
      if (employeeData != null) {
        Duration internalDuration = employeeData['internalDuration'] != null
            ? Duration(seconds: employeeData['internalDuration'])
            : const Duration();
        Duration clientsDuration = employeeData['clientsDuration'] != null
            ? Duration(seconds: employeeData['clientsDuration'])
            : const Duration();
        Duration totalDuration = clientsDuration + internalDuration;

        double totalHourlyRate = newMrr / (totalDuration.inSeconds / 3600);
        double clientsHourlyRate = newMrr / (clientsDuration.inSeconds / 3600);

        employees.add(Employee(
            member: element,
            lastActivity: employeeData['updatedAt'] != null
                ? DateTime.fromMicrosecondsSinceEpoch(
                    employeeData['updatedAt'].microsecondsSinceEpoch)
                : null,
            totalDuration: totalDuration,
            clientsDuration: clientsDuration,
            totalHourlyRate: totalHourlyRate.isFinite ? totalHourlyRate : 0,
            clientsHourlyRate:
                clientsHourlyRate.isFinite ? clientsHourlyRate : 0,
            internalDuration: internalDuration,
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
  double clientsHourlyRate;
  double totalHourlyRate;
  DateTime? lastActivity;
  final Map tags;
  Employee({
    required this.member,
    this.lastActivity,
    required this.clientsDuration,
    required this.totalDuration,
    required this.clientsHourlyRate,
    required this.internalDuration,
    required this.totalHourlyRate,
    required this.tags,
  });
}
