import 'dart:math';

import 'package:agency_time/functions/authentication/repos/signin_repo.dart';
import 'package:agency_time/main.dart';
import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

part 'login_state.dart';

class LoginCubit extends Cubit<LoginState> {
  LoginCubit() : super(LoginInitial());

  SignInRepo signInRepo = SignInRepo();

  void loginUser(String password, String email) async {
    emit(LoginLoading());
    try {
      await FirebaseAuth.instance
          .signInWithEmailAndPassword(email: email, password: password);
      emit(LoginInitial());
      Navigator.pop(navigatorKey.currentContext!);
    } on FirebaseAuthException catch (e) {
      print(e.code);
      if (e.code == 'user-not-found') {
        emit(LoginFailed(
            errorMessage: 'No user found for that email', errorCode: e.code));
      } else if (e.code == "wrong-password") {
        emit(LoginFailed(
            errorMessage: 'Wrong password provided for that user',
            errorCode: e.code));
      }
    }
  }

  void registerUser(
      String password, String email, String name, bool newletter) async {
    emit(LoginLoading());

    try {
      await signInRepo.registerUser(
        email: email,
        name: name,
        newletter: newletter,
        password: password,
      );

      // await FirebaseAuth.instance
      //     .signInWithCredential(userCredential.credential!);

      emit(LoginInitial());
    } on FirebaseAuthException catch (e) {
      print(e.code);
      if (e.code == 'email-already-in-use') {
        print('email-already-in-use');
        emit(LoginFailed(errorMessage: e.message!, errorCode: e.code));
      }
    }
  }
}

//helper functions:
