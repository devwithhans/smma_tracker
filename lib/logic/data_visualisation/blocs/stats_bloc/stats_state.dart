part of 'stats_bloc.dart';

enum StatsStatus { loading, succes, failed, initial }

class StatsState extends Equatable {
  const StatsState({
    this.months = const [],
    this.dashData,
    this.selectedMonth = const CompanyMonth(),
    this.compareMonth = const CompanyMonth(),
    this.status = StatsStatus.initial,
  });
  final StatsStatus status;
  final List<CompanyMonth> months;
  final DashData? dashData;

  final CompanyMonth selectedMonth;
  final CompanyMonth compareMonth;

  StatsState copyWith({
    StatsStatus? status,
    List<CompanyMonth>? months,
    DashData? dashData,
    CompanyMonth? selectedMonth,
    CompanyMonth? compareMonth,
  }) {
    return StatsState(
      dashData: dashData ?? this.dashData,
      months: months ?? this.months,
      selectedMonth: selectedMonth ?? this.selectedMonth,
      compareMonth: compareMonth ?? this.compareMonth,
    );
  }

  @override
  List get props => [
        months,
        selectedMonth,
        status,
        dashData,
      ];
}
