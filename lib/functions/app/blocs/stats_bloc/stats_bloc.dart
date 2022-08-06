import 'dart:async';
import 'package:agency_time/functions/app/models/stats.dart';
import 'package:agency_time/functions/app/repos/settings_repo.dart';
import 'package:agency_time/utils/functions/data_explanation.dart';
import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';

part 'stats_event.dart';
part 'stats_state.dart';

class StatsBloc extends Bloc<StatsEvent, StatsState> {
  SettingsRepo settingsRepo;
  late StreamSubscription _monthsStream;

  StatsBloc(this.settingsRepo) : super(StatsState()) {
    _monthsStream = settingsRepo.companyMonths().listen(((event) {
      emit(state.copyWith(status: Status.loading));
      for (var monthRaw in event.docs) {
        add(AddMonth(monthRaw));
      }
      add(GetStats());
      emit(state.copyWith(status: Status.initial));
    }));

    on<AddMonth>(_addMonth);
    on<GetStats>(_getStats);
  }

  void _getStats(GetStats event, Emitter emit) async {
    DateTime selectedMonthDate = event.month ?? DateTime.now();
    CompanyMonth? statMonth = state.months.last;

    if (statMonth.month!.month != selectedMonthDate.month) {
      print('noSTATMONTH');
    }

    CompanyMonth compareMonth = _getMonthFormList(
            DateTime(statMonth.month!.year, statMonth.month!.month - 1)) ??
        CompanyMonth(month: DateTime.now(), updatedAt: DateTime.now(), mrr: 0);

    double mrrChange = getChangeProcentage(statMonth.mrr, compareMonth.mrr);
    double hourlyRateChange =
        getChangeProcentage(statMonth.hourlyRate, compareMonth.hourlyRate);

    Duration totalDurationChange =
        statMonth.totalDuration - compareMonth.totalDuration;

    Duration internalDurationChange =
        statMonth.internalDuration - compareMonth.internalDuration;
    Duration clientsDuratioChange =
        statMonth.clientsDuration - compareMonth.clientsDuration;
    emit(
      state.copyWith(
        mrrChange: mrrChange,
        selectedMonth: statMonth,
        hourlyRateChange: hourlyRateChange,
        internalDurationChange: internalDurationChange,
        clientsDurationChange: clientsDuratioChange,
        totalDurationChange: totalDurationChange,
      ),
    );
  }

  void _addMonth(AddMonth event, Emitter emit) {
    List<CompanyMonth> CompanyMonths = [];
    CompanyMonths.addAll(state.months);
    CompanyMonth? newMonth =
        CompanyMonth.convertMonth(event.monthDoc.data(), event.monthDoc.id);

    CompanyMonths = _addNewMonthToList(newMonth: newMonth);

    emit(state.copyWith(months: CompanyMonths));
  }

  CompanyMonth? _getMonthFormList(DateTime date) {
    try {
      return state.months
          .firstWhere((element) => element.month!.month == date.month);
    } catch (e) {
      return null;
    }
  }

  List<CompanyMonth> _addNewMonthToList({required CompanyMonth? newMonth}) {
    List<CompanyMonth> newMonthList = [];
    newMonthList.addAll(state.months);

    if (newMonth == null) {
      return newMonthList;
    }

    if (newMonthList
        .where((element) => element.month!.month == newMonth.month!.month)
        .isEmpty) {
      newMonthList.add(newMonth);
    } else {
      newMonthList[newMonthList.lastIndexWhere(
              (element) => element.month!.month == newMonth.month!.month)] =
          newMonth;
    }

    return newMonthList;
  }
}
