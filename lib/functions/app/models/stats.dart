import 'package:agency_time/functions/authentication/models/company.dart';
import 'package:agency_time/functions/authentication/models/user.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class CompanyMonth {
  final DateTime? month;
  final Duration internalDuration;
  final Duration clientsDuration;
  final Duration totalDuration;
  final double mrr;
  final double clientsHourlyRate;
  final double totalHourlyRate;
  final double hourlyRateTarget;
  final List<Employee> employees;
  final Map tags;
  final DateTime? updatedAt;

  const CompanyMonth({
    this.month,
    this.mrr = 0,
    this.hourlyRateTarget = 0,
    this.clientsHourlyRate = 0,
    this.totalHourlyRate = 0,
    this.internalDuration = const Duration(),
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
    Map? employeesData = value['employees'];
    company.members.forEach((element) {
      if (employeesData != null) {
        Map? employeeData = employeesData[element.id];
        if (employeeData != null) {
          Duration internalDuration = employeeData['internalDuration'] != null
              ? Duration(seconds: employeeData['internalDuration'])
              : const Duration();
          Duration clientsDuration = employeeData['clientsDuration'] != null
              ? Duration(seconds: employeeData['clientsDuration'])
              : const Duration();
          Duration totalDuration = clientsDuration + internalDuration;

          employees.add(Employee(
              member: element,
              totalDuration: totalDuration,
              clientsDuration: clientsDuration,
              totalHourlyRate: newMrr / (totalDuration.inSeconds / 3600),
              clientsHourlyRate: newMrr / (clientsDuration.inSeconds / 3600),
              internalDuration: internalDuration,
              tags: employeeData['tags'] ?? {}));
        }
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

    // List<Employee> employees = [];
    // if (value['employees'] != null) {
    //   value['employees'].forEach((key, value) {
    //     Duration internalDuration = value['internalDuration'] != null
    //         ? Duration(seconds: value['internalDuration'])
    //         : const Duration();
    //     Duration clientsDuration = value['clientsDuration'] != null
    //         ? Duration(seconds: value['clientsDuration'])
    //         : const Duration();
    //     Duration totalDuration = clientsDuration + internalDuration;
    //     Member member = Member(id: key, firstName: '', lastName: '', email: '');
    //     List<Member> memberList =
    //         company.members.where((element) => element.id == key).toList();
    //     if (memberList.isNotEmpty) {
    //       member = memberList.first;
    //     }
    //     employees.add(Employee(
    //       member: member,
    //       totalDuration: totalDuration,
    //       clientsDuration: clientsDuration,
    //       totalHourlyRate: newMrr / (totalDuration.inSeconds / 3600),
    //       clientsHourlyRate: newMrr / (clientsDuration.inSeconds / 3600),
    //       internalDuration: internalDuration,
    //       tags: value['tags'] ?? {},
    //     ));
    //   });
    // }

    Timestamp updatedAtStamp = value['updatedAt'];

    return CompanyMonth(
      month: DateTime(int.parse(monthId.split('-').first),
          int.parse(monthId.split('-').last)),
      internalDuration: internalDuration,
      totalDuration: totalDuration,
      clientsDuration: clientsDuration,
      mrr: newMrr,
      employees: employees,
      clientsHourlyRate: newMrr / (clientsDuration.inSeconds / 3600),
      totalHourlyRate: newMrr / (totalDuration.inSeconds / 3600),
      hourlyRateTarget: value['hourlyRateTarget'] ?? 0,
      tags: value['tags'] ?? {},
      updatedAt: DateTime.fromMicrosecondsSinceEpoch(
          updatedAtStamp.microsecondsSinceEpoch),
    );
  }
}

class Employee {
  final Member member;
  final Duration internalDuration;
  final Duration clientsDuration;
  final Duration totalDuration;
  final double clientsHourlyRate;
  final double totalHourlyRate;
  final Map tags;
  Employee({
    required this.member,
    required this.clientsDuration,
    required this.totalDuration,
    required this.clientsHourlyRate,
    required this.internalDuration,
    required this.totalHourlyRate,
    required this.tags,
  });
}
