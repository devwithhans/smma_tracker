import 'package:agency_time/models/clientMonth.dart';

class Client {
  bool activeMonth;
  String id;
  String name;
  Month selectedMonth;
  Month? compareMonth;
  List<Month> savedMonths;
  DateTime? updatedAt;

  Client copyWith({
    bool? activeMonth,
    String? name,
    String? id,
    DateTime? updatedAt,
    Month? selectedMonth,
    Month? compareMonth,
    List<Month>? savedMonths,
  }) {
    return Client(
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

  ClientLite copyWith({
    String? name,
    String? id,
  }) {
    return ClientLite(
      id: id ?? this.id,
      name: name ?? this.name,
    );
  }

  static ClientLite fromClient(
    Client client,
  ) {
    return ClientLite(
      id: client.id,
      name: client.name,
    );
  }

  ClientLite({
    required this.id,
    required this.name,
  });
}
