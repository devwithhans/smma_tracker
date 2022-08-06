import 'package:agency_time/functions/clients/models/month.dart';

class InternalClient {
  bool activeMonth;
  String id;
  String name;
  Month selectedMonth;
  Month? compareMonth;
  List<Month> savedMonths;
  DateTime? updatedAt;

  InternalClient copyWith({
    bool? activeMonth,
    String? name,
    String? id,
    DateTime? updatedAt,
    Month? selectedMonth,
    Month? compareMonth,
    List<Month>? savedMonths,
  }) {
    return InternalClient(
      activeMonth: activeMonth ?? this.activeMonth,
      savedMonths: savedMonths ?? this.savedMonths,
      updatedAt: updatedAt ?? this.updatedAt,
      id: id ?? this.id,
      name: name ?? this.name,
      selectedMonth: selectedMonth ?? this.selectedMonth,
      compareMonth: compareMonth ?? this.compareMonth,
    );
  }

  InternalClient({
    this.activeMonth = true,
    required this.savedMonths,
    required this.selectedMonth,
    this.compareMonth,
    this.updatedAt,
    required this.id,
    required this.name,
  });
}
