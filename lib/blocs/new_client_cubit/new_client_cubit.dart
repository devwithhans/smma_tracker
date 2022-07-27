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
    required double mrr,
    required double hourly_rate_target,
  }) async {
    emit(state.copyWith(status: Status.loading));
    CollectionReference clients = FirebaseFirestore.instance
        .collection('companies')
        .doc(companyId)
        .collection('clients');
    DateTime thisDate = DateTime.now();
    String thisMonthString = '${thisDate.year}-${thisDate.month}';

    try {
      await clients.add(
        {
          'name': name,
          'mrr': mrr,
          'hourly_rate_target': hourly_rate_target,
          'months': {
            thisMonthString: {
              'duration': 0,
              'mrr': mrr,
              'updatedAt': Timestamp.now()
            }
          },
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
