import 'package:agency_time/bloc_config.dart';
import 'package:agency_time/features/error/error.dart';
import 'package:agency_time/features/auth/models/signup_payload.dart';
import 'package:agency_time/features/auth/repository/authenticate_repo.dart';
import 'package:agency_time/main.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

part 'authenticate_state.dart';

class AuthenticateCubit extends Cubit<AuthenticateState> {
  AuthenticateCubit() : super(AuthenticateState());
  AuthenticateRepo authRepo = AuthenticateRepo();

  void signinWithPassword(String password, String email) async {
    emit(state.copyWith(status: BlocStatus.loading));
    try {
      await authRepo.loginUser(password, email);
      emit(state.copyWith(status: BlocStatus.succes));
    } on FirebaseAuthException catch (e) {
      switch (e.code) {
        case 'user-not-found':
          emit(
            state.copyWith(
              status: BlocStatus.failed,
              error: HcError.noUserFound,
            ),
          );
          break;
        case 'wrong-password':
          emit(
            state.copyWith(
              status: BlocStatus.failed,
              error: HcError.noUserFound,
            ),
          );
          break;
        default:
          emit(
            state.copyWith(
              status: BlocStatus.failed,
              error: HcError.noUserFound,
            ),
          );
      }
    }
  }

  void signinWithGoogle() async {
    emit(state.copyWith(status: BlocStatus.loading));
    try {
      await authRepo.signInWithGoogle();
      emit(state.copyWith(status: BlocStatus.succes));
    } catch (e) {
      emit(
        state.copyWith(
          status: BlocStatus.failed,
          error: HcError.googleSigninFailed,
        ),
      );
    }
  }

  void registerUser({required SignupPayload registerLoad}) async {
    emit(state.copyWith(status: BlocStatus.loading));
    try {
      await authRepo.registerUser(
        registerLoad: registerLoad,
      );
      emit(state.copyWith(status: BlocStatus.succes));
    } on FirebaseAuthException catch (e) {
      if (e.code == 'email-already-in-use') {
        emit(state.copyWith(
            status: BlocStatus.failed, error: HcError.emailAlreadyInUse));
      } else {
        emit(state.copyWith(
            status: BlocStatus.failed, error: HcError.failedToRegisterUser));
      }
    }
  }
}
