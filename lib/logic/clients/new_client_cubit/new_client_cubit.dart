import 'package:agency_time/main.dart';
import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:overlay_support/overlay_support.dart';

part 'new_client_state.dart';

class NewClientCubit extends Cubit<NewClientState> {
  NewClientCubit({required this.companyId}) : super(NewClientState());

  String companyId;

  Future<void> addClient({
    required String name,
    required String? description,
    required bool internal,
    required double? mrr,
    required double? hourly_rate_target,
  }) async {
    emit(state.copyWith(status: Status.loading));

    CollectionReference clients = FirebaseFirestore.instance
        .collection('companies')
        .doc(companyId)
        .collection('clients');

    try {
      await clients.add(
        internal
            ? {
                'name': name,
                'internal': internal,
                'description': description,
                'paused': false
              }
            : {
                'name': name,
                'mrr': mrr,
                'internal': internal,
                'description': description,
                'hourly_rate_target': hourly_rate_target,
                'paused': false
              },
      );
    } on FirebaseException catch (e) {
      String errorMessage = 'Something went wrong';
      print(e.stackTrace);
      if (e.code == 'permission-denied') {
        showSimpleNotification(
          const Text(
            'You don\'t have permission to add clients',
            textAlign: TextAlign.center,
          ),
          duration: Duration(seconds: 2),
          background: Colors.red,
        );
        emit(state.copyWith(status: Status.failed));
      }

      print(e.code);
    }
    emit(state.copyWith(status: Status.succes));
    Navigator.pop(navigatorKey.currentContext!);
  }
}
