import 'package:agency_time/logic/data_visualisation/models/month.dart';
import 'package:agency_time/utils/functions/data_explanation.dart';
import 'package:agency_time/views/view_data_visualisation/data_visualisation_dependencies.dart';

class Changes {
  final Duration clientDuration;
  final Duration internalDuration;
  final Duration totalDuration;

  final double mrr;

  final double clientHourlyRate;
  final double internalHourlyRate;
  final double totalHourlyRate;

  const Changes({
    this.clientDuration = const Duration(),
    this.internalDuration = const Duration(),
    this.totalDuration = const Duration(),
    this.mrr = 0,
    this.clientHourlyRate = 0,
    this.internalHourlyRate = 0,
    this.totalHourlyRate = 0,
  });

  static Changes getFromMonths(Month currentMonth, Month compareMonth) {
    Duration clientDuraiton = currentMonth.durationData.clientDuration -
        compareMonth.durationData.clientDuration;

    Duration internalDuration = currentMonth.durationData.internalDuration -
        compareMonth.durationData.internalDuration;

    Duration totalDuration = currentMonth.durationData.totalDuration -
        compareMonth.durationData.totalDuration;

    double clientHourlyRate = getChangeProcentage(
        currentMonth.durationData.clientHourlyRate,
        compareMonth.durationData.clientHourlyRate);
    double internalHourlyRate = getChangeProcentage(
        currentMonth.durationData.internalHourlyRate,
        compareMonth.durationData.internalHourlyRate);
    double totalHourlyRate = getChangeProcentage(
        currentMonth.durationData.totalHourlyRate,
        compareMonth.durationData.totalHourlyRate);

    double mrr = getChangeProcentage(currentMonth.mrr, compareMonth.mrr);

    return Changes(
      mrr: mrr,
      clientDuration: clientDuraiton,
      clientHourlyRate: clientHourlyRate,
      totalDuration: totalDuration,
      totalHourlyRate: totalHourlyRate,
      internalDuration: internalDuration,
      internalHourlyRate: internalHourlyRate,
    );
  }
}
