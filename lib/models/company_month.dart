// import 'package:agency_time/models/company.dart';
// import 'package:agency_time/models/day.dart';
// import 'package:agency_time/models/employee.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';

// class CompanyMonth {
//   final DateTime? date;
//   final List<DayOld> days;
//   final String? id;
//   final Duration internalDuration;
//   final Duration clientsDuration;
//   final Duration totalDuration;
//   final double clientsHourlyRate;
//   final double totalHourlyRate;
//   final List<Employee> employees;
//   final Map tags;
//   final double mrr;
//   final DateTime? updatedAt;

//   const CompanyMonth({
//     this.days = const [],
//     this.id,
//     this.date,
//     this.mrr = 0,
//     this.clientsHourlyRate = 0,
//     this.totalHourlyRate = 0,
//     this.internalDuration = const Duration(seconds: 0),
//     this.clientsDuration = const Duration(),
//     this.totalDuration = const Duration(),
//     this.employees = const [],
//     this.updatedAt,
//     this.tags = const {},
//   });

//   static CompanyMonth? convertMonth(
//     Map<String, dynamic>? value,
//     String monthId,
//     Company company,
//   ) {
//     if (value == null) return null;

//     Duration internalDuration =
//         Duration(seconds: value['internalDuration'] ?? 0);
//     Duration clientsDuration = Duration(seconds: value['clientsDuration'] ?? 0);
//     Duration totalDuration = internalDuration + clientsDuration;
//     double newMrr = value['mrr'] != null ? value['mrr'].toDouble() : 0;
//     List<Employee> employees = [];
//     Map employeesData = value['employees'] ?? {};
//     company.members.forEach((element) {
//       Map? employeeData = employeesData[element.id];
//       employees.add(Employee.getEmployeeFromMap(employeeData, element));
//     });

//     Timestamp updatedAtStamp = value['updatedAt'];
//     double totalHourlyRate = (newMrr / (totalDuration.inSeconds / 3600));
//     double clientsHourlyRate = (newMrr / (clientsDuration.inSeconds / 3600));

//     List<DayOld> days = [];
//     List<Map<String, dynamic>> daysRaw = value['days'] ?? [];

//     daysRaw.forEach((e) {
//       DayOld day = DayOld.convertDay(e, company, newMrr)!;
//       days.add(day);
//     });

//     return CompanyMonth(
//       id: monthId,
//       days: days,
//       date: DateTime(int.parse(monthId.split('-').first),
//           int.parse(monthId.split('-').last)),
//       internalDuration: internalDuration,
//       totalDuration: totalDuration,
//       clientsDuration: clientsDuration,
//       mrr: newMrr,
//       employees: employees,
//       clientsHourlyRate: clientsHourlyRate.isFinite ? clientsHourlyRate : 0,
//       totalHourlyRate: totalHourlyRate.isFinite ? totalHourlyRate : 0,
//       tags: value['tags'] ?? {},
//       updatedAt: DateTime.fromMicrosecondsSinceEpoch(
//           updatedAtStamp.microsecondsSinceEpoch),
//     );
//   }
// }
