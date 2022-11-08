import 'dart:async';

import 'package:agency_time/features/auth/models/user.dart';
import 'package:agency_time/features/auth/repository/authenticate_repo.dart';
import 'package:agency_time/logic/authorization/repositories/auth_repo.dart';
import 'package:agency_time/main.dart';
import 'package:agency_time/models/company.dart';
import 'package:agency_time/models/invite.dart';
import 'package:agency_time/utils/error_handling/errors.dart';
import 'package:agency_time/views/view_data_visualisation/data_visualisation_dependencies.dart';
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
    AppUser? appUser = await authRepo.getUserDocument(user.uid);

    if (appUser == null) {
      UserCredential userCredential =
          await FirebaseAuth.instance.getRedirectResult();
      if (userCredential.user == null) {
        FirebaseAuth.instance.signOut();
        emit(state.copyWith(authStatus: AuthStatus.signedOut));
      }
      await AuthenticateRepo().createUserWithOauth(user);
      Navigator.popUntil(
          navigatorKey.currentContext!, (route) => route.isFirst);

      print(userCredential.user!.uid);
    }
    emitNotCompany() async {
      Invite? companyInvite = await authRepo.checkForInvites(appUser!.email);
      emit(state.copyWith(
        authStatus: AuthStatus.noCompany,
        appUser: appUser,
        invite: companyInvite,
      ));
    }

    Company? company = await authRepo.getCompany(appUser!.id);

    if (company == null) {
      emitNotCompany();
      return;
    }

    emit(
      state.copyWith(
        authStatus: AuthStatus.signedIn,
        appUser: appUser,
        company: company,
        role: UserRole.owner,
      ),
    );
    print('company');

    Future<void> acceptInvite(String email) async {
      authRepo.acceptInvite(email);
    }
  }

  _getUserRoleFromString(String string) {
    return string == 'owner' ? UserRole.owner : UserRole.user;
  }
}
