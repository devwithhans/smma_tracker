import 'dart:async';
import 'package:agency_time/bloc_config.dart';
import 'package:agency_time/features/error/error.dart';
import 'package:agency_time/features/auth/models/user.dart';
import 'package:agency_time/features/auth/repository/authenticate_repo.dart';
import 'package:agency_time/features/auth/repository/authorize_repo.dart';
import 'package:agency_time/main.dart';

import 'package:agency_time/models/company.dart';
import 'package:agency_time/views/view_data_visualisation/data_visualisation_dependencies.dart';
import 'package:equatable/equatable.dart';
import 'package:firebase_auth/firebase_auth.dart';

part 'authorize_state.dart';

class AuthorizeCubit extends Cubit<AuthorizeState> {
  late StreamSubscription<User?> authStream;
  AuthorizeRepo authorizeRepo = AuthorizeRepo();
  AuthenticateRepo authenticateRepo = AuthenticateRepo();

  AuthorizeCubit() : super(AuthorizeState()) {
    // Listening if any changes happens to the user state.
    // If a user signins in we get the Firebase User entity and use that to get the user from the database

    authStream =
        FirebaseAuth.instance.authStateChanges().listen((User? user) async {
      if (user != null) {
        emit(state.copyWith(status: BlocStatus.loading));
        Navigator.popUntil(
            navigatorKey.currentContext!, (route) => route.isFirst);
        // If a user is found we use following function to gather the needing information about the user
        await _handleSignedInUser(user).catchError((e) {
          emit(
            state.copyWith(
              status: BlocStatus.failed,
              error: HcError.errorConnectingToTheServer,
            ),
          );
        });
      } else {
        emit(AuthorizeState());
      }
    });
  }

  Future<void> _handleSignedInUser(User user) async {
    emit(state.copyWith(status: BlocStatus.loading));

    // We recieve the appUser containing values from our database.

    AppUser? appUser = await authorizeRepo.getAppUser(user.uid);
    // If this value is null, then it means the user has created signed in with a third party platform for the first time.
    // Therefore we create a new user with the values supplied by the thirdparty

    if (appUser == null) {
      UserCredential userCredential =
          await FirebaseAuth.instance.getRedirectResult();

      if (userCredential.user == null) {
        FirebaseAuth.instance.signOut();
        emit(state.copyWith(status: BlocStatus.initial));
      }

      AppUser? generatedAppUser =
          await authenticateRepo.createUserWithOauth(user);

      // Because it is a new user, then we can be sure it does not have a company and we can log them in without one
      emit(state.copyWith(
        appUser: generatedAppUser,
        status: BlocStatus.succes,
      ));
    }

    //We wanna check if the user is associated with a company

    Company? company = await authorizeRepo.getCompany(appUser!.id);
    String role = '';
    if (company != null) {
      role = company.roles[user.uid];
    }

    emit(
      state.copyWith(
        admin: role == 'admin',
        appUser: appUser,
        company: company,
        status: BlocStatus.succes,
      ),
    );
  }
}
