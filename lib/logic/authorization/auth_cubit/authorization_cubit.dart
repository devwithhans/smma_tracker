import 'dart:async';

import 'package:agency_time/logic/authorization/repositories/auth_repo.dart';
import 'package:agency_time/models/company.dart';
import 'package:agency_time/models/invite.dart';
import 'package:agency_time/models/user.dart';
import 'package:agency_time/utils/error_handling/errors.dart';
import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';
import 'package:firebase_auth/firebase_auth.dart';
part 'authorization_state.dart';

/// Here we manage all initial operations to authenticate the user with user data and company data
/// We always listen to the authState to ensure the user always has permission to the given screens

class AuthorizationCubit extends Cubit<AuthorizationState> {
  AuthRepo authRepo = AuthRepo();
  late StreamSubscription<User?> authStream;
  FirebaseFirestore firestore = FirebaseFirestore.instance;

  AuthorizationCubit() : super(const AuthorizationState()) {
    authStream =
        FirebaseAuth.instance.authStateChanges().listen((User? user) async {
      if (user != null) {
        await _handleSignedInUser(user).catchError((e) {
          addError(ErrorContent(message: e.toString()));
          // AppErrors.failedToLoadUser(user, 'authCubits'));
        });
      } else {
        emit(state.copyWith(authStatus: AuthStatus.signedOut));
      }
    });
  }

  Future<void> _handleSignedInUser(User user) async {
    AppUser appUser = await authRepo.getUserDocument(user.uid);
    _emitNotCompany() async {
      Invite? companyInvite = await authRepo.checkForInvites(appUser.email);
      emit(state.copyWith(
        authStatus: AuthStatus.noCompany,
        appUser: appUser,
        invite: companyInvite,
      ));
    }

    if (appUser.companyId == null) {
      _emitNotCompany();
      return;
    }

    Company? company = await authRepo.getCompany(appUser.companyId!);
    if (company == null) {
      _emitNotCompany();
    } else {
      emit(
        state.copyWith(
          authStatus: AuthStatus.signedIn,
          appUser: appUser,
          company: company,
          role: _getUserRoleFromString(company.roles[appUser.id]),
        ),
      );
    }

    Future<void> acceptInvite(String email) async {
      authRepo.acceptInvite(email);
    }
  }

  _getUserRoleFromString(String string) {
    return string == 'owner' ? UserRole.owner : UserRole.user;
  }
}
