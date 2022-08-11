import 'package:intl/intl.dart';

double getHourlyRate(double mrr, Duration totalDuration) {
  return mrr / (totalDuration.inSeconds / 3600);
}

double getChangeProcentage(thisMonth, lastMonth) {
  if (lastMonth == null) return 100;
  double change = (thisMonth - lastMonth) / thisMonth * 100;
  return change.isInfinite ? 100 : change;
}

final moneyFormatter = NumberFormat.currency(locale: 'da', name: 'kr.');

String toK(double value) {
  if (value > 1000) {
    return '${(value / 1000).toStringAsPrecision(2)}k';
  } else {
    return moneyFormatter.format(value);
  }
}
