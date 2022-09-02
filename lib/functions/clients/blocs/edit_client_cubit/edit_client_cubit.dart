import 'package:agency_time/main.dart';
import 'package:agency_time/functions/clients/repos/client_repo.dart';
import 'package:agency_time/models/client.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

part 'edit_client_state.dart';

class EditClientCubit extends Cubit<EditClientState> {
  ClientsRepo clientsRepo;

  EditClientCubit(this.clientsRepo) : super(EditClientInitial());

  Future<void> editClient(Client newValues) async {
    emit(EditClientLoading());

    try {
      await clientsRepo.editClient(newValues);
    } catch (e) {
      emit(EditClientFailed());
    }

    Navigator.popUntil(navigatorKey.currentContext!, (route) => route.isFirst);

    emit(EditClientSucces());
  }
}
