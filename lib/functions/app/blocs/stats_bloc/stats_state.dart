part of 'stats_bloc.dart';

enum StatsStatus { loading, succes, failed, initial }

class StatsState extends Equatable {
  const StatsState({
    this.months = const [],
    this.selectedMonth = const CompanyMonth(),
    this.compareMonth = const CompanyMonth(),
    this.totalDurationChange = const Duration(),
    this.status = StatsStatus.initial,
    this.clientsDurationChange = const Duration(),
    this.internalDurationChange = const Duration(),
    this.mrrChange = 0,
    this.clientsHourlyRateChange = 0,
    this.totalHourlyRateChange = 0,
  });
  final StatsStatus status;
  final List<CompanyMonth> months;

  final double mrrChange;

  final double clientsHourlyRateChange;
  final double totalHourlyRateChange;

  final Duration clientsDurationChange;

  final Duration internalDurationChange;
  final Duration totalDurationChange;

  final CompanyMonth selectedMonth;
  final CompanyMonth compareMonth;

  StatsState copyWith({
    StatsStatus? status,
    List<CompanyMonth>? months,
    double? mrrChange,
    double? clientsHourlyRateChange,
    double? totalHourlyRateChange,
    Duration? clientsDurationChange,
    Duration? internalDurationChange,
    Duration? totalDurationChange,
    CompanyMonth? selectedMonth,
    CompanyMonth? compareMonth,
  }) {
    return StatsState(
      months: months ?? this.months,
      selectedMonth: selectedMonth ?? this.selectedMonth,
      compareMonth: compareMonth ?? this.compareMonth,
      mrrChange: mrrChange ?? this.mrrChange,
      clientsDurationChange:
          clientsDurationChange ?? this.clientsDurationChange,
      totalDurationChange: totalDurationChange ?? this.totalDurationChange,
      internalDurationChange:
          internalDurationChange ?? this.internalDurationChange,
      clientsHourlyRateChange:
          clientsHourlyRateChange ?? this.clientsHourlyRateChange,
      totalHourlyRateChange:
          totalHourlyRateChange ?? this.totalHourlyRateChange,
    );
  }

  @override
  List<Object> get props => [
        months,
        selectedMonth,
        status,
        mrrChange,
        internalDurationChange,
        clientsDurationChange,
        totalDurationChange,
        clientsHourlyRateChange,
        totalHourlyRateChange,
        totalDurationChange,
      ];
}
