import 'package:agency_time/logic/authentication/repositories/signin_repo.dart';
import 'package:agency_time/main.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

part 'login_state.dart';

class AuthenticationCubit extends Cubit<AuthenticationState> {
  AuthenticationCubit() : super(LoginInitial());

  SignInRepo signInRepo = SignInRepo();

  void loginUser(String password, String email) async {
    emit(LoginLoading());
    try {
      await FirebaseAuth.instance
          .signInWithEmailAndPassword(email: email, password: password);
      emit(LoginInitial());
      Navigator.pop(navigatorKey.currentContext!);
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        emit(LoginFailed(
            errorMessage: 'No user found for that email', errorCode: e.code));
      } else if (e.code == "wrong-password") {
        emit(LoginFailed(
            errorMessage: 'Wrong password provided for that user',
            errorCode: e.code));
      }
    } catch (e) {
      print('EROOR');
      emit(LoginFailed(
          errorMessage:
              'Could not connect to the server, check your internet connection and try again',
          errorCode: e.toString()));
    }
  }

  void registerUser({
    required RegisterLoad registerLoad,
  }) async {
    emit(LoginLoading());
    try {
      await signInRepo.registerUser(
        registerLoad: registerLoad,
      );
      emit(LoginInitial());
    } on FirebaseAuthException catch (e) {
      if (e.code == 'email-already-in-use') {
        emit(LoginFailed(errorMessage: e.message!, errorCode: e.code));
      }
    }
  }
}

class RegisterLoad {
  RegisterLoad(
      {required this.password,
      required this.email,
      required this.name,
      required this.newletter});

  final String password;
  final String email;
  final String name;
  final bool newletter;
}
