import 'dart:async';

import 'package:agency_time/logic/settings/repos/settings_repo.dart';
import 'package:agency_time/models/company.dart';
import 'package:agency_time/models/company_month.dart';
import 'package:agency_time/models/dashdata.dart';
import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';

part 'stats_event.dart';
part 'stats_state.dart';

class StatsBloc extends Bloc<StatsEvent, StatsState> {
  SettingsRepo settingsRepo;
  Company company;
  late StreamSubscription monthsStream;

  StatsBloc(this.settingsRepo, this.company) : super(StatsState()) {
    settingsRepo.checkIfMonthsUpToDate();
    monthsStream = settingsRepo.companyMonths().listen(((event) {
      emit(state.copyWith(status: StatsStatus.loading));
      for (var monthRaw in event.docs) {
        add(AddMonth(monthRaw));
      }
      add(GetStats());
    }));

    on<AddMonth>(_addMonth);

    on<GetStats>(_getStats);
  }

  void _getStats(GetStats event, Emitter emit) {
    emit(state.copyWith(status: StatsStatus.loading));
    DateTime selectedMonth =
        event.month ?? state.selectedMonth.date ?? DateTime.now();
    List<CompanyMonth>? statMonthList =
        state.months.where((element) => element.date == selectedMonth).toList();

    CompanyMonth statMonth =
        statMonthList.isNotEmpty ? statMonthList.first : state.months.last;

    CompanyMonth compareMonth = _getMonthFormList(
            DateTime(statMonth.date!.year, statMonth.date!.month - 1)) ??
        CompanyMonth(
          date: DateTime.now(),
          updatedAt: DateTime.now(),
          mrr: 0,
        );

    emit(
      state.copyWith(
        status: StatsStatus.initial,
        selectedMonth: statMonth,
        dashData: DashData.getDashData(
            selectedMonth: statMonth, compareMonth: compareMonth),
      ),
    );
  }

  void _addMonth(AddMonth event, Emitter emit) {
    List<CompanyMonth> CompanyMonths = [];
    CompanyMonths.addAll(state.months);
    CompanyMonth? newMonth = CompanyMonth.convertMonth(
      event.monthDoc.data(),
      event.monthDoc.id,
      company,
    );
    CompanyMonths = _addNewMonthToList(newMonth: newMonth);

    emit(state.copyWith(months: CompanyMonths));
  }

  CompanyMonth? _getMonthFormList(DateTime date) {
    try {
      return state.months
          .firstWhere((element) => element.date!.month == date.month);
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
        .where((element) => element.date!.month == newMonth.date!.month)
        .isEmpty) {
      newMonthList.add(newMonth);
    } else {
      newMonthList[newMonthList.lastIndexWhere(
          (element) => element.date!.month == newMonth.date!.month)] = newMonth;
    }

    return newMonthList;
  }
}
