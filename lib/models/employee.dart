import 'package:agency_time/models/user.dart';

class Employee {
  final UserData member;
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

  static getEmployeeFromMap(Map? employeeMap, UserData member) {
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
