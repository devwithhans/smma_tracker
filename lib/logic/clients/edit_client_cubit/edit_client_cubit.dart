import 'package:agency_time/logic/clients/repos/client_repo.dart';
import 'package:agency_time/main.dart';
import 'package:agency_time/models/client.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

part 'edit_client_state.dart';

class EditClientCubit extends Cubit<EditClientState> {
  ClientsRepo clientsRepo;

  EditClientCubit(this.clientsRepo) : super(EditClientInitial());

  Future<void> pauseClient({
    required String id,
    required bool pause,
    required double mrr,
  }) async {
    emit(EditClientLoading());
    try {
      await clientsRepo.pauseClient(
        id: id,
        mrr: mrr,
        paused: pause,
      );
    } catch (e) {
      emit(EditClientFailed());
    }
    emit(EditClientSucces());
  }

  Future<void> editClient({
    required double mrr,
    required double hourlyRateTarget,
    required String name,
    required String description,
    required String id,
  }) async {
    emit(EditClientLoading());
    try {
      await clientsRepo.editClient(
        mrr: mrr,
        hourlyRateTarget: hourlyRateTarget,
        name: name,
        description: description,
        id: id,
      );
    } catch (e) {
      emit(EditClientFailed());
    }
    Navigator.popUntil(navigatorKey.currentContext!, (route) => route.isFirst);
    emit(EditClientSucces());
  }
}
