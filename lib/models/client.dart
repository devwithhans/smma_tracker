import 'package:agency_time/models/company.dart';
import 'package:agency_time/models/month.dart';
import 'package:agency_time/utils/functions/data_explanation.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class Client {
  bool activeMonth;
  bool internal;
  String id;
  String name;
  Month? selectedMonth;
  Month? compareMonth;

  Duration durationChange;
  double hourlyRateChange;

  List<Month> savedMonths;
  DateTime? updatedAt;

  Client copyWith({
    Duration? durationChange,
    double? hourlyRateChange,
    bool? activeMonth,
    bool? internal,
    String? name,
    String? id,
    DateTime? updatedAt,
    Month? selectedMonth,
    Month? compareMonth,
    List<Month>? savedMonths,
  }) {
    return Client(
      durationChange: durationChange ?? this.durationChange,
      hourlyRateChange: hourlyRateChange ?? this.hourlyRateChange,
      internal: internal ?? this.internal,
      activeMonth: activeMonth ?? this.activeMonth,
      savedMonths: savedMonths ?? this.savedMonths,
      updatedAt: updatedAt ?? this.updatedAt,
      id: id ?? this.id,
      name: name ?? this.name,
      selectedMonth: selectedMonth ?? this.selectedMonth,
      compareMonth: compareMonth ?? this.compareMonth,
    );
  }

  Client({
    this.internal = false,
    this.activeMonth = true,
    this.durationChange = const Duration(),
    this.hourlyRateChange = 0,
    this.savedMonths = const [],
    this.selectedMonth,
    this.compareMonth,
    this.updatedAt,
    this.id = '',
    this.name = '',
  });

  static Client fromFirestoreResult(
      QueryDocumentSnapshot<Map<String, dynamic>> clientSnapshot,
      Company company) {
    Map clientMap = clientSnapshot.data();

    Map<String, dynamic> monthsAsMap = clientMap['months'] ?? [];
    List<Month> savedMonths = [];

    monthsAsMap.forEach((key, value) {
      Month? month = Month.convertMonth(value, key, company);
      if (month != null) savedMonths.add(month);
    });

    Month? lastMonth = savedMonths.length < 2 ? null : savedMonths[1];
    Month thisMonth = savedMonths[0];
    return Client(
      internal: clientMap['internal'] ?? false,
      id: clientSnapshot.id,
      name: clientMap['name'],
      savedMonths: savedMonths,
      updatedAt: clientMap['updatedAt'],
      compareMonth: savedMonths.length < 2 ? null : savedMonths[1],
      selectedMonth: savedMonths[0],
      hourlyRateChange: getChangeProcentage(
          thisMonth.hourlyRate, lastMonth != null ? lastMonth.hourlyRate : 0),
      durationChange: lastMonth == null
          ? thisMonth.duration
          : thisMonth.duration - lastMonth.duration,
    );
  }
}

class ClientLite {
  String id;
  String name;
  bool internal;

  ClientLite copyWith({
    String? name,
    String? id,
    bool? internal,
  }) {
    return ClientLite(
      internal: internal ?? this.internal,
      id: id ?? this.id,
      name: name ?? this.name,
    );
  }

  static ClientLite fromClient(
    Client client,
  ) {
    return ClientLite(
      internal: client.internal,
      id: client.id,
      name: client.name,
    );
  }

  ClientLite({
    this.internal = false,
    required this.id,
    required this.name,
  });
}
