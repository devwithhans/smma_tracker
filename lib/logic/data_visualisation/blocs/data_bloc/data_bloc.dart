import 'dart:async';
import 'package:agency_time/new_data_handling/models/changes.dart';
import 'package:agency_time/new_data_handling/models/day.dart';
import 'package:agency_time/new_data_handling/models/duration_data.dart';
import 'package:agency_time/new_data_handling/models/graph_data_spots.dart';
import 'package:agency_time/new_data_handling/models/graph_interval.dart';
import 'package:agency_time/new_data_handling/models/month.dart';
import 'package:agency_time/new_data_handling/repositories/data_repository.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'data_event.dart';
part 'data_state.dart';

class DataBloc extends Bloc<DataEvent, DataState> {
  DataReposity dataReposity;
  StreamSubscription? _currentDataStream;
  DataBloc(this.dataReposity) : super(DataState()) {
    on<DataEvent>((event, emit) {});
    on<RunStream>(_startStream);
    on<GetMonths>(_getMonths);
    on<SetCompareMonth>(_setCompareMonth);
    on<GetGraphPlots>(_getGraphPlots);
  }

  Future<void> _getMonths(GetMonths event, Emitter emit) async {
    List<Month> allMonths = await dataReposity.getMonths(3);
    List<Day> allDays = [];
    allMonths.forEach((e) {
      allDays.addAll(e.days);
    });
    emit(state.copyWith(allMonths: allMonths, allDays: allDays));
    add(SetCompareMonth());
  }

  _setCompareMonth(SetCompareMonth event, Emitter emit) {
    if (event.monthDate == null) {
      Month compareMonth =
          state.compareMonth ?? DataHelpers.getCompareMonth(state.allMonths);
      emit(state.copyWith(compareMonth: compareMonth));
    } else {
      emit(state.copyWith(
          compareMonthDate: event.monthDate ?? state.compareMonthDate));

      List<Month> checkListResult = state.allMonths
          .where((element) =>
              element.monthDate.month == state.compareMonthDate!.month)
          .toList();

      if (checkListResult.isNotEmpty) {
        emit(state.copyWith(compareMonth: checkListResult.first));
      } else {
        emit(
          state.copyWith(
            compareMonth: Month(
              monthDate: state.compareMonthDate!,
              durationData: const DurationData(),
            ),
          ),
        );
      }
    }
    emit(state.copyWith(
        changes:
            Changes.getFromMonths(state.currentMonth!, state.compareMonth!)));

    add(GetGraphPlots(graphInterval: GraphInterval.monthToDate));
  }

  void _startStream(RunStream event, Emitter emit) async {
    add(GetMonths());

    Stream stream = dataReposity.monthsStream();

    _currentDataStream?.cancel();
    _currentDataStream = stream.listen((data) async {
      for (var monthRaw in data.docs) {
        Month month = Month.fromMap(monthRaw.data());
        _updateMonth(month);
      }
    });
  }

  _updateMonth(Month month) {
    emit(state.copyWith(currentMonth: month));
  }

  void _getGraphPlots(GetGraphPlots event, Emitter emit) {
    DateTime start = event.graphInterval.start;
    DateTime end = event.graphInterval.end;
    int daysLength = end.difference(start).inDays;
    DataBundleSize dataBundleSize = DataHelpers.getBundleSize(daysLength);

    if (dataBundleSize == DataBundleSize.day) {
      emit(
        state.copyWith(
          graphDataSpots: DataHelpers.getDayRange(state.allDays, start, end)
              .map((e) => GraphDataSpot(
                  spotDay: e.dayDate,
                  durationData: e.durationData,
                  spotDayName: e.dayDate.day.toString()))
              .toList(),
        ),
      );
    }

    if (dataBundleSize == DataBundleSize.month) {
      emit(
        state.copyWith(
          graphDataSpots: DataHelpers.getDayRange(state.allMonths, start, end)
              .map((e) => GraphDataSpot(
                  spotDay: e.monthDate,
                  durationData: e.durationData,
                  spotDayName: e.monthDate.day.toString()))
              .toList(),
        ),
      );
    }
  }
}

enum DataBundleSize { day, week, month }

class DataHelpers {
  static getBundleSize(int days) {
    if (days < 60) {
      return DataBundleSize.day;
    }
    return DataBundleSize.month;
  }

  static getCompareMonth(List<Month> allMonths) {
    Month compareMonth =
        Month(monthDate: DateTime.now(), durationData: const DurationData());
    if (allMonths.length >= 2) {
      compareMonth = allMonths[allMonths.length - 1];
    }
    return compareMonth;
  }

  static List getDayRange(List days, DateTime start, DateTime end) {
    int startIndex = days.indexWhere((element) =>
            element.dayDate.toUtc().toString().split(' ')[0] ==
            start.toString().split(' ')[0]) +
        1;
    int endIndex = days.indexWhere((element) =>
            element.dayDate.toString().split(' ')[0] ==
            end.toString().split(' ')[0]) +
        1;
    return days.getRange(startIndex, endIndex).toList();
  }
}
