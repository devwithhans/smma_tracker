import 'package:flutter/material.dart';

class DashData {
  const DashData({
    Key? key,
    this.mrr,
    this.lastMrr,
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
  final double? mrr;
  final double? lastMrr;

  final Duration internalDuration;
  final Duration internalDurationChange;
}
