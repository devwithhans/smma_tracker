/// Contains performance information about a custom period in time. Can be used to show current stats, and to keep previus stats to compare
///
/// Contains:
/// - totalMRR
/// - totalDuration

class PerformanceSnapshot {
  PerformancePeriode performancePeriode;
  PerformanceDurations performanceDurations;
  double mrr;
  double totalHourlyRate;
  double hourlyRateTarget;
  Map tags;

  PerformanceSnapshot({
    this.mrr = 0,
    this.totalHourlyRate = 0,
    this.hourlyRateTarget = 0,
    required this.performancePeriode,
    this.performanceDurations = const PerformanceDurations(),
    this.tags = const {},
  });
}

class PerformancePeriode {
  final DateTime from;
  final DateTime to;
  const PerformancePeriode({required this.from, required this.to});
}

class PerformanceDurations {
  final Duration totalDuration;
  final Duration internalDuration;
  final Duration clientDuration;
  const PerformanceDurations({
    this.totalDuration = const Duration(),
    this.clientDuration = const Duration(),
    this.internalDuration = const Duration(),
  });
}
