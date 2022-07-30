import 'package:agency_time/models/clientMonth.dart';

class Client {
  String id;
  String name;
  Month selectedMonth;
  Month? compareMonth;
  DateTime? updatedAt;

  Client copyWith({
    String? name,
    String? id,
    DateTime? updatedAt,
    Month? selectedMonth,
    Month? compareMonth,
  }) {
    return Client(
      updatedAt: updatedAt ?? this.updatedAt,
      id: id ?? this.id,
      name: name ?? this.name,
      selectedMonth: selectedMonth ?? this.selectedMonth,
      compareMonth: compareMonth ?? this.compareMonth,
    );
  }

  Client({
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
