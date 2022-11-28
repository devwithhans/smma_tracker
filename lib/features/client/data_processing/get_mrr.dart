import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';

List<Fee> getAllMonths(List<Fee> fees) {
  List<Fee> filledFees = [];
  fees.sort(((a, b) => a.date.compareTo(b.date)));

  int feeIndex = 0;
  var date1 = fees.first.date;
  var date2 = DateTime.now();
  while (date1.isBefore(date2)) {
    String thisDate = DateFormat("M/yyyy").format(date1);
    if (fees.length - 1 != feeIndex) {
      String nextFeeDate = DateFormat("M/yyyy").format(fees[feeIndex + 1].date);
      if (nextFeeDate == thisDate) {
        feeIndex = feeIndex + 1;
      }
    }
    filledFees.add(fees[feeIndex].copyWith(date: date1));
    date1 = DateTime(date1.year, date1.month + 1);
  }

  return filledFees;
}

class ServiceObject {
  double mrr;
  Map employees;
  ServiceObject({required this.mrr, required this.employees});
}

class Fee {
  DateTime date;
  double totalMrr;
  Map<String, ServiceObject> services;
  Fee({
    required this.date,
    required this.services,
    required this.totalMrr,
  });

  static Fee fromMap(Map map) {
    Map services = map['services'];

    Map<String, ServiceObject> serviceObject = services.map(
      (key, value) => MapEntry(
        key,
        ServiceObject(
          employees: value['employees'],
          mrr: value['mrr'],
        ),
      ),
    );

    Timestamp from = map['from'];

    double totalMrr = 0;
    serviceObject.forEach((key, value) {
      totalMrr = totalMrr + value.mrr;
    });

    Fee fee = Fee(
      totalMrr: totalMrr,
      date: from.toDate(),
      services: serviceObject,
    );
    return fee;
  }

  Fee copyWith({
    DateTime? date,
  }) {
    return Fee(
      date: date ?? this.date,
      totalMrr: totalMrr,
      services: services,
    );
  }
}
