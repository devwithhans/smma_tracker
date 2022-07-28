import 'dart:async';

import 'package:agency_time/models/company.dart';
import 'package:agency_time/models/user.dart';
import 'package:agency_time/repos/trackerRepository.dart';
import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cloud_functions/cloud_functions.dart';
import 'package:equatable/equatable.dart';
import 'package:firebase_auth/firebase_auth.dart';

part 'auth_state.dart';

class AuthCubit extends Cubit<AuthState> {
  late StreamSubscription<User?> _authStream;

  CollectionReference users = FirebaseFirestore.instance.collection('users');

  AuthCubit() : super(AuthState()) {
    _authStream =
        FirebaseAuth.instance.authStateChanges().listen((User? user) async {
      if (user != null) {
        try {
          DocumentSnapshot userDocument = await users.doc(user.uid).get();
          AppUser appUser = AppUser.convert(
              userDocument.data() as Map<String, dynamic>, user.uid);
          Company company = await getCompany(appUser);
          await Future.delayed(Duration(seconds: 2));
          emit(state.copyWith(
            authStatus: AuthStatus.signedIn,
            appUser: appUser,
            company: company,
          ));
        } on FirebaseException catch (error) {
          emit(state.copyWith(authStatus: AuthStatus.noCompany));
          print('errorFUCKING');
          print(error.code);
        }
      } else {
        emit(state.copyWith(authStatus: AuthStatus.signedOut));
      }
    });
  }

  Future<Company> getCompany(AppUser user) async {
    try {
      DocumentSnapshot<Map<String, dynamic>> companyRaw =
          await FirebaseFirestore.instance
              .collection('companies')
              .doc(user.companyId)
              .get();

      return Company.convert(companyRaw.data()!, companyRaw.id);
    } on FirebaseFunctionsException catch (error) {
      rethrow;
    }
  }
}
