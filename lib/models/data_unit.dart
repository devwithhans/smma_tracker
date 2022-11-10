class DataUnit {
  Duration internal;
  Duration external;
  double hourlyRate;
  DateTime date;

  DataUnit({
    this.internal = const Duration(),
    this.external = const Duration(),
    this.hourlyRate = 0,
    required this.date,
  });
}



/// CURRENT DATA:
/// client_duration
/// internal_duration
/// total_duration

/// CURRENT MONTH:
/// LAST MONTH
/// CLIENT DURATION
/// INTERNAL DURATION
/// TOTAL DURATION

/// CLIENT HOURLY RATE
/// TOTAL HOURLY RATE
