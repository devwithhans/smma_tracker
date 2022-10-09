part of 'data_bloc.dart';

class DataState extends Equatable {
  final Month? currentMonth;
  final Month? compareMonth;
  final DateTime? compareMonthDate;
  final Changes changes;
  final List<Month> allMonths;
  final List<Day> allDays;
  final List<GraphDataSpot> graphDataSpots;

  const DataState({
    this.currentMonth,
    this.allDays = const [],
    this.graphDataSpots = const [],
    this.changes = const Changes(),
    this.compareMonth,
    this.compareMonthDate,
    this.allMonths = const [],
  });

  DataState copyWith({
    Month? currentMonth,
    Month? compareMonth,
    DateTime? compareMonthDate,
    List<Month>? allMonths,
    List<Day>? allDays,
    List<GraphDataSpot>? graphDataSpots,
    Changes? changes,
  }) {
    return DataState(
      currentMonth: currentMonth ?? this.currentMonth,
      compareMonth: compareMonth ?? this.compareMonth,
      allMonths: allMonths ?? this.allMonths,
      allDays: allDays ?? this.allDays,
      graphDataSpots: graphDataSpots ?? this.graphDataSpots,
      compareMonthDate: compareMonthDate ?? this.compareMonthDate,
      changes: changes ?? this.changes,
    );
  }

  @override
  List get props => [
        currentMonth,
        allMonths,
        allDays,
        compareMonth,
        compareMonthDate,
        graphDataSpots,
        changes,
      ];
}
