import 'package:agency_time/functions/statistics/models/company_month.dart';
import 'package:agency_time/functions/statistics/models/dashdata.dart';
import 'package:agency_time/models/user.dart';
import 'package:agency_time/utils/functions/data_explanation.dart';
import 'package:flutter/material.dart';

DashData getEmployeeDashData({
  required String userId,
  required List<Employee> thisMonthEmployees,
  List<Employee>? lastMonthEmployees = const [],
  double? mrr,
  double? lastMrr,
  Employee? employee,
}) {
  Employee selectedMonthEmployee;

  if (employee == null) {
    List<Employee> selectedMonthEmployeeList = thisMonthEmployees
        .where(
          (element) => element.member.id == userId,
        )
        .toList();
    if (selectedMonthEmployeeList.isEmpty) {
      selectedMonthEmployee = Employee(
        member: Member(email: '', id: '', firstName: '', lastName: ''),
        clientsDuration: Duration(),
        totalDuration: Duration(),
        clientsHourlyRate: 0,
        internalDuration: Duration(),
        totalHourlyRate: 0,
        tags: {},
      );
    } else {
      selectedMonthEmployee = selectedMonthEmployeeList.first;
    }
  } else {
    selectedMonthEmployee = employee;
  }

  List<Employee> compareMonthEmployeeList = lastMonthEmployees != null
      ? lastMonthEmployees
          .where(
            (element) => element.member.id == userId,
          )
          .toList()
      : [];
  Employee compareMonthEmployee = compareMonthEmployeeList.isNotEmpty
      ? compareMonthEmployeeList.first
      : Employee(
          member: selectedMonthEmployee.member,
          clientsDuration: Duration(),
          internalDuration: Duration(),
          totalHourlyRate: 0,
          clientsHourlyRate: 0,
          totalDuration: Duration(),
          tags: {},
        );

  Duration clientDurationChange = selectedMonthEmployee.clientsDuration -
      compareMonthEmployee.clientsDuration;

  double clientHourlyRateChange = getChangeProcentage(
      selectedMonthEmployee.clientsHourlyRate,
      compareMonthEmployee.clientsHourlyRate);

  Duration totalDurationChange =
      selectedMonthEmployee.totalDuration - compareMonthEmployee.totalDuration;

  double totalHourlyRate =
      getHourlyRate(mrr ?? 0, selectedMonthEmployee.totalDuration);

  double totalHourlyRateChange = getChangeProcentage(
    totalHourlyRate,
    compareMonthEmployee.totalHourlyRate,
  );

  Duration internalDurationChange = selectedMonthEmployee.internalDuration -
      compareMonthEmployee.internalDuration;

  return DashData(
    selectedMrr: mrr,
    compareMrr: lastMrr,
    clientDuration: selectedMonthEmployee.clientsDuration,
    clientDurationChange: clientDurationChange,
    clientsHourlyRate: selectedMonthEmployee.clientsHourlyRate,
    clientHourlyRateChange: clientHourlyRateChange,
    totalDuration: selectedMonthEmployee.totalDuration,
    totalDurationChange: totalDurationChange,
    totalHourlyRate: totalHourlyRate,
    totalHourlyRateChange: totalHourlyRateChange,
    internalDuration: selectedMonthEmployee.internalDuration,
    internalDurationChange: internalDurationChange,
    tags: selectedMonthEmployee.tags,
  );
}
