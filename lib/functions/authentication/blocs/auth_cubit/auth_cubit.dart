import 'dart:async';
import 'dart:io';

import 'package:agency_time/functions/authentication/models/company.dart';
import 'package:agency_time/functions/authentication/models/invite.dart';
import 'package:agency_time/functions/authentication/models/user.dart';
import 'package:agency_time/utils/constants/colors.dart';
import 'package:agency_time/utils/error_handling/errors.dart';
import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cloud_functions/cloud_functions.dart';
import 'package:equatable/equatable.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:overlay_support/overlay_support.dart';

part 'auth_state.dart';

/// Here we manage all initial operations to authenticate the user with user data and company data
/// We always listen to the authState to ensure the user always has permission to the given screens

class AuthCubit extends Cubit<AuthState> {
  late StreamSubscription<User?> _authStream;
  FirebaseFirestore firestore = FirebaseFirestore.instance;
  CollectionReference users = FirebaseFirestore.instance.collection('users');

  AuthCubit() : super(AuthState()) {
    // _checkWifiConnection();
    _authStream =
        FirebaseAuth.instance.authStateChanges().listen((User? user) async {
      if (user != null) {
        try {
          DocumentSnapshot userDocument =
              await users.doc(user.uid).get().timeout(Duration(seconds: 10));
          AppUser appUser = AppUser.convert(
              userDocument.data() as Map<String, dynamic>, user.uid);

          try {
            Company company = await getCompany(appUser);
            // await Future.delayed(const Duration(seconds: 1));
            if (company.roles[appUser.id] == null) {
              Invite? companyInvite = await checkForInvites(appUser.email);

              emit(state.copyWith(
                  authStatus: AuthStatus.noCompany,
                  appUser: appUser,
                  invite: companyInvite));
            } else {
              emit(
                state.copyWith(
                  authStatus: AuthStatus.signedIn,
                  appUser: appUser,
                  company: company,
                  role: company.roles[appUser.id],
                ),
              );
            }
          } on FirebaseException catch (error) {
            // addError(AppError.noConnection(user));
            Invite? companyInvite = await checkForInvites(appUser.email);

            emit(state.copyWith(
                authStatus: AuthStatus.noCompany,
                invite: companyInvite,
                appUser: appUser));
          }
        } on FirebaseException catch (error) {
          addError(AppErrors.noConnection(user, 'auth_cubit, line 55'));
          emit(
            state.copyWith(
              authStatus: AuthStatus.noCompany,
            ),
          );
          print(error.code);
        }
      } else {
        emit(state.copyWith(authStatus: AuthStatus.signedOut));
      }
    });
  }

  Future<void> _checkWifiConnection() async {
    try {
      final result = await InternetAddress.lookup('example.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {}
    } on SocketException catch (_) {
      showSimpleNotification(
        const Text(
          'You are currently offline',
          style: TextStyle(color: Colors.black),
          textAlign: TextAlign.center,
        ),
        duration: Duration(seconds: 10),
        background: kColorYellow,
      );
    }
  }

  Future<Invite?> checkForInvites(String email) async {
    try {
      DocumentSnapshot<Map<String, dynamic>> inviteRaw = await FirebaseFirestore
          .instance
          .collection('invites')
          .doc(email)
          .get();
      Invite? invite;
      if (inviteRaw.data() != null) {
        invite = Invite.convert(inviteRaw.data()!, inviteRaw.id);
      }

      return invite;
    } on FirebaseFunctionsException catch (error) {
      print(error);
      rethrow;
    }
  }
}

Future<Company> getCompany(AppUser user) async {
  try {
    DocumentSnapshot<Map<String, dynamic>> companyRaw = await FirebaseFirestore
        .instance
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
