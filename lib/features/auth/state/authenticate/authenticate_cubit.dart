import 'package:agency_time/bloc_config.dart';
import 'package:agency_time/features/auth/models/error.dart';
import 'package:agency_time/features/auth/models/signup_payload.dart';
import 'package:agency_time/features/auth/repository/authenticate_repo.dart';
import 'package:agency_time/main.dart';
import 'package:agency_time/views/view_data_visualisation/data_visualisation_dependencies.dart';
import 'package:equatable/equatable.dart';
import 'package:firebase_auth/firebase_auth.dart';

part 'authenticate_state.dart';

class AuthenticateCubit extends Cubit<AuthenticateState> {
  AuthenticateCubit() : super(AuthenticateState());
  AuthenticateRepo authRepo = AuthenticateRepo();

  void signinWithPassword(String password, String email) async {
    emit(state.copyWith(status: Status.loading));
    try {
      await authRepo.loginUser(password, email);
      emit(state.copyWith(status: Status.succes));
      Navigator.popUntil(
          navigatorKey.currentContext!, (route) => route.isFirst);
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        emit(
          state.copyWith(
            status: Status.failed,
            error: HcError.noUserFound,
          ),
        );
      } else if (e.code == "wrong-password") {
        emit(
          state.copyWith(
            status: Status.failed,
            error: HcError.noUserFound,
          ),
        );
      }
    } catch (e) {
      emit(
        state.copyWith(
          status: Status.failed,
          error: HcError.errorConnectingToTheServer,
        ),
      );
    }
  }

  void signinWithGoogle() async {
    emit(state.copyWith(status: Status.loading));
    try {
      await authRepo.signInWithGoogle();
      emit(state.copyWith(status: Status.succes));
    } catch (e) {
      emit(
        state.copyWith(
          status: Status.failed,
          error: HcError.googleSigninFailed,
        ),
      );
    }
  }

  void registerUser({required SignupPayload registerLoad}) async {
    emit(state.copyWith(status: Status.loading));
    try {
      await authRepo.registerUser(
        registerLoad: registerLoad,
      );
      emit(state.copyWith(status: Status.succes));
    } on FirebaseAuthException catch (e) {
      if (e.code == 'email-already-in-use') {
        emit(state.copyWith(
            status: Status.failed, error: HcError.emailAlreadyInUse));
      } else {
        emit(state.copyWith(
            status: Status.failed, error: HcError.failedToRegisterUser));
      }
    }
  }
}
