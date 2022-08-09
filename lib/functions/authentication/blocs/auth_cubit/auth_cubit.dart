import 'dart:async';

import 'package:agency_time/functions/authentication/models/company.dart';
import 'package:agency_time/functions/authentication/models/user.dart';
import 'package:agency_time/functions/tracking/repos/tracker_repo.dart';
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
          if (company.roles[appUser.id] == null) {
            emit(state.copyWith(
              authStatus: AuthStatus.noCompany,
              appUser: appUser,
            ));
          } else {
            emit(state.copyWith(
                authStatus: AuthStatus.signedIn,
                appUser: appUser,
                company: company,
                role: company.roles[appUser.id]));
          }
        } on FirebaseException catch (error) {
          emit(state.copyWith(authStatus: AuthStatus.noCompany));
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
      Company company = Company.convert(companyRaw.data()!, companyRaw.id);
      List<Member> members = [];

      List rolesKeys = company.roles.keys.toList();

      for (var key in rolesKeys) {
        DocumentSnapshot<Map<String, dynamic>> member =
            await FirebaseFirestore.instance.collection('users').doc(key).get();
        members.add(Member.convert(member.data()!, key));
      }

      company = company.copyWith(members: members);

      return company;
    } on FirebaseFunctionsException catch (error) {
      print(error);
      rethrow;
    }
  }
}
