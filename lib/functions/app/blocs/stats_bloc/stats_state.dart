part of 'stats_bloc.dart';

enum Status { loading, succes, failed, initial }

class StatsState extends Equatable {
  const StatsState({
    this.months = const [],
    this.selectedMonth = const CompanyMonth(),
    this.totalDurationChange = const Duration(),
    this.status = Status.initial,
    this.clientsDurationChange = const Duration(),
    this.internalDurationChange = const Duration(),
    this.mrrChange = 0,
    this.hourlyRateChange = 0,
  });
  final Status status;
  final List<CompanyMonth> months;

  final double mrrChange;

  final double hourlyRateChange;

  final Duration clientsDurationChange;

  final Duration internalDurationChange;
  final Duration totalDurationChange;

  final CompanyMonth selectedMonth;

  StatsState copyWith({
    Status? status,
    List<CompanyMonth>? months,
    double? mrrChange,
    double? hourlyRateChange,
    Duration? clientsDurationChange,
    Duration? internalDurationChange,
    Duration? totalDurationChange,
    CompanyMonth? selectedMonth,
  }) {
    return StatsState(
      months: months ?? this.months,
      selectedMonth: selectedMonth ?? this.selectedMonth,
      mrrChange: mrrChange ?? this.mrrChange,
      clientsDurationChange:
          clientsDurationChange ?? this.clientsDurationChange,
      totalDurationChange: totalDurationChange ?? this.totalDurationChange,
      internalDurationChange:
          internalDurationChange ?? this.internalDurationChange,
      hourlyRateChange: hourlyRateChange ?? this.hourlyRateChange,
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
        hourlyRateChange,
      ];
}
