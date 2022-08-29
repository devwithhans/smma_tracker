import 'dart:async';
import 'package:agency_time/functions/authentication/models/company.dart';
import 'package:agency_time/functions/authentication/models/invite.dart';
import 'package:agency_time/functions/authentication/models/user.dart';
import 'package:agency_time/functions/authentication/repos/auth_repo.dart';
import 'package:agency_time/utils/error_handling/errors.dart';
import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';
import 'package:firebase_auth/firebase_auth.dart';
part 'auth_state.dart';

/// Here we manage all initial operations to authenticate the user with user data and company data
/// We always listen to the authState to ensure the user always has permission to the given screens

class AuthCubit extends Cubit<AuthState> {
  AuthRepo authRepo = AuthRepo();
  late StreamSubscription<User?> _authStream;
  FirebaseFirestore firestore = FirebaseFirestore.instance;

  AuthCubit() : super(AuthState()) {
    // _checkWifiConnection();
    _authStream =
        FirebaseAuth.instance.authStateChanges().listen((User? user) async {
      if (user != null) {
        try {
          AppUser? appUser = await authRepo.getUserDocument(user.uid);
          if (appUser == null) {
            FirebaseAuth.instance.signOut();
          }

          try {
            Company company = await authRepo.getCompany(appUser!);
            // await Future.delayed(const Duration(seconds: 1));
            if (company.roles[appUser.id] == null) {
              Invite? companyInvite =
                  await authRepo.checkForInvites(appUser.email);
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
            print(error);

            Invite? companyInvite =
                await authRepo.checkForInvites(appUser!.email);

            emit(state.copyWith(
                authStatus: AuthStatus.noCompany,
                invite: companyInvite,
                appUser: appUser));
          }
        } on FirebaseException catch (error) {
          print(error);
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

  Future<void> acceptInvite(String email) async {
    authRepo.acceptInvite(email);
  }
}
