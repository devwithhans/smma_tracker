import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:equatable/equatable.dart';
import 'package:firebase_auth/firebase_auth.dart';

part 'login_state.dart';

class LoginCubit extends Cubit<LoginState> {
  LoginCubit() : super(LoginInitial());

  void loginUser(String password, String email) async {
    try {
      final credential = await FirebaseAuth.instance
          .signInWithEmailAndPassword(email: email, password: password);
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
      UserCredential userCredential = await FirebaseAuth.instance
          .createUserWithEmailAndPassword(email: email, password: password);

      FirebaseAuth.instance.signInWithCredential(userCredential.credential!);

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
