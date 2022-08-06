import 'package:agency_time/functions/clients/models/month.dart';

class Client {
  bool activeMonth;
  bool internal;
  String id;
  String name;
  Month selectedMonth;
  Month? compareMonth;
  List<Month> savedMonths;
  DateTime? updatedAt;

  Client copyWith({
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
    required this.savedMonths,
    required this.selectedMonth,
    this.compareMonth,
    this.updatedAt,
    required this.id,
    required this.name,
  });
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
