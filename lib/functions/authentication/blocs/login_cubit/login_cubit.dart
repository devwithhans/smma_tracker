import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cloud_functions/cloud_functions.dart';

import 'package:equatable/equatable.dart';
import 'package:firebase_auth/firebase_auth.dart';

part 'login_state.dart';

class LoginCubit extends Cubit<LoginState> {
  LoginCubit() : super(LoginInitial());

  void loginUser(String password, String email) async {
    emit(LoginLoading());
    try {
      final credential = await FirebaseAuth.instance
          .signInWithEmailAndPassword(email: email, password: password);
      emit(LoginInitial());
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

      if (userCredential.user != null) {
        FirebaseFirestore.instance
            .collection('users')
            .doc(userCredential.user!.uid)
            .set({
          'firstName': splitNames(name).first,
          'lastName': splitNames(name).last,
          'email': email,
          'newletter': newletter
        });
      }

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

List<String> splitNames(String fullName) {
  String firstName = fullName.split(' ').first;
  String lastName = fullName.replaceFirst('$firstName ', '');
  return [firstName, lastName];
}
