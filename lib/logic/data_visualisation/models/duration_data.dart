class DurationData {
  final Duration clientDuration;
  final Duration internalDuration;
  final Duration totalDuration;

  final double clientHourlyRate;
  final double internalHourlyRate;
  final double totalHourlyRate;

  const DurationData({
    this.clientDuration = const Duration(),
    this.internalDuration = const Duration(),
    this.totalDuration = const Duration(),
    this.clientHourlyRate = 0,
    this.internalHourlyRate = 0,
    this.totalHourlyRate = 0,
  });

  static DurationData fromMap(
      {required Map<String, dynamic> value, double? revenue}) {
    int clientSeconds = value['clientsDuration'] ?? 0;
    int internalSeconds = value['internalDuration'] ?? 0;
    int totalSeconds = clientSeconds + internalSeconds;
    double clientHourlyRate = 0;
    double internalHourlyRate = 0;
    double totalHourlyRate = 0;

    if (revenue != null) {
      clientHourlyRate = revenue / (clientSeconds / 3600);
      internalHourlyRate = revenue / (internalSeconds / 3600);
      totalHourlyRate = revenue / (totalSeconds / 3600);
    }

    return DurationData(
      clientDuration: Duration(seconds: clientSeconds),
      internalDuration: Duration(seconds: internalSeconds),
      totalDuration: Duration(seconds: totalSeconds),
      clientHourlyRate: clientHourlyRate,
      internalHourlyRate: internalHourlyRate,
      totalHourlyRate: totalHourlyRate,
    );
  }
}
