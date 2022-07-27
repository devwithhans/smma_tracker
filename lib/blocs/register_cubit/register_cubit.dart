import 'dart:html';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/physics.dart';

part 'register_state.dart';

class RegisterCubit extends Cubit<RegisterState> {
  RegisterCubit() : super(RegisterState());

  void setStep(int step) {
    print(step);
    emit(state.copyWith(step: step));
  }

  void companyDetails({String? companyName, String? vat}) {
    emit(state.copyWith(companyName: companyName, vat: vat));
  }
}
