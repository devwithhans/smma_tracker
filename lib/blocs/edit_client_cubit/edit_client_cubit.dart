import 'package:agency_time/main.dart';
import 'package:agency_time/models/client.dart';
import 'package:agency_time/repos/trackerRepository.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

part 'edit_client_state.dart';

class EditClientCubit extends Cubit<EditClientState> {
  TrackerRepository _trackerRepository;

  EditClientCubit(this._trackerRepository) : super(EditClientInitial());

  Future<void> editClient(Client newValues) async {
    emit(EditClientLoading());

    try {
      await _trackerRepository.editClient(newValues);
    } catch (e) {
      emit(EditClientFailed());
    }
    Navigator.pop(navigatorKey.currentContext!);

    emit(EditClientSucces());
  }
}
