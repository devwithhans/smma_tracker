import 'package:agency_time/functions/statistics/models/company_month.dart';
import 'package:agency_time/utils/functions/data_explanation.dart';
import 'package:flutter/material.dart';

class DashData {
  const DashData({
    Key? key,
    this.selectedMrr,
    this.compareMrr,
    this.changeMrr,
    this.clientDuration = const Duration(),
    this.clientDurationChange = const Duration(),
    this.clientsHourlyRate = 0,
    this.clientHourlyRateChange = 0,
    this.totalDuration = const Duration(),
    this.totalDurationChange = const Duration(),
    this.totalHourlyRate = 0,
    this.totalHourlyRateChange = 0,
    this.internalDuration = const Duration(),
    this.internalDurationChange = const Duration(),
    this.tags = const {},
  });

  final Duration clientDuration;
  final Duration clientDurationChange;

  final double clientsHourlyRate;
  final double clientHourlyRateChange;

  final Duration totalDuration;
  final Duration totalDurationChange;

  final double totalHourlyRate;
  final double totalHourlyRateChange;

  final Map tags;
  final double? selectedMrr;
  final double? compareMrr;
  final double? changeMrr;

  final Duration internalDuration;
  final Duration internalDurationChange;

  static DashData getDashData({
    required CompanyMonth selectedMonth,
    required CompanyMonth compareMonth,
  }) {
    return DashData(
      tags: selectedMonth.tags,
      selectedMrr: selectedMonth.mrr,
      compareMrr: compareMonth.mrr,
      changeMrr: getChangeProcentage(selectedMonth.mrr, compareMonth.mrr),
      clientDuration: selectedMonth.clientsDuration,
      clientDurationChange:
          selectedMonth.clientsDuration - compareMonth.clientsDuration,
      clientsHourlyRate: selectedMonth.clientsHourlyRate,
      clientHourlyRateChange: getChangeProcentage(
          selectedMonth.clientsHourlyRate, compareMonth.clientsHourlyRate),
      totalDuration: selectedMonth.totalDuration,
      totalDurationChange:
          selectedMonth.totalDuration - compareMonth.totalDuration,
      totalHourlyRate: selectedMonth.totalHourlyRate,
      totalHourlyRateChange: getChangeProcentage(
          selectedMonth.totalHourlyRate, compareMonth.totalHourlyRate),
      internalDuration: selectedMonth.internalDuration,
      internalDurationChange:
          selectedMonth.internalDuration - compareMonth.internalDuration,
    );
  }
}
