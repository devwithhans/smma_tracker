import 'package:agency_time/main.dart';
import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

part 'new_company_state.dart';

class ManageCompanyCubit extends Cubit<ManageCompanyState> {
  ManageCompanyCubit({this.initialStep = 1})
      : super(ManageCompanyState(step: initialStep));

  final int initialStep;

  void plusStep() {
    emit(state.copyWith(step: state.step + 1));
  }

  void minusStep() {
    emit(state.copyWith(step: state.step - 1));
  }

  Future<void> createCompany(String userId) async {
    emit(state.copyWith(newCompanyStatus: NewCompanyStatus.loading));
    FirebaseFirestore firestore = FirebaseFirestore.instance;
    try {
      DocumentReference<Map<String, dynamic>> result =
          await firestore.collection('companies').add({
        'companyName': state.companyName,
        'countryCode': state.countyCode,
        'members': {'$userId': 'owner'}
      });
      await firestore.collection('users').doc(userId).update({
        'companyId': result.id,
      });

      RestartWidget.restartApp(navigatorKey.currentContext!);
      emit(state.copyWith(
          newCompanyStatus: NewCompanyStatus.initial, step: state.step + 1));
    } on FirebaseException catch (error) {
      // addError(AppError.noConnection(user));
      emit(state.copyWith(newCompanyStatus: NewCompanyStatus.failed));
    }
  }

  void updateValues({
    String? countryCode,
    String? companyName,
    String? vatNumber,
    List<String>? invites,
  }) {
    emit(state.copyWith(
        companyName: companyName,
        invites: invites,
        countyCode: countryCode,
        vatNumber: vatNumber));
  }
}
